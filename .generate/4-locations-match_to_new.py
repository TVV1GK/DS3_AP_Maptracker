from enum import Enum
import json5
import json
import os
import copy

# ── File paths ────────────────────────────────────────────────────────────────

sections_file = os.path.join(
    os.path.dirname(__file__),
    "matched_locations.json"
)

vis_file = os.path.join(
    os.path.dirname(__file__),
    "fetched_locations.json"
)

output_file = os.path.join(
    os.path.dirname(__file__),
    "locations\\locations.jsonc"
)

# ── Define json structure order ──────────────────────────────────────────────

class Level(Enum):
    CHILD = "location"
    SECTION = "location section"
    SECTION_REF = "location section reference"

STRUCTURE_ORDER = {
    Level.CHILD: [
        "name",
        "access_rules",
        "visibility_rules",
        "sections",
        "children",
        "map_locations",
    ],
    Level.SECTION: [
        "name",
        "access_rules",
        "visibility_rules",
        "ap_id",
    ],
    Level.SECTION_REF: [
        "name",
        "ref",
    ],
}

# ── Build ground-truth visibility from location_name_groups ──────────────────

def build_name_to_keys(location_name_groups: dict[str, list[str]]) -> dict[str, list[str]]:
    """Return section_name -> list of vis keys it belongs to (per the groups file)."""
    result: dict[str, list[str]] = {}
    for key, names in [item for item in location_name_groups.items() if item[0] != "everywhere"]: # "everywhere" shouldn't be included in the JSON
        for name in names:
            if name in result.get(key, []):
                print(f"Error: duplicate section name '{name}' found in location_name_groups['{key}']")
            else:
                result.setdefault(name, []).append(key)
    return result


# ── Visibility helpers ────────────────────────────────────────────────────────

def keys_to_rule_string(keys: list[str]) -> str | None:
    """Serialise a list of vis keys back to a comma-separated string, or None."""
    if not keys:
        return None
    return ",".join(keys)

def set_visibility(node: dict, keys: list[str], level: Level) -> None:
    """Write (or remove) the visibility_rules entry on a node in-place."""
    rule = keys_to_rule_string(keys)
    ordered_keys = STRUCTURE_ORDER[level]

    wrong_keys = [k for k in node.keys() if k not in ordered_keys]
    if wrong_keys:
        print(f"ERROR: node '{node.get('name', '<unnamed>')}' is level '{level.value}' which cannot have key(s): {wrong_keys}")

    new_node = {}
    
    for key in ordered_keys:
        if key == "visibility_rules":
            if rule:
                new_node[key] = [rule]
        elif key in node:
            new_node[key] = node[key]
    
    node.clear()
    node.update(new_node)


# ── Core tree-rewriting logic ─────────────────────────────────────────────────

def get_section_keys(section: dict, name_to_keys: dict[str, list[str]]) -> list[str]:
    """Return the ground-truth vis keys for a (non-ref) section."""
    return name_to_keys.get(section["name"], [])


def process_sections(
    sections: list[dict],
    name_to_keys: dict[str, list[str]],
    name_to_id: dict[str, int],
) -> list[str]:
    """
    Update every non-ref section in `sections` in-place:
      - set its visibility_rules from ground truth
      - set its ap_id from location_name_to_id

    Returns the intersection of all sections' key-lists.
    """

    key_lists: list[list[str]] = []

    for sec in sections:
        if "ref" in sec:
            key_lists.append([]) # treat reference sections as having no keys
            continue

        # ap_id
        ap_id = name_to_id.get(sec["name"])
        if ap_id is not None:
            sec["ap_id"] = ap_id
        else:
            print(f"ERROR: section '{sec['name']}' has no entry in location_name_to_id")

        # visibility_rules
        keys = get_section_keys(sec, name_to_keys)
        set_visibility(sec, keys, Level.SECTION)
        key_lists.append(keys)

    if key_lists:
        intersection_list = key_lists[0]
        for l in key_lists[1:]:
            intersection_list = [k for k in intersection_list if k in l]
        return intersection_list
    else:
        return []


def process_child(
    child: dict,
    name_to_keys: dict[str, list[str]],
    name_to_id: dict[str, int],
) -> list[str]:
    """
    Recursively process a child node.
    Returns the intersection of all descendant section key-lists.
    """
    candidate_sets: list[list[str]] = []

    # Process own sections
    if "sections" in child:
        inter = process_sections(child["sections"], name_to_keys, name_to_id)
        candidate_sets.append(inter)

    # Recurse into grandchildren
    for grandchild in child.get("children", []):
        inter = process_child(grandchild, name_to_keys, name_to_id)
        candidate_sets.append(inter)

    subtree_intersection: list[str] = []

    if candidate_sets:
        subtree_intersection = candidate_sets[0]
        for l in candidate_sets[1:]:
            subtree_intersection = [k for k in subtree_intersection if k in l]
    else:
        subtree_intersection = []

    # Bubble up: move keys shared by ALL descendants onto this child,
    # and strip them from every descendant section / child node.
    if subtree_intersection:
        _strip_keys_from_subtree(child, subtree_intersection, skip_self=True)
        set_visibility(child, subtree_intersection, Level.CHILD)
    else:
        set_visibility(child, [], Level.CHILD)

    # Return what we'd bubble further up (the full subtree intersection)
    return subtree_intersection

# ── Key stripping helpers ─────────────────────────────────────────────────────

def _parse_own_keys(node: dict) -> list[str]:
    """Parse whatever visibility_rules is currently set on a node."""
    raw = node.get("visibility_rules")
    if not raw:
        return []
    return [k.strip() for k in raw[0].split(",") if k.strip()]


def _strip_keys_from_subtree(
    node: dict,
    keys_to_remove: list[str],
    skip_self: bool = False,
) -> None:
    """
    Remove `keys_to_remove` from every section and child
    in the subtree rooted at `node`. Optionally skip the node itself.
    """
    if not skip_self:
        own = _parse_own_keys(node)
        set_visibility(node, [k for k in own if k not in keys_to_remove], Level.CHILD)

    for sec in node.get("sections", []):
        own = _parse_own_keys(sec)
        set_visibility(sec, [k for k in own if k not in keys_to_remove], Level.SECTION_REF if node.get("ref") else Level.SECTION)

    for child in node.get("children", []):
        _strip_keys_from_subtree(child, keys_to_remove)


# ── Entry point ───────────────────────────────────────────────────────────────

def rewrite(sections_path: str, vis_path: str, output_path: str) -> None:
    with open(sections_path, encoding="utf-8") as f:
        sections_data: list = json5.load(f)
    with open(vis_path, encoding="utf-8") as f:
        vis_data: dict = json5.load(f)

    print(f"\n------ Processing ------")

    name_to_keys = build_name_to_keys(vis_data.get("location_name_groups", {}))
    name_to_id   = vis_data.get("location_name_to_id", {})

    # Deep-copy so we never mutate the originals
    output = copy.deepcopy(sections_data)

    for map_node in output:
        process_child(map_node, name_to_keys, name_to_id)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(output, f, indent=4, ensure_ascii=True)

    print(f"--------- Done ---------")

    print(f"Written to '{output_path}'")

if __name__ == "__main__":
    rewrite(sections_file, vis_file, output_file)
