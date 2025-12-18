ENABLE_DEBUG_LOG = true -- use --console flag for debugging when running poptracker from cmd
AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP = true

-- get current variant
local variant = Tracker.ActiveVariantUID
-- check variant info
IS_ITEMS_ONLY = variant:find("itemsonly")

print("-- Dark Souls III Tracker --")

ScriptHost:LoadScript("scripts/utils.lua")

Tracker:AddItems("items/items.json")

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

if not IS_ITEMS_ONLY then
    Tracker:AddItems("items/settings.json")
    Tracker:AddLayouts("layouts/settings.json")
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLocations("locations/locations.json")
end

if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/archipelago.lua")
end