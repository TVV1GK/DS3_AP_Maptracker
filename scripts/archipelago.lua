ScriptHost:LoadScript("scripts/item_mapping.lua")
ScriptHost:LoadScript("scripts/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1

    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            end
        end
    end

    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                end
            end
        end
    end

    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

    if SLOT_DATA == nil then
        return
    end

    if slot_data.options.enable_dlc then
        print("slot_data.options.enable_dlc: " .. slot_data.options.enable_dlc)
        local obj = Tracker:FindObjectForCode("dlc")
        if obj then
            obj.Active = slot_data.options.enable_dlc == 1
        end
    end
    if slot_data.options.enable_ngp then
        print("slot_data.options.enable_ngp: " .. slot_data.options.enable_ngp)
        local obj = Tracker:FindObjectForCode("ng+")
        if obj then
            obj.Active = slot_data.options.enable_ngp == 1
        end
    end
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    end

    CUR_INDEX = index;

    local v = ITEM_MAPPING[item_id]
    if not v then
        return
    end
    if not v[1] then
        return
    end

    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        end
    end

    --[[
    -- track local items via snes interface
    if player_number == Archipelago.PlayerNumber then
        if LOCAL_ITEMS[ v[1] ] then
            LOCAL_ITEMS[ v[1] ] = LOCAL_ITEMS[ v[1] ] + 1
        else
            LOCAL_ITEMS[ v[1] ] = 1
        end
    else
        if GLOBAL_ITEMS[ v[1] ] then
            GLOBAL_ITEMS[ v[1] ] = GLOBAL_ITEMS[ v[1] ] + 1
        else
            GLOBAL_ITEMS[ v[1] ] = 1
        end
    end
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here for local item tracking
    end
    ]]
end

--called when a location gets cleared
function onLocation(location_id, location_name)
    local v = LOCATION_MAPPING[location_id]
    if not v[1] then
        return
    end

    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    end
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)