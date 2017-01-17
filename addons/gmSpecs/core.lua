-- Most of the addon code and fixes are by Vrul (really much appreciated)
-- You can check the forum here:
-- http://www.wowinterface.com/forums/showthread.php?t=54975
-- 

local ADDON = ...

local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()

local BUTTON_HEIGHT = fontHeight + 4
local BUTTON_SPACING = 0
local MENU_BUFFER = 10
local MENU_SPACING = 1
local MENU_WIDTH = 190

local Menu = CreateFrame('Frame', nil, UIParent)
Menu:SetFrameStrata('TOOLTIP')
Menu:SetClampedToScreen(true)
Menu:SetBackdrop({
	bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 16,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
Menu:Hide()

local function Menu_OnLeave()
	local focus = GetMouseFocus() or WorldFrame
	if focus ~= Menu and focus:GetParent() ~= Menu then
		Menu:Hide()
	end
end
Menu:SetScript('OnLeave', Menu_OnLeave)

local talent_desc = Menu:CreateFontString()
talent_desc:SetPoint("TOPLEFT", Menu, "TOPLEFT", MENU_BUFFER, -MENU_BUFFER)
talent_desc:SetFont(fontName, fontHeight)
talent_desc:SetTextColor(1, 1, 1, 1)
talent_desc:SetText("Spec config:")

local talent_value = Menu:CreateFontString()
talent_value:SetPoint("TOPRIGHT", Menu, "TOPRIGHT", -MENU_BUFFER, -MENU_BUFFER)
talent_value:SetFont(fontName, fontHeight)
talent_value:SetTextColor(1, 1, 1, 1)

local rclick_desc = Menu:CreateFontString()
rclick_desc:SetPoint("BOTTOMLEFT", Menu, "BOTTOMLEFT", MENU_BUFFER, MENU_BUFFER)
rclick_desc:SetFont(fontName, fontHeight)
rclick_desc:SetTextColor(0, 1, 0, 1)
rclick_desc:SetText("Right-Click")

local rclick_value = Menu:CreateFontString()
rclick_value:SetPoint("BOTTOMRIGHT", Menu, "BOTTOMRIGHT", -MENU_BUFFER, MENU_BUFFER)
rclick_value:SetFont(fontName, fontHeight)
rclick_value:SetTextColor(1, 0.8, 0, 1)
rclick_value:SetText("Toggle Talents")

local lclick_desc = Menu:CreateFontString()
lclick_desc:SetPoint("BOTTOMLEFT", rclick_desc, "TOPLEFT", 0, MENU_SPACING)
lclick_desc:SetFont(fontName, fontHeight)
lclick_desc:SetTextColor(0, 1, 0, 1)
lclick_desc:SetText("Left-Click")

local lclick_value = Menu:CreateFontString()
lclick_value:SetPoint("BOTTOMRIGHT", rclick_value, "TOPRIGHT", 0, MENU_SPACING)
lclick_value:SetFont(fontName, fontHeight)
lclick_value:SetTextColor(1, 0.8, 0, 1)
lclick_value:SetText("Toggle Menu")

local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(ADDON, {
	type = "data source",
	icon = "Interface\\Icons\\INV_Misc_QuestionMark.blp",
	text = "None",
	OnClick = function(self, button)
		if button == "LeftButton" then
			Menu:SetShown(not Menu:IsShown())
		elseif button == "RightButton" then
			ToggleTalentFrame()
		end
	end,
	OnEnter = function(self)
		if not Menu:IsShown() then
			local _, selfCenter = self:GetCenter()
			local _, uiCenter = UIParent:GetCenter()
			Menu:ClearAllPoints()
			if selfCenter >= uiCenter then
				Menu:SetPoint('TOP', self, 'BOTTOM')
			else
				Menu:SetPoint('BOTTOM', self, 'TOP')
			end
			Menu:Show()
		end
	end,
	OnLeave = Menu_OnLeave
})

local function EventHandler()
	local activeSpec = GetSpecialization()
	if activeSpec then
		local id, name, description, icon = GetSpecializationInfo(activeSpec)
		dataobj.text = name
		dataobj.icon = icon     
	else
		dataobj.icon = "Interface\\Icons\\INV_Misc_QuestionMark.blp"
		dataobj.text = "None"
	end

	local talents = ""
	for tier = 1, GetMaxTalentTier()  do
		local talentTier = "x"
		for column = 1, 3 do
			local talentID, name, texture, selected = GetTalentInfo(tier, column, 1)
			if selected then
				talentTier = column
				break
			end
		end
		if talents ~= "" then
			talents = talents .. "." .. talentTier
		else
			talents = talentTier
		end
	end
	talent_value:SetText(talents)
end

local function Button_OnClick(self)
	Menu:Hide()
	if not InCombatLockdown() and GetSpecialization() ~= self.index then
		SetSpecialization(self.index)
	end
end

Menu:RegisterEvent('PLAYER_LOGIN')
Menu:SetScript('OnEvent', function(self, event)
	Menu:UnregisterEvent(event)
	Menu:SetScript('OnEvent', EventHandler)

	local numButtons = GetNumSpecializations()
	for index = 1, numButtons do
		local id, name, description, icon, background, role = GetSpecializationInfo(index)

		local button = CreateFrame("Button", nil, Menu)
		if index ~= 1 then
			button:SetPoint("TOPLEFT", Menu[index - 1], "BOTTOMLEFT", 0, -BUTTON_SPACING)
		else
			button:SetPoint("TOPLEFT", talent_desc, "BOTTOMLEFT", 0, -MENU_BUFFER)
		end
		button:SetPoint("RIGHT", -MENU_BUFFER, 0)
		button:SetHeight(BUTTON_HEIGHT)
		button:SetNormalFontObject("GameFontNormal")
		button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		button.index = index
		button:SetScript("OnClick", Button_OnClick)
		button:SetScript("OnLeave", Menu_OnLeave)
		Menu[index] = button

		local text = button:CreateFontString(ADDON .. "btn_font", nil, "GameFontNormal")
		text:SetAllPoints()
		text:SetJustifyH("LEFT")
		text:SetJustifyV("MIDDLE")
		text:SetTextColor(1, 1, 1, 1)
		button:SetFontString(text)
		button:SetText(("|T%s:0|t %s"):format(icon, name))
	end 
	Menu:SetSize(MENU_WIDTH, (MENU_BUFFER * 4) + (fontHeight * 3) + MENU_SPACING + ((BUTTON_HEIGHT + BUTTON_SPACING) * numButtons - BUTTON_SPACING))

	EventHandler()
	Menu:RegisterEvent('PLAYER_ENTERING_WORLD')
	Menu:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	Menu:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
end)