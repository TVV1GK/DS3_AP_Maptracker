--- Creates a list of scroll item codes for the tracker's scroll items from JSON datas.
--- @return table<string> table A list of scroll item codes.
local function loadScrollItemCodeList()
    print("Loading scroll item codes from \"items/items.jsonc\"...")

    local scroll_item_codes = {}
    local data, json = LoadJson("items/items.jsonc")
    if data then
        for _, item in ipairs(data) do
            if item ~= json.null() then
                local is_scroll_item = item.codes:sub(1, 7) == "scroll_"
                if is_scroll_item and not DoesTableContainValue(scroll_item_codes, item.codes) then
                    table.insert(scroll_item_codes, item.codes)
                elseif is_scroll_item and LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print("> ERROR: [loadScrollItemCodeList] Duplicate code '%s' found for scroll item", item.codes)
                end
            end
        end
    end

    print("Loading scroll item codes from \"items/hidden_items.jsonc\"...")

    data, json = LoadJson("items/hidden_items.jsonc")
    if data then
        for _, item in ipairs(data) do
            if item ~= json.null() then
                local is_scroll_item = item.codes:sub(1, 7) == "scroll_"
                if is_scroll_item and not DoesTableContainValue(scroll_item_codes, item.codes) then
                    table.insert(scroll_item_codes, item.codes)
                elseif is_scroll_item and LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print("> ERROR: [loadScrollItemCodeList] Duplicate code '%s' found for scroll item", item.codes)
                end
            end
        end
    end

    return scroll_item_codes
end

return loadScrollItemCodeList()
