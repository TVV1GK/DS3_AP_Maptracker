--- Creates an item mapping table for AP progression items from JSON data.
--- @return table<integer, string> table A table mapping AP item IDs to their corresponding item codes.
local function loadItemMapping()
    print("Loading item mapping from \"items/items.jsonc\"...")

    local item_mapping = {}
    local data, json = LoadJson("items/items.jsonc")
    if data then
        for _, item in ipairs(data) do
            if item ~= json.null() and item.ap_id then
                if not item_mapping[item.ap_id] then
                    item_mapping[item.ap_id] = item.codes
                elseif LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print("> ERROR: [loadItemMapping] Duplicate AP ID '%d' found for item '%s'", item.ap_id, item.codes)
                end
            end
        end
    end

    print("Loading item mapping from \"items/hidden_items.jsonc\"...")

    data, json = LoadJson("items/hidden_items.jsonc")
    if data then
        for _, item in ipairs(data) do
            if item ~= json.null() then
                if item ~= json.null() and item.ap_id then
                    if not item_mapping[item.ap_id] then
                        item_mapping[item.ap_id] = item.codes
                    elseif LOG_LEVEL <= LOG_LEVELS.ERROR then
                        print("> ERROR: [loadItemMapping] Duplicate AP ID '%d' found for item '%s'", item.ap_id, item.codes)
                    end
                end
            end
        end
    end

    return item_mapping
end

return loadItemMapping()
