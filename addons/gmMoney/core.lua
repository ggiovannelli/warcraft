local ADDON, namespace = ...
local L = namespace.L
local tooltip
local arg = {}

local prgname = "|cffffd200"..ADDON.."|r"

local playerName = UnitName("player")
local realmName = GetRealmName()
local _, class = UnitClass("player")
local StartGold, SessionGold, SesSign
 
local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "
 
local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "-"
}) 

-- LibStub("LibDBIcon-1.0"):Register(ADDON, dataobj, mmobjDB)
--- or
-- local icon = LibStub("LibDBIcon-1.0")
-- icon:Register(ADDON, dataobj, xxxminimapicondb)

local frame = CreateFrame("Frame")


local function classcolor(name,class)
	local color = _G["RAID_CLASS_COLORS"][class]
	return string.format("\124cff%02x%02x%02x%s\124r", color.r*255, color.g*255, color.b*255, name)
end

local function printmoney(value)

	if GMMONEY_CFG["TEXTMODE"] or GMMONEY_CFG["GOLDONLY"] then 	
		if value == 0 then return 0 end
		local gold = math.floor(value / 10000)
		local silver = mod(math.floor(value / 100), 100)
		local copper = mod(value, 100)
		if GMMONEY_CFG["GOLDONLY"] then 
			return string.format("|cffffd700%i|r",gold)
		else
			return string.format("|cffffd700%i|r.|cffc7c7cf%02i|r.|cffeda55f%02i|r", gold, silver, copper)
		end
	else
		return GetCoinTextureString(value)
	end
	
end

local function UpdateLDB()

	local SesColStr
	if SessionGold >= 0 then SesColStr="|c0000ff00" else SesColStr="|c00ff0000" end 

	if GMMONEY_CFG["TEXTMODE"] == false and GMMONEY_CFG["FULLDISP"] == false then
		dataobj.text = string.format("%d", GMMONEY_NAMES[realmName][playerName]["GOLD"] / 10000)
	
	elseif GMMONEY_CFG["TEXTMODE"] == false and GMMONEY_CFG["FULLDISP"] == true then
		dataobj.text = 	GetCoinTextureString(GMMONEY_NAMES[realmName][playerName]["GOLD"]) .. 
						SesColStr .. "  (|r " .. SesSign .. GetCoinTextureString(math.abs(SessionGold)) .. SesColStr .. " )|r" 
		
	elseif GMMONEY_CFG["TEXTMODE"] == true and GMMONEY_CFG["FULLDISP"] == false then
		dataobj.text = string.format("|cffffd700%i|r ", GMMONEY_NAMES[realmName][playerName]["GOLD"] / 10000)
	
	elseif GMMONEY_CFG["TEXTMODE"] == true and GMMONEY_CFG["FULLDISP"] == true then
		dataobj.text = 	printmoney(GMMONEY_NAMES[realmName][playerName]["GOLD"]) .. 
						SesColStr .. "  (|r " .. SesSign .. printmoney(math.abs(SessionGold)) .. SesColStr .. " )|r"
	end
end

local function spairs(t)
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end
	table.sort(keys)
	local i = 0
	return function()
		i = i + 1
		if keys[i] then return keys[i], t[keys[i]] end
	end
end

local function YesNo(arg)
	if GMMONEY_CFG[arg.param] == true then 
		arg.tooltip:SetCell(arg.row,2,_G["YES"])
		arg.tooltip:SetCellTextColor(arg.row,2,0,1,0,1)
	else
		arg.tooltip:SetCell(arg.row,2,_G["NO"])
		arg.tooltip:SetCellTextColor(arg.row,2,1,0,0,1)
	end
end 

local function OnRelease_legenda(self)
	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  
end  
 
local function OnLeave_legenda(self)
	if self.tooltip_legenda and not self.tooltip_legenda:IsMouseOver() then
		self.tooltip_legenda:Release()
	end
end  

local function ShowLegenda(self)
	
	arg = {}

	LibQTip:Release(tooltip_legenda)
	tooltip_legenda = nil  

	local row,col
    tooltip_legenda = LibQTip:Acquire(ADDON.."tip_legenda", 2, "LEFT","RIGHT")
	self.tooltip_legenda = tooltip_legenda
    tooltip_legenda:SmartAnchorTo(self)
	tooltip_legenda:EnableMouse(true)
	tooltip_legenda.OnRelease = OnRelease_legenda
	tooltip_legenda.OnLeave = OnLeave_legenda
    tooltip_legenda:SetAutoHideDelay(.1, self)
	tooltip_legenda:SetScale(GMMONEY_CFG["SCALE"])
	
 	row,col = tooltip_legenda:AddLine("")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["KNOWLEDGE_BASE"],"CENTER",2)
	
	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,L["Summary"],"CENTER",2)

	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["CTRL_KEY"] .. " " ..LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["REMOVE"] .. "|r")

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,L["DataBroker"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["TOKENS"] .. "|r")

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")			
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ALT_KEY"] .. " " ..MiddleButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["RESET"] .. "|r")

	row,col = tooltip_legenda:AddLine("")		
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["SHIFT_KEY"] .. " " .. LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200 - " .. _G["UI_SCALE"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["SHIFT_KEY"] .. " " ..RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200 + " .. _G["UI_SCALE"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["SHIFT_KEY"] .. " " ..MiddleButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200 1.0 " .. _G["UI_SCALE"] .. "|r")

	tooltip_legenda:Show()
end

local function Button_OnClick(row,arg,button)

	if InCombatLockdown() then return end

	LibQTip:Release(arg.tooltip)
	arg.tooltip = nil

	if 	button == "LeftButton" and IsControlKeyDown() and arg.param == "DELETE" then 
		GMMONEY_NAMES[realmName][arg.name]=nil
		print(prgname .. ": " .. realmName .. "-" .. arg.name .." " .. _G["ACTION_SPELL_AURA_REMOVED"])
		UpdateLDB()
	else
		GMMONEY_CFG[arg.param] = not GMMONEY_CFG[arg.param]
	end
	UpdateLDB()
	
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

	local TotalGold = 0
	arg = {}

	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 2, "LEFT", "RIGHT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	tooltip:SetScale(GMMONEY_CFG["SCALE"])

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Summary"],"CENTER",2)
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
	for idx in spairs(GMMONEY_NAMES[realmName]) do	
	
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,classcolor(idx,GMMONEY_NAMES[realmName][idx]["CLASS"]))
		tooltip:SetCell(row,2,printmoney(GMMONEY_NAMES[realmName][idx]["GOLD"]))
		if playerName ~= idx then 
			arg[row] = { tooltip=tooltip, name=idx, param="DELETE"}
			tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
		end
		TotalGold = TotalGold + GMMONEY_NAMES[realmName][idx]["GOLD"]
	end	
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddSeparator()
	row,col = tooltip:AddLine("")
	
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Money on"] .." ".. realmName)
	tooltip:SetCell(row,2,printmoney(TotalGold))
	
	row,col = tooltip:AddLine("")

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["This session balance"])
	tooltip:SetCell(row,2,SesSign .. printmoney(math.abs(SessionGold)))

	if SessionGold >= 0  then 
		tooltip:SetCellTextColor(row,1,0,1,0,1)
	else 
		tooltip:SetCellTextColor(row,1,1,0,0,1)
	end

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Text Mode"])
	arg[row] = { tooltip=tooltip, row=row, param="TEXTMODE" }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])	

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Full Docker Display"])
	arg[row] = { tooltip=tooltip, row=row, param="FULLDISP" }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])	

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Gold Only"])
	arg[row] = { tooltip=tooltip, row=row, param="GOLDONLY" }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,_G["ALT_KEY"] .. " " .. LeftButton .. "  " .. prgname .. " |cffffd200" .. _G["KNOWLEDGE_BASE"] .. "|r","RIGHT",2)
	
    row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

dataobj.OnClick = function(self, button)  

	if InCombatLockdown() then return end

	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  

	LibQTip:Release(self.tooltip)
	self.tooltip = nil

	if IsShiftKeyDown() then 	
		if button == "LeftButton" then	
			if GMMONEY_CFG["SCALE"] < 0.8 then return end
			GMMONEY_CFG["SCALE"] =GMMONEY_CFG["SCALE"] - 0.05
			config_changed = true
		end

		if button == "RightButton" then 
			if GMMONEY_CFG["SCALE"] > 2 then return end
			GMMONEY_CFG["SCALE"] = GMMONEY_CFG["SCALE"] + 0.05
			config_changed = true
		end
		
		if button == "MiddleButton" then 
			GMMONEY_CFG["SCALE"] = 1
			config_changed = true
		end
	end

	if 	IsAltKeyDown() then
		if 	button == "LeftButton" then 
			if self.tooltip_legenda then return end 
			ShowLegenda(self)
		end
		
		if button == "MiddleButton" then 
			
			GMMONEY_NAMES = {}
			GMMONEY_NAMES[realmName] = {}
			GMMONEY_NAMES[realmName][playerName] = {}
			GMMONEY_NAMES[realmName][playerName]["GOLD"] = GetMoney() 
			GMMONEY_NAMES[realmName][playerName]["CLASS"] = class 
			config_changed = true
		end
	end	

	if button == "LeftButton" and not IsModifierKeyDown() then ToggleCharacter("TokenFrame") end
		
	UpdateLDB()

	if config_changed == true then 
		print(string.format("|cFFFFFF00%s|r config: scale %s",ADDON,GMMONEY_CFG["SCALE"]))
	end

end


frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("PLAYER_TRADE_MONEY")
frame:RegisterEvent("TRADE_MONEY_CHANGED")
frame:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
frame:RegisterEvent("SEND_MAIL_COD_CHANGED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)

	if event == "PLAYER_LOGIN" then 
		-- defaults
		local GMMONEY_DEFAULTS = {FULLDISP = true,TEXTMODE = true, GOLDONLY = true, SCALE=1}
		GMMONEY_CFG = GMMONEY_CFG or {}
		
		for k in pairs(GMMONEY_DEFAULTS) do
			if GMMONEY_CFG[k] == nil then GMMONEY_CFG[k] = GMMONEY_DEFAULTS[k] end
		end
	end	

	GMMONEY_NAMES = GMMONEY_NAMES or {}
	GMMONEY_NAMES[realmName] = GMMONEY_NAMES[realmName] or {}
	GMMONEY_NAMES[realmName][playerName] = {}
	GMMONEY_NAMES[realmName][playerName]["GOLD"] = GetMoney() 
	GMMONEY_NAMES[realmName][playerName]["CLASS"] = class 
	
	if event == "PLAYER_LOGIN" then 
		StartGold = GMMONEY_NAMES[realmName][playerName]["GOLD"]
	end

	SessionGold = GMMONEY_NAMES[realmName][playerName]["GOLD"] - StartGold

	if StartGold <= GMMONEY_NAMES[realmName][playerName]["GOLD"] then 
		SesSign = "+ "
	else 
		SesSign = "- "
	end
	UpdateLDB()	
end)