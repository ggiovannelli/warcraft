-- Most of the idea to the code (and the "well written" part of it :-) are by Phanx, whom I thanks for the helps and patience in explaining. 

local ADDON = ...

-- defaults saved variables
GMAGGROMON = GMAGGROMON or {}

GMAGGROMON["ACTIVE"] = GMAGGROMON["ACTIVE"] or true
GMAGGROMON["SOUND"] = GMAGGROMON["SOUND"] or true
GMAGGROMON["CHAT"] = GMAGGROMON["CHAT"] or false
GMAGGROMON["SHOW"] = GMAGGROMON["SHOW"] or false
GMAGGROMON["SNDFLE"] = GMAGGROMON["SNDFLE"] or 1
GMAGGROMON["ENAPVP"] = GMAGGROMON["ENAPVP"] or false

local prgname = "|cffffd200gmAggroMon|r"
local string_format = string.format
local tostring = tostring

local gmAggroMon_status_old, gmAggroMon_value, gmAggroMon_status, gmAggroMon_summary

-- Frame related vars
local bgfile = "Interface\\ChatFrame\\ChatFrameBackground"
local edgefile = "Interface\\Tooltips\\UI-Tooltip-Border"
local framefontn, framefonth, framefontf = GameFontNormal:GetFont()

-- local role = UnitGroupRolesAssigned(Unit); 

local gmAggroMon_lvl = {
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
	
local gmAggroMon_color = {
	{1,1,0},
	{1,0.5,0},
	{1,0.2,0},
	{1,0,0},
}
	
local gmAggroMon_soundfile = {
	"Interface\\AddOns\\gmAggroMon\\sounds\\babe.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\zenham.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\pluck.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\ok.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\laser.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\left.ogg",
	
	-- Sounds taken from banzai-alert: http://www.wowace.com/addons/banzai-alert/ and from LibreOffice distribution
}

local function gmAggroMon_check()

	local disable = 0

	if GMAGGROMON["ACTIVE"] == false then 
		disable = 1 
	end
	
	local _, instanceType = IsInInstance()
	if GMAGGROMON["ENAPVP"] == false and (instanceType == "arena" or instanceType == "pvp" or (instanceType == "none" and GetZonePVPInfo() == "combat")) then
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
local gmAggroMon_AggroFrame = CreateFrame("Frame")
gmAggroMon_AggroFrame:SetBackdrop({bgFile = bgfile, edgeFile = edgefile, edgeSize = 18, insets = {left = 5, right = 5, top = 5, bottom = 5}})
gmAggroMon_AggroFrame:SetBackdropColor(0,0,0,0.8)
gmAggroMon_AggroFrame:SetWidth(40)
gmAggroMon_AggroFrame:SetHeight(40)
gmAggroMon_AggroFrame:SetPoint("CENTER",UIParent)
gmAggroMon_AggroFrame:EnableMouse(true)
gmAggroMon_AggroFrame:SetMovable(true)
gmAggroMon_AggroFrame:RegisterForDrag("LeftButton")
gmAggroMon_AggroFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
gmAggroMon_AggroFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)		
gmAggroMon_AggroFrame:SetClampedToScreen(true)

local gmAggroMon_AggroValue = gmAggroMon_AggroFrame:CreateFontString("gmAggroMon_AggroFrame")
gmAggroMon_AggroValue:SetPoint("CENTER", gmAggroMon_AggroFrame,"CENTER",0, 0)
gmAggroMon_AggroValue:SetFont(GameFontNormal:GetFont(),(framefonth))
gmAggroMon_AggroFrame:Hide()


	
-- Frame to parse UNIT_THREAT_SITUATION_UPDATE	
local frame_cleu = CreateFrame("Frame", "frame_cleu", UIParent)
frame_cleu:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame_cleu:RegisterEvent("PLAYER_ENTERING_WORLD")
frame_cleu:SetScript("OnEvent", function(self, event, ...)

	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		gmAggroMon_check()
	end 
	
	gmAggroMon_status = UnitThreatSituation("player")
	
	-- show the colored frame
	if GMAGGROMON["SHOW"] == true then	
		gmAggroMon_AggroFrame:Show()		
		if gmAggroMon_status then
			gmAggroMon_AggroFrame:SetBackdropColor(gmAggroMon_color[gmAggroMon_status+1][1],gmAggroMon_color[gmAggroMon_status+1][2],gmAggroMon_color[gmAggroMon_status+1][3],0.8)
		else
			gmAggroMon_AggroFrame:SetBackdropColor(0,1,0,0.8)			
		end					
	else
		gmAggroMon_AggroFrame:Hide()
	end
	
	-- print on the console
	if GMAGGROMON["CHAT"] == true then 
		if gmAggroMon_status then 
			DEFAULT_CHAT_FRAME:AddMessage(string_format("gmAggroMon: [threat lvl:%i] [target:%s] %s", gmAggroMon_status, gmAggroMon_value, gmAggroMon_lvl[gmAggroMon_status+1]), gmAggroMon_color[gmAggroMon_status+1][1],gmAggroMon_color[gmAggroMon_status+1][2],gmAggroMon_color[gmAggroMon_status+1][3]) 
		else  
			DEFAULT_CHAT_FRAME:AddMessage("gmAggroMon: [threat nil] no aggro, unit is not on any other unit's threat table.",0,1,0) 
		end
	end 
	-- play the old "Aggro!" ... It miss me so much ...  ! :-)
	if GMAGGROMON["SOUND"] == true then 
		if gmAggroMon_status and gmAggroMon_status >= 1 and gmAggroMon_status_old == nil then
			PlaySoundFile(gmAggroMon_soundfile[GMAGGROMON["SNDFLE"]], "Master")
		end
	end 		
	-- store the actual aggro level
	gmAggroMon_status_old = gmAggroMon_status
end)
	

-- create a second frame to register also the COMBAT_LOG to update the value gmAggroMon_value	
local frame_cleu2 = CreateFrame("Frame", "frame_cleu2", UIParent)
frame_cleu2:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame_cleu2:RegisterEvent("PLAYER_ENTERING_WORLD")
frame_cleu2:SetScript("OnEvent", function(self, event, ...)

	local _

	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		gmAggroMon_check()
	end 

	_,_,gmAggroMon_value,_,_ = UnitDetailedThreatSituation("player", "target");
	gmAggroMon_value = tostring(string_format("%.0f",(gmAggroMon_value or 0)))
	gmAggroMon_AggroValue:SetText(gmAggroMon_value)

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
enable:SetChecked(GMAGGROMON["ACTIVE"])
enable:SetScript("OnClick", function(self)
	if enable:GetChecked() then 
		GMAGGROMON["ACTIVE"] = true
		print(string_format("%s is enabled",prgname))
		gmAggroMon_check()
	else 
		GMAGGROMON["ACTIVE"] = false
		print(string_format("%s is disabled",prgname))
		gmAggroMon_check()
	end	
end)

local enable_pvp = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
enable_pvp:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -38)
enable_pvp.Text:SetText("PVP zones")
enable_pvp.tooltipText = "Enable monitoring in PVP zones"
enable_pvp:SetChecked(GMAGGROMON["ENAPVP"])
enable_pvp:SetScript("OnClick", function(self)
	if enable_pvp:GetChecked() then 
		GMAGGROMON["ENAPVP"] = true
		print(string_format("%s is enabled in pvp zones",prgname))
		gmAggroMon_check()
	else 
		GMAGGROMON["ENAPVP"] = false
		print(string_format("%s is disabled in pvp zones",prgname))
		gmAggroMon_check()
	end	
end)


local sampletext = options:CreateFontString("$parentSampleText", "ARTWORK", "GameFontHighlight")
sampletext:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -120)
sampletext:SetText('Alerts:')

local chatout = CreateFrame("CheckButton", "$parentCHATOUT", options, "InterfaceOptionsCheckButtonTemplate")
chatout:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -140)
chatout.Text:SetText("Chat (spammy)")
chatout.tooltipText = "Print on chat"
chatout:SetChecked(GMAGGROMON["CHAT"]);
chatout:SetScript("OnClick", function(self)
	if chatout:GetChecked() then 
		GMAGGROMON["CHAT"] = true
		print(string_format("%s: output on chat is enabled",prgname))
	else 
		GMAGGROMON["CHAT"] = false
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
		DEFAULT_CHAT_FRAME:AddMessage("gmAggroMon: [threat nil] no aggro, unit is not on any other unit's threat table.",0,1,0) 
		for index = 0, 3, 1 do
			DEFAULT_CHAT_FRAME:AddMessage(string_format("gmAggroMon: [threat lvl:%i] %s", index, gmAggroMon_lvl[index+1]), gmAggroMon_color[index+1][1],gmAggroMon_color[index+1][2],gmAggroMon_color[index+1][3]) 
		end
	end) 

local frameshow = CreateFrame("CheckButton", "$parentFRAMESHOW", options, "InterfaceOptionsCheckButtonTemplate")
frameshow:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -170)
frameshow.Text:SetText("Aggro Frame")
frameshow.tooltipText = "Show the little aggro frame"
frameshow:SetChecked(GMAGGROMON["SHOW"]);
frameshow:SetScript("OnClick", function(self)
	
	if frameshow:GetChecked() then 
		GMAGGROMON["SHOW"] = true
		print(string_format("%s: aggro frame is enabled",prgname))
		gmAggroMon_AggroFrame:SetBackdropColor(0,1,0,0.8)	
		gmAggroMon_AggroFrame:Show()
	else 
		GMAGGROMON["SHOW"] = false
		print(string_format("%s: aggro frame is disabled",prgname))
		gmAggroMon_AggroFrame:Hide()
	end	
	
end)	

local sound = CreateFrame("CheckButton", "$parentSND", options, "InterfaceOptionsCheckButtonTemplate")
sound:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -200)
sound.Text:SetText("Sound Alert")
sound.tooltipText = "Sound"
sound:SetChecked(GMAGGROMON["SOUND"]);
sound:SetScript("OnClick", function(self)
	
	if sound:GetChecked() then 
		GMAGGROMON["SOUND"] = true
		print(string_format("%s: sound alert is enabled",prgname))
	else 
		GMAGGROMON["SOUND"] = false
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
		PlaySoundFile(gmAggroMon_soundfile[GMAGGROMON["SNDFLE"]], "Master")
	end) 
	
local sndfile = CreateFrame("Slider", "$parentSNDFILE", options, "OptionsSliderTemplate")
sndfile:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 6, -230)
sndfile:SetWidth(250)
sndfile:SetMinMaxValues(1, 6)
sndfile:SetValue(1)
sndfile.low = _G[sndfile:GetName().."Low"]
sndfile.low:SetPoint("TOPLEFT", sndfile, "BOTTOMLEFT", 0, 0)
sndfile.low:SetText('1')
sndfile.high = _G[sndfile:GetName().."High"]
sndfile.high:SetPoint("TOPRIGHT", sndfile, "BOTTOMRIGHT", 0, 0)
sndfile.high:SetText('6')
sndfile.text = _G[sndfile:GetName().."Text"]
sndfile.text:SetText("Sounds")
sndfile.tooltipText = "Sound"
sndfile.value = sndfile:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
sndfile.value:SetPoint("TOP", sndfile, "BOTTOM", 0, 0)
sndfile.value:SetText(GMAGGROMON["SNDFLE"])
sndfile:SetScript("OnValueChanged", function(self, value)
	GMAGGROMON["SNDFLE"] = floor(value + 0.5)
	self:SetValue(GMAGGROMON["SNDFLE"])
	self.value:SetText(GMAGGROMON["SNDFLE"])
end)

function options.refresh()
	enable:SetChecked(GMAGGROMON["ACTIVE"])
	sound:SetChecked(GMAGGROMON["SOUND"])
	chatout:SetChecked(GMAGGROMON["CHAT"])
	enable_pvp:SetChecked(GMAGGROMON["ENAPVP"])
	frameshow:SetChecked(GMAGGROMON["SHOW"])
end

if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end


-- Frame to register the global vars at the ADDON_LOADED event.	
local frame_al = CreateFrame("Frame", "frame_al", UIParent)
frame_al:RegisterEvent("ADDON_LOADED")	
frame_al:SetScript("OnEvent", function(self, event, arg1, ...)	
	if event == "ADDON_LOADED" and arg1 == "gmAggroMon" then		
	
		if GMAGGROMON["SHOW"] == false then	
			gmAggroMon_summary = "[show no] "
			gmAggroMon_AggroFrame:Hide()
		else
			gmAggroMon_summary = "[show yes] "
			gmAggroMon_AggroFrame:Show()
		end
		
		if GMAGGROMON["CHAT"] == false then	
			gmAggroMon_summary = gmAggroMon_summary .. "[print no] "
		else
			gmAggroMon_summary = gmAggroMon_summary .. "[print yes] "
		end
		
		if GMAGGROMON["SOUND"] == false then	
			gmAggroMon_summary = gmAggroMon_summary .. "[sound no] "
		else
			gmAggroMon_summary = gmAggroMon_summary .. "[sound yes] "
		end

		if GMAGGROMON["ENAPVP"] == false then	
			gmAggroMon_summary = gmAggroMon_summary .. "[pvp no] "
		else
			gmAggroMon_summary = gmAggroMon_summary .. "[pvp yes] "
		end
		
		if GMAGGROMON["ACTIVE"] == false then			
			print(string_format("%s: |cffff0000disabled|r. Type /%s to enable", prgname, prgname))
		else
			print(string_format("%s: |cff228B22enabled|r %s" , prgname, gmAggroMon_summary))
		end 
				
		options.refresh()
		self:UnregisterEvent("ADDON_LOADED")		
	end	
end)	


-- CMD Parse --------------------------------------------------------------------------------------------
	
SLASH_GMAGGROMON1 = "/aggromon";
SlashCmdList["GMAGGROMON"] = function() 
	InterfaceOptionsFrame_OpenToCategory(options)
end