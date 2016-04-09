-- Most of the idea to the code (and the "well written" part of it :-) are by Phanx, whom I thanks for the helps and patience in explaining. 

local ADDON = ...

-- defaults saved variables
AGGROMON = AGGROMON or {}

AGGROMON["ACTIVE"] = AGGROMON["ACTIVE"] or true
AGGROMON["SOUND"] = AGGROMON["SOUND"] or true
AGGROMON["CHAT"] = AGGROMON["CHAT"] or false
AGGROMON["SHOW"] = AGGROMON["SHOW"] or false
AGGROMON["SNDFLE"] = AGGROMON["SNDFLE"] or 1
AGGROMON["ENAPVP"] = AGGROMON["ENAPVP"] or false

local prgname = "|cffffd200aggromon|r"
local string_format = string.format
local tostring = tostring

local aggromon_status_old, aggromon_value, aggromon_status, aggromon_summary

-- Frame related vars
local bgfile = "Interface\\ChatFrame\\ChatFrameBackground"
local edgefile = "Interface\\Tooltips\\UI-Tooltip-Border"
local framefontn, framefonth, framefontf = GameFontNormal:GetFont()

-- local role = UnitGroupRolesAssigned(Unit); 

local aggromon_lvl = {
	"in aggro, but not tanking anything",
	"not tanking anything, but have higher threat than tank on at least one unit",
	"insecurely tanking at least one unit, but not securely tanking anything",
	"securely tanking at least one unit",
}
	-- nil = unit is not on any other unit's threat table.
	-- 0 = not tanking anything.
	-- 1 = not tanking anything, but have higher threat than tank on at least one unit.
	-- 2 = insecurely tanking at least one unit, but not securely tanking anything.
	-- 3 = securely tanking at least one unit. 
	-- descriptions taken from: http://www.wowwiki.com/API_UnitThreatSituation

	-- nil  
	-- 0 = Unit has less than 100% raw threat (default UI shows no indicator)
    -- 1 = Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
    -- 2 = Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
    -- 3 = Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
	-- descriptions taken from: http://wowprogramming.com/docs/api/UnitThreatSituation
	
local aggromon_color = {
	{1,1,0},
	{1,0.5,0},
	{1,0.2,0},
	{1,0,0},
}
	
local aggromon_soundfile = {
	"Interface\\AddOns\\Aggromon\\sounds\\babe.ogg",
	"Interface\\AddOns\\Aggromon\\sounds\\zenham.ogg",
	"Sound\\Doodad\\BellTollAlliance.wav",
	"Sound\\interface\\AuctionWindowClose.wav",
	
	-- Sounds taken from banzai-alert: http://www.wowace.com/addons/banzai-alert/ 
}

local function Aggromon_check()

	local disable = 0

	if AGGROMON["ACTIVE"] == false then 
		disable = 1 
	end
	
	local _, instanceType = IsInInstance()
	if AGGROMON["ENAPVP"] == false and (instanceType == "arena" or instanceType == "pvp" or (instanceType == "none" and GetZonePVPInfo() == "combat")) then
		disable = 1
	end

	if disable == 1 then
		frame_cleu:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		frame_cleu2:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		frame_cleu2:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE")
	else
		frame_cleu:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		frame_cleu2:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		frame_cleu2:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
		
	return		
end
	
		
-- Frame colored based on aggro
local Aggromon_AggroFrame = CreateFrame("Frame", "Aggromon_AggroFrame", UIParent)
Aggromon_AggroFrame:SetBackdrop({bgFile = bgfile, edgeFile = edgefile, edgeSize = 18, insets = {left = 5, right = 5, top = 5, bottom = 5}})
Aggromon_AggroFrame:SetBackdropColor(0,0,0,0.8)
Aggromon_AggroFrame:SetWidth(40)
Aggromon_AggroFrame:SetHeight(40)
Aggromon_AggroFrame:SetPoint("CENTER",UIParent)
Aggromon_AggroFrame:EnableMouse(true)
Aggromon_AggroFrame:SetMovable(true)
Aggromon_AggroFrame:RegisterForDrag("LeftButton")
Aggromon_AggroFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
Aggromon_AggroFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)		
Aggromon_AggroFrame:SetClampedToScreen(true)

local Aggromon_AggroValue = Aggromon_AggroFrame:CreateFontString("Aggromon_AggroFrame")
Aggromon_AggroValue:SetPoint("CENTER", Aggromon_AggroFrame,"CENTER",0, 0)
Aggromon_AggroValue:SetFont(GameFontNormal:GetFont(),(framefonth))
Aggromon_AggroFrame:Hide()


	
-- Frame to parse UNIT_THREAT_SITUATION_UPDATE	
local frame_cleu = CreateFrame("Frame", "frame_cleu", UIParent)
frame_cleu:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame_cleu:RegisterEvent("PLAYER_ENTERING_WORLD")
frame_cleu:SetScript("OnEvent", function(self, event, ...)

	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		Aggromon_check()
	end 
	
	aggromon_status = UnitThreatSituation("player")
	
	-- show the colored frame
	if AGGROMON["SHOW"] == true then	
		Aggromon_AggroFrame:Show()		
		if aggromon_status then
			Aggromon_AggroFrame:SetBackdropColor(aggromon_color[aggromon_status+1][1],aggromon_color[aggromon_status+1][2],aggromon_color[aggromon_status+1][3],0.8)
		else
			Aggromon_AggroFrame:SetBackdropColor(0,1,0,0.8)			
		end					
	else
		Aggromon_AggroFrame:Hide()
	end
	
	-- print on the console
	if AGGROMON["CHAT"] == true then 
		if aggromon_status then 
			DEFAULT_CHAT_FRAME:AddMessage(string_format("aggromon: [threat lvl:%i] [target:%s] %s", aggromon_status, aggromon_value, aggromon_lvl[aggromon_status+1]), aggromon_color[aggromon_status+1][1],aggromon_color[aggromon_status+1][2],aggromon_color[aggromon_status+1][3]) 
		else  
			DEFAULT_CHAT_FRAME:AddMessage("aggromon: [threat nil] no aggro, unit is not on any other unit's threat table.",0,1,0) 
		end
	end 
	-- play the old "Aggro!" ... It miss me so much ...  ! :-)
	if AGGROMON["SOUND"] == true then 
		if aggromon_status and aggromon_status >= 1 and aggromon_status_old == nil then
			PlaySoundFile(aggromon_soundfile[AGGROMON["SNDFLE"]], "Master")
		end
	end 		
	-- store the actual aggro level
	aggromon_status_old = aggromon_status
end)
	

-- create a second frame to register also the COMBAT_LOG to update the value aggromon_value	
local frame_cleu2 = CreateFrame("Frame", "frame_cleu2", UIParent)
frame_cleu2:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame_cleu2:RegisterEvent("PLAYER_ENTERING_WORLD")
frame_cleu2:SetScript("OnEvent", function(self, event, ...)

	local _

	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		Aggromon_check()
	end 

	_,_,aggromon_value,_,_ = UnitDetailedThreatSituation("player", "target");
	aggromon_value = tostring(string_format("%.0f",(aggromon_value or 0)))
	Aggromon_AggroValue:SetText(aggromon_value)

end)

-- Configuration Panel -------------------------------------------------------------------------------------

local options = CreateFrame("Frame", "options", InterfaceOptionsFramePanelContainer)
options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
InterfaceOptions_AddCategory(options)

local title = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(options.name)
options.title = title

local subtext = options:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
subtext:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtext:SetPoint("RIGHT", -32, 0)
subtext:SetHeight(32)
subtext:SetJustifyH("LEFT")
subtext:SetJustifyV("TOP")
subtext:SetText(GetAddOnMetadata(ADDON, "Notes"))
options.subtext = subtext

local enable = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
enable:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -8)
enable.Text:SetText("Enable")
enable.tooltipText = "Enable global monitoring"
enable:SetChecked(AGGROMON["ACTIVE"])
enable:SetScript("OnClick", function(self)
	if enable:GetChecked() then 
		AGGROMON["ACTIVE"] = true
		print(string_format("%s is enabled",prgname))
		Aggromon_check()
	else 
		AGGROMON["ACTIVE"] = false
		print(string_format("%s is disabled",prgname))
		Aggromon_check()
	end	
end)

local enable_pvp = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
enable_pvp:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -38)
enable_pvp.Text:SetText("PVP zones")
enable_pvp.tooltipText = "Enable monitoring in PVP zones"
enable_pvp:SetChecked(AGGROMON["ENAPVP"])
enable_pvp:SetScript("OnClick", function(self)
	if enable_pvp:GetChecked() then 
		AGGROMON["ENAPVP"] = true
		print(string_format("%s is enabled in pvp zones",prgname))
		Aggromon_check()
	else 
		AGGROMON["ENAPVP"] = false
		print(string_format("%s is disabled in pvp zones",prgname))
		Aggromon_check()
	end	
end)


local sampletext = options:CreateFontString("$parentSampleText", "ARTWORK", "GameFontHighlight")
sampletext:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -120)
sampletext:SetText('Alerts:')

local chatout = CreateFrame("CheckButton", "$parentCHATOUT", options, "InterfaceOptionsCheckButtonTemplate")
chatout:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -140)
chatout.Text:SetText("Chat (spammy)")
chatout.tooltipText = "Print on chat"
chatout:SetChecked(AGGROMON["CHAT"]);
chatout:SetScript("OnClick", function(self)
	if chatout:GetChecked() then 
		AGGROMON["CHAT"] = true
		print(string_format("%s: output on chat is enabled",prgname))
	else 
		AGGROMON["CHAT"] = false
		print(string_format("%s: output on chat is disabled",prgname))
	end	
end)	

local legenda = CreateFrame("button", "$parentLegenda", options, "UIPanelButtonTemplate")
legenda:SetHeight(25)
legenda:SetWidth(80)
legenda:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", 170, -140)
legenda:SetText("Legenda")
legenda:SetScript("OnClick", 
	function()
		local index
		print(prgname .. " colors:")
		DEFAULT_CHAT_FRAME:AddMessage("aggromon: [threat nil] no aggro, unit is not on any other unit's threat table.",0,1,0) 
		for index = 0, 3, 1 do
			DEFAULT_CHAT_FRAME:AddMessage(string_format("aggromon: [threat lvl:%i] %s", index, aggromon_lvl[index+1]), aggromon_color[index+1][1],aggromon_color[index+1][2],aggromon_color[index+1][3]) 
		end
	end) 

local frameshow = CreateFrame("CheckButton", "$parentFRAMESHOW", options, "InterfaceOptionsCheckButtonTemplate")
frameshow:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -170)
frameshow.Text:SetText("Aggro Frame")
frameshow.tooltipText = "Show the little aggro frame"
frameshow:SetChecked(AGGROMON["SHOW"]);
frameshow:SetScript("OnClick", function(self)
	
	if frameshow:GetChecked() then 
		AGGROMON["SHOW"] = true
		print(string_format("%s: aggro frame is enabled",prgname))
		Aggromon_AggroFrame:SetBackdropColor(0,1,0,0.8)	
		Aggromon_AggroFrame:Show()
	else 
		AGGROMON["SHOW"] = false
		print(string_format("%s: aggro frame is disabled",prgname))
		Aggromon_AggroFrame:Hide()
	end	
	
end)	

local sound = CreateFrame("CheckButton", "$parentSND", options, "InterfaceOptionsCheckButtonTemplate")
sound:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -200)
sound.Text:SetText("Sound Alert")
sound.tooltipText = "Sound"
sound:SetChecked(AGGROMON["SOUND"]);
sound:SetScript("OnClick", function(self)
	
	if sound:GetChecked() then 
		AGGROMON["SOUND"] = true
		print(string_format("%s: sound alert is enabled",prgname))
	else 
		AGGROMON["SOUND"] = false
		print(string_format("%s: sound alert is disabled",prgname))
	end	
	
end)		

local testsnd = CreateFrame("button", "$parentTestSound", options, "UIPanelButtonTemplate")
testsnd:SetHeight(25)
testsnd:SetWidth(80)
testsnd:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", 170, -200)
testsnd:SetText("Play it")
testsnd:SetScript("OnClick", 
	function()
		PlaySoundFile(aggromon_soundfile[AGGROMON["SNDFLE"]], "Master")
	end) 
	
local sndfile = CreateFrame("Slider", "$parentSNDFILE", options, "OptionsSliderTemplate")
sndfile:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 6, -230)
sndfile:SetWidth(250)
sndfile:SetMinMaxValues(1, 4)
sndfile:SetValue(1)
sndfile.low = _G[sndfile:GetName().."Low"]
sndfile.low:SetPoint("TOPLEFT", sndfile, "BOTTOMLEFT", 0, 0)
sndfile.low:SetText('1')
sndfile.high = _G[sndfile:GetName().."High"]
sndfile.high:SetPoint("TOPRIGHT", sndfile, "BOTTOMRIGHT", 0, 0)
sndfile.high:SetText('4')
sndfile.text = _G[sndfile:GetName().."Text"]
sndfile.text:SetText("Sounds")
sndfile.tooltipText = "Sound"
sndfile.value = sndfile:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
sndfile.value:SetPoint("TOP", sndfile, "BOTTOM", 0, 0)
sndfile.value:SetText(AGGROMON["SNDFLE"])
sndfile:SetScript("OnValueChanged", function(self, value)
	AGGROMON["SNDFLE"] = floor(value + 0.5)
	self:SetValue(AGGROMON["SNDFLE"])
	self.value:SetText(AGGROMON["SNDFLE"])
end)

function options.refresh()
	enable:SetChecked(AGGROMON["ACTIVE"])
	sound:SetChecked(AGGROMON["SOUND"])
	chatout:SetChecked(AGGROMON["CHAT"])
	enable_pvp:SetChecked(AGGROMON["ENAPVP"])
	frameshow:SetChecked(AGGROMON["SHOW"])
end

if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end


-- Frame to register the global vars at the ADDON_LOADED event.	
local frame_al = CreateFrame("Frame", "frame_al", UIParent)
frame_al:RegisterEvent("ADDON_LOADED")	
frame_al:SetScript("OnEvent", function(self, event, arg1, ...)	
	if event == "ADDON_LOADED" and arg1 == "Aggromon" then		
	
		if AGGROMON["SHOW"] == false then	
			aggromon_summary = "[show no] "
			Aggromon_AggroFrame:Hide()
		else
			aggromon_summary = "[show yes] "
			Aggromon_AggroFrame:Show()
		end
		
		if AGGROMON["CHAT"] == false then	
			aggromon_summary = aggromon_summary .. "[print no] "
		else
			aggromon_summary = aggromon_summary .. "[print yes] "
		end
		
		if AGGROMON["SOUND"] == false then	
			aggromon_summary = aggromon_summary .. "[sound no] "
		else
			aggromon_summary = aggromon_summary .. "[sound yes] "
		end

		if AGGROMON["ENAPVP"] == false then	
			aggromon_summary = aggromon_summary .. "[pvp no] "
		else
			aggromon_summary = aggromon_summary .. "[pvp yes] "
		end
		
		if AGGROMON["ACTIVE"] == false then			
			print(string_format("%s: |cffff0000disabled|r. Type /%s to enable", prgname, prgname))
		else
			print(string_format("%s: |cff228B22enabled|r %s" , prgname, aggromon_summary))
		end 
				
		options.refresh()
		self:UnregisterEvent("ADDON_LOADED")		
	end	
end)	


-- CMD Parse --------------------------------------------------------------------------------------------
	
SLASH_AGGROMON1 = "/aggromon";
SlashCmdList["AGGROMON"] = function() 
	InterfaceOptionsFrame_OpenToCategory(options)
end