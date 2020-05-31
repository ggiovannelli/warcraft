local ADDON = ...

GMCHAT = {
	SHOWTABS = false,
	FONTOUTLINE = false,
	ALERTSOCIAL = false,
}

local function colorclass(name,class)
	local color = _G["RAID_CLASS_COLORS"][class]
	return string.format("\124cff%02x%02x%02x%s\124r", color.r*255, color.g*255, color.b*255, name)
end

-- Create a Button on TOPLEFT
-- local gmChatTabBtn = CreateFrame( "Button", "gmChatTabBtn", UIParent, "UIPanelButtonTemplate" )
local gmChatTabBtn = CreateFrame("Frame", nil, UIParent)
gmChatTabBtn:EnableMouse( true )
gmChatTabBtn:SetWidth(5)
gmChatTabBtn:SetHeight(5)
gmChatTabBtn:SetPoint("TOPLEFT",GeneralDockManager,"BOTTOMLEFT",0,-5)
gmChatTabBtn.texture = gmChatTabBtn:CreateTexture(nil, "BACKGROUND")
gmChatTabBtn.texture:SetAllPoints(true)
gmChatTabBtn.texture:SetColorTexture(0.0, 1.0, 0.0, 1)


--[[ -- Need more debug.
local gmChatSocAlert = CreateFrame("Frame")
local function SocialAlert(enable)
	if enable then
		print("Social Alert ENABLED")
		gmChatSocAlert:RegisterEvent("SOCIAL_QUEUE_UPDATE")
		gmChatSocAlert:SetScript("OnEvent", function(self, event, arg1, arg2)
			if event == "SOCIAL_QUEUE_UPDATE" then
				if arg1 and arg2 and arg2 >= 1 then
					-- print("DEBUG1:"..arg1..":"..arg2)
					local className, classId, raceName, raceId, gender, name, realm = GetPlayerInfoByGUID(select(7,C_SocialQueue.GetGroupInfo(arg1)))
					if name and className then				
						print("Your friend " .. colorclass(name, className:upper()) .." create a group")
					end
				end
			end
		end)
	else 
		print("Social Alert DISABLED")
		gmChatSocAlert:UnregisterEvent("SOCIAL_QUEUE_UPDATE")
	end
end
--]]

local function ShowTabs(visibility)
	if visibility then 
			GeneralDockManager:Show( )
			GMCHAT["SHOWTABS"] = true
			gmChatTabBtn.texture:SetColorTexture(1.0, 0.0, 0.0, 1)			
	else
			GeneralDockManager:Hide( )
			GMCHAT["SHOWTABS"] = false
			gmChatTabBtn.texture:SetColorTexture(0.0, 1.0, 0.0, 1)	
	end
end

local function StyleFont(font,size,flags)

	for i=1, NUM_CHAT_WINDOWS do
		if font == nil then font = select(1,_G["ChatFrame"..i]:GetFont()) end
		if size == nil then size = select(2,_G["ChatFrame"..i]:GetFont()) end
		if flags == nil then flags = "" end
		_G["ChatFrame"..i]:SetFont(font , size , flags)
		_G["ChatFrame"..i.."EditBox"]:SetFont(font , size , flags)
	end

end

gmChatTabBtn:SetScript('OnMouseUp', function(self, button)
	if (button == 'RightButton') then
		if GeneralDockManager:IsVisible()  then 	
			ShowTabs(false)
		else
			ShowTabs(true)
		end
	end	
end)

-- Url code by ReUrl: -----------------------------------------------------------
-- https://www.wowinterface.com/downloads/info5181-ReURL.html
local SetItemRef_orig = SetItemRef
function ReURL_SetItemRef(link, text, button)
	if (strsub(link, 1, 3) == "url") then
		local url = strsub(link, 5)
		local activeWindow = ChatEdit_GetActiveWindow()
		if ( activeWindow ) then
			activeWindow:Insert(url)
			ChatEdit_FocusActiveWindow()
			activeWindow:HighlightText()
		else
			ChatEdit_GetLastActiveWindow():Show()
			ChatEdit_GetLastActiveWindow():Insert(url)
			ChatEdit_GetLastActiveWindow():SetFocus()
			ChatEdit_GetLastActiveWindow():HighlightText()
		end
	else
		SetItemRef_orig(link, text, button)
	end
end
SetItemRef = ReURL_SetItemRef

function ReURL_AddLinkSyntax(chatstring)
	if (type(chatstring) == "string") then
		local extraspace
		if (not strfind(chatstring, "^ ")) then
			extraspace = true
			chatstring = " "..chatstring
		end
		chatstring = gsub (chatstring, " www%.([_A-Za-z0-9-]+)%.(%S+)%s?", " |cffFFFF55|Hurl:www.%1.%2|h[www.%1.%2]|h|r ")
		chatstring = gsub (chatstring, " (%a+)://(%S+)%s?", " |cffFFFF55|Hurl:%1://%2|h[%1://%2]|h|r ")
		chatstring = gsub (chatstring, " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", " |cffFFFF55|Hurl:%1@%2%3%4|h[%1@%2%3%4]|h|r ")
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?", " |cffFFFF55|Hurl:%1.%2.%3.%4:%5|h[%1.%2.%3.%4:%5]|h|r ")
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", " |cffFFFF55|Hurl:%1.%2.%3.%4|h[%1.%2.%3.%4]|h|r ")
		if (extraspace) then
			chatstring = strsub(chatstring, 2)
		end
	end
	return chatstring
end

--Hook all the AddMessage funcs
for i=1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	local addmessage = frame.AddMessage
	frame.AddMessage = function(self, text, ...) addmessage(self, ReURL_AddLinkSyntax(text), ...) end
end
-- END ReUrl Code ---------------------------------------------------------------

--  Chat ------------------------------------------------------------------------

local function StyleChat(enabled)
	for i=1, NUM_CHAT_WINDOWS do

		-- position the EditBoxes
		_G["ChatFrame"..i.."EditBox"]:ClearAllPoints()
		_G["ChatFrame"..i.."EditBox"]:SetPoint("BOTTOMLEFT",  _G["ChatFrame"..i], "TOPLEFT",  -5, 0)
		_G["ChatFrame"..i.."EditBox"]:SetPoint("BOTTOMRIGHT", _G["ChatFrame"..i], "TOPRIGHT", 5, 0)
		
		-- hide the textures
		_G["ChatFrame"..i.."EditBoxMid"]:Hide()
		_G["ChatFrame"..i.."EditBoxLeft"]:Hide()
		_G["ChatFrame"..i.."EditBoxRight"]:Hide()
		
		-- misc settings
		_G["ChatFrame"..i]:SetClampedToScreen(false)
		_G["ChatFrame"..i]:SetFading(true)
		_G["ChatFrame"..i]:SetTimeVisible(20)
		_G["ChatFrame"..i]:SetFadeDuration(20)	
		_G["ChatFrame"..i]:SetMaxLines(1000)
		
		_G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0)
		_G["ChatFrame"..i]:SetMaxResize(UIParent:GetWidth()/2, UIParent:GetHeight()/2)
		_G["ChatFrame"..i]:SetMinResize(100, 50)

		if GMCHAT["FONTOUTLINE"] then 
			StyleFont(nil,nil,"OUTLINE")
		end
		
		-- Allow arrow keys in Edit Box
		_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
	
		_G["ChatFrame"..i.."ButtonFrame"]:Hide()
		_G["ChatFrame"..i.."ButtonFrameLeftTexture"]:Hide()

		_G["ChatFrame"..i.."EditBox"]:SetScript("OnShow", function(self) 
			GeneralDockManager:Hide()
		end)

		_G["ChatFrame"..i.."EditBox"]:SetScript("OnHide", function(self) 	
			if GMCHAT["SHOWTABS"] then 
				ShowTabs(true)
			end
		end)
		
	end

	--ChatFrameMenuButton
	ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
	ChatFrameMenuButton:Hide()

	--ChatFrameChannelButton
	ChatFrameChannelButton:HookScript("OnShow", ChatFrameChannelButton.Hide)
	ChatFrameChannelButton:Hide()

	--ChatFrameToggleVoiceDeafenButton
	ChatFrameToggleVoiceDeafenButton:HookScript("OnShow", ChatFrameToggleVoiceDeafenButton.Hide)
	ChatFrameToggleVoiceDeafenButton:Hide()

	--ChatFrameToggleVoiceMuteButton
	ChatFrameToggleVoiceMuteButton:HookScript("OnShow", ChatFrameToggleVoiceMuteButton.Hide)
	ChatFrameToggleVoiceMuteButton:Hide()

	--QuickJoinToastButton
	QuickJoinToastButton:HookScript("OnShow", QuickJoinToastButton.Hide)
	QuickJoinToastButton:Hide()

	--don't cut the toastframe
	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-15,15,15,-15)

	-- Remove Tabs		
	-- If you enable the following line the button can't show the tab again
	-- GeneralDockManager:HookScript("OnShow", GeneralDockManager.Hide)
	ShowTabs(GMCHAT["SHOWTABS"])

	--channels
	CHAT_WHISPER_GET              = "From %s "
	CHAT_WHISPER_INFORM_GET       = "To %s "
	CHAT_BN_WHISPER_GET           = "From %s "
	CHAT_BN_WHISPER_INFORM_GET    = "To %s "
	CHAT_YELL_GET                 = "%s "
	CHAT_SAY_GET                  = "%s "
	CHAT_BATTLEGROUND_GET         = "|Hchannel:Battleground|hBG.|h %s: "
	CHAT_BATTLEGROUND_LEADER_GET  = "|Hchannel:Battleground|hBGL.|h %s: "
	CHAT_GUILD_GET                = "|Hchannel:Guild|hG.|h %s: "
	CHAT_OFFICER_GET              = "|Hchannel:Officer|hGO.|h %s: "
	CHAT_PARTY_GET                = "|Hchannel:Party|hP.|h %s: "
	CHAT_PARTY_LEADER_GET         = "|Hchannel:Party|hPL.|h %s: "
	CHAT_PARTY_GUIDE_GET          = "|Hchannel:Party|hPG.|h %s: "
	CHAT_RAID_GET                 = "|Hchannel:Raid|hR.|h %s: "
	CHAT_RAID_LEADER_GET          = "|Hchannel:Raid|hRL.|h %s: "
	CHAT_RAID_WARNING_GET         = "|Hchannel:RaidWarning|hRW.|h %s: "
	CHAT_INSTANCE_CHAT_GET        = "|Hchannel:Battleground|hI.|h %s: "
	CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
	--CHAT_MONSTER_PARTY_GET       = CHAT_PARTY_GET
	--CHAT_MONSTER_SAY_GET         = CHAT_SAY_GET
	--CHAT_MONSTER_WHISPER_GET     = CHAT_WHISPER_GET
	--CHAT_MONSTER_YELL_GET        = CHAT_YELL_GET
	CHAT_FLAG_AFK = "<AFK> "
	CHAT_FLAG_DND = "<DND> "
	CHAT_FLAG_GM = "<[GM]> "
	CHAT_TAB_HIDE_DELAY = 1

	--remove the annoying guild loot messages by replacing them with the original ones
	YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
	LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

	SetCVar("colorChatNamesByClass", "1")
	
end




local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, arg1, arg2)
	if event == "PLAYER_ENTERING_WORLD" then
		StyleChat(true)
		-- SocialAlert(GMCHAT["ALERTSOCIAL"])
	end
end)

-- Configuration Panel ----------------------------------------------------------------------------

local options = CreateFrame("Frame", "options", InterfaceOptionsFramePanelContainer)
options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
InterfaceOptions_AddCategory(options)

-- Title (title)
local title = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(options.name)
options.title = title

-- SubTitle (subtitle)
local subtext = options:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
subtext:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtext:SetPoint("RIGHT", -32, 0)
subtext:SetHeight(32)
subtext:SetJustifyH("LEFT")
subtext:SetJustifyV("TOP")
subtext:SetText(GetAddOnMetadata(ADDON, "Notes"))
options.subtext = subtext

local check1 = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
check1:SetPoint("TOPLEFT", 18, -100)
check1.Text:SetText("Font Outline")
check1.tooltipText = "Font Outline"
check1:SetChecked(GMCHAT["FONTOUTLINE"])
check1:SetScript("OnClick", function(self)
	local flags = nil
	if check1:GetChecked() then
		GMCHAT["FONTOUTLINE"] = true
		flags="OUTLINE"
	else 
		GMCHAT["FONTOUTLINE"] = false
	end	
	StyleFont(nil,nil,flags)

end)

local check2 = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
check2:SetPoint("TOPLEFT", 18, -130)
check2.Text:SetText("Show Tabs")
check2.tooltipText = "Default setting for Chat Tabs. In game you can Show/Hide them by right-click the small button in top-left of chat frame"
check2:SetChecked(GMCHAT["SHOWTABS"])
check2:SetScript("OnClick", function(self)
	if check2:GetChecked() then
		GMCHAT["SHOWTABS"] = true
	else 
		GMCHAT["SHOWTABS"] = false
	end
	ShowTabs(GMCHAT["SHOWTABS"])
end)

--[[ Need more debug.
local check3 = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
check3:SetPoint("TOPLEFT", 18, -160)
check3.Text:SetText("Social Alert (alpha code)")
check3.tooltipText = "Try to alert in chat when a friends make some social activities"
check3:SetChecked(GMCHAT["ALERTSOCIAL"])
check3:SetScript("OnClick", function(self)
	if check3:GetChecked() then
		GMCHAT["ALERTSOCIAL"] = true
	else 
		GMCHAT["ALERTSOCIAL"] = false
	end
	SocialAlert(GMCHAT["ALERTSOCIAL"])
end)
--]]

-- WoW Default Fonts Button
local button1 = CreateFrame("button", button1, options, "UIPanelButtonTemplate")
button1:SetHeight(40)
button1:SetWidth(150)
button1:SetPoint("BOTTOMLEFT", 10, 16)
button1:SetText("Reset and reload UI")
button1.tooltipText = "BEWARE: Reset your custom settings and reload your UI"
button1:SetScript("OnClick",  
	function()
		GMCHAT = {}
		ReloadUI()
	end)  
	
-- WoW Default Fonts Button
local button2 = CreateFrame("button", button2, options, "UIPanelButtonTemplate")
button2:SetHeight(40)
button2:SetWidth(150)
button2:SetPoint("BOTTOMLEFT", 190, 16)
button2:SetText("Chat Panel")
button2.tooltipText = "Open the default Blizzard Chat Panel to all the other settings"
button2:SetScript("OnClick",  
	function()
		InterfaceOptionsFrame_OpenToCategory(InterfaceOptionsSocialPanel)
	end)  	

--- credits  
local credits = options:CreateFontString("$parentTitle", "ARTWORK", "SystemFont_Small")
credits:SetPoint("BOTTOMRIGHT", -16, 16)
credits:SetText("version: |cffffd200"..GetAddOnMetadata(ADDON, "Version").."|r by |cffffd200"..GetAddOnMetadata(ADDON, "Author").."|r")
options.credits = credits		

function options.refresh()
	check1:SetChecked(GMCHAT["FONTOUTLINE"])
	check2:SetChecked(GMCHAT["SHOWTABS"])
	-- check3:SetChecked(GMCHAT["ALERTSOCIAL"])	
end

if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end