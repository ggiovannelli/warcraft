local ADDON, namespace = ...
local L = namespace.L
local tooltip
local arg = {}

local checkbox = {}

local mediapath = "Interface\\Addons\\"..ADDON.."\\media\\"

local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\media\\icon.tga",
    text = "-"
}) 

local prgname = "|cffffd200"..ADDON.."|r"

local addon = {}		
local addonsort = {}

local UPDATEPERIOD = 5
local elapsed = 0

local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

local row_start_addons = 1 -- initialize defaults

local GMMENU_ENTRIES = {
	{L["Character"], "ToggleCharacter('PaperDollFrame')","green.tga", "TOGGLECHARACTER0"},
	{L["Spellbook and Abilities"], "if not InCombatLockdown() then ToggleSpellBook(BOOKTYPE_SPELL); end", "spells.tga", "TOGGLESPELLBOOK"},
	{L["Specialization and Talents"], "ToggleTalentFrame()", "talents.tga","TOGGLETALENTS"},
	{L["Achievements"], "ToggleAchievementFrame()", "achievements.tga","TOGGLEACHIEVEMENT"},
	{L["Quest Log"], "ToggleQuestLog()", "quest.tga","TOGGLEQUESTLOG"},
	{L["Guild"], "ToggleGuildFrame()", "social.tga","TOGGLEGUILDTAB"}, 
	{L["Group Finder"], "PVEFrame_ToggleFrame()", "lfg.tga","TOGGLEGROUPFINDER"}, 
	{L["Collections"], "if not InCombatLockdown() then ToggleCollectionsJournal(1); end", "mounts.tga","TOGGLECOLLECTIONS"}, 
	{L["Adventure Guide"], "ToggleEncounterJournal()", "journal.tga","TOGGLEENCOUNTERJOURNAL"},
	{"-"},
	{"-"},
	{L["Game Menu"], "GameMenuFrame:Show()","", "TOGGLEGAMEMENU"},
	{L["Reload UI"], "ReloadUI()"},
	{"-"},
	{"-"},
}
local function color(number,text)
	
	if number == nil or number == 0 then return "-" end

	if text == "latency" then
	
		if number <= 75 then 
			return string.format("|cff00FF00"..number.."|r")
		elseif number > 75 and number < 120 then 
			return string.format("|cffFFFF00"..number.."|r")
		elseif number >= 120 then 
			return string.format("|cffFF0000"..number.."|r")
		end
	
	elseif text == "fps" then
	
		if number <= 30 then 
			return string.format("|cffFF0000"..number.."|r")
		elseif number > 30 and number < 59 then 
			return string.format("|cffFFFF00"..number.."|r")
		elseif number >= 59 then 
			return string.format("|cff00FF00"..number.."|r")
		end
	
	elseif text == "memory" then 

		if number >= 3 then 
			return string.format("|cffFF0000"..string.format("%.2f mb", number).."|r")
		elseif number > 0.5 and number < 3 then 
			return string.format("|cffFFFF00"..string.format("%.2f mb", number).."|r")
		elseif number <= 0.5 then 
			return string.format("|cff00FF00"..string.format("%.2f mb", number).."|r")
		end
	end
end

local function numaddons()
	local count = 0
	local memTot = 0
	
	addon = {}
	addonsort = {}
	
	UpdateAddOnMemoryUsage()
	for i = 1, GetNumAddOns() do
		local name, _, _, enabled = GetAddOnInfo(i)		
		if IsAddOnLoaded(i) then
			-- ugly hack to sort them later
			addon[GetAddOnMemoryUsage(i)] = name
			table.insert(addonsort, GetAddOnMemoryUsage(i))
			memTot = memTot + (GetAddOnMemoryUsage(i)/1024)
			count = count + 1
		end
		table.sort(addonsort, function(a,b) return a>b end)
	end
	return count , color(memTot,"memory")
end

local function Button_OnClick(row,arg,button)
	LibQTip:Release(arg.tooltip)
	arg.tooltip = nil  
    assert(loadstring(GMMENU_ENTRIES[arg.index][2]))()
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

	local free,tot,bagname,bagtype,delta
	arg = {}

	LibQTip:Release(self.tooltip)
	self.tooltip = nil  

    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 2, "LEFT", "RIGHT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	tooltip:SetScale(GMMENU_CFG["SCALE"])
	tooltip:SetScript("OnUpdate", function(self, elap)
		elapsed = elapsed + elap
		if elapsed < UPDATEPERIOD then 
			return 
		else
			tooltip:SetCell(row_start_addons,1,L["Total addon(s):"] .. " " .. string.format("|cff00ff00%d|r", select(1,numaddons())),"LEFT",1)
			tooltip:SetCell(row_start_addons,2,select(2,numaddons()))

			for i = 1, GMMENU_CFG["MAXADDS"] do
				tooltip:SetCell(row_start_addons + i + 2,1,addon[addonsort[i]])
				tooltip:SetCell(row_start_addons + i + 2,2,color(addonsort[i]/1024, "memory"))
			end
		end
	end)  

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,prgname,"CENTER",2)
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
	--- Build static entries
	for i = 1, #GMMENU_ENTRIES do

		if GMMENU_ENTRIES[i][1] == "-" then 
			row,col = tooltip:AddLine("")	
		else 

			if GMMENU_ENTRIES[i][3] and GMMENU_ENTRIES[i][3] ~="" then	
				
				if GMMENU_CFG["SHOWICON"] and GMMENU_CFG["SHOWKEYS"] then
					row,col = tooltip:AddLine(string.format("|T%s:0|t %s |cffFFFF00(%s)|r",mediapath..GMMENU_ENTRIES[i][3], GMMENU_ENTRIES[i][1], GetBindingKey(GMMENU_ENTRIES[i][4])))
				elseif GMMENU_CFG["SHOWICON"] == false and GMMENU_CFG["SHOWKEYS"] then
					row,col = tooltip:AddLine(string.format("%s |cffFFFF00(%s)|r)", GMMENU_ENTRIES[i][1], GetBindingKey(GMMENU_ENTRIES[i][4])))
				elseif 	GMMENU_CFG["SHOWICON"] and GMMENU_CFG["SHOWKEYS"] == false then
					row,col = tooltip:AddLine(string.format("|T%s:0|t %s",mediapath..GMMENU_ENTRIES[i][3], GMMENU_ENTRIES[i][1]))
				else
					row,col = tooltip:AddLine(GMMENU_ENTRIES[i][1])
				end
			else	
				row,col = tooltip:AddLine(GMMENU_ENTRIES[i][1])
			end	
			arg[row] = { tooltip=tooltip, index=i }
			tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])
		end 
	end  

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Total addon(s):"] .. " " .. string.format("|cff00ff00%d|r", select(1,numaddons())),"LEFT",1)
	tooltip:SetCell(row,2,select(2,numaddons()))

	-- this is the row number from where addons begin to be displayed
	row_start_addons = row
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
		
	for i = 1, GMMENU_CFG["MAXADDS"] do
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,addon[addonsort[i]])
		tooltip:SetCell(row,2,color(addonsort[i]/1024, "memory"))
	end

	row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

dataobj.OnClick = function(self, button)  

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

-- Desc Text
local phrasedesc = options:CreateFontString(nil, nil, "GameFontHighlight")
phrasedesc:SetPoint("TOPLEFT", 18, -180)
phrasedesc:SetText(L["Number of addons:"])	

local input_nr_addon = CreateFrame("EditBox",input_nr_addon,options,"InputBoxTemplate")
input_nr_addon:SetPoint("TOPLEFT", 145, -177)
input_nr_addon:SetAutoFocus(disable)
input_nr_addon:SetSize(45,20)
input_nr_addon:SetMaxLetters(2)
input_nr_addon:SetScript("OnEnterPressed",
function()
	
	local num = input_nr_addon:GetNumber()	
	local num_addons = numaddons()
	if num_addons >= 22 then num_addons = 22 end  -- set it to 22 as a good choice 
		
	if num > num_addons then 

		input_nr_addon:SetText(num_addons)
		GMMENU_CFG["MAXADDS"] = num_addons
		
	elseif num <= 0 or num == nil then

		input_nr_addon:SetText("1")
		GMMENU_CFG["MAXADDS"] = 1

	else

		GMMENU_CFG["MAXADDS"] = num

	end 
	
	input_nr_addon:ClearFocus()
		
end)


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
	GMMENU_CFG = {}
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
	checkbox[1]:SetChecked(GMMENU_CFG["SHOWICON"])
	checkbox[2]:SetChecked(GMMENU_CFG["SHOWKEYS"])
	input_nr_addon:Insert(GMMENU_CFG["MAXADDS"])
	input_nr_addon:SetCursorPosition(0)
end

if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end

-- End Configuration Panel ---------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)

	if event == "PLAYER_LOGIN" then 
	
		local GMMENU_DEFAULTS = {
			MAXADDS = 10,
			SHOWICON = true,
			SHOWKEYS = false,
			SCALE = 1,
		}

		GMMENU_CFG = GMMENU_CFG or {}
		
		for k in pairs(GMMENU_DEFAULTS) do
			if GMMENU_CFG[k] == nil then GMMENU_CFG[k] = GMMENU_DEFAULTS[k] end
		end
	
		-- Building Options Panel
		checkbox[1] = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
		checkbox[1]:SetPoint("TOPLEFT", 18, -100)
		checkbox[1].Text:SetText(L["Show Icons"])
		checkbox[1]:SetChecked(GMMENU_CFG["SHOWICON"])
		checkbox[1]:SetScript("OnClick", function(self)
			if checkbox[1]:GetChecked() then
				GMMENU_CFG["SHOWICON"] = true
			else 
				GMMENU_CFG["SHOWICON"] = false
			end	
		end)

		checkbox[2] = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
		checkbox[2]:SetPoint("TOPLEFT", 18, -130)
		checkbox[2].Text:SetText(L["Show Bind Keys"])	
		checkbox[2]:SetChecked(GMMENU_CFG["SHOWKEYS"])
		checkbox[2]:SetScript("OnClick", function(self)
			if checkbox[2]:GetChecked() then
				GMMENU_CFG["SHOWKEYS"] = true
			else 
				GMMENU_CFG["SHOWKEYS"] = false
			end	
		end)
		
		-- Set a default for the num of the addons
		input_nr_addon:Insert(GMMENU_CFG["MAXADDS"])
		input_nr_addon:SetCursorPosition(0)
		
	end
	
	-- wipe old savedvar if any
	GMMENU = {}
	
end)

local UpdateBroker = CreateFrame("Frame")
UpdateBroker:SetScript("OnUpdate", function(self, elap)
	elapsed = elapsed + elap
	if elapsed < UPDATEPERIOD then 
		return 
	else
		elapsed = 0
		dataobj.text = "H:"..color(select(3,GetNetStats()) or 0,"latency").." W:"..color(select(4,GetNetStats()) or 0,"latency").." F:"..color(floor(GetFramerate()) or 0,"fps")
	end
end)