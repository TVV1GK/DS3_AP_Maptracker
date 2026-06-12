# Changelog
## v1.0.0
- Initial release of DS3 AP Maptracker
### v1.0.1
- Updated some location visibilities
### v1.0.2
- Fixed a location issue
### v1.0.3
- Improve item icons by @kaffo in https://github.com/TVV1GK/DS3_AP_Maptracker/pull/1
- Yoel and Yuria location names updated to match Archipleago 0.6.1
### v1.0.4
- Fixed SL: Chaos Gem locations
### v1.0.5
- Updated some location visibilities to match Archipleago 0.6.5
- Fixed Red and White Round Shield name
- README.md updated to better reflect current features
- Removed Everywhere and missable_location_behavior settings
- Removed DLC setting automatically turning on
- Update initial state for settings to reflect the default settings for AP
## v2.0.0
- Updated to work with the new [DS3 AP client and world (4.0.X)](https://github.com/fswap/from-software-archipelago-clients)
- Recreated the access rules to match exactly the new AP world (even the missable locations)
- [only works when connected to AP] Yhorm is now tracked, meaning that locations behind him are shown as unreachable until `Storm Ruler` is obtained
- Added 3 new visibility groups: `Drops`, `Shops` and `missable_location_behavior`
- Added 3 new Location Keys: `Storm Ruler`, `Chameleon` and `Twinkling Dragon Torso Stone`
- [only works when connected to AP] Added all remaining progression items to the tracker, although the these are not displayed and cannot be modified by the user
- Added soft logic for killing NPCs, so users are notified not to kill them immediately
- Changed the text on `FS` map from `Shop after killing` to `Shop after ...`