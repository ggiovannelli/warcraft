local ADDON, namespace = ...
local L = namespace.L
local tooltip, tooltip_legenda
local arg = {}
 
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

local prgname = "|cffffd200"..ADDON.."|r"

GMEXP_NAMES = GMEXP_NAMES or {}
GMEXP_CFG = GMEXP_CFG or {}

local next = next

local playerName = UnitName("player")
local realmName = GetRealmName()
local _, class = UnitClass("player")

local list_enable = true -- false to not show the list of pg
local list_maxpgnum = 23

local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "


local function classcolor(name,class)
	local color = _G["RAID_CLASS_COLORS"][class]
	return string.format("\124cff%02x%02x%02x%s\124r", color.r*255, color.g*255, color.b*255, name)
end

local number = function(v)

	if GMEXP_CFG["LONGNRFMT"] then return v end

	if v <= 9999 then return v
	elseif v >= 1000000000 then return format("%.1fB", v/1000000000)	
	elseif v >= 1000000 then return format("%.1fM", v/1000000)
	elseif v >= 10000 then return format("%.1fK", v/1000)
	end
end

local function TableLength(T)
	local count = 0
		for _ in pairs(T) do count = count + 1 end
	return count
end

local function YesNo(arg)
	if GMEXP_CFG[arg.param] == true then 
		arg.tooltip:SetCell(arg.row,3,_G["YES"])
		arg.tooltip:SetCellTextColor(arg.row,3,0,1,0,1)
	else
		arg.tooltip:SetCell(arg.row,3,_G["NO"])
		arg.tooltip:SetCellTextColor(arg.row,3,1,0,0,1)
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
	tooltip_legenda:SetScale(GMEXP_CFG["SCALE"])
	
 	row,col = tooltip_legenda:AddLine("")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["GAMEMENU_HELP"],"CENTER",2)
	
	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["PLAYER"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["CTRL_KEY"] .. " " ..LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["REMOVE"] .. "|r")

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,L["DataBroker"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ALT_KEY"] .. " " ..LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["GAMEMENU_HELP"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ALT_KEY"] .. " " ..MiddleButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["RESET"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ALT_KEY"] .. " " ..RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Long Numbers"] .." | ".. L["Short Numbers"] .. "|r")

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

	row,col = tooltip_legenda:AddLine("")		
	row,col = tooltip_legenda:AddLine("")		
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["GAME_VERSION_LABEL"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()	
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,prgname)
	tooltip_legenda:SetCell(row,2,"ver.|cffffd200"..GetAddOnMetadata(ADDON, "Version").."|r")
	row,col = tooltip_legenda:AddLine("")	
	
	tooltip_legenda:Show()

end

local function Button_OnClick(row,arg,button)
    	
	if InCombatLockdown() then return end
	
	LibQTip:Release(arg.tooltip)
	arg.tooltip = nil

	if arg.param == "LIST" then 
		GMEXP_CFG["LIST"] = not GMEXP_CFG["LIST"]
		return
	end

	if arg.param == "DELETE" and IsControlKeyDown() and button == "LeftButton" then  
		GMEXP_NAMES[arg.name]=nil
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

	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  

	LibQTip:Release(self.tooltip)
	self.tooltip = nil
	
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 3, "LEFT","LEFT", "RIGHT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	tooltip:SetScale(GMEXP_CFG["SCALE"])

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	if UnitLevel("player") == GetMaxPlayerLevel() then
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Max content level"],2)
		tooltip:SetCell(row,3,UnitLevel("player"))
		tooltip:SetCellTextColor(row,3,0,1,0,1)
	else
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Level"],2)
		tooltip:SetCell(row,3,UnitLevel("player"))
		tooltip:SetCellTextColor(row,3,0,1,0,1)		
	
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Current XP"],2)
		tooltip:SetCell(row,3,UnitXP("player"))
		tooltip:SetCellTextColor(row,3,0,1,0,1)		
	
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Remaining XP"],2)
		tooltip:SetCell(row,3,UnitXPMax("player") - UnitXP("player"))
		tooltip:SetCellTextColor(row,3,1,0,0,1)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Level Progress %"],2)
		tooltip:SetCell(row,3,string.format("%.1f", UnitXP("player")/UnitXPMax("player")*100))
		tooltip:SetCellTextColor(row,3,0,1,0,1)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Remaining rested"],2)
		tooltip:SetCell(row,3,GetXPExhaustion() or 0)
		tooltip:SetCellTextColor(row,3,0,1,1,1)

	end

	if HasArtifactEquipped() then 
		row,col = tooltip:AddLine("")
		row,col = tooltip:AddLine("")
		
		local _, _, ArtName,ArtIcon,ArtPower,ArtPointsSpent ,  _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo();
		local ArtNextRank=C_ArtifactUI.GetCostForPointAtRank(ArtPointsSpent,artifactTier)
		local delta = ArtNextRank-ArtPower

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Artifact"],2)
		tooltip:SetCell(row,3,ArtName)
		tooltip:SetCellTextColor(row,3,0,1,1,1)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Rank"],2)
		tooltip:SetCell(row,3,number(ArtPointsSpent))
		tooltip:SetCellTextColor(row,3,0,1,0,1)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Artifact Power"],2)
		tooltip:SetCell(row,3,number(ArtPower))
		tooltip:SetCellTextColor(row,3,0,1,0,1)

		if (delta) >= 0 then		
			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1,L["Power to next rank"],2)
			tooltip:SetCell(row,3,number(delta))
			tooltip:SetCellTextColor(row,3,1,0,0,1)
		else
			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1,L["Power in excess in rank"],2)
			tooltip:SetCell(row,3,number(abs(delta)))
			tooltip:SetCellTextColor(row,3,0,1,0,1)			
		end
		
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Progress in rank %"],2)
		tooltip:SetCell(row,3,string.format("%.1f", ArtPower/ArtNextRank*100))
		tooltip:SetCellTextColor(row,3,0,1,0,1)
		
	end	

	if C_AzeriteItem.HasActiveAzeriteItem() then

		row,col = tooltip:AddLine("")
		row,col = tooltip:AddLine("")
	
		local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
		local xp, totalLevelXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)		
		local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Artifact"],2)
		tooltip:SetCell(row,3,azeriteItem:GetItemName())
		tooltip:SetCellTextColor(row,3,0,1,1,1)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Artifact Power"],2)
		tooltip:SetCell(row,3,C_AzeriteItem.GetPowerLevel(azeriteItemLocation))
		tooltip:SetCellTextColor(row,3,0,1,0,1)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Power to next rank"],2)
		tooltip:SetCell(row,3,totalLevelXP - xp)
		tooltip:SetCellTextColor(row,3,1,0,0,1)

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Progress in rank %"],2)
		tooltip:SetCell(row,3,string.format("%.1f", xp/totalLevelXP*100))
		tooltip:SetCellTextColor(row,3,0,1,0,1)
	end
		
		row,col = tooltip:AddLine("")
		row,col = tooltip:AddLine("")

	if GMEXP_CFG["LIST"] == true then 
		
		-- Check if GMEXP_NAMES is empty
		if next(GMEXP_NAMES) ~= nil then
			local num = 0
			tooltip:AddLine(" ")
			for name in pairs(GMEXP_NAMES) do
				row,col = tooltip:AddLine()
				tooltip:SetCell(row,1,GMEXP_NAMES[name]["LIVL"])
				tooltip:SetCell(row,2,classcolor(GMEXP_NAMES[name]["NAME"],GMEXP_NAMES[name]["CLASS"]))		tooltip:SetCell(row,3,GMEXP_NAMES[name]["ILVO"])
				tooltip:SetCellTextColor(row,2,0,1,0,1)
				arg[row] = { tooltip=tooltip, name=name, param="DELETE"  }
				tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])					
				num = num +1
				if num > GMEXP_CFG["MAXLIST"] then
					row,col = tooltip:AddLine()
					break
				end
			end		
		end
	end

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,_G["GUILD_TAB_ROSTER_ABBR"],2)
	arg[row] = { tooltip=tooltip, row=row, param="LIST"  }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])	

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")	
		
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,2,_G["ALT_KEY"] .. " " .. LeftButton .. " |cffffd200" .. _G["GAMEMENU_HELP"] .. "|r","RIGHT",2)

	tooltip:UpdateScrolling(GetScreenHeight()-100)
	row,col = tooltip:Show()	

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

	local config_changed = false
	
	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  

	LibQTip:Release(self.tooltip)
	self.tooltip = nil

	if IsShiftKeyDown() then 	
		if button == "LeftButton" then	
			if GMEXP_CFG["SCALE"] < 0.8 then return end
			GMEXP_CFG["SCALE"] = GMEXP_CFG["SCALE"] - 0.05
			config_changed = true
		end

		if button == "RightButton" then 
			if GMEXP_CFG["SCALE"] > 2 then return end
			GMEXP_CFG["SCALE"] = GMEXP_CFG["SCALE"] + 0.05
			config_changed = true
		end
		
		if button == "MiddleButton" then 
			GMEXP_CFG["SCALE"] = 1
			config_changed = true
		end
	end

	if 	IsAltKeyDown() then
		if 	button == "LeftButton" then 
			if self.tooltip_legenda then return end 
			ShowLegenda(self)
		end
		
		if button == "MiddleButton" then 
			GMEXP_NAMES = {}
			config_changed = true
		end
		
		if button == "RightButton" then 
			GMEXP_CFG["LONGNRFMT"] = not GMEXP_CFG["LONGNRFMT"]
			config_changed = true
		end	
		
	end	

	if config_changed == true then 
		print(string.format("|cFFFFFF00%s|r config: scale %s long format %s",ADDON,GMEXP_CFG["SCALE"],tostring(GMEXP_CFG["LONGNRFMT"])))
	end
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("ARTIFACT_XP_UPDATE")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:SetScript("OnEvent", function(self, event, ...)

-- Manage defaults
if event == "PLAYER_LOGIN" then 
	local GMEXP_DEFAULTS = { LONGNRFMT = false, SCALE = 1, LIST = true, MAXLIST = 12 }
	for k in pairs(GMEXP_DEFAULTS) do
		-- GMEXP_CFG[k] = GMEXP_CFG[k] or GMEXP_DEFAULTS[k]
		if GMEXP_CFG[k] == nil then GMEXP_CFG[k] = GMEXP_DEFAULTS[k] end
	end
end

if UnitLevel("player") == GetMaxPlayerLevel() then 
	dataobj.text = "L: " .. UnitLevel("player")		
else	
	dataobj.text = string.format("L:%s %.1f%%", UnitLevel("player"), UnitXP("player")/UnitXPMax("player")*100)	
end

-- Remove a random entry 
if TableLength(GMEXP_NAMES) >= GMEXP_CFG["MAXLIST"] then 
	for k in pairs(GMEXP_NAMES) do
		GMEXP_NAMES[k] = nil
		break
	end
end

if UnitLevel("player") >= 5 then 
	-- Define the current row in the array
	GMEXP_NAMES[realmName.."-"..playerName] = GMEXP_NAMES[realmName.."-"..playerName] or {}
	GMEXP_NAMES[realmName.."-"..playerName]["NAME"] = realmName.."-"..playerName
	GMEXP_NAMES[realmName.."-"..playerName]["ILVO"] = string.format("%.1f",select(1,GetAverageItemLevel()))
	GMEXP_NAMES[realmName.."-"..playerName]["ILVE"] = string.format("%.1f",select(2,GetAverageItemLevel()))
	GMEXP_NAMES[realmName.."-"..playerName]["CLASS"] = class
	GMEXP_NAMES[realmName.."-"..playerName]["LIVL"] = string.format("%s", UnitLevel("player"))
end 
end)	