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

local faction_icon = {
	Alliance = "|TInterface\\TargetingFrame\\UI-PVP-ALLIANCE:13:13:0:0:64:64:0:32:0:38|t",
	Horde = "|TInterface\\TargetingFrame\\UI-PVP-HORDE:13:13:0:0:64:64:0:38:0:36|t"
}

local bnet_code = _G["BATTLENET_FONT_COLOR_CODE"]
local bnet_color = _G["BATTLENET_FONT_COLOR"]

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

		if arg.type == "GUILD" or arg.type == "FRIENDS" then
			if IsAltKeyDown() then
				print(string.format("%s : %s",_G["GROUP_INVITE"],classcolor(arg.name,arg.class)))
				C_PartyInfo.InviteUnit(arg.name)
			else
				ChatFrame_SendTell(arg.name)
			end
		end

		if arg.type == "BNET" then

			if arg.client == BNET_CLIENT_WOW and arg.wowProjectID == WOW_PROJECT_ID and IsAltKeyDown() then
				print(string.format("%s : %s",_G["GROUP_INVITE"],arg.name))
				C_PartyInfo.InviteUnit(arg.name)
			else
				ChatFrame_SendBNetTell(arg.account)
			end
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

	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil
	end

    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 4, "LEFT", "CENTER", "LEFT","LEFT")
    self.tooltip = tooltip
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)

	-- Guild -------------------------------------------------------------------------------

	if GMGUILDFRIENDS_CFG[1][2] then

		if IsInGuild() then

			GuildRoster()
			row,col = tooltip:AddHeader()
			tooltip:SetCell(row,1,select(1,GetGuildInfo("player")),"LEFT",4)
			tooltip:SetCellTextColor(row,1,0,1,0)

			if GMGUILDFRIENDS_CFG[5][2] and GetGuildRosterMOTD() then
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

					if GMGUILDFRIENDS_CFG[6][2] then
						arg_note[row] = { note=note, officernote=officernote, achievementPoints=achievementPoints, strata=tooltip:GetFrameLevel()+10 }
						tooltip:SetLineScript(row,'OnEnter',ShowNote,arg_note[row])
					end
				end
			end
		end
	end

	-- BNET Friends ---------------------------------------------------------------------------------------

	if GMGUILDFRIENDS_CFG[2][2] then

		local numBNetTotal, numBNetOnline, numBNetFavorite, numBNetFavoriteOnline = BNGetNumFriends()

		if numBNetTotal > 0 then

			-- If Show Guild is UP ... print separator
			if GMGUILDFRIENDS_CFG[1][2] then
					row,col = tooltip:AddLine("")
					row,col = tooltip:AddLine("")
					row,col = tooltip:AddSeparator()
					row,col = tooltip:AddLine("")
					row,col = tooltip:AddLine("")
			end

			row,col = tooltip:AddLine("")

			row,col = tooltip:AddHeader()
			tooltip:SetCell(row,1,string.format("BNET %s",_G["SHOW_TOAST_ONLINE_TEXT"]),"LEFT",4)
			tooltip:SetCellTextColor(row,1,bnet_color.r,bnet_color.g,bnet_color.b)

			row,col = tooltip:AddLine("")
			row,col = tooltip:AddLine("")

			row,col = tooltip:AddLine(_G["NAME"],_G["LEVEL"],_G["ZONE"],_G["GAME"])
			tooltip:SetLineTextColor(row, 1, 0, 0)

			row,col = tooltip:AddLine("")

			local numBNetTotal, numBNetOnline, numBNetFavorite, numBNetFavoriteOnline = BNGetNumFriends()

			for i = 1, numBNetTotal do

				-- https://wow.gamepedia.com/API_C_BattleNet.GetFriendAccountInfo
				local accountInfo = C_BattleNet.GetFriendAccountInfo(i)

				local bnetAccID 	= accountInfo.gameAccountID
				local account 		= accountInfo.accountName
				local btag 			= accountInfo.battleTag
				local isAFK			= accountInfo.battleTag
				local isDND			= accountInfo.isDND

				local isOnline 		= accountInfo.gameAccountInfo.isOnline
				local client 		= accountInfo.gameAccountInfo.clientProgram
				local character 	= accountInfo.gameAccountInfo.characterName
				local realmName		= accountInfo.gameAccountInfo.realmName
				local timestamp 	= date("%d.%m.%y %H:%M:%S", accountInfo.lastOnlineTime)
				local class 		= accountInfo.gameAccountInfo.className
				local richPresence 	= accountInfo.gameAccountInfo.richPresence
				local wowProjectID 	= accountInfo.gameAccountInfo.wowProjectID
				local isGameBusy 	= accountInfo.gameAccountInfo.isGameBusy
				local isGameAFK 	= accountInfo.gameAccountInfo.isGameAFK
				local level			= accountInfo.gameAccountInfo.characterLevel
				local factionName	= accountInfo.gameAccountInfo.factionName


				if isGameAFK then
					StatusIcon = AwayIcon
				elseif isGameBusy then
					StatusIcon = DnDIcon
				else
					StatusIcon = ""
				end


				-- Show only playing BNET friends ?
				if (GMGUILDFRIENDS_CFG[7][2] and (client == BNET_CLIENT_APP or client == "BSAp")) == false then

					if isOnline then

						if character == nil then character = account end

						-- Setup some defaults
						row,col = tooltip:AddLine("","","","")
						tooltip:SetCell(row,3,richPresence)
						tooltip:SetCell(row,4,client)

						arg[row] = {
							type = "BNET",
							account = account,
							name = "-",
							class = "-",
							client = client,
							wowProjectID = "-"
						}


						-- retail WoW client
						if client == BNET_CLIENT_WOW then

								7
								tooltip:SetCell(row,2,level .. faction_icon[factionName])

								-- Sometimes accountInfo.gameAccountInfo.realmName == nil
								if realmName then
									arg[row]["name"] = character .. "-" .. realmName
								else
									arg[row]["name"] = character .. "-" .. GetRealmName()
								end

								arg[row]["wowProjectID"] = wowProjectID
								arg[row]["class"] = class

						-- Mobile Battle.net
						elseif client == BNET_CLIENT_APP or client == "BSAp" then
							tooltip:SetCell(row,1,BNet_GetClientEmbeddedTexture(client, 14) .. account)
						-- Other Games
						else

							if character == account then
								tooltip:SetCell(row,1,BNet_GetClientEmbeddedTexture(client, 14) .. StatusIcon .. classcolor(character,class))
							else
								tooltip:SetCell(row,1,BNet_GetClientEmbeddedTexture(client, 14) .. StatusIcon .. classcolor(character,class) .. " - " .. account)
							end
						end

						tooltip:SetLineScript(row, 'OnMouseUp', Button_OnClick, arg[row])


						if client == BNET_CLIENT_APP or client == "BSAp" then
							tooltip:SetLineTextColor(row,bnet_color.r,bnet_color.g,bnet_color.b)
						else
							tooltip:SetLineTextColor(row, 1, 1, 1)
						end
					end
				end
			end
		end
	end

	-- WoW Friends --------------------------------------------------------------------------------------------------

	if GMGUILDFRIENDS_CFG[3][2] then

		local numTotFriends = C_FriendList.GetNumFriends()
		local numTotOnlineFriends = C_FriendList.GetNumOnlineFriends()

		-- Re-check BNET before use them again
		local numBNetTotal = BNGetNumFriends()

		if numTotOnlineFriends > 0 then

			-- If Show Guild is UP or BNET (with online) ... print separator
			if GMGUILDFRIENDS_CFG[1][2] or (GMGUILDFRIENDS_CFG[2][2] and numBNetTotal > 0) then
					row,col = tooltip:AddLine("")
					row,col = tooltip:AddLine("")
					row,col = tooltip:AddSeparator()
					row,col = tooltip:AddLine("")
					row,col = tooltip:AddLine("")
			end

			local numBNetTotal, numBNetOnline, numBNetFavorite, numBNetFavoriteOnline = BNGetNumFriends()

			row,col = tooltip:AddLine("")

			row,col = tooltip:AddHeader()

			string.format("WoW %s",_G["SHOW_TOAST_ONLINE_TEXT"])

			tooltip:SetCell(row,1,string.format("WoW %s",_G["SHOW_TOAST_ONLINE_TEXT"]),"LEFT",4)
			tooltip:SetCellTextColor(row,1,1,1,0)

			row,col = tooltip:AddLine("")
			row,col = tooltip:AddLine("")

			row,col = tooltip:AddLine(_G["NAME"],_G["LEVEL"],_G["ZONE"],_G["CLASS"])
			tooltip:SetLineTextColor(row, 1, 0, 0)

			row,col = tooltip:AddLine("")

			for i = 1, numTotFriends do

				local accountInfo = C_FriendList.GetFriendInfoByIndex(i)
				local area = accountInfo.area
				local account = accountInfo.accountName
				local isOnline = accountInfo.connected
				local level = accountInfo.level
				local name = accountInfo.name
				local class = accountInfo.className
				local isafk = accountInfo.afk
				local isdnd = accountInfo.dnd

				if isOnline then

					if isafk then
						StatusIcon = AwayIcon
					elseif isdnd then
						StatusIcon = DnDIcon
					else
						StatusIcon = ""
					end
					row,col = tooltip:AddLine(StatusIcon .. classcolor(name,class),level,area,class)

					arg[row] = { type = "FRIENDS", name = name, class = class, client = "-", account = "-"}
					tooltip:SetLineScript(row, 'OnMouseUp', Button_OnClick, arg[row])
				end
			end
		end
	end

	-- Legenda -------------------------------------------------------------------------------------------------------

	if GMGUILDFRIENDS_CFG[4][2] then

		-- Re-check BNET and FriendList before use them again
		local numTotOnlineFriends = C_FriendList.GetNumOnlineFriends()
		local numBNetTotal = BNGetNumFriends()

		-- If Show Guild is UP or BNET (with online) or Friend List (with online) is up ... print separator
		if GMGUILDFRIENDS_CFG[1][2] or (GMGUILDFRIENDS_CFG[2][2] and numBNetTotal > 0) or (GMGUILDFRIENDS_CFG[3][2] and numTotOnlineFriends > 0) then
				row,col = tooltip:AddLine("")
				row,col = tooltip:AddLine("")
				row,col = tooltip:AddSeparator()
				row,col = tooltip:AddLine("")
				row,col = tooltip:AddLine("")
		end

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1, LeftButton .. " |cFF00FF00" .. _G["GUILD_FRAME_TITLE"] .."|r","LEFT",2)
		tooltip:SetCell(row,3,_G["NAME"] .." ".. LeftButton .. " |cFFFF7FFF" .. _G["WHISPER"] .."|r","RIGHT",2)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1, RightButton .." |cFFFFFF00" .. _G["SHOW_FRIENDS_LIST"] .. "|r","LEFT",2)
		tooltip:SetCell(row,3,_G["NAME"] .. " ALT+" .. LeftButton .. " |cFFAAAAFF" .. _G["PARTY_INVITE"] .."|r","RIGHT",2)

	end

	-- The END -------------------------------------------------------------------------------------------------

	if GMGUILDFRIENDS_CFG[1][2] == false and GMGUILDFRIENDS_CFG[2][2] == false and GMGUILDFRIENDS_CFG[3][2] == false and GMGUILDFRIENDS_CFG[4][2] == false then

		LibQTip:Release(self.tooltip)
		self.tooltip = nil

	else
		-- Show the tooltip
        row,col = tooltip:Show()
        tooltip:UpdateScrolling(UIParent:GetHeight()-100)
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
		GMGUILDFRIENDS_CFG = {}
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
	for i = 1, #GMGUILDFRIENDS_CFG do
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
			GMGUILDFRIENDS_CFG = GMGUILDFRIENDS_CFG or {}
			local GMGUILDFRIENDS_DEFAULTS = {
				{L["Show Guild"], true},								-- 	1
				{L["Show Battle.net"], true},							-- 	2
				{L["Show FriendList"], true},							--	3
				{L["Show Help"], true}	,								--	4
				{L["Show Guild Message"], true},						--	5
				{L["Show Player Info"], false},						--	6
				{L["Show only playing Battle.net Friends"], true},		--	7
			}

			for k in pairs(GMGUILDFRIENDS_DEFAULTS) do
				if GMGUILDFRIENDS_CFG[k] == nil then GMGUILDFRIENDS_CFG[k] = GMGUILDFRIENDS_DEFAULTS[k] end
			end

			-- Building Options Panel
			for i = 1, #GMGUILDFRIENDS_CFG do
				checkbox[i] = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
				checkbox[i]:SetPoint("TOPLEFT", 18, (-70 - (30*i)))
				checkbox[i].Text:SetText(GMGUILDFRIENDS_CFG[i][1])
				checkbox[i]:SetChecked(GMGUILDFRIENDS_CFG[i][2])
				checkbox[i]:SetScript("OnClick", function(self)
					if checkbox[i]:GetChecked() then
						GMGUILDFRIENDS_CFG[i][2] = true
					else
						GMGUILDFRIENDS_CFG[i][2] = false
					end
				end)
				checkbox[i]:SetChecked(GMGUILDFRIENDS_CFG[i][2])
			end

			-- Wipe the old SavedVars
			GMGUFRCFG = {}

			-- Print Hello World :)
			print("|cffffd200".. ADDON .. " : If you get errors please reset configuration in options|r")

		end

		-- Manage other events
		dataobj.text = string.format(" |cFF00FF00%s|r "..bnet_code.."%s|r |cFFFFFF00%s|r", "G:"..select(3,GetNumGuildMembers()),"B:"..select(2,BNGetNumFriends()), "F:" .. C_FriendList.GetNumOnlineFriends())
end)