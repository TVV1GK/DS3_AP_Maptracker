--- The ID of the location where Yhorm is currently located.
--- This is set by the AP integration when we receive information about Yhorm's location.
--- @type string?
YHORM_LOCATION_ID = nil

--- Checks if Yhorm is not at the specified location or if he's beatable.
--- If we don't have any information about Yhorm's location, return true so we don't block anything.
--- @param location_id string The ID of the location to check.
--- @return boolean true Yhorm is not at the specified location or he's beatable.
function IsYhormNotHereOrBeatable(location_id)
    if not YHORM_LOCATION_ID or location_id ~= YHORM_LOCATION_ID then
        if LOG_LEVEL <= LOG_LEVELS.DEBUG then
            if not YHORM_LOCATION_ID then
                print("> DEBUG: [IsYhormNotHereOrBeatable] Yhorm's location is unknown, returning 'true'")
            else
                print(string.format("> DEBUG: [IsYhormNotHereOrBeatable] Yhorm is not at location '%s', returning 'true'", location_id))
            end
        end
        return true
    end

    local stormRuler_obj = GetObjTypeSafe("misc_stormRuler", OBJECT_TYPES.JsonItem)
    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
        if not stormRuler_obj then
            print("> DEBUG: [IsYhormNotHereOrBeatable] Yhorm's location is '%s', but we couldn't find the Storm Ruler, returning 'true'", YHORM_LOCATION_ID)
        elseif stormRuler_obj.Active then
            print("> DEBUG: [IsYhormNotHereOrBeatable] Yhorm's location is '%s', and the Storm Ruler is active, returning 'true'", YHORM_LOCATION_ID)
        else
            print("> DEBUG: [IsYhormNotHereOrBeatable] Yhorm's location is '%s', but the Storm Ruler is inactive, returning 'false'", YHORM_LOCATION_ID)
        end
    end

    return not stormRuler_obj or stormRuler_obj.Active
end

--- All scroll item codes.
--- @type table<string>
local SCROLL_CODES = require("scroll_item_codes")

--- Checks if the player has any of the scroll items.
--- @return boolean true If the player has at least one scroll item.
function HasAnyScroll()
    for _, scroll_code in pairs(SCROLL_CODES) do
        local scroll_obj = GetObjTypeSafe(scroll_code, OBJECT_TYPES.JsonItem)
        if scroll_obj and scroll_obj.Active then
            if LOG_LEVEL <= LOG_LEVELS.DEBUG then
                print(string.format("> DEBUG: [HasAnyScroll] Player has scroll item '%s', returning 'true'", scroll_code))
            end
            return true
        end
    end

    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
        print("> DEBUG: [HasAnyScroll] Player does not have any scroll items, returning 'false'")
    end

    return false
end

--- Checks if an item is randomized and active, or if it's not randomized at all.
--- (An item can only be randomized if user has connected their tracker to AP.)
--- @param is_randomized_code string The code of the randomization tracking item.
--- @param has_item_code string The code of the item to check.
--- @return boolean true If the item is not randomized or if the player has it.
function OnlyIfRandom(is_randomized_code, has_item_code)
    local is_randomized_obj = GetObjTypeSafe(is_randomized_code, OBJECT_TYPES.JsonItem)
    if not is_randomized_obj then
        if LOG_LEVEL <= LOG_LEVELS.DEBUG then
            print(string.format("> DEBUG: [OnlyIfRandom] Could not find randomization tracking item '%s', returning 'true'", is_randomized_code))
        end
        return true
    end

    local has_item_obj = GetObjTypeSafe(has_item_code, OBJECT_TYPES.JsonItem)
    if not has_item_obj then
        if LOG_LEVEL <= LOG_LEVELS.DEBUG then
            print(string.format("> DEBUG: [OnlyIfRandom] Could not find item '%s', returning 'false'", has_item_code))
        end
        return false
    end

    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
        print(string.format("> DEBUG: [OnlyIfRandom] Objects '%s' and '%s' found, returning '%s'", is_randomized_code, has_item_code, tostring(not is_randomized_obj.Active or has_item_obj.Active)))
    end

    return not is_randomized_obj.Active or has_item_obj.Active
end

--- Gets the accessibility level for a given rule if the current pack variant is the softlogic one.
--- @param rule string The rule to check, if the current pack variant is the softlogic variant.
--- @param ... string If the rule is a function, the arguments to pass to the function.
--- @return accessibilityLevel accessibility_level If the current pack variant is not the softlogic variant, returns AccessibilityLevel.Normal. Otherwise, returns the accessibility level based on the rule.
function ApplyRuleOnlyIfSoftVariant(rule, ...)
    if not IS_SOFT_VARIANT then
        if LOG_LEVEL <= LOG_LEVELS.DEBUG then
            print(string.format("> DEBUG: [ApplyRuleOnlyIfSoftVariant] Pack is not the softlogic variant, returning '%s'", tostring(ACCESSIBILITY_LEVELS_AS_STRINGS[AccessibilityLevel.Normal])))
        end
        return AccessibilityLevel.Normal
    end

    local accessibility_level = ConvertRulesToAccessibilityLevels(rule, ...)
    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
        if #{...} > 0 then
            print(string.format("> DEBUG: [ApplyRuleOnlyIfSoftVariant] Pack is the softlogic variant, returning accessibility level '%s' based on rule '%s|%s'", tostring(ACCESSIBILITY_LEVELS_AS_STRINGS[accessibility_level]), rule, table.concat({...}, "|")))
        else
            print(string.format("> DEBUG: [ApplyRuleOnlyIfSoftVariant] Pack is the softlogic variant, returning accessibility level '%s' based on rule '%s'", tostring(ACCESSIBILITY_LEVELS_AS_STRINGS[accessibility_level]), rule))
        end
    end
    return accessibility_level
end

--- Checks if the Basin of Vows is 'logically' late (based on the AP world logic).
--- (This can only be determined if user has connected their tracker to AP, otherwise it will default to true.)
--- <- This is actually not entirely true, because currently DS3's AP world's slot_data doesn't send the late_basin_of_vows option,
--- so we can't determine it, but I'll add a PR for it, and hope for the best.
--- @return boolean true If the Basin of Vows is 'logically' late.
function IsBasinOfVowsLate()
    local ap_lateBasinOfVows_obj = GetObjTypeSafe("ap_lateBasinOfVows", OBJECT_TYPES.JsonItem)

    local stage_1_result = true
    if ap_lateBasinOfVows_obj and ap_lateBasinOfVows_obj.CurrentStage > 0 then
        local key_smallLothricBanner_obj = GetObjTypeSafe("key_smallLothricBanner", OBJECT_TYPES.JsonItem)
        local has_transposingKiln = OnlyIfRandom("ap_transposingKilnRandomized", "misc_transposingKiln")
        local has_pyromancyFlame = OnlyIfRandom("ap_pyromancyFlameRandomized", "misc_pyromancyFlame")
        stage_1_result = (not key_smallLothricBanner_obj or key_smallLothricBanner_obj.Active)
                        and has_transposingKiln
                        and has_pyromancyFlame
                        and HasAnyScroll()
    end

    local stage_2_result = true
    if ap_lateBasinOfVows_obj and ap_lateBasinOfVows_obj.CurrentStage > 1 then
        local key_smallDoll_obj = GetObjTypeSafe("key_smallDoll", OBJECT_TYPES.JsonItem)
        stage_2_result = not key_smallDoll_obj or key_smallDoll_obj.Active
    end

    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
        print(string.format("> DEBUG: [IsBasinOfVowsLate] stage 1: '%s', stage 2: '%s', returning '%s'", tostring(stage_1_result), tostring(stage_2_result), tostring(stage_1_result and stage_2_result)))
    end

    return stage_1_result and stage_2_result
end

--- Checks if the DLC is 'logically' late (based on the AP world logic).
--- (This can only be determined if user has connected their tracker to AP, otherwise it will default to true.)
--- <- This is actually not entirely true, because currently DS3's AP world's slot_data doesn't send the late_basin_of_vows option,
--- so we can't determine it, but I'll add a PR for it, and hope for the best.
--- @return boolean true If the DLC is 'logically' late.
function IsDlcLate()
    local ap_lateDlc_obj = GetObjTypeSafe("ap_lateDlc", OBJECT_TYPES.JsonItem)

    local stage_1_result = true
    if ap_lateDlc_obj and ap_lateDlc_obj.CurrentStage > 0 then
        local key_smallDoll_obj = GetObjTypeSafe("key_smallDoll", OBJECT_TYPES.JsonItem)
        stage_1_result = (not key_smallDoll_obj or key_smallDoll_obj.Active)
                        and HasAnyScroll()
    end

    local stage_2_result = true
    if ap_lateDlc_obj and ap_lateDlc_obj.CurrentStage > 1 then
        local key_basinOfVows_obj = GetObjTypeSafe("key_basinOfVows", OBJECT_TYPES.JsonItem)
        stage_2_result = (not key_basinOfVows_obj or key_basinOfVows_obj.Active)
    end

    if LOG_LEVEL <= LOG_LEVELS.DEBUG then
        print(string.format("> DEBUG: [IsDlcLate] stage 1: '%s' and stage 2: '%s', returning '%s'", tostring(stage_1_result), tostring(stage_2_result), tostring(stage_1_result and stage_2_result)))
    end

    return stage_1_result and stage_2_result
end
