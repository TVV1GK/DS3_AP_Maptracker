--- From https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
--- 
--- Dumps a table in a readable string.
--- @param o table The table to dump.
--- @param depth? number The current depth of the table (used for indentation).
--- @return string dumped_table The dumped table as a string.
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

--- Gets the key of a table by its value.
--- @param table table The table to search through.
--- @param value number|string|boolean The value to find the key for.
--- @return number|string|boolean? key The key corresponding to the value, or nil if not found.
function GetKeyByValue(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
    return nil
end

--- Checks if a table contains a specific value.
--- @param table table The table to search through.
--- @param value number|string|boolean The value to check for.
--- @return boolean true If the table contains the value.
function DoesTableContainValue(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function LoadJson(path)
    local json = require("jsonc")
    local ok, data = pcall(json.read_jsonc_file, path)

    if not ok or type(data) ~= "table" then
        print("WARNING: unable to read file")
        data = nil
    end

    return data, json
end

--- PopTracker supported types.
--- @enum object_types
OBJECT_TYPES = {
    JsonItem = 1,
    LuaItem = 2,
    LocationSection = 3,
    Location = 4,
}

--- OBJECT_TYPES converted to strings for debugging purposes.
--- @type table<object_types, string>
OBJECT_TYPES_AS_STRINGS = {
    [OBJECT_TYPES.JsonItem] = "JsonItem",
    [OBJECT_TYPES.LuaItem] = "LuaItem",
    [OBJECT_TYPES.LocationSection] = "LocationSection",
    [OBJECT_TYPES.Location] = "Location",
}

--- Gets an object by its code and checks if it is any of the expected types.
--- @param code string The code of the object to find.
--- @param expected_types object_types|table<object_types> The expected type(s) of the object.
--- @return AnyObject? object The object if found and is any of the expected types, or nil otherwise.
--- @return object_types? returned_type The type of the returned object, or nil if not found.
function GetObjTypeSafe(code, expected_types)
    if type(expected_types) ~= "table" then
        expected_types = { expected_types }
    end

    local obj = Tracker:FindObjectForCode(code)
    local returned_type = nil
    if obj then
        if obj.Type and obj.Type ~= "custom" then
            if not DoesTableContainValue(expected_types, OBJECT_TYPES.JsonItem) then
                obj = nil
            else
                returned_type = OBJECT_TYPES.JsonItem
            end
        elseif obj.Type then
            if not DoesTableContainValue(expected_types, OBJECT_TYPES.LuaItem) then
                obj = nil
            else
                returned_type = OBJECT_TYPES.LuaItem
            end
        elseif obj.FullID then
            if not DoesTableContainValue(expected_types, OBJECT_TYPES.LocationSection) then
                obj = nil
            else
                returned_type = OBJECT_TYPES.LocationSection
            end
        elseif obj.AccessibilityLevel then
            if not DoesTableContainValue(expected_types, OBJECT_TYPES.Location) then
                obj = nil
            else
                returned_type = OBJECT_TYPES.Location
            end
        else
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                print(string.format("> ERROR: [GetObjTypeSafe] Unimplemented PopTracker type for object with code '%s'", code))
            end
            return nil, nil
        end
    end

    if not obj and LOG_LEVEL <= LOG_LEVELS.ERROR then
        local expected_types_str = {}
        for _, t in ipairs(expected_types) do
            table.insert(expected_types_str, OBJECT_TYPES_AS_STRINGS[t] or tostring(t))
        end
        if returned_type then
            print(string.format("> ERROR: [GetObjTypeSafe] Object for code '%s' is of type '%s', but expected type(s): '%s'", code, OBJECT_TYPES_AS_STRINGS[returned_type] or tostring(returned_type), table.concat(expected_types_str, ", ")))
        else
            print(string.format("> ERROR: [GetObjTypeSafe] Object for code '%s' does not exist", code))
        end
    end

    return obj, returned_type
end

if not IS_ITEMS_ONLY then
    --- accessibilityLevel converted to strings for debugging purposes.
    --- @type table<accessibilityLevel, string>
    ACCESSIBILITY_LEVELS_AS_STRINGS = {
        [AccessibilityLevel.None] = "None",
        [AccessibilityLevel.Partial] = "Partial",
        [AccessibilityLevel.Inspect] = "Inspect",
        [AccessibilityLevel.SequenceBreak] = "SequenceBreak",
        [AccessibilityLevel.Normal] = "Normal",
        [AccessibilityLevel.Cleared] = "Cleared",
    }

    --- Gets the accessibility level for a given rule.
    --- @param rule string The rule to check.
    --- @param ... string If the rule is a function, the arguments to pass to the function.
    --- @return accessibilityLevel accessibility_level The accessibility level based on the rule.
    function ConvertRulesToAccessibilityLevels(rule, ...)
        -- Location or location section rule (@)
        if rule:sub(1, 1) == "@" then
            local obj = GetObjTypeSafe(rule, {OBJECT_TYPES.Location, OBJECT_TYPES.LocationSection})
            if obj then
                return obj.AccessibilityLevel
            end
            return AccessibilityLevel.Normal
        end

        local rule_version = -1 -- -1 = not a function, 0 = $, 1 = ^$
        if rule:sub(1, 2) == "^$" then
            rule = rule:sub(3)
            rule_version = 1
        elseif rule:sub(1, 1) == "^" then
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                if #{...} > 0 then
                    print(string.format("> ERROR: [ConvertRulesToAccessibilityLevels] Rule '%s|%s' starts with '^' but not followed by '$'", rule, table.concat({...}, "|")))
                else
                    print(string.format("> ERROR: [ConvertRulesToAccessibilityLevels] Rule '%s' starts with '^' but not followed by '$'", rule))
                end
            end
            return AccessibilityLevel.Normal
        elseif rule:sub(1, 1) == "$" then
            rule_version = 0
            rule = rule:sub(2)
        end

        local min_count
        if rule_version ~= 1 then
            local base_rule, count = rule:match("([^:]*):(.*)")
            if base_rule and count then
                rule = base_rule
                min_count = tonumber(count)
                if not min_count then
                    if LOG_LEVEL <= LOG_LEVELS.ERROR then
                        if #{...} > 0 then
                            print(string.format("> ERROR: [ConvertRulesToAccessibilityLevels] Rule '%s|%s' has an invalid min_count value '%s'", rule, table.concat({...}, "|"), min_count))
                        else
                            print(string.format("> ERROR: [ConvertRulesToAccessibilityLevels] Rule '%s' has an invalid min_count value '%s'", rule, min_count))
                        end
                    end
                    return AccessibilityLevel.Normal
                end
            else
                min_count = 1
            end
        else
            min_count = 1
        end

        -- Function rule ($ or ^$)
        if rule_version ~= -1 then
            local fn = _G[rule]
            if type(fn) ~= "function" then
                if LOG_LEVEL <= LOG_LEVELS.ERROR then
                    if #{...} > 0 then
                        print(string.format("> ERROR: [ConvertRulesToAccessibilityLevels] Rule '%s|%s' is not a valid function", rule, table.concat({...}, "|")))
                    else
                        print(string.format("> ERROR: [ConvertRulesToAccessibilityLevels] Rule '%s' is not a valid function", rule))
                    end
                end
                return AccessibilityLevel.Normal
            end

            local result = fn(table.unpack({...}))

            if type(result) == "boolean" then
                if (result and min_count < 2) or min_count < 1 then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            elseif type(result) == "number" then
                if rule_version == 1 then
                    return result
                else
                    if result >= min_count then
                        return AccessibilityLevel.Normal
                    else
                        return AccessibilityLevel.None
                    end
                end
            end
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                if #{...} > 0 then
                    print(string.format("> ERROR: [ConvertRulesToAccessibilityLevels] Rule '%s|%s' returned an invalid type '%s'", rule, table.concat({...}, "|"), type(result)))
                else
                    print(string.format("> ERROR: [ConvertRulesToAccessibilityLevels] Rule '%s' returned an invalid type '%s'", rule, type(result)))
                end
            end
            return AccessibilityLevel.Normal
        end

        -- Item rule
        local item_obj = GetObjTypeSafe(rule, {OBJECT_TYPES.JsonItem, OBJECT_TYPES.LuaItem})
        if item_obj then
            local count = Tracker:ProviderCountForCode(rule)
            if count >= min_count then
                return AccessibilityLevel.Normal
            else
                return AccessibilityLevel.None
            end
        end
        return AccessibilityLevel.Normal
    end

    local HIDDEN_ITEM_CODES = require("hidden_item_codes")

    --- Sets all hidden items to active or inactive based on the provided value. Only applies to items of type 'toggle', others are reset.
    --- @param value boolean Whether to set all hidden items to active (true) or inactive (false). Only applies to items of type 'toggle'.
    function SetAllHiddenItems(value)
        for _, item_code in pairs(HIDDEN_ITEM_CODES) do
            local hidden_item_obj = GetObjTypeSafe(item_code, OBJECT_TYPES.JsonItem)
            if hidden_item_obj then
                if hidden_item_obj.Type == "toggle" then
                    hidden_item_obj.Active = value
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
end
