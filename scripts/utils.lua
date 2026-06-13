-- From https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- Dumps a table in a readable string
function DumpTable(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. DumpTable(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

--- Gets the key of a table by its value. Returns nil if the value is not found.
--- @param table table The table to search through.
--- @param value any The value to find the key for.
--- @return any? key The key corresponding to the value, or nil if not found.
function GetKeyByValue(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
    return nil
end

-- PopTracker supported types
--- @enum object_types
OBJECT_TYPES = {
    JsonItem = "JsonItem",
    LuaItem = "LuaItem",
    LocationSection = "LocationSection",
    Location = "Location",
}

--- Safely gets an object by its code and checks if it's of the expected type.
--- @param code any The code of the object to find.
--- @param expected_type object_types The expected type of the object.
--- @return AnyObject? object The object if found and of the expected type, or nil otherwise.
function GetObjTypeSafe(code, expected_type)
    local obj = Tracker:FindObjectForCode(code)
    if obj == nil then
        if LOG_LEVEL <= LOG_LEVELS.ERROR then
            print(string.format("> ERROR: [GetObjTypeSafe] Could not find object for code '%s' with expected type '%s'", code, expected_type))
        end
        return nil
    end

    if obj.Type and obj.Type ~= "custom" then
        if expected_type ~= OBJECT_TYPES.JsonItem then
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                print(string.format("> ERROR: [GetObjTypeSafe] Object with code '%s' is a JsonItem, but expected type was %s", code, expected_type))
            end
            return nil
        end
    elseif obj.Type then
        if expected_type ~= OBJECT_TYPES.LuaItem then
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                print(string.format("> ERROR: [GetObjTypeSafe] Object with code '%s' is a LuaItem, but expected type was %s", code, expected_type))
            end
            return nil
        end
    elseif obj.FullID then
        if expected_type ~= OBJECT_TYPES.LocationSection then
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                print(string.format("> ERROR: [GetObjTypeSafe] Object with code '%s' is a LocationSection, but expected type was %s", code, expected_type))
            end
            return nil
        end
    elseif obj.AccessibilityLevel then
        if expected_type ~= OBJECT_TYPES.Location then
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                print(string.format("> ERROR: [GetObjTypeSafe] Object with code '%s' is a Location, but expected type was %s", code, expected_type))
            end
            return nil
        end
    end
    return obj
end

--- Sets all hidden items to active or inactive based on the provided value. Only applies to items of type 'toggle', others are reset.
--- @param value boolean Whether to set all hidden items to active (true) or inactive (false). Only applies to items of type 'toggle'.
function SetAllHiddenItems(value)
    for _, item_code in pairs(HIDDEN_ITEM_CODES) do
        local hidden_item_obj = GetObjTypeSafe(item_code, OBJECT_TYPES.JsonItem)
        if hidden_item_obj then
            if hidden_item_obj.Type == "toggle" then
                hidden_item_obj.Active = value
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [SetAllHiddenItems] Set hidden item '%s' to %s", item_code, tostring(value)))
                end
            elseif hidden_item_obj.Type == "progressive" then
                hidden_item_obj.CurrentStage = 0
                hidden_item_obj.Active = false
            else
                if LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print(string.format("> ERROR: [SetAllHiddenItems] Unrecognized item type '%s' for item code '%s'", hidden_item_obj.Type, item_code))
                end
            end
        end
    end
end