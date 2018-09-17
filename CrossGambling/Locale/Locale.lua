local _, CrossGambling = ...
CrossGambling.L = {}
--[[Translation missing --]]
do
    local locale = GetLocale()
    if locale == "enUS" or locale == "enGB" then
        CrossGambling.L["RollSplitStringIndexesPlayer"] = 1;
        CrossGambling.L["RollSplitStringIndexesJunk"] = 2;
        CrossGambling.L["RollSplitStringIndexesRoll"] = 3;
        CrossGambling.L["RollSplitStringIndexesRange"] = 4;
        CrossGambling.L["RollSplitJunkString"] = "rolls";
        CrossGambling.L["%s owes %s %s gold!"] = "%s owes %s %s gold!";
        CrossGambling.L["%s owes %s %s gold and %s gold the guild bank!"] = "%s owes %s %s gold and %s gold the guild bank!";
        CrossGambling.L["%s can now set the next gambling amount by saying !amount x"] = "%s can now set the next gambling amount by saying !amount x";
        CrossGambling.L["It was a tie! No payouts on this roll!"] = "It was a tie! No payouts on this roll!";
        CrossGambling.L[".:Welcome to CrossGambling:. User's Roll - (%s) - Type 1 to Join (-1 to withdraw)"] = ".:Welcome to CrossGambling:. User's Roll - (%s) - Type 1 to Join (-1 to withdraw)"
        CrossGambling.L["Last Call to join!"] = "Last Call to join!";
        CrossGambling.L["%s still needs to roll."] = "%s still needs to roll.";
        CrossGambling.L["Roll mow!"] = "Roll mow!";
        CrossGambling.L["Not enough Players!"] = "Not enough Players!";
        CrossGambling.L["High end tiebreaker! Roll 1- %s now!"] = "High end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["Low end tiebreaker! Roll 1- %s now!"] = "Low end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s won %d total";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s lost %d total";
        CrossGambling.L["The house has taken %s total."] = "The house has taken %s total.";
    elseif locale == "deDE" then
        CrossGambling.L = CrossGambling.L or {}
        CrossGambling.L["RollSplitStringIndexesPlayer"] = 1;
        CrossGambling.L["RollSplitStringIndexesJunk"] = 2;
        CrossGambling.L["RollSplitStringIndexesRoll"] = 4;
        CrossGambling.L["RollSplitStringIndexesRange"] = 5;
        CrossGambling.L["RollSplitJunkString"] = "würfelt.";
        CrossGambling.L["%s owes %s %s gold!"] = "%s schuldet %s %s gold!";
        CrossGambling.L["%s owes %s %s gold and %s gold the guild bank!"] = "%s schuldet %s %s gold und %s Gold der Gildenbank!";
        CrossGambling.L["%s can now set the next gambling amount by saying !amount x"] = "%s kann nun den Einsatz der nächsten Spielrunde festlegen. - !amount x";
        CrossGambling.L["It was a tie! No payouts on this roll!"] = "Unentschieden! Keine Auszahlungen auf diese Runde!";
        CrossGambling.L[".:Welcome to CrossGambling:. User's Roll - (%s) - Type 1 to Join (-1 to withdraw)"] = ".:Willkommen bei CrossGambling:. Nutzer würfeln - (%s) - Tippe 1 zum Teilnehmen (-1 um nicht mehr Teilzunehmen.)"
        CrossGambling.L["Last Call to join!"] = "Letzte Chance, um teilzunehmen!";
        CrossGambling.L["%s still needs to roll."] = "%s muss noch würfeln.";
        CrossGambling.L["Roll mow!"] = "Jetzt würfeln!";
        CrossGambling.L["Not enough Players!"] = "Nicht genug Teilnehmer!";
        CrossGambling.L["High end tiebreaker! Roll 1- %s now!"] = "High end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["Low end tiebreaker! Roll 1- %s now!"] = "Low end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s hat insgesamt %d Gold gewonnen.";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s hat insgesamt %d Gold verloren.";
        CrossGambling.L["The house has taken %s total."] = "Das Haus hat insgesamt %s Gold bekommen.";
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