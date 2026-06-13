--- @enum log_level
LOG_LEVELS = {
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4,
}

--- PopTracker's debug output setting.
DEBUG =  {"errors"}

--- Pack's own logging level.
--- @type log_level
LOG_LEVEL = LOG_LEVELS.DEBUG

--- Whether the variant loaded in PopTracker is an "itemsonly" variant.
--- @type boolean
IS_ITEMS_ONLY = Tracker.ActiveVariantUID:find("itemsonly") ~= nil

print("-- Dark Souls III Tracker --")

ScriptHost:LoadScript("scripts/hidden_item_codes.lua")
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/custom_rules.lua")

Tracker:AddItems("items/items.jsonc")

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

if not IS_ITEMS_ONLY then
    Tracker:AddItems("items/settings.jsonc")
    Tracker:AddItems("items/hidden_items.jsonc")
    Tracker:AddLayouts("layouts/settings.json")
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLocations("locations/locations.jsonc")

    -- We need to reset the hidden items when starting PopTracker, otherwise
    -- in some cases it would be impossible to change a location's state
    SetAllHiddenItems(true)
end

ScriptHost:LoadScript("scripts/archipelago.lua")