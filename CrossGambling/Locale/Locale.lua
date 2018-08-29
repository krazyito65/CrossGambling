local _, CrossGambling = ...
CrossGambling.L = {}

do
    local locale = GetLocale()
    if locale == "enUS" or locale == "enGB" then
        CrossGambling.L["RollSplitStringIndexesPlayer"] = 1;
        CrossGambling.L["RollSplitStringIndexesJunk"] = 2;
        CrossGambling.L["RollSplitStringIndexesRoll"] = 3;
        CrossGambling.L["RollSplitStringIndexesRange"] = 4;
        CrossGambling.L["RollSplitJunkString"] = "rolls";
    elseif locale == "deDE" then
        CrossGambling.L = CrossGambling.L or {}
        CrossGambling.L["RollSplitStringIndexesPlayer"] = 1;
        CrossGambling.L["RollSplitStringIndexesJunk"] = 2;
        CrossGambling.L["RollSplitStringIndexesRoll"] = 4;
        CrossGambling.L["RollSplitStringIndexesRange"] = 5;
        CrossGambling.L["RollSplitJunkString"] = "würfelt.";
    elseif locale == "frFR" then
        CrossGambling.L = CrossGambling.L or {}
        CrossGambling.L["RollSplitStringIndexesPlayer"] = 1;
        CrossGambling.L["RollSplitStringIndexesJunk"] = 2;
        CrossGambling.L["RollSplitStringIndexesRoll"] = 4;
        CrossGambling.L["RollSplitStringIndexesRange"] = 5; -- FR Range = (1-100).
        CrossGambling.L["RollSplitJunkString"] = "obtient";
    else
        error("Unknown locale: "..tostring(locale))
    end

    --local HAS_STRINGS = next(CrossGambling.L) and true or false
    setmetatable(CrossGambling.L, {
        __index = function(t, k)
            --assert(not HAS_STRINGS)
            local v = tostring(k)
            rawset(t, k, v)
            return v
        end,
        __newindex = function(t, k, v)
            error("Cannot write to the locale table")
        end,
    })
end