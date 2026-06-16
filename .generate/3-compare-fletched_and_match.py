import json5
import os
from visibility_convert_keys import VISIBILITY_CONVERT_KEYS

# ── VISIBILITY_CONVERT_KEYS (values are the canonical key names) ──────────────

KNOWN_VIS_KEYS = set(VISIBILITY_CONVERT_KEYS.values())

# ── File paths ────────────────────────────────────────────────────────────────

sections_file = os.path.join(
    os.path.dirname(__file__),
    "matched_locations.json"
)

vis_file = os.path.join(
    os.path.dirname(__file__),
    "fetched_locations.json"
)

# ── Helpers ───────────────────────────────────────────────────────────────────

def parse_vis_rules(node: dict, inherited: frozenset[str]) -> frozenset[str]:
    """Return the effective visibility key-set for a node (own + inherited)."""
    raw = node.get("visibility_rules")
    if raw:
        # heuristic: single string element
        own = frozenset(k.strip() for k in raw[0].split(",") if k.strip())
    else:
        own = frozenset()
    return inherited | own


def collect_sections(sections_data: list) -> dict[str, frozenset[str]]:
    """
    Walk the sections JSON tree and return a mapping of
      section_name -> effective visibility keys (inherited + own)
    Reference sections (those with a "ref" key) are skipped.
    """
    result: dict[str, frozenset[str]] = {}

    def walk_map(map_node: dict):
        map_vis = parse_vis_rules(map_node, frozenset())
        for child in map_node.get("children", []):
            walk_child(child, map_vis)

    def walk_child(child_node: dict, parent_vis: frozenset[str]):
        child_vis = parse_vis_rules(child_node, parent_vis)
        for section in child_node.get("sections", []):
            if "ref" in section:
                continue # skip reference sections
            sec_vis = parse_vis_rules(section, child_vis)
            name = section["name"]
            # if a name appears multiple times, union the key-sets
            if name in result:
                print(f"Error: duplicate section name '{name!r}' found; "
                      f"unioning visibility keys")
            result[name] = result.get(name, frozenset()) | sec_vis
        for grandchild in child_node.get("children", []):
            walk_child(grandchild, child_vis)

    for map_node in sections_data:
        walk_map(map_node)

    return result


# ── Main comparison ───────────────────────────────────────────────────────────

def compare(sections_path: str, vis_path: str) -> None:
    with open(sections_path, encoding="utf-8") as f:
        sections_data: list = json5.load(f)
    with open(vis_path, encoding="utf-8") as f:
        vis_data: dict = json5.load(f)

    location_name_to_id: dict[str, int] = vis_data.get("location_name_to_id", {})
    location_name_groups: dict[str, list[str]] = vis_data.get("location_name_groups", {})

    # All section names defined in location_name_groups (across all keys)
    all_group_names: set[str] = {
        name for names in location_name_groups.values() for name in names
    }

    # Collect sections from the JSON tree
    section_vis: dict[str, frozenset[str]] = collect_sections(sections_data)
    all_section_names: set[str] = set(section_vis.keys())

    sep = "─" * 72

    # ── Part 1: orphan / unknown names ────────────────────────────────────────
    print(sep)
    print("PART 1 — Names not reconciled between the two files")
    print(sep)

    # Sections present in the JSON tree but absent from location_name_to_id
    not_in_id_map = all_section_names - set(location_name_to_id.keys())
    print(f"\n[A] Sections in JSON but NOT in location_name_to_id "
          f"({len(not_in_id_map)}):")
    for n in not_in_id_map:
        print(f"    {n!r}")

    # Section names present in location_name_groups but absent from the JSON tree
    not_in_sections = sorted(all_group_names - all_section_names)
    print(f"\n[B] Section names in location_name_groups but NOT in JSON "
          f"({len(not_in_sections)}):")
    for n in not_in_sections:
        print(f"    {n!r}")

    # ── Part 2: visibility key mismatches ─────────────────────────────────────
    print(f"\n{sep}")
    print("PART 2 — Visibility key mismatches")
    print(sep)

    # Only consider keys that exist in both sources (KNOWN_VIS_KEYS ∩ group keys)
    group_keys = set(location_name_groups.keys())

    if group_keys != KNOWN_VIS_KEYS:
        missing_keys = group_keys - KNOWN_VIS_KEYS
        extra_keys = KNOWN_VIS_KEYS - group_keys
        if missing_keys:
            print(f"\nERROR: KNOWN_VIS_KEYS hasn't got these keys: {sorted(missing_keys)}")
        if extra_keys:
            print(f"\nERROR: location_name_groups hasn't got these keys: {sorted(extra_keys)}")

    checked_keys = KNOWN_VIS_KEYS & group_keys - set(["everywhere"])  # "everywhere" is not included in the JSON

    missing_from_section: dict[str, list[str]] = {}
    missing_from_group:   dict[str, list[str]] = {}

    for key in sorted(checked_keys):
        group_names = set(location_name_groups[key])

        for name in sorted(group_names):
            # Section names is in the group but doesn't have the key in its vis rules
            sec_keys = section_vis.get(name, frozenset())
            if key not in sec_keys:
                missing_from_section.setdefault(key, []).append(name)

        for name, sec_keys in section_vis.items():
            if key not in sec_keys:
                continue
            # Section claims the key is in its vis rules but is absent from the group
            if name not in group_names:
                missing_from_group.setdefault(key, []).append(name)

    print(f"\n[C] Section names in location_name_groups[key] but key NOT in section's "
          f"visibility_rules:")
    if missing_from_section:
        for key in sorted(missing_from_section):
            names = missing_from_section[key]
            print(f"\n  key={key!r} ({len(names)} section(s))")
            for n in names:
                print(f"    {n!r}")
    else:
        print("    (none)")

    print(f"\n[D] Key in section's visibility_rules but section name NOT in "
          f"location_name_groups[key]:")
    if missing_from_group:
        for key in sorted(missing_from_group):
            names = missing_from_group[key]
            print(f"\n  key={key!r} ({len(names)} section(s))")
            for n in names:
                print(f"    {n!r}")
    else:
        print("    (none)")

    missing_group_entries: dict[str, list[str]] = {}

    for section_name, sec_keys in section_vis.items():
        for key in sec_keys:
            if key not in location_name_groups:
                missing_group_entries.setdefault(key, []).append(section_name)

    print(f"\n[E] Key in section's visibility_rules but does NOT have a corresponding entry in "
          f"location_name_groups[key]:")
    if missing_group_entries:
        for key in sorted(missing_group_entries):
            names = sorted(missing_group_entries[key])
            print(f"\n  key={key!r} ({len(names)} section(s))")
            for name in names:
                print(f"    {name!r}")

    print(f"\n{sep}")
    print("Done.")
    print(f"NEXT: Generate updated locations file. Run '4-locations-match_to_new.py' script.")


# ── Entry point ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    compare(sections_file, vis_file)
