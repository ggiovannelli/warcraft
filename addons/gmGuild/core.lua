local ADDON, namespace = ...
local L = namespace.L
local tooltip, tooltip_note
local checkbox = {}

local OnlineIcon = "|TInterface\\FriendsFrame\\StatusIcon-Online:13:13:0:0:16:16:0:16:0:16|t "
local AwayIcon = "|TInterface\\FriendsFrame\\StatusIcon-Away:13:13:0:0:16:16:0:16:0:16|t "
local DnDIcon = "|TInterface\\FriendsFrame\\StatusIcon-DnD:13:13:0:0:16:16:0:16:0:16|t "
local StatusIcon, StatusAccountIcon

local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

local arg = {}
local arg_note = {}

local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

local dataobj = ldb:NewDataObject(ADDON, {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
	text = "-"
})

local classes = {}
for class in pairs(RAID_CLASS_COLORS) do
   tinsert(classes, class)
end
sort(classes)

local classTokens = {}
for token, class in pairs(LOCALIZED_CLASS_NAMES_MALE) do
   classTokens[class] = token
end
for token, class in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
   classTokens[class] = token
end

local function GetClassToken(className)
   return className and classTokens[className]
end

local function classcolor(name,class)
	if class then 
		class = GetClassToken(class)
		local color = _G["RAID_CLASS_COLORS"][class]
		if color then 
			return string.format("\124cff%02x%02x%02x%s\124r", color.r*255, color.g*255, color.b*255, name)
		end
	end
	return name
end

local function OnRelease_note(self)
	LibQTip:Release(self.tooltip_note)
	self.tooltip_note = nil  
end  
 
local function OnLeave_note(self)
	if self.tooltip_note and not self.tooltip_note:IsMouseOver() then
		self.tooltip_note:Release()
	end
end  

local function ShowNote(self,arg_note,button)
	
	-- create and destroy everything is attached to note --
	local tooltip_note = LibQTip:Acquire(ADDON.."tip_note", 2, "LEFT", "LEFT")
	LibQTip:Release(tooltip_note)
	tooltip_note = nil

	local row,col
    local tooltip_note = LibQTip:Acquire(ADDON.."tip_note", 2, "LEFT", "LEFT")
    self.tooltip_note = tooltip_note 
    tooltip_note:SmartAnchorTo(self)
	tooltip_note.OnRelease = OnRelease_note
	tooltip_note.OnLeave = OnLeave_note
    tooltip_note:SetAutoHideDelay(.1, self)
	tooltip_note:SetFrameLevel(arg_note.strata)
	
	row,col = tooltip_note:AddLine()
	tooltip_note:SetCell(row,1,"|cFFFFFF00" .. L["Note"] .. "|r","LEFT")	
	tooltip_note:SetCell(row,2,arg_note.note,"RIGHT")
	
	row,col = tooltip_note:AddLine()
	tooltip_note:SetCell(row,1,"|cFFFFFF00" .. L["Officer Note"] .. "|r","LEFT")	
	tooltip_note:SetCell(row,2,arg_note.officernote,"RIGHT")	
	
	row,col = tooltip_note:AddLine()
	tooltip_note:SetCell(row,1,"|cFFFFFF00" .. L["Achievements Points"] .. "|r","LEFT")	
	tooltip_note:SetCell(row,2,arg_note.achievementPoints,"RIGHT")	
	tooltip_note:SetBackdropColor(0,0,0,1)
	row,col = tooltip_note:Show()
end

local function Button_OnClick(row,arg,button)
	
	if button == "LeftButton" then	
		if IsAltKeyDown() then
			print(string.format("%s : %s",_G["GROUP_INVITE"],classcolor(arg.name,arg.class)))
			C_PartyInfo.InviteUnit(arg.name)
		else
			ChatFrame_SendTell(arg.name)
		end
	end	
end

local function OnRelease(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil  
end  
 
local function OnLeave(self)
	if self.tooltip and not self.tooltip:IsMouseOver() then
		self.tooltip:Release()
	end
end  

local function anchor_OnEnter(self)
	
	arg = {}
	arg_note = {}

	LibQTip:Release(self.tooltip)
	self.tooltip = nil  

	-- Guild -------------------------------------------------------------------------------

	if IsInGuild() then

		local row,col
		local tooltip = LibQTip:Acquire(ADDON.."tip", 4, "LEFT", "CENTER", "LEFT","LEFT")
		self.tooltip = tooltip 
		tooltip:SmartAnchorTo(self)
		tooltip:EnableMouse(true)
		tooltip.OnRelease = OnRelease
		tooltip.OnLeave = OnLeave
		tooltip:SetAutoHideDelay(.1, self)
	
		GuildRoster()
		row,col = tooltip:AddHeader()
		tooltip:SetCell(row,1,select(1,GetGuildInfo("player")),"LEFT",4)
		tooltip:SetCellTextColor(row,1,0,1,0)
		
		if GMGUILD_CFG[1][2] and GetGuildRosterMOTD() then 
			local width
			if tooltip:GetWidth() > 200 then
					width = tooltip:GetWidth() + 100
			else
				width = 300
			end
			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1,GetGuildRosterMOTD(),nil,"LEFT",4,nil, 0, 0, width)
			tooltip:SetCellTextColor(row,1,0,1,0)
		end
		row,col = tooltip:AddLine("")
		row,col = tooltip:AddLine(_G["NAME"],_G["LEVEL"],_G["ZONE"],_G["RANK"])
		tooltip:SetLineTextColor(row, 1, 0, 0)

		row,col = tooltip:AddLine("")
		
		for i = 1, GetNumGuildMembers() do
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(i)

			if online then
				name = Ambiguate(name, "none")
				
				if status == 1 then
					StatusIcon = AwayIcon
				elseif status == 2 then 
					StatusIcon = DnDIcon
				else
					StatusIcon = ""
				end			
				
				if UnitInParty(name) then 
					StatusIcon = " + " .. StatusIcon
				end
				
				row,col = tooltip:AddLine(StatusIcon .. classcolor(name,class),level,zone,rank)
		
				arg[row] = { type = "GUILD", name = name, class = class, client = "-", account = "-"}
				tooltip:SetLineScript(row, 'OnMouseUp', Button_OnClick, arg[row])
				
				if GMGUILD_CFG[2][2] then
					arg_note[row] = { note=note, officernote=officernote, achievementPoints=achievementPoints, strata=tooltip:GetFrameLevel()+10 }
					tooltip:SetLineScript(row,'OnEnter',ShowNote,arg_note[row])
				end
				
			end
		end	
	
	
		if GMGUILD_CFG[3][2] then
		
			row,col = tooltip:AddLine("")
			row,col = tooltip:AddLine("")
			row,col = tooltip:AddSeparator()
			row,col = tooltip:AddLine("")
			row,col = tooltip:AddLine("")		
			
			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1, LeftButton .. " |cFF00FF00" .. _G["GUILD_FRAME_TITLE"] .."|r","LEFT",2)
			tooltip:SetCell(row,3,_G["NAME"] .." ".. LeftButton .. " |cFFFF7FFF" .. _G["WHISPER"] .."|r","RIGHT",2)	

			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1, RightButton .." |cFFFFFF00" .. _G["SHOW_FRIENDS_LIST"] .. "|r","LEFT",2)	
			tooltip:SetCell(row,3,_G["NAME"] .. " ALT+" .. LeftButton .. " |cFFAAAAFF" .. _G["PARTY_INVITE"] .."|r","RIGHT",2)

		end
	
        row,col = tooltip:Show()
        tooltip:UpdateScrolling(UIParent:GetHeight()-100)	
		-- The END -------------------------------------------------------------------------------------------------
	end 
end

 
dataobj.OnClick = function(self, button)  

	if InCombatLockdown() then return end

	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end

	if button == "LeftButton" then
		ToggleGuildFrame()
		if IsInGuild() then 	
			CommunitiesFrame:SetDisplayMode(COMMUNITIES_FRAME_DISPLAY_MODES.ROSTER)
		end
	end	
	
	if button == "RightButton" then
		ToggleFriendsFrame(1)
	end	
end

dataobj.OnEnter = function(self)
	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil
	end
	anchor_OnEnter(self)
end

dataobj.OnLeave = function(self)
	-- Null operation: Some LDB displays get cranky if this method is missing.
end

-- Configuration Panel -------------------------------------------------------------------------------

local options = CreateFrame("Frame", ADDON .. "options", InterfaceOptionsFramePanelContainer)
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

-- All the lines of the options panel are built during the 
-- event "PLAYER_LOGIN" 

-- Reset and Reload Default 
local button1 = CreateFrame("button", ADDON .. "button1", options, "UIPanelButtonTemplate")
button1:SetHeight(40)
button1:SetWidth(150)
button1:SetPoint("BOTTOMLEFT", 10, 16)
button1:SetText("Reset and reload UI")
button1.tooltipText = "BEWARE: Reset your custom settings and reload your UI"
button1:SetScript("OnClick",  
	function()
		GMGUILD_CFG = {}
		ReloadUI()
	end)  
	
-- Reload UI 
local button2 = CreateFrame("button", ADDON .. "button2", options, "UIPanelButtonTemplate")
button2:SetHeight(40)
button2:SetWidth(150)
button2:SetPoint("BOTTOMLEFT", 190, 16)
button2:SetText("Save and reload UI")
button2.tooltipText = "Save your settings and reload your UI"
button2:SetScript("OnClick",  
	function()
		ReloadUI()
	end)  	

--- credits  
local credits = options:CreateFontString("$parentTitle", "ARTWORK", "SystemFont_Small")
credits:SetPoint("BOTTOMRIGHT", -16, 16)
credits:SetText("version: |cffffd200"..GetAddOnMetadata(ADDON, "Version").."|r by |cffffd200"..GetAddOnMetadata(ADDON, "Author").."|r")
options.credits = credits		

function options.refresh()
	for i = 1, #GMGUILD_CFG do
		checkbox[i] = SetChecked(checkbox[i][2])
	end
end

if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end

-- End Configuration Panel -----------------------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_GUILD_UPDATE")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")
frame:RegisterEvent("GUILD_RANKS_UPDATE")
frame:RegisterEvent("GUILD_MOTD")
frame:RegisterEvent("FRIENDLIST_UPDATE")
frame:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
frame:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
frame:SetScript("OnEvent", function(self, event, ...)

		if event == "PLAYER_LOGIN" then	

			-- Building default values 
			GMGUILD_CFG = GMGUILD_CFG or {}
			local GMGUILD_DEFAULTS = {
				{L["Show Guild Message"], true},
				{L["Show Player Info"], false},
				{L["Show Help"],true},
			}
				
			for k in pairs(GMGUILD_DEFAULTS) do
				if GMGUILD_CFG[k] == nil then GMGUILD_CFG[k] = GMGUILD_DEFAULTS[k] end
			end

			-- Building Options Panel
			for i = 1, #GMGUILD_CFG do
				checkbox[i] = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
				checkbox[i]:SetPoint("TOPLEFT", 18, (-70 - (30*i)))
				checkbox[i].Text:SetText(GMGUILD_CFG[i][1])
				checkbox[i]:SetChecked(GMGUILD_CFG[i][2])
				checkbox[i]:SetScript("OnClick", function(self)
					if checkbox[i]:GetChecked() then
						GMGUILD_CFG[i][2] = true
					else 
						GMGUILD_CFG[i][2] = false
					end	
				end)
				checkbox[i]:SetChecked(GMGUILD_CFG[i][2])
			end
		end

		-- Manage other events
		dataobj.text = string.format(" |cFF00FF00%s|r ", "G:"..select(3,GetNumGuildMembers()))
end)