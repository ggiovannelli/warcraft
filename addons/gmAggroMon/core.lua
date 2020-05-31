-- Most of the idea to the code (and the "well written" part of it :-) are by Phanx, whom I thanks for the helps and patience in explaining. 

local ADDON = ...

-- defaults 

GMAGGROMON = {

	ACTIVE = true,
	SOUND = true,
	CHAT = false,
	SHOW = false,
	SNDFLE = 1,
	ENAPVP = false,
	
	AFPOINT = "CENTER",
	AFRELPNT = "CENTER",
	AFX = 0,
	AFY = 0,

}


local prgname = "|cffffd200gmAggroMon|r"
local string_format = string.format
local tostring = tostring

local status_old, gmAggroMon_value

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
	
local color = {
	{1,1,0},
	{1,0.5,0},
	{1,0.2,0},
	{1,0,0},
}
	
local soundfile = {
	"Interface\\AddOns\\gmAggroMon\\sounds\\babe.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\zenham.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\pluck.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\ok.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\laser.ogg",
	"Interface\\AddOns\\gmAggroMon\\sounds\\left.ogg",
	
	-- Sounds taken from banzai-alert: http://www.wowace.com/addons/banzai-alert/ and from LibreOffice distribution
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

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
		frame:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		frame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end		
end
	
		
-- Frame colored based on aggro -----------------------------------------------------------------------------
local miniFrame = CreateFrame("Frame")
miniFrame:SetBackdrop({bgFile = bgfile, edgeFile = edgefile, edgeSize = 18, insets = {left = 5, right = 5, top = 5, bottom = 5}})
miniFrame:SetBackdropColor(0,0,0,0.8)
miniFrame:SetWidth(40)
miniFrame:SetHeight(40)
miniFrame:EnableMouse(true)
miniFrame:SetMovable(true)
miniFrame:RegisterForDrag("LeftButton")
miniFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
miniFrame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing()
	GMAGGROMON["AFPOINT"], _, GMAGGROMON["AFRELPNT"], GMAGGROMON["AFX"], GMAGGROMON["AFY"] = miniFrame:GetPoint()
end)		
miniFrame:SetClampedToScreen(true)
miniFrame:SetUserPlaced(true)


local aggroValue = miniFrame:CreateFontString("miniFrame")
aggroValue:SetPoint("CENTER", miniFrame,"CENTER",0, 0)
aggroValue:SetFont(GameFontNormal:GetFont(),(framefonth))
miniFrame:Hide()

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
			DEFAULT_CHAT_FRAME:AddMessage(string_format("gmAggroMon: [threat lvl:%i] %s", index, gmAggroMon_lvl[index+1]), color[index+1][1],color[index+1][2],color[index+1][3]) 
		end
	end) 

local frameshow = CreateFrame("CheckButton", "$parentFRAMESHOW", options, "InterfaceOptionsCheckButtonTemplate")
frameshow:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -170)
frameshow.Text:SetText("Aggro Frame (combat only)")
frameshow.tooltipText = "Show the little aggro frame during combat"
frameshow:SetChecked(GMAGGROMON["SHOW"]);
frameshow:SetScript("OnClick", function(self)
	
	if frameshow:GetChecked() then 
		GMAGGROMON["SHOW"] = true
		print(string_format("%s: aggro frame is enabled in combat",prgname))
		miniFrame:SetBackdropColor(0,1,0,0.8)	
		-- miniFrame:Show()
	else 
		GMAGGROMON["SHOW"] = false
		print(string_format("%s: aggro frame is disabled",prgname))
		-- miniFrame:Hide()
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
		PlaySoundFile(soundfile[GMAGGROMON["SNDFLE"]], "Master")
	end) 
	
local sndfile = CreateFrame("Slider", "$parentSNDFILE", options, "OptionsSliderTemplate")
sndfile:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 6, -230)
sndfile:SetWidth(250)
sndfile:SetMinMaxValues(1, 6)
sndfile:SetValue(1)
sndfile.low = _G[sndfile:GetName().."Low"]
sndfile.low:SetPoint("TOPLEFT", sndfile, "BOTTOMLEFT", 0, 0)
sndfile.low:SetText("")
sndfile.low:SetText("1")
sndfile.high = _G[sndfile:GetName().."High"]
sndfile.high:SetPoint("TOPRIGHT", sndfile, "BOTTOMRIGHT", 0, 0)
sndfile.high:SetText("")
sndfile.high:SetText("6")
sndfile.text = _G[sndfile:GetName().."Text"]
sndfile.text:SetText("")
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



frame:SetScript("OnEvent", function(self, event, arg1, ...)

	if event == "ADDON_LOADED" and arg1 == "gmAggroMon" then 
	
		if GMAGGROMON["ACTIVE"] == false then			
			print(string.format("%s: |cffff0000disabled|r. Type /%s to enable", prgname, prgname))
		end 
				
		options.refresh()
		self:UnregisterEvent("ADDON_LOADED")		

	elseif event == "PLAYER_ENTERING_WORLD" then

		miniFrame:SetPoint(GMAGGROMON["AFPOINT"],nil,GMAGGROMON["AFRELPNT"],GMAGGROMON["AFX"],GMAGGROMON["AFY"])
		gmAggroMon_check()
	
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		
		gmAggroMon_check()

	elseif event == "UNIT_THREAT_SITUATION_UPDATE" or event == "COMBAT_LOG_EVENT_UNFILTERED" then

		local status = UnitThreatSituation("player")
	
		-- show the colored frame
		if GMAGGROMON["SHOW"] == true then	

			if status then
				miniFrame:Show()
				miniFrame:SetBackdropColor(color[status+1][1],color[status+1][2],color[status+1][3],0.8)
			else
				miniFrame:Hide()
				miniFrame:SetBackdropColor(0,1,0,0.8)			
			end					
		end
		
		-- print on the console
		if GMAGGROMON["CHAT"] == true then 

			if status then 
				DEFAULT_CHAT_FRAME:AddMessage(string_format("gmAggroMon: [threat lvl:%i] [target:%s] %s", status, gmAggroMon_value, gmAggroMon_lvl[status+1]), color[status+1][1],color[status+1][2],color[status+1][3]) 
			else  
				DEFAULT_CHAT_FRAME:AddMessage("gmAggroMon: [threat nil] no aggro, unit is not on any other unit's threat table.",0,1,0) 
			end
		end 
		
		-- play the old "Aggro!" ... It miss me so much ...  ! :-)
		if GMAGGROMON["SOUND"] == true then 

			if status and status >= 1 and status_old == nil then
				PlaySoundFile(soundfile[GMAGGROMON["SNDFLE"]], "Master")
			end
		end 		
		-- store the actual aggro level
		status_old = status

		_,_,gmAggroMon_value,_,_ = UnitDetailedThreatSituation("player", "target");
		gmAggroMon_value = tostring(string_format("%.0f",(gmAggroMon_value or 0)))
		aggroValue:SetText(gmAggroMon_value)
	
	end	
	
end)


-- CMD Parse --------------------------------------------------------------------------------------------
	
SLASH_GMAGGROMON1 = "/aggromon";
SlashCmdList["GMAGGROMON"] = function() 
	InterfaceOptionsFrame_OpenToCategory(options)
end