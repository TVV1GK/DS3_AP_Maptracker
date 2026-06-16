import sys
import os
from visibility_convert_keys import VISIBILITY_CONVERT_KEYS

ARCHIPELAGO_PATH = r""
sys.path.insert(0, ARCHIPELAGO_PATH)

# pyright: reportMissingImports=false
from worlds.dark_souls_3.Locations import location_name_groups, location_dictionary, DS3LocationData

################################################################################

# Modify this area if you want to manually add a location group

location_name_groups["Everywhere"] = set()
location_name_groups["Missable"] = set()
location_name_groups["New Game+"] = set()

for location_name, location_data in location_dictionary.items():
    if not location_data.is_event:
        location_name_groups["Everywhere"].add(location_name)
        if location_data.missable:
            location_name_groups["Missable"].add(location_name)
        if location_data.ngp:
            location_name_groups["New Game+"].add(location_name)

################################################################################

if set(VISIBILITY_CONVERT_KEYS.keys()) != set(location_name_groups.keys()):
    missing_keys = set(VISIBILITY_CONVERT_KEYS.keys()) - set(location_name_groups.keys())
    extra_keys = set(location_name_groups.keys()) - set(VISIBILITY_CONVERT_KEYS.keys())
    if missing_keys:
        print(f"Error: location_name_groups hasn't got these keys: {missing_keys}")
    if extra_keys:
        print(f"Error: VISIBILITY_CONVERT_KEYS hasn't got these keys: {extra_keys}")
    sys.exit(1)

import json
output_file = os.path.join(
    os.path.dirname(__file__),
    "fetched_locations.json"
)

data = {
    "location_name_groups": {
        VISIBILITY_CONVERT_KEYS[key]: sorted([loc for loc in location_name_groups[key]])
        for key in VISIBILITY_CONVERT_KEYS.keys()
    },
    "location_name_to_id": dict(sorted({
        location_name: location_data.ap_code 
        for location_name, location_data in location_dictionary.items()
        if not location_data.is_event
    }.items(), key=lambda x: x[1]))
}
with open(output_file, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=4, ensure_ascii=True)

print(f"Locations data saved to: {output_file}")
print(f"NEXT: Compare 'matched_locations.json' with 'fetched_locations.json' to verify correctness. Run '3-compare-fletched_and_match.py' script.")
