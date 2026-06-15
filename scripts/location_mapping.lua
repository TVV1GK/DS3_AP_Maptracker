--- Creates a location mapping table for AP progression items from JSON data.
--- @return table<integer, string> table A table mapping AP item IDs to their corresponding location codes.
local function loadLocationMapping()
	print("Loading location mapping from \"locations/locations.jsonc\"...")

    local location_mapping = {}
	local data, json = LoadJson("locations/locations.jsonc")
    if data then
		for _, map in ipairs(data) do
			if map ~= json.null() then
				for _, location in ipairs(map.children) do
					if location ~= json.null() then
						for _, section in ipairs(location.sections) do
							if section ~= json.null() and section.ap_id then
								if not location_mapping[section.ap_id] then
									location_mapping[section.ap_id] = "@" .. map.name .. "/" .. location.name .. "/" .. section.name
								elseif LOG_LEVEL <= LOG_LEVELS.ERROR then
									print(string.format("> ERROR: [loadLocationMapping] Duplicate AP ID '%d' found for location section '%s'", section.ap_id, "@" .. map.name .. "/" .. location.name .. "/" .. section.name))
								end
							elseif section ~= json.null() and not section.ref and LOG_LEVEL <= LOG_LEVELS.ERROR then
								print(string.format("> ERROR: [loadLocationMapping] A \"non-ref\" location section found without AP ID: '%s'", "@" .. map.name .. "/" .. location.name .. "/" .. section.name))
							end
						end
					end
				end
			end
		end
	end
	return location_mapping
end

return loadLocationMapping()
