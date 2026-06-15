--- Creates a list of hidden item codes for the tracker's hidden items from JSON data.
--- @return table<string> table A list of hidden item codes.
local function loadhiddenItemCodeList()
    print("Loading hidden item codes from \"scripts/hidden_item_codes.lua\"...")

    local hidden_item_codes = {}
    local data, json = LoadJson("items/hidden_items.jsonc")
    if data then
        for _, item in ipairs(data) do
            if item ~= json.null() then
                if not DoesTableContainValue(hidden_item_codes, item.codes) then
                    table.insert(hidden_item_codes, item.codes)
                elseif LOG_LEVEL <= LOG_LEVELS.ERROR then
                    print("> ERROR: [loadhiddenItemCodeList] Duplicate code '%s' found for hidden item", item.codes)
                end
            end
        end
    end
    return hidden_item_codes
end

return loadhiddenItemCodeList()
