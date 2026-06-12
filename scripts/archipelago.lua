ScriptHost:LoadScript("scripts/item_mapping.lua")
ScriptHost:LoadScript("scripts/location_mapping.lua")

--- A table for determining whether a location is randomized.
--- @type table
local SCOUTING_DETAILS = {
    {
        ["location_section"] = "@US/US: Pyromancy Flame - Cornyx/US: Pyromancy Flame - Cornyx",
        ["item_code"] = "misc_pyromancyFlame",
        ["option_item_code"] = "ap_pyromancyFlameRandomized"
    },
    {
        ["location_section"] = "@US/US: Transposing Kiln - boss drop/US: Transposing Kiln - boss drop",
        ["item_code"] = "misc_transposingKiln",
        ["option_item_code"] = "ap_transposingKilnRandomized"
    },
}

--- All boss location ids, used for validating the Yhorm's location.
--- @type table
local BOSS_LOCATION_IDS = {
    "4000800", -- Iudex Gundyr
    "3000800", -- Vordt of the Boreal Valley
    "3100800", -- Curse-rotted Greatwood
    "3300850", -- Crystal Sage
    "3500800", -- Deacons of the Deep
    "3300801", -- Abyss Watchers
    "3800800", -- High Lord Wolnir
    "3700850", -- Pontiff Sulyvahn
    "3800830", -- Old Demon King
    "3900800", -- Yhorm the Giant
    "3700800", -- Aldrich, Devourer of Gods
    "3000899", -- Dancer of the Boreal Valley
    "3010800", -- Dragonslayer Armour
    "3000830", -- Consumed King Oceiros
    "4000830", -- Champion Gundyr
    "3200800", -- Ancient Wyvern
    "3200850", -- King of the Storm
    "3200851", -- Nameless King
    "3410830", -- Lothric, Younger Prince
    "3410832", -- Lorian, Elder Prince
    "4500860", -- Champion's Gravetender and Gravetender Greatwolf
    "4500801", -- Sister Friede
    "4500800", -- Blackflame Friede
    "5000801", -- Demon Prince
    "5100800", -- Halflight, Spear of the Church
    "5100850", -- Darkeater Midir
    "5110801", -- Slave Knight Gael (Phase 1)
    "5110800", -- Slave Knight Gael (Phase 2)
    "4100800", -- Lords of Cinder
}

--- The flag for the KFF boss, used for determining whether the goal is not KFF boss only.
--- @type string
local KFF_BOSS_FLAG = "14100800"

--- Index of the last processed item/location, used to ignore duplicate callbacks from AP.
--- @type integer?
local CUR_INDEX = nil

--- The slot data received from AP on clear, used for setting options and other details.
--- @type table?
local SLOT_DATA = nil

--- Called when connecting to a (new) server. Resets all locations and items, and sets options based on the received slot data.
--- @param slot_data table The data received from AP on clear, containing options and other details.
local function onClear(slot_data)
    if slot_data == nil then
        if LOG_LEVEL <= LOG_LEVELS.WARNING then
            print("> WARNING: [onClear] Received nil slot_data from AP")
        end
    elseif LOG_LEVEL <= LOG_LEVELS.INFO then
        print(string.format("> INFO: [onClear] Successfully connected to server, received slot_data:\n%s", DumpTable(slot_data)))
    end

    SLOT_DATA = slot_data
    YHORM_LOCATION_ID = nil
    CUR_INDEX = nil

    -- Reset locations
    if LOG_LEVEL <= LOG_LEVELS.INFO then
        print(string.format("> INFO: [onClear] Resetting locations..."))
    end

    for _, location_section in pairs(LOCATION_MAPPING) do
        if location_section then
            local location_obj = GetObjTypeSafe(location_section, OBJECT_TYPES.LocationSection)
            if location_obj then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Resetting location section: '%s'", location_section))
                end
                location_obj.AvailableChestCount = location_obj.ChestCount
            end
        else
            if LOG_LEVEL <= LOG_LEVELS.WARNING then
                print(string.format("> WARNING: [onClear] LOCATION_MAPPING has an empty value"))
            end
        end
    end

    -- Reset items
    if LOG_LEVEL <= LOG_LEVELS.INFO then
        print(string.format("> INFO: [onClear] Resetting items..."))
    end

    for _, item_code in pairs(ITEM_MAPPING) do
        if item_code then
            local item_obj = GetObjTypeSafe(item_code, OBJECT_TYPES.JsonItem)
            if item_obj then
                if item_obj.Type == "toggle" then
                    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                        print(string.format("> DEBUG: [onClear] Resetting toggle item: '%s' ('%s')", item_obj.Name, item_code))
                    end
                    item_obj.Active = false
                elseif item_obj.Type == "progressive" then
                    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                        print(string.format("> DEBUG: [onClear] Resetting progressive item: '%s' ('%s')", item_obj.Name, item_code))
                    end
                    item_obj.CurrentStage = 0
                    item_obj.Active = false
                else
                    if LOG_LEVEL <= LOG_LEVELS.ERROR then
                        print(string.format("> ERROR: [onClear] Unrecognized item type '%s' for item: '%s' ('%s')", item_obj.Type, item_obj.Name, item_code))
                    end
                end
            end
        else
            if LOG_LEVEL <= LOG_LEVELS.WARNING then
                print(string.format("> WARNING: [onClear] ITEM_MAPPING has an empty value"))
            end
        end
    end

    -- Set all hidden items to false
    SetAllHiddenItems(false)

    -- Set settings
    if SLOT_DATA == nil then
        return
    end

    -- Scout locations
    -- We need to scout certain locations AP to check if they are randomized.
    if LOG_LEVEL <= LOG_LEVELS.INFO then
        print(string.format("> INFO: [onClear] Checking AP locations to determine whether we can scout them..."))
    end

    local all_ap_location_ids = { Archipelago.CheckedLocations, Archipelago.MissingLocations }
    local list_of_scouted_location_ids = {}
    for _, scouting_detail in pairs(SCOUTING_DETAILS) do
        local location_section_to_scout = scouting_detail["location_section"]
        local is_location_section_found = false
        local location_id_to_scout = GetKeyByValue(LOCATION_MAPPING, location_section_to_scout)
        if location_id_to_scout then
            for _, location_list in pairs(all_ap_location_ids) do
                for _, location_id in pairs(location_list) do
                    if location_id == location_id_to_scout then
                        if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                            print(string.format("> DEBUG: [onClear] Location section '%s' with id '%s' found in AP locations", location_section_to_scout, location_id_to_scout))
                        end
                        table.insert(list_of_scouted_location_ids, location_id_to_scout)
                        is_location_section_found = true
                        break
                    end
                end
                if is_location_section_found then
                    break
                end
            end
            if not is_location_section_found then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Location section '%s' was not found in the list of checked/missing locations", location_section_to_scout))
                end
            end
        else
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                print(string.format("> ERROR: [onClear] Location section not found for scouting_detail:\n%s", location_section_to_scout, DumpTable(scouting_detail)))
            end
        end
    end

    if #list_of_scouted_location_ids > 0 then
        if LOG_LEVEL <= LOG_LEVELS.INFO then
            print(string.format("> INFO: [onClear] Scouting the following location IDs: %s", DumpTable(list_of_scouted_location_ids)))
        end
        Archipelago:LocationScouts(list_of_scouted_location_ids, 0)
    end

    -- Set options based on slot data
    if LOG_LEVEL <= LOG_LEVELS.INFO then
        print(string.format("> INFO: [onClear] Setting options based on slot data..."))
    end

    local enable_dlc_data = SLOT_DATA.options.enable_dlc
    if enable_dlc_data then
        local dlc_item_obj = GetObjTypeSafe("dlc", OBJECT_TYPES.JsonItem)
        if dlc_item_obj then
            if type(enable_dlc_data) == "number" then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Setting dlc item active state to '%s' from number", tostring(enable_dlc_data ~= 0)))
                end
                dlc_item_obj.Active = enable_dlc_data ~= 0
            elseif type(enable_dlc_data) == "boolean" then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Setting dlc item active state to '%s' from boolean", tostring(enable_dlc_data)))
                end
                dlc_item_obj.Active = enable_dlc_data
            else
                if LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print(string.format("> ERROR: [onClear] Unexpected type for slot_data.options.enable_dlc: '%s'", type(enable_dlc_data)))
                end
            end
        end
    else
        if LOG_LEVEL <= LOG_LEVELS.WARNING then
            print(string.format("> WARNING: [onClear] slot_data.options.enable_dlc is nil"))
        end
    end

    local enable_ngp_data = SLOT_DATA.options.enable_ngp
    if enable_ngp_data then
        local ngp_item_obj = GetObjTypeSafe("ng+", OBJECT_TYPES.JsonItem)
        if ngp_item_obj then
            if type(enable_ngp_data) == "number" then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Setting ng+ item active state to '%s' from number", tostring(enable_ngp_data ~= 0)))
                end
                ngp_item_obj.Active = enable_ngp_data ~= 0
            elseif type(enable_ngp_data) == "boolean" then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Setting ng+ item active state to '%s' from boolean", tostring(enable_ngp_data)))
                end
                ngp_item_obj.Active = enable_ngp_data
            else
                if LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print(string.format("> ERROR: [onClear] Unexpected type for slot_data.options.enable_ngp: '%s'", type(enable_ngp_data)))
                end
            end
        end
    else
        if LOG_LEVEL <= LOG_LEVELS.WARNING then
            print(string.format("> WARNING: [onClear] slot_data.options.enable_ngp is nil"))
        end
    end

    local late_basin_of_vows_data = SLOT_DATA.options.late_basin_of_vows
    if late_basin_of_vows_data then
        local late_basin_of_vows_item_obj = GetObjTypeSafe("ap_lateBasinOfVows", OBJECT_TYPES.JsonItem)
        if late_basin_of_vows_item_obj then
            if type(late_basin_of_vows_data) == "number" then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Setting 'ap_lateBasinOfVows' item stage to '%s'", tostring(late_basin_of_vows_data)))
                end
                late_basin_of_vows_item_obj.CurrentStage = late_basin_of_vows_data
            else
                if LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print(string.format("> ERROR: [onClear] Unexpected type for slot_data.options.late_basin_of_vows: '%s'", type(late_basin_of_vows_data)))
                end
            end
        end
    else
        if LOG_LEVEL <= LOG_LEVELS.WARNING then
            print(string.format("> WARNING: [onClear] slot_data.options.late_basin_of_vows is nil"))
        end
    end

    local late_dlc_data = SLOT_DATA.options.late_dlc
    if late_dlc_data then
        local late_dlc_item_obj = GetObjTypeSafe("ap_lateDlc", OBJECT_TYPES.JsonItem)
        if late_dlc_item_obj then
            if type(late_dlc_data) == "number" then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Setting 'ap_lateDlc' item stage to '%s'", tostring(late_dlc_data)))
                end
                late_dlc_item_obj.CurrentStage = late_dlc_data
            else
                if LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print(string.format("> ERROR: [onClear] Unexpected type for slot_data.options.late_dlc: '%s'", type(late_dlc_data)))
                end
            end
        end
    else
        if LOG_LEVEL <= LOG_LEVELS.WARNING then
            print(string.format("> WARNING: [onClear] slot_data.options.late_dlc is nil"))
        end
    end

    local yhorm_data = SLOT_DATA.yhorm
    if yhorm_data then
        if type(yhorm_data) == "string" then
            YHORM_LOCATION_ID = yhorm_data:match("([^%s]+)$")
            if not GetKeyByValue(BOSS_LOCATION_IDS, YHORM_LOCATION_ID) then
                if LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print(string.format("> ERROR: [onClear] Unexpected id '%s' extracted from slot_data.yhorm: '%s'", YHORM_LOCATION_ID, yhorm_data))
                end
                YHORM_LOCATION_ID = nil
            else
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Extracted Yhorm's location id '%s' from slot_data.yhorm: '%s'", YHORM_LOCATION_ID, yhorm_data))
                end
            end
        else
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                print(string.format("> ERROR: [onClear] Unexpected type for slot_data.yhorm: '%s'", type(yhorm_data)))
            end
        end
    else
        if LOG_LEVEL <= LOG_LEVELS.WARNING then
            print(string.format("> WARNING: [onClear] slot_data.yhorm is nil"))
        end
    end

    local goal_data = SLOT_DATA.goal
    if goal_data then
        local goalNotKffBossOnly_obj = GetObjTypeSafe("ap_goalNotKffBossOnly", OBJECT_TYPES.JsonItem)
        if goalNotKffBossOnly_obj then
            if type(goal_data) == "table" then
                local goal_location_ids = {}
                for _, location_id in pairs(goal_data) do
                    table.insert(goal_location_ids, location_id)
                end
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onClear] Extracted goal location ids:\n%s", DumpTable(goal_location_ids)))
                    print(string.format("> DEBUG: [onClear] Setting 'ap_goalNotKffBossOnly' active state to '%s'", tostring(#goal_location_ids > 1 or goal_location_ids[1] ~= KFF_BOSS_FLAG)))
                end
                goalNotKffBossOnly_obj.Active = #goal_location_ids > 1 or goal_location_ids[1] ~= KFF_BOSS_FLAG
            else
                if LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print(string.format("> ERROR: Unexpected type for slot_data.goal: '%s'", type(goal_data)))
                end
            end
        end
    else
        if LOG_LEVEL <= LOG_LEVELS.WARNING then
            print(string.format("> WARNING: slot_data.goal is nil"))
        end
    end
end

--- Called when an item gets collected. Updates the corresponding item based on the received item_id.
--- @param index integer The event index.
--- @param item_id integer The id of the collected item.
--- @param item_name string The name of the collected item.
--- @param player_number integer The id of the player who collected the item.
local function onItem(index, item_id, item_name, player_number)
    if LOG_LEVEL <= LOG_LEVELS.INFO then
        print(string.format("> INFO: [onItem] Received item event with index: '%s', item_id: '%s', item_name: '%s', player_number: '%s'", index, item_id, item_name, player_number))
    end

    if CUR_INDEX and index <= CUR_INDEX then
        if LOG_LEVEL <= LOG_LEVELS.INFO then
            print(string.format("> DEBUG: [onItem] Event already processed (index: '%s', current index: '%s'), ignoring event", index, CUR_INDEX))
        end
        return
    end

    CUR_INDEX = index;

    local item_code = ITEM_MAPPING[item_id]
    if not item_code then
        if LOG_LEVEL <= LOG_LEVELS.INFO then
            print(string.format("> DEBUG: [onItem] No mapping found for item_id: '%s' ('%s')", item_id, item_name))
        end
        return
    end

    local item_obj = GetObjTypeSafe(item_code, OBJECT_TYPES.JsonItem)
    if item_obj then
        if item_obj.Type == "toggle" then
            if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                print(string.format("> DEBUG: [onItem] Activating toggle item: '%s' ('%s')", item_obj.Name, item_code))
            end
            item_obj.Active = true
        elseif item_obj.Type == "progressive" then
            if item_obj.Active then
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onItem] Incrementing progressive item: '%s' ('%s')", item_obj.Name, item_code))
                end
                item_obj.CurrentStage = item_obj.CurrentStage + 1
            else
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onItem] Activating progressive item: '%s' ('%s')", item_obj.Name, item_code))
                end
                item_obj.Active = true
            end
        else
            if LOG_LEVEL <= LOG_LEVELS.ERROR then
                print(string.format("> ERROR: [onItem] Unrecognized item type '%s' for item: '%s' ('%s')", item_obj.Type, item_obj.Name, item_code))
            end
        end
    end
end

--- Called when a location gets cleared. Updates the corresponding location section based on the received location_id.
--- @param location_id integer The id of the cleared location.
--- @param location_name string The name of the cleared location.
local function onLocation(location_id, location_name)
    if LOG_LEVEL <= LOG_LEVELS.INFO then
        print(string.format("> INFO: [onLocation] Received location event with id: '%s', name: '%s'", location_id, location_name))
    end

    local location_section = LOCATION_MAPPING[location_id]
    if not location_section then
        if LOG_LEVEL <= LOG_LEVELS.ERROR then
            print(string.format("> ERROR: [onLocation] No mapping found for location_id: '%s' ('%s')", location_id, location_name))
        end
        return
    end

    local location_obj = GetObjTypeSafe(location_section, OBJECT_TYPES.LocationSection)
    if location_obj then
        location_obj.AvailableChestCount = location_obj.AvailableChestCount - 1
        if LOG_LEVEL <= LOG_LEVELS.DEBUG then
            if location_obj.AvailableChestCount <= 0 then
                print(string.format("> DEBUG: [onLocation] Deactivating location section: '%s', ('%s')", location_section, location_id))
            else
                print(string.format("> DEBUG: [onLocation] Decrementing location section: '%s', ('%s'), available chest count: '%s'", location_section, location_id, location_obj.AvailableChestCount))
            end
        end
    end
end

--- Called when getting a scouted location. Updates the corresponding option item based on the received location_id and item_id.
--- @param location_id integer The id of the scouted location.
--- @param location_name string The name of the scouted location.
--- @param item_id integer The id of the item found at the scouted location.
--- @param item_name string The name of the item found at the scouted location.
--- @param item_player integer The id of the player who has the scouted item.
local function onScout(location_id, location_name, item_id, item_name, item_player)
    if LOG_LEVEL <= LOG_LEVELS.INFO then
        print(string.format("> INFO: [onScout] Received scout event with id: '%s', name: '%s', item_id: '%s', item_name: '%s', item_player: '%s'", location_id, location_name, item_id, item_name, item_player))
    end

    local item_code = ITEM_MAPPING[item_id]
    if not item_code then
        if LOG_LEVEL <= LOG_LEVELS.DEBUG then
            print(string.format("> DEBUG: [onScout] No mapping found for item_id: '%s' ('%s')", item_id, item_name))
        end
    end

    local location_section = LOCATION_MAPPING[location_id]
    if not location_section then
        if LOG_LEVEL <= LOG_LEVELS.ERROR then
            print(string.format("> ERROR: [onScout] No mapping found for location_id: '%s' ('%s')", location_id, location_name))
        end
        return
    end

    for _, scouting_detail in pairs(SCOUTING_DETAILS) do
        if scouting_detail["location_section"] == location_section then
            if not item_code or scouting_detail["item_code"] ~= item_code then
                local option_item_code = scouting_detail["option_item_code"]
                local option_item_obj = GetObjTypeSafe(option_item_code, OBJECT_TYPES.JsonItem)
                if option_item_obj then
                    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                        print(string.format("> DEBUG: [onScout] Activating option item: '%s', ('%s')", option_item_obj.Name, option_item_code))
                    end
                    option_item_obj.Active = true
                else
                    if LOG_LEVEL <= LOG_LEVELS.ERROR then
                        print(string.format("> ERROR: [onScout] Location section found, but option item not found for scouting_detail:\n%s", DumpTable(scouting_detail)))
                    end
                end
            else
                if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                    print(string.format("> DEBUG: [onScout] Location section '%s' is not randomized", location_section))
                end
            end
            return
        end
    end
    if LOG_LEVEL <= LOG_LEVELS.ERROR then
        print(string.format("> ERROR: [onScout] No special handling for scouted location_id: '%s' ('%s')", location_id, location_name))
    end
end

-- Add AP callbacks
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddScoutHandler("scout handler", onScout)