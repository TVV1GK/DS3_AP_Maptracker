SETTING_CODES = {
    "everywhere",
    "prominent",
    "progression",
    "bossReward",
    "minibossReward",
    "mimicReward",
    "hostileNPCReward",
    "friendlyNPCReward",
    "smallCrystalLizard",
    "weaponUpgrade",
    "smallSoul",
    "bossSoul",
    "unique",
    "healingUpgrade",
    "misc",
    "hidden",
    "weapon",
    "shield",
    "armor",
    "ring",
    "spell",
    "missable_dis",
    "ng+",

    "ca",
    "fs",
    "fsbt",
    "hwl",
    "us",
    "rs",
    "cd",
    "fk",
    "cc",
    "sl",
    "ibv",
    "id",
    "pc",
    "al",
    "lc",
    "ckg",
    "ga",
    "ug",
    "ap",
    "kff",
    "dlc",
    "pwa",
    "dh",
    "rc"
}

DLC_REGIONS = {
    "dlc",
    "pwa",
    "dh",
    "rc"
}

function codeChange(code)
    if code == "everywhere" or code == "dlc" then
        local codes
        if code == "everywhere" then
            codes = SETTING_CODES
        else
            codes = DLC_REGIONS
        end

        local isNothingActive = true
        for _, v in ipairs(codes) do
            if v ~= code then
                if Tracker:FindObjectForCode(v).Active then
                    isNothingActive = false
                    break
                end
            end
        end

        local isCodeObjActive = Tracker:FindObjectForCode(code).Active
        if isNothingActive or not isCodeObjActive then
            for _, v in ipairs(codes) do
                if v ~= code then
                    local obj = Tracker:FindObjectForCode(v)
                    if obj then
                        obj.Active = isCodeObjActive
                    end
                end
            end
        end
    else
        local isCodeObjActive = Tracker:FindObjectForCode(code).Active
        if isCodeObjActive then
            local everywhereObj = Tracker:FindObjectForCode("everywhere")
            if everywhereObj and not everywhereObj.Active then
                everywhereObj.Active = true
            end

            for _, v in ipairs(DLC_REGIONS) do
                if v == code then
                    local dlcObj = Tracker:FindObjectForCode("dlc")
                    if dlcObj and not dlcObj.Active then
                        dlcObj.Active = true
                    end
                    break
                end
            end
        end
    end
end

function initAddWatchForCodes()
    for _, v in ipairs(SETTING_CODES) do
        ScriptHost:AddWatchForCode(v, v, codeChange)
    end
end