local virag_debug = true
local AcceptOnes = false;
local AcceptRolls = false;
local totalrolls = 0
local tierolls = 0;
local theMax
local lowname = ""
local highname = ""
local low = 0
local high = 0
local tie = 0
local highbreak = 0;
local lowbreak = 0;
local tiehigh = 0;
local tielow = 0;
local chatmethod = "RAID";
local whispermethod = false;
local totalentries = 0;
local highplayername = "";
local lowplayername = "";
local rollCmd = SLASH_RANDOM1:upper();


-- Called when the addon is loaded via xml
function CrossGambling_OnLoad(self)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00<CrossGambling v7.3> loaded /cg to use")

	self:RegisterEvent("CHAT_MSG_RAID")                 
	self:RegisterEvent("CHAT_MSG_RAID_LEADER")                 
	self:RegisterEvent("CHAT_MSG_GUILD")                 
	self:RegisterEvent("CHAT_MSG_GUILD_LEADER")                 
	-- self:RegisterEvent("CHAT_MSG_SYSTEM")                 
	self:RegisterEvent("PLAYER_ENTERING_WORLD")                 
	self:RegisterForDrag("LeftButton")                 

	CrossGambling_ROLL_Button:Disable()                 
	CrossGambling_AcceptOnes_Button:Enable()                 		
	CrossGambling_LASTCALL_Button:Disable()                 
	CrossGambling_CHAT_Button:Enable()                 
end

local function OptionsFormatter(text, prefix)
	if prefix == "" or prefix == nil then prefix = "/CG" end
	DEFAULT_CHAT_FRAME:AddMessage(string.format("%s%s%s: %s", GREEN_FONT_COLOR_CODE, prefix, FONT_COLOR_CODE_CLOSE, text))
end

-- makeshift switch statement for options parsing
function switch(condition, cases)
  return (cases[condition] or cases.default)()
end

function debug(name, data)
	if not virag_debug then
		return false
	elseif not ViragDevTool_AddData and virag_debug then
	 	OptionsFormatter("VDT not enabled for debugging")
	 	return false
	elseif not data or not name then
		OptionsFormatter(string.format("Debug failed: data: %s, name: %s", data, name))
		return false
	end
	ViragDevTool_AddData(data, name)
end

-- function to be called from XML to save the hidden state when pushing the 'X'
function hide_from_xml()
	CrossGambling_SlashCmd("hide")
end

function CrossGambling_SlashCmd(cmd)
	local command = {strsplit(" ", cmd)}

	local option = command[1] or ""

	switch(option, {
		default = function()
			OptionsFormatter("~Following commands for CrossGambling~")                 
			OptionsFormatter("show - Shows the frame")                 
			OptionsFormatter("hide - Hides the frame")                 
			OptionsFormatter("reset - Resets the AddOn")                 
			OptionsFormatter("resetstats - Resets the stats")                 
			OptionsFormatter("fullstats - list full stats")                 
			OptionsFormatter("joinstats [main] [alt] - Apply [alt]'s win/losses to [main]")                 
			OptionsFormatter("unjoinstats [alt] - Unjoin [alt]'s win/losses from whomever it was joined to")                 
			OptionsFormatter("ban [name] - Ban's the user from being able to roll")                 
			OptionsFormatter("unban [name] - Unban's the user")                 
			OptionsFormatter("listban - Shows ban list")                 
		end,
		hide = function() 
			CrossGambling_Frame:Hide()
			CrossGambling["active"] = false
		end,
		show = function()
			CrossGambling_Frame:Show()
			CrossGambling["active"] = true
		end,
		reset = function()
			Print("", "", "|cffffff00GCG has now been reset")
			CrossGambling_Reset()                 
			CrossGambling_AcceptOnes_Button:SetText("Open Entry")
		end,
		resetstats = function()
			Print("", "", "|cffffff00GCG stats have now been reset")
			CrossGambling_ResetStats()                 
		end,
		fullstats = function()
			CrossGambling_OnClickSTATS(true)
		end,
		joinstats = function()
			CrossGambling_JoinStats(command[2], command[3])
		end,
		unjoinstats = function()
			CrossGambling_UnjoinStats(command[2])
		end,
		ban = function()
			CrossGambling_AddBan(command[2])
		end,
		unban = function()
			CrossGambling_RemoveBan(command[2])
		end,
		listban = function()
			CrossGambling_ListBan()                 
		end,
	})
end

SLASH_CrossGambling1 = "/CrossGambler"
SLASH_CrossGambling2 = "/cg"
SlashCmdList["CrossGambling"] = CrossGambling_SlashCmd

function CrossGambling_JoinStats(main, alt)
	if not main or not alt then
		OptionsFormatter("No main or alt provided.")
		OptionsFormatter("joinstats [main] [alt] - Apply [alt]'s win/losses to [main]")
		return 
	end
	OptionsFormatter(string.format("Joined alt '%s' -> main '%s'", alt, main))
	CrossGambling["joinstats"][alt] = main                 
end

function CrossGambling_UnjoinStats(alt)
	if not alt then
		OptionsFormatter("No alt name provided.")
		OptionsFormatter("unjoinstats [alt] - Unjoin [alt]'s win/losses from whomever it was joined to")
		for altname, mainname in pairs(CrossGambling["joinstats"]) do
			OptionsFormatter(string.format("currently joined: alt '%s' -> main '%s'", altname, mainname))
		end
		return
	end
	OptionsFormatter(string.format("Unjoined alt '%s' from any other characters", alt))
	CrossGambling["joinstats"][altname] = nil                 
end

function CrossGambling_AddBan(name)
	if not name then
		OptionsFormatter("No name provided")
		OptionsFormatter("ban [name] - Ban's the user from being able to roll")
		return
	end

	local charname = strsplit("-",name)
	-- I want to redo the bans list to put the names as keys for faster lookup.  
	-- Need to figure a way to not mess up everyone's current ban list (or just yolo it)
	for index, toon in ipairs(bans) do
		if toon == charname then
			OptionsFormatter(string("%s already banned", toon))
			return
		end
	end

	table.insert(CrossGambling.bans, charname)
	OptionsFormatter(string.format("%s is now banned!", charname))
end

function CrossGambling_RemoveBan(name)
	if not name then
		OptionsFormatter("No name provided")
		OptionsFormatter("unban [name] - Unban's the user")
		return
	end

	local charname = strsplit("-",name)
	-- I want to redo the bans list to put the names as keys for faster lookup.  
	-- Need to figure a way to not mess up everyone's current ban list (or just yolo it)
	for index, toon in ipairs(bans) do
		if toon == charname then
			table.remove(CrossGambling.bans, index)
			OptionsFormatter(string("%s has been unbanned!", toon))
			return
		end
	end
	OptionsFormatter(string("%s was not banned.", toon))
end

function CrossGambling_OnEvent(self, ...)

	-- Event parser.
	local args = {...}

	local event = args[1]

	switch(event, {
		PLAYER_ENTERING_WORLD = function()
			-- Inital set up of the frame
			CrossGambling_EditBox:SetJustifyH("CENTER")
			local saved_vars = {"active", "chat", "whispers", "lowtie", "hightie", "bans"}
			if not CrossGambling then CrossGambling = {} end

			-- Initial  set up of missing variables.  Only set the ones that are missing.
			for  _, var in ipairs(saved_vars) do
				if not CrossGambling[var] then
					switch(var, {
						active = function () CrossGambling[var] = false end,
						chat = function () CrossGambling[var] = "RAID" end,
						whispers = function () CrossGambling[var] = false end,
						lowtie = function () CrossGambling[var] = {} end,
						hightie = function () CrossGambling[var] = {} end,
						bans = function () CrossGambling[var] = {} end,
						lastroll = function () CrossGambling[var] = 100 end,
						stats = function () CrossGambling[var] = {} end,
						joinstats = function () CrossGambling[var] = {} end,
					})
				end
			end

			CrossGambling_EditBox:SetText(""..CrossGambling["lastroll"])

			if not CrossGambling["chat"] then
				CrossGambling_CHAT_Button:SetText("(Guild)")
				chatmethod = "GUILD"
			else
				CrossGambling_CHAT_Button:SetText("(Raid)")
				chatmethod = "RAID"
			end

			if CrossGambling["active"] == 1 or CrossGambling["active"] == 0 then 
				CrossGambling["active"] = false 
			end

			if CrossGambling["chat"] then CrossGambling["chat"] = "RAID"
			else CrossGambling["chat"] = "GUILD" end

			if CrossGambling["active"] then CrossGambling_Frame:Show()
			else CrossGambling_Frame:Hide() end


			-- not used at the moment..
			-- if(CrossGambling["whispers"] == false) then
			-- 	whispermethod = false;
			-- else
			-- 	CrossGambling_WHISPER_Button:SetText("(Whispers)");
			-- 	whispermethod = true;
			-- end
			-- END: PLAYER_ENTERING_WORLD
		end,
		-- CHAT_MSG_SYSTEM = function()
		-- end,
		CHAT_MSG_GUILD_LEADER = function()
		end,
		CHAT_MSG_GUILD = function()
		end,
		CHAT_MSG_RAID_LEADER = function()
			Parse_Raid(args)
		end,
		CHAT_MSG_RAID = function()
			Parse_Raid(args)
		end,
		default = function() end,
		})
	--===================================================

	

	-- if ((event == "CHAT_MSG_GUILD_LEADER" or event == "CHAT_MSG_GUILD")and AcceptOnes=="true" and CrossGambling["chat"] == false) then
	-- 	-- ADDS USER TO THE ROLL POOL - CHECK TO MAKE SURE THEY ARE NOT BANNED --
	-- 	if (arg1 == "1") then
	-- 		if(CrossGambling_ChkBan(tostring(arg2)) == 0) then
	-- 			CrossGambling_Add(tostring(arg2));
	-- 			if (not CrossGambling_LASTCALL_Button:IsEnabled() and totalrolls == 1) then
	-- 				CrossGambling_LASTCALL_Button:Enable();
	-- 			end
	-- 			if totalrolls == 2 then
	-- 				CrossGambling_AcceptOnes_Button:Disable();
	-- 				CrossGambling_AcceptOnes_Button:SetText("Open Entry");
	-- 			end
	-- 		else
	-- 			SendChatMessage("Sorry, but you're banned from the game!", chatmethod);
	-- 		end

	-- 	elseif(arg1 == "-1") then
	-- 		CrossGambling_Remove(tostring(arg2));
	-- 		if (CrossGambling_LASTCALL_Button:IsEnabled() and totalrolls == 0) then
	-- 			CrossGambling_LASTCALL_Button:Disable();
	-- 		end
	-- 		if totalrolls == 1 then
	-- 			CrossGambling_AcceptOnes_Button:Enable();
	-- 			CrossGambling_AcceptOnes_Button:SetText("Open Entry");
	-- 		end
	-- 	end
	-- end

	-- if (event == "CHAT_MSG_SYSTEM" and AcceptRolls=="true") then
	-- 	local temp1 = tostring(arg1);
	-- 	CrossGambling_ParseRoll(temp1);		
	-- end	
	-- CrossGambling_Frame:Hide();
end


function Parse_Raid(event_args)
-- IF IT'S A RAID MESSAGE... 
	debug("chat var", CrossGambling["chat"])
	if AcceptOnes and CrossGambling["chat"] == "RAID" then
		--- CHECK FOR BANS FIRST.
		local msg = event_args[2] -- 1 is the event, 2 is the msg.
		local sender = event_args[6] -- 6 is the name without the realm
		debug("raid msg", event_args)
		if msg == "1" then
			CrossGambling_Add(sender);
				if (not CrossGambling_LASTCALL_Button:IsEnabled() and totalrolls == 1) then
					CrossGambling_LASTCALL_Button:Enable();
				end
				if totalrolls == 2 then
					CrossGambling_AcceptOnes_Button:Disable();
					CrossGambling_AcceptOnes_Button:SetText("Open Entry");
				end
		else
			SendChatMessage("Sorry, but you're banned from the game!", chatmethod);
		end
	end
		
	-- 	-- ADDS USER TO THE ROLL POOL - CHECK TO MAKE SURE THEY ARE NOT BANNED --
	-- 	if (arg1 == "1") then
	-- 		if(CrossGambling_ChkBan(tostring(arg2)) == 0) then
	-- 			CrossGambling_Add(tostring(arg2));
	-- 			if (not CrossGambling_LASTCALL_Button:IsEnabled() and totalrolls == 1) then
	-- 				CrossGambling_LASTCALL_Button:Enable();
	-- 			end
	-- 			if totalrolls == 2 then
	-- 				CrossGambling_AcceptOnes_Button:Disable();
	-- 				CrossGambling_AcceptOnes_Button:SetText("Open Entry");
	-- 			end
	-- 		else
	-- 			SendChatMessage("Sorry, but you're banned from the game!", chatmethod);
	-- 		end

	-- 	elseif(arg1 == "-1") then
	-- 		CrossGambling_Remove(tostring(arg2));
	-- 		if (CrossGambling_LASTCALL_Button:IsEnabled() and totalrolls == 0) then
	-- 			CrossGambling_LASTCALL_Button:Disable();
	-- 		end
	-- 		if totalrolls == 1 then
	-- 			CrossGambling_AcceptOnes_Button:Enable();
	-- 			CrossGambling_AcceptOnes_Button:SetText("Open Entry");
	-- 		end
	-- 	end
	-- end
end

function CrossGambling_OnClickACCEPTONES() 
	if CrossGambling_EditBox:GetText() == "" and  roll_amount < 1 then
		OptionsFormatter("Please enter a number larger than 1 to roll from.");
		return
	end

	local roll_amount = tonumber(CrossGambling_EditBox:GetText()) 
	CrossGambling_Reset();
	CrossGambling_ROLL_Button:Disable();
	CrossGambling_LASTCALL_Button:Disable();
	AcceptOnes = "true";
	local fakeroll = "";
	SendChatMessage(format("%s%s%s%s", ".:Welcome to CrossGambling:. User's Roll - (", CrossGambling_EditBox:GetText(), ") - Type 1 to Join  (-1 to withdraw)", fakeroll),chatmethod,GetDefaultLanguage("player"));
      		CrossGambling["lastroll"] = CrossGambling_EditBox:GetText();
	theMax = roll_amount
	low = theMax+1;
	tielow = theMax+1;
	CrossGambling_EditBox:ClearFocus();
	CrossGambling_AcceptOnes_Button:SetText("New Game");
	CrossGambling_LASTCALL_Button:Disable();
	CrossGambling_EditBox:ClearFocus();
end

function CrossGambling_Reset()
	CrossGambling["strings"] = { };
	CrossGambling["lowtie"] = { };
	CrossGambling["hightie"] = { };
	AcceptOnes = "false"
	AcceptRolls = "false"
	totalrolls = 0
	theMax = 0
	tierolls = 0;
	lowname = ""
	highname = ""
	low = theMax
	high = 0
	tie = 0
	highbreak = 0;
	lowbreak = 0;
	tiehigh = 0;
	tielow = 0;
	totalentries = 0;
	highplayername = "";
	lowplayername = "";
	CrossGambling_ROLL_Button:Disable();
	CrossGambling_AcceptOnes_Button:Enable();		
	CrossGambling_LASTCALL_Button:Disable();
	CrossGambling_CHAT_Button:Enable();
end

function CrossGambling_OnClickCHAT()
	CrossGambling["chat"] = not CrossGambling["chat"];
	
	if not CrossGambling["chat"] then
		CrossGambling_CHAT_Button:SetText("(Guild)");
		chatmethod = "GUILD";
	else
		CrossGambling_CHAT_Button:SetText("(Raid)");
		chatmethod = "RAID";
	end
end

-- Seem to not be used.
function CrossGambling_OnClickWHISPERS()
	CrossGambling["whispers"] = not CrossGambling["whispers"];
	
	if not CrossGambling["whispers"] then
		CrossGambling_WHISPER_Button:SetText("(No Whispers)");
		whispermethod = false;
	else
		CrossGambling_WHISPER_Button:SetText("(Whispers)");
		whispermethod = true;
	end
end

function CrossGambling_ResetCmd()
	SendChatMessage(".:CrossGambling:. Game has been reset", chatmethod)	
end

function CrossGambling_EditBox_OnLoad()
	CrossGambling_EditBox:SetNumeric(true);
	CrossGambling_EditBox:SetAutoFocus(false);
end