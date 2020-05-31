-- Most of the addon code and fixes are by Vrul (really much appreciated)
-- You can check the forum here:
-- http://www.wowinterface.com/forums/showthread.php?t=54975
-- 

local ADDON = ...

--- Some default definitions ----------------------------------------------------------------------
GMSAY_PH = {
"Hello world!",
"Alive and kicking",
"Another one bites the dust",
}

GMSAY_CFG = {
	CHN = 1,
}

--- My locals -------------------------------------------------------------------------------------
local GMSAY_OUTNAM = {"SAY", "YELL", "GROUP", "WHISPER", "GUILD", "OFFICER"}
local GMSAY_CHN
local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()
local input_box = {}

local phrase, ch

local BUTTON_HEIGHT = fontHeight + 4
local BUTTON_SPACING = 0
local MENU_BUFFER = 10
local MENU_SPACING = 1
local MENU_WIDTH = 250

-- local GMSAY_PHCH = {}

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function stripstring(string)	
	if not string.find(string, "@") then
		return string, "-"
	else
		local ph, ch
		ph = strsub(string, 1, string.find(string,"@")-1):gsub("^%s*(.-)%s*$", "%1")
		ch = string.gsub(strsub(string, string.find(string,"@")+1),"%s+", ""):upper()
		if has_value(GMSAY_OUTNAM,ch) then 
			return ph, ch
		else 
			return ph, "-"
		end
	end
end


local function color(chat,string)
	
	if chat == "-" then 
		return string.format("\124cff%02x%02x%02x%s\124r", 255, 255, 0, string)
	end
	
	if chat == "GROUP" then 
		chat = "PARTY"
	end
	
	local color = ChatTypeInfo[chat]
	return string.format("\124cff%02x%02x%02x%s\124r", color.r*255, color.g*255, color.b*255, string)
	
end

--- Create Base Menu Frame ------------------------------------------------------------------------
local Menu = CreateFrame('Frame', nil, UIParent)
Menu:RegisterEvent("ADDON_LOADED")
Menu:RegisterEvent("PLAYER_ENTERING_WORLD")
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

local topheader_desc = Menu:CreateFontString()
topheader_desc:SetPoint("TOPLEFT", Menu, "TOPLEFT", MENU_BUFFER, -MENU_BUFFER)
topheader_desc:SetFont(fontName, fontHeight)
topheader_desc:SetTextColor(1, 0.8, 0, 1)
topheader_desc:SetText("My phrases:")

local topheader_value = Menu:CreateFontString()
topheader_value:SetPoint("TOPRIGHT", Menu, "TOPRIGHT", -MENU_BUFFER, -MENU_BUFFER)
topheader_value:SetFont(fontName, fontHeight)
topheader_value:SetTextColor(1, 1, 1, 1)

local lclick_desc = Menu:CreateFontString()
lclick_desc:SetPoint("BOTTOMLEFT", Menu, "BOTTOMLEFT", MENU_BUFFER, MENU_BUFFER)
lclick_desc:SetFont(fontName, fontHeight)
lclick_desc:SetTextColor(0, 1, 0, 1)
lclick_desc:SetText("Menu Left-Click")

local lclick_value = Menu:CreateFontString()
lclick_value:SetPoint("BOTTOMRIGHT", Menu, "BOTTOMRIGHT", -MENU_BUFFER, MENU_BUFFER)
lclick_value:SetFont(fontName, fontHeight)
lclick_value:SetTextColor(1, 0.8, 0, 1)
lclick_value:SetText("Send Phrase")

local irclick_desc = Menu:CreateFontString()
irclick_desc:SetPoint("BOTTOMLEFT", lclick_desc, "TOPLEFT", 0, MENU_SPACING)
irclick_desc:SetFont(fontName, fontHeight)
irclick_desc:SetTextColor(0, 1, 0, 1)
irclick_desc:SetText("Icon Right-Click")

local irclick_value = Menu:CreateFontString()
irclick_value:SetPoint("BOTTOMRIGHT", lclick_value, "TOPRIGHT", 0, MENU_SPACING)
irclick_value:SetFont(fontName, fontHeight)
irclick_value:SetTextColor(1, 0.8, 0, 1)
irclick_value:SetText("Options")

local ilclick_desc = Menu:CreateFontString()
ilclick_desc:SetPoint("BOTTOMLEFT", irclick_desc, "TOPLEFT", 0, MENU_SPACING)
ilclick_desc:SetFont(fontName, fontHeight)
ilclick_desc:SetTextColor(0, 1, 0, 1)
ilclick_desc:SetText("Icon Left-Click")

local ilclick_value = Menu:CreateFontString()
ilclick_value:SetPoint("BOTTOMRIGHT", irclick_value, "TOPRIGHT", 0, MENU_SPACING)
ilclick_value:SetFont(fontName, fontHeight)
ilclick_value:SetTextColor(1, 0.8, 0, 1)
ilclick_value:SetText("Change Default Chat")

--- Create LDB top --------------------------------------------------------------------------------
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("gmSay", {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
	text = GMSAY_OUTNAM[GMSAY_CFG["CHN"]],
	
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

local function UpdateLDB()
		if GMSAY_CFG["CHN"] == 3 then 
		 	dataobj.text = color(GMSAY_OUTNAM[GMSAY_CFG["CHN"]],"GROUP")
		else
			dataobj.text = color(GMSAY_OUTNAM[GMSAY_CFG["CHN"]],GMSAY_OUTNAM[GMSAY_CFG["CHN"]])
		end	
end

function dataobj.OnClick(self, button)    

	if button == "LeftButton" then
	
		if (GMSAY_CFG["CHN"] == #GMSAY_OUTNAM ) then 					
			GMSAY_CFG["CHN"] = 1
		else
			GMSAY_CFG["CHN"] = GMSAY_CFG["CHN"] + 1
		end		

		GMSAY_CHN=GMSAY_OUTNAM[GMSAY_CFG["CHN"]]		
		UpdateLDB()
	end
	
	if button == "RightButton" then
		InterfaceOptionsFrame_Show(options)
	end
end

local function Button_OnClick(self)
	
	Menu:Hide()
	
	local ph,ch=stripstring(GMSAY_PH[self.index])
	
	if ch == "-" then 
		-- if no mandatory @chat use the LDB one
		ch = GMSAY_OUTNAM[GMSAY_CFG["CHN"]]
	end

	if ch == "GROUP" then
		SendChatMessage(ph, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or IsInGroup() and 'PARTY' or 'SAY')
		return
	end
	
	if ch == "WHISPER" then 
		if UnitExists("target") and UnitIsFriend("player", "target") then 
			SendChatMessage(ph, "WHISPER", nil, GetUnitName("PLAYERTARGET"))
		else
			print("No target selected ... no whispering :)")
		end		
		return
	end
	
	SendChatMessage(ph, ch)	
end

--- Startup Builders ------------------------------------------------------------------------------
Menu:SetScript('OnEvent', function(self, event)
	Menu:UnregisterEvent(event)

	if event == "ADDON_LOADED" and arg1 == "gmSay" then 
	
	end

	if event == "PLAYER_ENTERING_WORLD" then 

		local numButtons = 0
		for index = 1, 15 do
			if GMSAY_PH[index] and GMSAY_PH[index] ~= "" then 
				numButtons = numButtons + 1
			end
		end
				
		local ph,ch
		for index = 1, 15 do
		
			if GMSAY_PH[index] and GMSAY_PH[index] ~= "" then

				if not string.find(GMSAY_PH[index], "@") then
					ph = GMSAY_PH[index]
					ch = "-"
				else 
					ph,ch=stripstring(GMSAY_PH[index])
				end
			
				local button = CreateFrame("Button", nil, Menu)
				
				if index ~= 1 then
					button:SetPoint("TOPLEFT", Menu[index - 1], "BOTTOMLEFT", 0, -BUTTON_SPACING)
				else
					button:SetPoint("TOPLEFT", topheader_desc, "BOTTOMLEFT", 0, -MENU_BUFFER)
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
				button:SetText(color(ch,ph))
				-- button:SetText(GMSAY_PH[index])
			else
			
				Menu[index] = Menu[index - 1]
			
			end		
		end
		
		Menu:SetSize(MENU_WIDTH, (MENU_BUFFER * 5) + (fontHeight * 5) + MENU_SPACING + ((BUTTON_HEIGHT + BUTTON_SPACING) * numButtons - BUTTON_SPACING))
		UpdateLDB()
		
	end
end)

-- Configuration Panel ----------------------------------------------------------------------------

local help_legenda = "Use the suffixes:  "
for index = 1, #GMSAY_OUTNAM do
	help_legenda = help_legenda.." @"..GMSAY_OUTNAM[index]
end
help_legenda = help_legenda .. " to force a specific chat (case insensitive)."

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

-- Desc Text
local phrasedesc = options:CreateFontString(nil, nil, "GameFontHighlightSmall")
phrasedesc:SetPoint("TOPLEFT", 18, -65)
phrasedesc:SetText("Define the phrases:")	

-- 10 x Text Input (name)
for index = 1, 15 do
	
	input_box[index] = CreateFrame("EditBox",input_box[index],options,"InputBoxTemplate")
	input_box[index]:SetMaxLetters(100)
	input_box[index]:SetAutoFocus(disable)
	input_box[index]:SetSize(400,20)
	input_box[index]:SetJustifyH("LEFT")
	input_box[index]:SetPoint("TOPLEFT", 18, -(60+(index * 25)))
	
	if GMSAY_PH[index] then 
		input_box[index]:SetText(GMSAY_PH[index])
		input_box[index]:SetCursorPosition(0)
	end
		
	input_box[index]:SetScript("OnEnterPressed",
		function() 
			GMSAY_PH[index] = input_box[index]:GetText()
			input_box[index]:ClearFocus()			
		end)	
end

-- Help text
local legendadesc = options:CreateFontString(nil, nil, "GameFontHighlightSmall")
legendadesc:SetPoint("BOTTOMLEFT", 16, 80)
legendadesc:SetText(help_legenda)

-- WoW Default Fonts Button
local button1 = CreateFrame("button", button1, options, "UIPanelButtonTemplate")
button1:SetHeight(40)
button1:SetWidth(150)
button1:SetPoint("BOTTOMLEFT", 10, 16)
button1:SetText("Reset and Reload UI")
button1.tooltipText = "BEWARE: Reset your phrases and reload your UI"
button1:SetScript("OnClick",  
	function()

		GMSAY_PH = {}
		ReloadUI()
		
	end)  
	
-- WoW Default Fonts Button
local button2 = CreateFrame("button", button2, options, "UIPanelButtonTemplate")
button2:SetHeight(40)
button2:SetWidth(150)
button2:SetPoint("BOTTOMLEFT", 190, 16)
button2:SetText("Save and Reload UI")
button2.tooltipText = "Save and reload your UI"
button2:SetScript("OnClick",  
	function()

		for index = 1, 15 do		
			if input_box[index]:GetText()  then 
				GMSAY_PH[index] = input_box[index]:GetText():gsub("^%s*(.-)%s*$", "%1")
			else
				GMSAY_PH[index] = ""
			end
		end	
		ReloadUI()
		
	end)  	

--- credits  
local credits = options:CreateFontString("$parentTitle", "ARTWORK", "SystemFont_Small")
credits:SetPoint("BOTTOMRIGHT", -16, 16)
credits:SetText("version: |cffffd200"..GetAddOnMetadata(ADDON, "Version").."|r by |cffffd200"..GetAddOnMetadata(ADDON, "Author").."|r")
options.credits = credits		


function options.refresh()
	
	for index = 1,15 do
		input_box[index]:SetText(GMSAY_PH[index])
		input_box[index]:SetCursorPosition(0)
	end
	
end

if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end

