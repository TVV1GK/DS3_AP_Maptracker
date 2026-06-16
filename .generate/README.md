# How to update visibility_rules and AP location IDs?

1. Clone the latest [Archipelago](https://github.com/ArchipelagoMW/Archipelago.git) repository or ensure you have the latest version.
    > ⚠️ Warning ⚠️
    > DS3 4.0 AP world is currently not pulled into the main ArchipelagoMW repository, so you need to clone fswap's ArchipelagoMW fork: [from-software-archipelago-clients](https://github.com/fswap/Archipelago).

2. Run a launcher Python script from the cloned repository to install the required dependencies.
    - Use `py [filepath]` to run the script. You need Python installed (3.11 <= 3.13) and added to your PATH (pyenv is recommended). Run the script the second time, if the first time fails (I have no idea why, but it works).
    - Running one of `WebHost.py`, `Generate.py` or `Launcher.py` should be enough.

2. Copy the main `locations.jsonc` to this folder and rename it to `ref_locations.jsonc`.
    - Change back to '/' versions in `name` keys in `ref_locations.jsonc` to match the cloned repository. The previous changes should be listed in Step 9.

3. In `1-locations-ref_to_match.py` and `2-locations-repo_to_fletched.py`, change `ARCHIPELAGO_PATH` to point to the cloned repository.

4. Run `1-locations-ref_to_match.py`. This will generate `matched_locations.json` based on the cloned repository and the current `ref_locations.jsonc`.
    - Install JSON5 package, if you don't have it: `pip install json5`
    - If a validation error occurs, you must fix it before proceeding to the next steps. If you remove/rename a section name, write down the old and new names, because a `ref` key could point to the old name.
    - You can change `INPUT_TO_CONTINUE` to `True` to pause after each difference for easier review.

5. Run `2-locations-repo_to_fletched.py`. This will generate `fetched_locations.json` based on the cloned repository.
    - It fails to run if there's any difference between `VISIBILITY_CONVERT_KEYS` in `visibility_convert_keys.py` and the cloned repository. You must fix the differences before proceeding to the next steps.
    - If you want to manually add a location group, you have to modify the `location_name_groups` dictionary in `2-locations-repo_to_fletched.py`.
    - If a location group has been added/renamed, then you should create an image for it, add a json item for it in `items\settings.json` and add the json item's `codes` in `layouts\settings.json`.

6. Run `3-compare-fletched_and_match.py`. This will list the differences between `fetched_locations.json` and `matched_locations.json`.
    - [A] and [B] should be empty
    - [C] and [D] are the visibility rules differences between the two files.
    - [E] should list the custom visibility rules that are not in `VISIBILITY_CONVERT_KEYS` (these are listed in Step 9).

7. If everything looks good, run `4-locations-match_to_new.py` to generate the updated `locations.jsonc` with the new visibility rules and AP location IDs in the `\locations` folder.

8. Copy the generated `locations.jsonc` to the main folder, replacing the old one.

9. Change the following things in the new `locations.jsonc`:
    - Change `name` keys which have '/' in them because of PopTracker's requirements.
        - You can use this regex pattern to find them: `"name"\s*:\s*"(?:[^"\\]|\\.)*/(?:[^"\\]|\\.)*"`
        - List of previous changes:
            - Yoel/Yuria -> Yoel or Yuria
            - Hodrick w/Sirris -> Hodrick with Sirris
    - These locations have custom visibility rules, so manually add the following keys to their visibility rules:
        - `behindMissableProgression`:
            - `HWL: Red Eye Orb - wall tower, miniboss`
            - `RC: Dragonhead Shield - streets monument, across bridge`
            - `RC: Large Soul of a Crestfallen Knight - streets monument, across bridge`
            - `RC: Divine Blessing - streets monument, mob drop`
            - `RC: Lapp's Helm - Lapp`
            - `RC: Lapp's Armor - Lapp`
            - `RC: Lapp's Gauntlets - Lapp`
            - `RC: Lapp's Leggings - Lapp`

10. Redo the comments in `locations.jsonc`.