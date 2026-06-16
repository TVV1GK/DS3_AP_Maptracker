from region_convert_keys import REGION_CONVERT_KEYS

INPUT_TO_CONTINUE = False

import copy
import sys
import os

ARCHIPELAGO_PATH = r""
sys.path.insert(0, ARCHIPELAGO_PATH)

# pyright: reportMissingImports=false
from worlds.dark_souls_3.Locations import location_tables, DS3LocationData

##############################################################################################################
print("=" * 80)
print("VALIDATION: Checking if REGION_CONVERT_KEYS keys match AP location dictionary keys")
print("-" * 80)

if set(REGION_CONVERT_KEYS.keys()) != set(location_tables.keys()):
    print("\n❌ VALIDATION FAILED - Issues found:\n")
    missing_keys = set(REGION_CONVERT_KEYS.keys()) - set(location_tables.keys())
    extra_keys = set(location_tables.keys()) - set(REGION_CONVERT_KEYS.keys())
    if missing_keys:
        print(f"Error: location_tables (AP location table) hasn't got these keys: {missing_keys}")
    if extra_keys:
        print(f"Error: REGION_CONVERT_KEYS hasn't got these keys: {extra_keys}")
    sys.exit(1)

print("✓ All REGION_CONVERT_KEYS keys match AP location dictionary keys!")
if INPUT_TO_CONTINUE:
    input("Press Enter to continue...")

import json5

# Create reverse mapping: short code -> full name
CONVERT_KEYS_REVERSE = {v: k for k, v in REGION_CONVERT_KEYS.items()}

# Load the locations JSON
locations_json_path = os.path.join(
    os.path.dirname(__file__),
    "ref_locations.jsonc"
)

with open(locations_json_path, "r", encoding="utf-8") as f:
    locations_data = json5.load(f)

# Build a dictionary of all location names in location_tables for quick lookup
location_names_by_table = {}
for table_key, location_list in location_tables.items():
    location_names_by_table[table_key] = [loc.name for loc in location_list if not loc.is_event]

##############################################################################################################
print("=" * 80)
print("VALIDATION: Checking if all region names in the JSONC exist as keys in AP location dictionary")
print("-" * 80)

all_region_names_in_json = set(loc.get("name") for loc in locations_data)

if all_region_names_in_json != set(CONVERT_KEYS_REVERSE.keys()):
    print("\n⚠️  VALIDATION FAILED - Issues found:\n")
    missing_keys = all_region_names_in_json - set(CONVERT_KEYS_REVERSE.keys())
    extra_keys = set(CONVERT_KEYS_REVERSE.keys()) - all_region_names_in_json
    if missing_keys:
        print(f"Error: locations_tables (AP location dictionary) hasn't got these keys: {missing_keys}")
    if extra_keys:
        print(f"Error: all_region_names_in_json (JSONC) hasn't got these keys: {extra_keys}")
else:
    print("✓ All region names in JSONC match keys in AP location dictionary!")

if INPUT_TO_CONTINUE:
    input("Press Enter to continue...")
##############################################################################################################
print("=" * 80)
print("VALIDATION: Checking if all section names are unique in the AP location dictionary")
print("-" * 80)

errors = {}

for table_key, location_list in location_names_by_table.items():
    for loc in location_list:
        if loc in errors:
            continue

        table_keys_with_loc = []
        for table_keyEq, location_listEq in location_names_by_table.items():
            duplicates = [locEq for locEq in location_listEq if locEq == loc]
            if duplicates and (table_key != table_keyEq or len(duplicates) > 1):
                table_keys_with_loc.append(table_keyEq)

        if table_keys_with_loc:
            errors[loc] = f"ERROR: Section name '{loc}' is not unique, found in regions: {table_keys_with_loc}"

if errors != {}:
    print("\n❌ VALIDATION FAILED - Issues found:\n")
    for error in errors.values():
        print(f"  {error}")
    print(f"\nTotal errors: {len(errors)}")
    sys.exit(1)
else:
    print("✓ All section names are unique in the AP location dictionary!")

if INPUT_TO_CONTINUE:
    input("Press Enter to continue...")
##############################################################################################################
print("=" * 80)
print("VALIDATION: Checking if all section names are unique and not missing 'name' attributes (unless they have a 'ref' attribute) in the JSONC")
print("-" * 80)

name_errors = []
errors = {}

for map_entry in locations_data:
    for loc_entry in map_entry.get("children", []):
        for section in loc_entry.get("sections", []):
            if section.get("ref") is not None:
                continue

            section_name = section.get("name")
            if section_name is None:
                name_errors.append(f"ERROR: A section under '{loc_entry.get('name')}' is missing a 'name' attribute and doesn't have a 'ref' attribute: '{section}'")
                continue

            all_routes = []
            for map_entry_forEq in locations_data:
                for loc_entry_forEq in map_entry_forEq.get("children", []):
                    for section_forEq in loc_entry_forEq.get("sections", []):
                        if section_forEq.get("ref") is not None:
                            continue

                        section_forEq_name = section_forEq.get("name")
                        if section_forEq_name is not None and section_forEq_name == section_name:
                            all_routes.append(f"{map_entry_forEq.get('name')}/{loc_entry_forEq.get('name')}/{section_forEq_name}")

            if len(all_routes) > 1 and section_name not in errors:
                errors[section_name] = f"ERROR: Section name '{section_name}' is not unique, found in routes: {all_routes}"

if name_errors != [] or errors != {}:
    print("\n❌ VALIDATION FAILED - Issues found:\n")
    for name_error in name_errors:
        print(f"  {name_error}")
    for error in errors.values():
        print(f"  {error}")
    print(f"\nTotal errors: {len(name_errors) + len(errors)}")
    sys.exit(1)
else:
    print("✓ All section names are unique and not missing 'name' attributes (unless they have a 'ref' attribute) in the JSONC!")

if INPUT_TO_CONTINUE:
    input("Press Enter to continue...")
##############################################################################################################
print("=" * 80)
print("VALIDATION: Checking if all section names in a location from the JSONC are under the same region in the AP location dictionary")
print("-" * 80)

errors = []

for map_entry in locations_data:
    
    for loc_entry in map_entry.get("children", []):
        all_regions = set()

        for section in loc_entry.get("sections", []):
            if section.get("ref") is not None:
                continue

            section_name = section.get("name")
            
            if section_name is None:
                continue

            region = next((table_key for table_key, location_list in location_names_by_table.items() if section_name in location_list), None)

            if region is not None:
                all_regions.add(region)
        
        if len(all_regions) > 1:
            errors.append(f"ERROR: Sections in '{loc_entry.get('name')}' belong to multiple regions: {all_regions}")

if errors != []:
    print("\n❌ VALIDATION FAILED - Issues found:\n")
    for error in errors:
        print(f"  {error}")
    print(f"\nTotal errors: {len(errors)}")
    sys.exit(1)
else:
    print("✓ All section names in a location from the JSONC are under the same region in the AP location dictionary!")

if INPUT_TO_CONTINUE:
    input("Press Enter to continue...")
##############################################################################################################
print("=" * 80)
print("VALIDATION: Checking if all section names from the JSONC exist in AP location dictionary")
print("-" * 80)

errors = []

for map_entry in locations_data:
    
    for loc_entry in map_entry.get("children", []):

        for section in loc_entry.get("sections", []):
            if section.get("ref") is not None:
                continue

            section_name = section.get("name")
            
            if section_name is None:
                continue

            if next((table_key for table_key, location_list in location_names_by_table.items() if section_name in location_list), None) is None:
                errors.append(f"WARNING: '{section_name}' does not exist in location_tables (AP location dictionary)")

if errors != []:
    print("\n⚠️  VALIDATION WARNING - Issues found:\n")
    for error in errors:
        print(f"  {error}")
    print(f"\nTotal errors: {len(errors)}")
else:
    print("✓ All section names from the JSONC exist in AP location dictionary!")

if INPUT_TO_CONTINUE:
    input("Press Enter to continue...")
##############################################################################################################
print("=" * 80)
print("VALIDATION: Checking if all AP location names are represented in the JSONC")
print("-" * 80)

errors = []

for table_key, location_list in location_names_by_table.items():
    for loc in location_list:
        found = False
        for map_entry in locations_data:
            for loc_entry in map_entry.get("children", []):
                section_names = [section.get("name") for section in loc_entry.get("sections", []) if section.get("ref") is None]
                if loc in section_names:
                    found = True
                    break
            if found:
                break
        if not found:
            errors.append(f"WARNING: Location '{loc}' in location_tables (AP location dictionary) is not represented in the JSONC")

if errors != []:
    print("\n⚠️  VALIDATION WARNING - Issues found:\n")
    for error in errors:
        print(f"  {error}")
    print(f"\nTotal errors: {len(errors)}")
else:
    print("✓ All AP location names are represented in the JSONC!")

if INPUT_TO_CONTINUE:
    input("Press Enter to continue...")
##############################################################################################################
# Reorganization: Move children to their own location table entries
print("=" * 80)
print("\nREORGANIZATION: Reorganizing structure based on REGION_CONVERT_KEYS")
print("-" * 80)

reorganized_data = []
leftover_maps = set(m.get("name") for m in locations_data if m.get("name") is not None)
new_maps_added = set()

leftover_sections = set(s.get("name") for m in locations_data for loc in m.get("children", []) for s in loc.get("sections", []) if s.get("name") is not None and s.get("ref") is None)
new_sections_added = set()

def del_access_rules(dict: dict) -> None:
    """if "access_rules" in dict:
        del dict["access_rules"]
    if "visibility_rules" in dict:
        del dict["visibility_rules"]"""
    if "item_count" in dict:
        del dict["item_count"]
    pass

for map_entry, location_list in location_names_by_table.items():
    matching_map_entry = next((m for m in locations_data if m.get("name") is not None and m.get("name") == REGION_CONVERT_KEYS.get(map_entry, map_entry)), None)
    new_map_entry: dict
    
    if matching_map_entry is None:
        new_map_entry = {
            "name": REGION_CONVERT_KEYS.get(map_entry, map_entry),
            "children": []
        }
        new_maps_added.add(new_map_entry["name"])
    else:
        new_map_entry = matching_map_entry.copy()
        new_map_entry["children"] = []
        leftover_maps.discard(new_map_entry["name"])

    del_access_rules(new_map_entry)

    location_list_copy = copy.deepcopy(location_list)

    for loc in location_list:
        if loc not in location_list_copy:
            continue

        matching_loc_entry = None
        for m in locations_data:
            for loc_entry in m.get("children", []):
                if any(s.get("name") is not None and s.get("ref") is None and s.get("name") == loc for s in loc_entry.get("sections", [])):
                    matching_loc_entry = copy.deepcopy(loc_entry)
                    if m.get("name", None) != new_map_entry.get("name", None) or (m.get("name", None) is None and new_map_entry.get("name", None) is None):
                        print(f"⚠️  Location '{loc}' has been moved from map '{m.get('name')}' to map '{new_map_entry.get('name')}'.")
                    break
            if matching_loc_entry is not None:
                break

        if matching_loc_entry is None:
            matching_loc_entry = {
                "name": loc,
                "sections": [
                    {
                        "name": loc
                    }
                ]
            }
            new_sections_added.add(f"{REGION_CONVERT_KEYS.get(map_entry, map_entry)}/{loc}/{loc}")
        else:
            leftover_sections.discard(loc)

        del_access_rules(matching_loc_entry)
        for section in matching_loc_entry.get("sections", []):
            del_access_rules(section)

        matching_loc_entry["sections"] = sorted(matching_loc_entry.get("sections", []), key=lambda s: next((i for i, l in enumerate(location_list_copy) if l == s.get("name") and s.get("ref") is None), float('inf')))
        
        remaning_sections = [s.get("name") for s in matching_loc_entry.get("sections", []) if s.get("name") is not None and s.get("ref") is None]
        for rs in remaning_sections:
            if rs in location_list_copy:
                location_list_copy.remove(rs)
                leftover_sections.discard(rs)
            else:
                matching_loc_entry["sections"] = [s for s in matching_loc_entry.get("sections", []) if (s.get("name") is not None and s.get("name") != rs) or s.get("ref") is not None]
                
        new_map_entry["children"].append(matching_loc_entry)

    # From matching_map_entry, if there are any loc entries that only have sections with refs, we want to add them back
    if matching_map_entry is not None:
        for loc_entry in matching_map_entry.get("children", []):
            if all(s.get("ref") is not None for s in loc_entry.get("sections", [])):
                new_map_entry["children"].append(loc_entry)

    reorganized_data.append(new_map_entry)

print(f"✓ Reorganized structure based on REGION_CONVERT_KEYS successfully!")
print("-" * 80)
print(f"New maps added: {len(new_maps_added)} - {new_maps_added}")
print(f"Leftover maps: {len(leftover_maps)} - {leftover_maps}")
print("-" * 80)
print(f"New sections added: {len(new_sections_added)} - {new_sections_added}")
print(f"Leftover sections: {len(leftover_sections)} - {leftover_sections}")
print("=" * 80)

output_file = os.path.join(
    os.path.dirname(__file__),
    "matched_locations.json"
)

import json

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(reorganized_data, f, indent=4, ensure_ascii=True)

print(f"\n✓ Reorganized locations data saved to: {output_file}")
print(f"Total entries: {len(reorganized_data)}")
print(f"NEXT: Create location visibility groups. Run '2-locations-repo_to_fletched' script.")
