-- Most of the comments to the code (and the "well written" part of it :-) are by Phanx, whom I thanks for the helps and patience in explaining. 
-- The layout of the input frame was inspired by the one of : http://www.wowinterface.com/downloads/info21884-AutoRun_Reminder.html
-- The scroll frame code is suggested by Lombra.

local ADDON = ...
local PCD = LibStub("PhanxConfig-Dropdown")

-- some other defaults
REMGANK_ENABLE = REMGANK_ENABLE or true;
REMGANK_GUILD_ANNOUNCE = REMGANK_GUILD_ANNOUNCE or false;

-- Player Lists
RemGankDB = RemGankDB or {}
local RemGankLS = {}  -- defined also below to initialize. here only to know.

-- ScrollFrame Defaults
local NUM_BUTTONS = 9
local BUTTON_HEIGHT = 20
local BUTTON_WIDTH = 96
local buttons = {}


-- Other defaults & upvalues
local cmd, name, note
local default_note="generic ganker"
local prgname = "|cffffd200remgank|r"
local testganker = "TesTgAnkEr"

local bgfile = "Interface\\ChatFrame\\ChatFrameBackground"
local edgefile = "Interface\\Tooltips\\UI-Tooltip-Border"
local framefontn, framefonth, framefontf = GameFontNormal:GetFont()

-- For general use, I wouldn't recommend obsessively upvaluing every
-- global but it is worth doing for situations like CLEU or OnUpdate
-- where you are accessing them extremely often.
local string_format = string.format
local bit_band = bit.band
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local date = date

-- GUIDs are not available when the main chunk executes, so you have to
-- wait and fill this in once the combat log starts running.
local playerGUID

local timeStamp, event, sourceGUID, sourceName, destGUID, destName, prefixParam1, prefixParam2, suffixParam1, suffixParam2
local selname

-- Alert MSGS
local RemGank_guild_alert = {
	"%s was brutally killed by %s in %s",
	"your guildmate %s was murdered by the evil %s in %s",
	"%s was ambushed by %s in %s",
	"the loyal %s was slaughtered by %s in %s",
	"%s, the (ex)immortal, was owned by %s in %s", 
}


-- Function to dump DB to the listnames
local function RemGank_DB_Dump()
	RemGankLS = {}
	for name in pairs(RemGankDB) do		
		if ( RemGankDB[name]["name"] and RemGankDB[name]["date"] and RemGankDB[name]["desc"] and RemGankDB[name]["lastloc"] and RemGankDB[name]["nrkill"] ) then  
			table.insert(RemGankLS, RemGankDB[name]["name"])
		else 
			print(string_format("%s: Removing mangled entry [%s]", prgname, name))
			RemGankDB[name] = nil
		end	
	end
	-- Sort the list alphabetically
	table.sort(RemGankLS)
	print(string_format("%s: finished rebuild database,found %s registred gankers", prgname,#RemGankLS))	
end


-- This finalize the storing of the name in the array.
local function RemGank_Record_Player(name, note)	

	if note == nil or note == "" then  note = default_note end
	
	-- Define the new row in the array
	RemGankDB[name] = RemGankDB[name] or {} 
	
	-- To prevent the math err on the sum of ( nil + 1 ) below
	RemGankDB[name]["nrkill"] = RemGankDB[name]["nrkill"] or 0

	RemGankDB[name]["name"] = name:lower()
	RemGankDB[name]["desc"] = string.sub(note,1,25) 
	RemGankDB[name]["lastloc"] = GetZoneText() .. "/" .. GetSubZoneText()
	RemGankDB[name]["date"] =  date("%d.%m.%Y %H:%M:%S")
	RemGankDB[name]["nrkill"] = ( RemGankDB[name]["nrkill"] + 1 )	
	
	print(string_format("%s: adding %s [ %s ] [ kills: %i ] ", prgname, name, note, RemGankDB[name]["nrkill"]))		
	RemGank_DB_Dump()
end

-- This show up the PopUp
local function RemGank_Add_Player(name) 
	RemGank_Input_Player:SetText(name)		
	RemGankDB[name] = RemGankDB[name] or {} 
	RemGankDB[name]["nrkill"] = RemGankDB[name]["nrkill"] or 0	
	RemGank_Input_Text2:SetText(string_format("You have been killed %i times", ( RemGankDB[name]["nrkill"] + 1 )))
	RemGank_Input:Show()
end

-- Various Checks.
local function RemGank_Check_Player(name)
	
	-- alert my guild mates if option is set
	if REMGANK_GUILD_ANNOUNCE == true then 
		SendChatMessage("REMGANK: " .. string_format(RemGank_guild_alert[random(1,#RemGank_guild_alert)] , UnitName("player"), name, GetZoneText() .. "/" .. GetSubZoneText()) , "GUILD")
		-- date("%d.%m.%Y %H:%M:%S")
	end
	
	-- is this a new player ? I want a PopUP here to pass a desc
	if RemGankDB[name] == nil then 		
		print(string_format("%s: [%s] new ganker !!", prgname, name))
		RemGank_Add_Player(name) 
	else -- update only record.
		print(string_format("%s: [%s] already present. skip popup, updating record", prgname, name))
		RemGank_Record_Player(name)
	end 
end 

-- Configuration in game frame -------------------------------------------------------------------------------------

-- Base Frame
local RemGank_Input = CreateFrame("Frame","RemGank_Input",UIParent)
RemGank_Input:SetBackdrop({bgFile = bgfile, edgeFile = edgefile, edgeSize = 18, insets = {left = 5, right = 5, top = 5, bottom = 5}})
RemGank_Input:SetBackdropColor(0,0,0,0.8)
RemGank_Input:SetWidth(250)
RemGank_Input:SetHeight(180)
RemGank_Input:SetPoint("CENTER",UIParent)
RemGank_Input:EnableMouse(true)
RemGank_Input:SetMovable(true)
RemGank_Input:RegisterForDrag("LeftButton")
RemGank_Input:SetScript("OnDragStart", function(self) self:StartMoving() end)
RemGank_Input:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
RemGank_Input:Hide()
RemGank_Input:SetClampedToScreen(true)

-- Title
local RemGank_Input_Title = RemGank_Input:CreateFontString("RemGank_Input_Title")
RemGank_Input_Title:SetPoint("TOPLEFT", RemGank_Input,"TOPLEFT",85, -15)
RemGank_Input_Title:SetFont(GameFontNormal:GetFont(),(framefonth+2))
RemGank_Input_Title:SetText(prgname)

-- Text Register this ...
local RemGank_Input_Text1 = RemGank_Input:CreateFontString("RemGank_Input_Text1")
RemGank_Input_Text1:SetPoint("TOPLEFT", RemGank_Input,"TOPLEFT",20, -45)
RemGank_Input_Text1:SetFont(framefontn,framefonth)
RemGank_Input_Text1:SetTextColor(0.6,0.6,0.6,1)
RemGank_Input_Text1:SetText('Register this kill by')

-- Player Name	
local RemGank_Input_Player = RemGank_Input:CreateFontString("RemGank_Input_Player")
RemGank_Input_Player:SetPoint("TOPLEFT", RemGank_Input,"TOPLEFT",20, -60)
RemGank_Input_Player:SetFont(framefontn,(framefonth+2))
RemGank_Input_Player:SetTextColor(1,0,0,1)

-- Text NrKill
local RemGank_Input_Text2 = RemGank_Input:CreateFontString("RemGank_Input_Text2")
RemGank_Input_Text2:SetPoint("TOPLEFT", RemGank_Input,"TOPLEFT",20, -83)
RemGank_Input_Text2:SetFont(framefontn,framefonth)
RemGank_Input_Text2:SetTextColor(0.6,0.6,0.6,1)

-- Text Note
local RemGank_Input_Text3 = RemGank_Input:CreateFontString("RemGank_Input_Text3")
RemGank_Input_Text3:SetPoint("TOPLEFT", RemGank_Input,"TOPLEFT",20, -105)
RemGank_Input_Text3:SetFont(framefontn,framefonth)
RemGank_Input_Text3:SetTextColor(0.6,0.6,0.6,1)
RemGank_Input_Text3:SetText('Edit note')
	
-- EditBox1
local RemGank_Input_eb1 = CreateFrame("EditBox", "RemGank_Input_eb1",RemGank_Input, "InputBoxTemplate")
RemGank_Input_eb1:SetPoint("TOPLEFT", RemGank_Input,"TOPLEFT",20, -120)
RemGank_Input_eb1:SetSize(200, BUTTON_HEIGHT)
RemGank_Input_eb1:SetMaxLetters(25)
RemGank_Input_eb1:SetFont(framefontn,framefonth)
RemGank_Input_eb1:SetText('generic ganker')
RemGank_Input_eb1:SetAutoFocus(disable)

-- Save button
local RemGank_Input_Save_Button = CreateFrame("button","RemGank_Input_Save_Button", RemGank_Input, "UIPanelButtonTemplate")
RemGank_Input_Save_Button:SetHeight(25)
RemGank_Input_Save_Button:SetWidth(50)
RemGank_Input_Save_Button:SetPoint("BOTTOMRIGHT", RemGank_Input, "BOTTOMRIGHT", -12, 12)
RemGank_Input_Save_Button:SetText("Yes")
RemGank_Input_Save_Button:SetScript("OnClick", 
		function()
			RemGank_Input:Hide()
			RemGank_Record_Player(RemGank_Input_Player:GetText(), RemGank_Input_eb1:GetText())
        end) 
	
-- Canc Button
local RemGank_Input_Canc_Button = CreateFrame("button","RemGank_Input_Canc_Button", RemGank_Input, "UIPanelButtonTemplate")
RemGank_Input_Canc_Button:SetHeight(25)
RemGank_Input_Canc_Button:SetWidth(50)
RemGank_Input_Canc_Button:SetPoint("BOTTOMLEFT", RemGank_Input, "BOTTOMLEFT", 12, 12)
RemGank_Input_Canc_Button:SetText("No")
RemGank_Input_Canc_Button:SetScript("OnClick",  function()
	RemGankDB[RemGank_Input_Player:GetText()] = nil
	RemGank_Input:Hide() 
end) 

-- Configuration Option Panel ----------------------------------------------------------------------------------

local RemGank_conf_options = CreateFrame("Frame", ADDON.."Options", InterfaceOptionsFramePanelContainer)
RemGank_conf_options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
InterfaceOptions_AddCategory(RemGank_conf_options)

local RemGank_conf_title = RemGank_conf_options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
RemGank_conf_title:SetPoint("TOPLEFT", 16, -16)
RemGank_conf_title:SetText(RemGank_conf_options.name)
RemGank_conf_options.title = RemGank_conf_title

local RemGank_conf_subtext = RemGank_conf_options:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
RemGank_conf_subtext:SetPoint("TOPLEFT", RemGank_conf_title, "BOTTOMLEFT", 0, -8)
RemGank_conf_subtext:SetPoint("RIGHT", -32, 0)
RemGank_conf_subtext:SetHeight(32)
RemGank_conf_subtext:SetJustifyH("LEFT")
RemGank_conf_subtext:SetJustifyV("TOP")
RemGank_conf_subtext:SetText(GetAddOnMetadata(ADDON, "Notes"))
RemGank_conf_options.RemGank_conf_subtext = RemGank_conf_subtext

local RemGank_conf_enable = CreateFrame("CheckButton", "$parentEnable", RemGank_conf_options, "InterfaceOptionsCheckButtonTemplate")
RemGank_conf_enable:SetPoint("TOPLEFT", RemGank_conf_subtext, "BOTTOMLEFT", -2, -8)
RemGank_conf_enable.Text:SetText("Enable monitoring")
RemGank_conf_enable.tooltipText = "Enable monitoring and popup frame. Disabling this allow only manual input"
RemGank_conf_enable:SetChecked(REMGANK_ENABLE);
RemGank_conf_enable:SetScript("OnClick", function(self)
	
	if RemGank_conf_enable:GetChecked() then 
		REMGANK_ENABLE = true
		print(string_format("%s: is enabled", prgname)) 
		frame_cleu:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else 
		REMGANK_ENABLE = false
		print(string_format("%s: is disabled",prgname))
		frame_cleu:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end	
	
end)

local RemGank_guild_enable = CreateFrame("CheckButton", "$parentEnable", RemGank_conf_options, "InterfaceOptionsCheckButtonTemplate")
RemGank_guild_enable:SetPoint("TOPLEFT", RemGank_conf_subtext, "BOTTOMLEFT", -2, -30)
RemGank_guild_enable.Text:SetText("Alert your guildmates when you are killed")
RemGank_guild_enable.tooltipText = "Alert your guildmates when the evils gank you"
RemGank_guild_enable:SetChecked(REMGANK_GUILD_ANNOUNCE);
RemGank_guild_enable:SetScript("OnClick", function(self)
	
	if RemGank_guild_enable:GetChecked() then 
		REMGANK_GUILD_ANNOUNCE = true
		print(string_format("%s: guild alert is enabled", prgname)) 
	else 
		REMGANK_GUILD_ANNOUNCE = false
		print(string_format("%s: guild alert is disabled",prgname))
	end	
	
end)

 
-- Database Text
local RemGank_conf_titlelist = RemGank_conf_options:CreateFontString(nil, nil, "GameFontHighlight")
RemGank_conf_titlelist:SetPoint("TOPLEFT", RemGank_conf_enable, "BOTTOMLEFT", 2, -32)
RemGank_conf_titlelist:SetText("Players")

-- Add button
local RemGank_Add_Player_Button = CreateFrame("button","RemGank_Add_Player_Button", RemGank_conf_options, "UIPanelButtonTemplate")
RemGank_Add_Player_Button:SetHeight(BUTTON_HEIGHT)
RemGank_Add_Player_Button:SetWidth(BUTTON_WIDTH/2)
RemGank_Add_Player_Button:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", -2, -8)
RemGank_Add_Player_Button:SetText("Add")
RemGank_Add_Player_Button.tooltipText = "Add or Edit the selected player. N.B. The number of kills will be incremented"
RemGank_Add_Player_Button:SetScript("OnClick", 
	function()
		name = RemGank_Input_eb2:GetText()
		name = name:lower()
		note = RemGank_Input_eb3:GetText()
		note = note:lower()
		
		print(string_format("%s: adding %s to the list", prgname,name))
		RemGank_Record_Player(name,note)
		RemGank_DB_Dump()
	end) 
	
-- Del Button
local RemGank_Del_Player_Button = CreateFrame("button","RemGank_Del_Player_Button", RemGank_conf_options, "UIPanelButtonTemplate")
RemGank_Del_Player_Button:SetHeight(BUTTON_HEIGHT)
RemGank_Del_Player_Button:SetWidth(BUTTON_WIDTH/2)
RemGank_Del_Player_Button:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 48, -8)
RemGank_Del_Player_Button:SetText("Del")
RemGank_Del_Player_Button.tooltipText = "Delete the selected player"
RemGank_Del_Player_Button:SetScript("OnClick",  
	function()		
		RemGankDB[RemGank_Input_eb2:GetText()] = nil
		RemGank_DB_Dump()
	end) 

-- Name Text on RemGank_Input_eb2
local smalltitlename = RemGank_conf_options:CreateFontString(nil, nil, "GameFontHighlightSmall")
smalltitlename:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 104, 4)
smalltitlename:SetText("Name")

-- Desc Text on RemGank_Input_eb3
local smalltitledesc = RemGank_conf_options:CreateFontString(nil, nil, "GameFontHighlightSmall")
smalltitledesc:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 305, 4)
smalltitledesc:SetText("Desc")	
	
-- Text Input (name)
local RemGank_Input_eb2 = CreateFrame("EditBox","RemGank_Input_eb2",RemGank_conf_options,"InputBoxTemplate")
RemGank_Input_eb2:SetMaxLetters(25)
RemGank_Input_eb2:SetFont(framefontn,framefonth)
RemGank_Input_eb2:SetAutoFocus(disable)
RemGank_Input_eb2:SetSize(BUTTON_WIDTH * 2, BUTTON_HEIGHT)
RemGank_Input_eb2:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 104, -8)

-- Text Input (desc)
local RemGank_Input_eb3 = CreateFrame("EditBox","RemGank_Input_eb3",RemGank_conf_options,"InputBoxTemplate")
RemGank_Input_eb3:SetMaxLetters(25)
RemGank_Input_eb3:SetFont(framefontn,framefonth)
RemGank_Input_eb3:SetAutoFocus(disable)
RemGank_Input_eb3:SetSize(BUTTON_WIDTH * 2, BUTTON_HEIGHT)
RemGank_Input_eb3:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 305, -8)

-- Info_name Text
local RemGank_conf_info_name = RemGank_conf_options:CreateFontString(nil, nil, "GameFontNormalLarge")
RemGank_conf_info_name:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 250, -80)

-- Info_desc Text
local RemGank_conf_info_desc = RemGank_conf_options:CreateFontString(nil, nil, "GameFontHighlightSmall")
RemGank_conf_info_desc:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 250, -100)

-- Info_loc_title Text
local RemGank_conf_info_loc_title = RemGank_conf_options:CreateFontString(nil, nil, "GameFontNormal")
RemGank_conf_info_loc_title:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 250, -130)

-- Info_loc Text
local RemGank_conf_info_loc = RemGank_conf_options:CreateFontString(nil, nil, "GameFontHighlightSmall")
RemGank_conf_info_loc:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 250, -145)

-- Info_date Text
local RemGank_conf_info_date = RemGank_conf_options:CreateFontString(nil, nil, "GameFontHighlightSmall")
RemGank_conf_info_date:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 250, -160)

-- Info_kills_title Text
local RemGank_conf_info_kills_title = RemGank_conf_options:CreateFontString(nil, nil, "GameFontNormal")
RemGank_conf_info_kills_title:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 250, -190)

-- Info_kills Text
local RemGank_conf_info_kills = RemGank_conf_options:CreateFontString(nil, nil, "GameFontHighlightSmall")
RemGank_conf_info_kills:SetPoint("TOPLEFT", RemGank_conf_titlelist, "BOTTOMLEFT", 250, -205)

-- Tools Text
local RemGank_conf_dbtoolstitle = RemGank_conf_options:CreateFontString(nil, nil, "GameFontHighlight")
RemGank_conf_dbtoolstitle:SetPoint("TOPLEFT", 16, -400)
RemGank_conf_dbtoolstitle:SetText("Database Tools")

-- Wipe Button
local RemGank_Wip_Player_Button = CreateFrame("button","RemGank_Wip_Player_Button", RemGank_conf_options, "UIPanelButtonTemplate")
RemGank_Wip_Player_Button:SetHeight(BUTTON_HEIGHT)
RemGank_Wip_Player_Button:SetWidth(BUTTON_WIDTH/2)
RemGank_Wip_Player_Button:SetPoint("TOPLEFT", RemGank_conf_dbtoolstitle, "BOTTOMLEFT", -2, -8)
RemGank_Wip_Player_Button:SetText("Wipe")
RemGank_Wip_Player_Button.tooltipText = "BEWARE: Silently initialize your database of players"
RemGank_Wip_Player_Button:SetScript("OnClick",  
	function()
		print(prgname .. " Wipes current database")		
		RemGankLS = {}
		RemGankDB = {}
		RemGank_DB_Dump()
	end)  

-- Reload Button
local RemGank_Rld_Player_Button = CreateFrame("button","RemGank_Rld_Player_Button", RemGank_conf_options, "UIPanelButtonTemplate")
RemGank_Rld_Player_Button:SetHeight(BUTTON_HEIGHT)
RemGank_Rld_Player_Button:SetWidth(BUTTON_WIDTH/2)
RemGank_Rld_Player_Button:SetPoint("TOPLEFT", RemGank_conf_dbtoolstitle, "BOTTOMLEFT", 48, -8)
RemGank_Rld_Player_Button:SetText("Rld")
RemGank_Rld_Player_Button.tooltipText = "Rebuild and sanity check of name database"
RemGank_Rld_Player_Button:SetScript("OnClick",  
	function()
		RemGank_DB_Dump()		
	end)  

-- ScrollFrame by Phanx
local RemGank_dropdown = PCD:New(RemGank_conf_options)
RemGank_dropdown:SetPoint("TOPLEFT", 16, -215)
	function RemGank_dropdown:OnValueChanged(selname)
		RemGank_Input_eb2:SetText(selname)
		RemGank_Input_eb3:SetText(RemGankDB[selname]["desc"])
		RemGank_conf_info_name:SetText(selname)
		RemGank_conf_info_desc:SetText(RemGankDB[selname]["desc"])
		RemGank_conf_info_loc_title:SetText("Last Kill:")
		RemGank_conf_info_date:SetText(RemGankDB[selname]["date"])
		RemGank_conf_info_loc:SetText(RemGankDB[selname]["lastloc"])
		RemGank_conf_info_kills_title:SetText("Tot.Kills:")
		RemGank_conf_info_kills:SetText(RemGankDB[selname]["nrkill"])
		RemGank_conf_options.refresh()
	end

	
function RemGank_conf_options.refresh()
	RemGank_conf_enable:SetChecked(REMGANK_ENABLE)
	RemGank_guild_enable:SetChecked(REMGANK_GUILD_ANNOUNCE)
	RemGank_dropdown:SetList(RemGankLS)	
end

if LibStub and LibStub("LibAboutPanel", true) then
	RemGank_conf_options.about = LibStub("LibAboutPanel").new(RemGank_conf_options.name, ADDON)
end

-- Register EVENTS -------------------------------------------------------------------------------------------
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")	

frame:SetScript("OnEvent", function(self, event, ...)
	
	if event == "ADDON_LOADED" and ... == ADDON then 
		frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		
		RemGank_DB_Dump()
		
		if REMGANK_ENABLE == true then 
			print(string_format("%s: enabled", prgname))
		else 
			print(string_format("%s: disabled. Type /remgank to configure", prgname))			
		end

		if REMGANK_GUILD_ANNOUNCE == true then 
			print(string_format("%s: guild alert is enabled", prgname))
		else 
			print(string_format("%s: guild alert is disabled.", prgname))			
		end

		self:UnregisterEvent("ADDON_LOADED")
	
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
	
			if ((UnitIsPlayer("mouseover")) and (UnitIsEnemy("mouseover", "player"))) then
				name = UnitName("mouseover"):lower();
				if RemGankDB[name] then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("- Your Note: " .. (RemGankDB[name]["desc"] or "generic ganker"))
					GameTooltip:AddLine("- Tot.kills: " .. (RemGankDB[name]["nrkill"] or "-"))
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("- Last time:")
					GameTooltip:AddLine(RemGankDB[name]["date"])
					GameTooltip:AddLine(RemGankDB[name]["lastloc"])				
					GameTooltipTextLeft1:SetTextColor(1, 0.5, 0.5)
					GameTooltip:SetBackdropColor(1, 0, 0)
					GameTooltip:Show()
				end
			end
	
	elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then 
		
		local _, instanceType = IsInInstance()
		if REMGANK_ENABLE == false or instanceType == "arena" or instanceType == "pvp" or (instanceType == "none" and GetZonePVPInfo() == "combat") then
			-- REMGANK_ENABLE == false Monitoring is disabled
			-- arena is, obviously, an arena.
			-- pvp is a battleground.
			-- none with GetZonePVPInfo() == "combat" is an outdoor PvP zone like Wintergrasp.
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		else
			-- If not in a pvp zone, register CLEU:
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
	
	elseif event=="COMBAT_LOG_EVENT_UNFILTERED" then 
	
		timeStamp, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, prefixParam1, prefixParam2, _, suffixParam1, suffixParam2 = ...

		-- proceed with CLEU handling
		if not playerGUID then
			playerGUID = UnitGUID("player")
		end
			
		-- Since these first two conditions apply no matter which event is
		-- firing, check them first.
		if (sourceGUID and sourceGUID ~= "" and sourceGUID ~= playerGUID) and destGUID == playerGUID and (sourceGUID:sub(1,3) == "Pet" or sourceGUID:sub(1,6) == "Player") then

			if event == "SWING_DAMAGE" then
				-- Nest checks inside each other instead of using and, so
				-- that if any check matches (eg. it is this event, but not
				-- the right prefix) the code doesn't keep checking other
				-- things that obviously can never match.
				if prefixParam2 > 0 then
					print(string_format("%s: [%s] killed [%s] with %s Melee overkill %s", prgname, sourceName, destName, prefixParam1, prefixParam2))
					name = sourceName:lower()
					RemGank_Check_Player(name)
				end
			elseif event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" then
				if suffixParam2 > 0 then
					print(string_format("%s: [%s] killed [%s] with %s damage of %s overkill %s", prgname, sourceName, destName, suffixParam1, GetSpellLink(prefixParam1), suffixParam2))
					name = sourceName:lower()
					RemGank_Check_Player(name)			
				end
			end
		end
	end
end)


SLASH_REMGANK1 = "/remgank"
SlashCmdList["REMGANK"] = function() 
	InterfaceOptionsFrame_OpenToCategory(RemGank_conf_options)
end