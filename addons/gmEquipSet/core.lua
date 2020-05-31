local ADDON, namespace = ...
local L = namespace.L
local tooltip
local arg = {}

local QUESTION_MARK_ICON = [[Interface\Icons\INV_MISC_QUESTIONMARK]]
local NOTASET = L["No Set"]

local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

local string_format = string.format
local string_find = string.find
local string_sub = string.sub

local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "-"
})

local function Button_OnClick(row,arg,button)

	if InCombatLockdown() then return end

	if button == "RightButton" then
		ToggleCharacter('PaperDollFrame')
		PaperDollFrame_SetSidebar(nil, 3)

	elseif button == "LeftButton" then
		C_EquipmentSet.UseEquipmentSet(arg.setID)

	elseif button == "MiddleButton" then
		C_EquipmentSet.SaveEquipmentSet(arg.setID)
		print ("|cffffd200"..ADDON.."|r: " .. L["Set saved"] .. " " .. C_EquipmentSet.GetEquipmentSetInfo(arg.setID))
	end
	
	LibQTip:Release(arg.tooltip)
	arg.tooltip = nil
	
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
	
	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end
	local row,col
	local tooltip = LibQTip:Acquire(ADDON.."tip", 3, "LEFT", "CENTER", "RIGHT")

	self.tooltip = tooltip 
	tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
	tooltip:SetAutoHideDelay(.1, self)

	local numEquipmentSets = C_EquipmentSet.GetNumEquipmentSets()
	if numEquipmentSets > 0 then
	
		arg = {}
		
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Equipment Sets"],"CENTER",3)
		tooltip:SetCellTextColor(row,1,1,1,0)			
		
		row,col = tooltip:AddLine("")		
		row,col = tooltip:AddLine("")
		
		for i, setID in next, C_EquipmentSet.GetEquipmentSetIDs() do

			local name, icon, _, isEquipped, numItems, numEquipped, _, _, _ = C_EquipmentSet.GetEquipmentSetInfo(setID)
			
			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1,string_format("|T%s:0|t",icon) .. " " .. name,"LEFT",1,0,15)
			tooltip:SetCell(row,2,numItems.." : "..numEquipped,"CENTER",1,0,5)
			tooltip:SetCell(row,3,setID,"RIGHT")

			if isEquipped == true then
				tooltip:SetLineTextColor(row,0,1,0,1)
			else
				arg[row] = { tooltip=tooltip, setID = setID, name = name }
				tooltip:SetLineScript(row, 'OnMouseUp', Button_OnClick, arg[row])
			end
			
		end
		
		row,col = tooltip:AddLine("")
		row,col = tooltip:AddLine("")
		
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,LeftButton .. "|cffffd200" .. L["Equip Set"],"LEFT",3)
		
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,RightButton .. "|cffffd200" .. L["Set Manager"],"LEFT",3)
		
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,MiddleButton .. "|cffffd200" .. L["Save Set"],"LEFT",3)

	else 

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["No Set"],"CENTER",3)
		tooltip:SetCellTextColor(row,1,1,1,0)		
	
	end
	
	row,col = tooltip:Show()
	
end

dataobj.OnClick = function(self, button)

	if InCombatLockdown() then return end

	if button == "RightButton" then
		ToggleCharacter('PaperDollFrame')
		PaperDollFrame_SetSidebar(nil, 3)
	end
end

dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent('UNIT_INVENTORY_CHANGED')
frame:RegisterEvent('EQUIPMENT_SETS_CHANGED')
frame:SetScript("OnEvent", function(self, event, ...)
	for index, setID in next, C_EquipmentSet.GetEquipmentSetIDs() do
		local name, icon, _, isEquipped, _, _, _, _, _ = C_EquipmentSet.GetEquipmentSetInfo(setID)		

		if isEquipped == true then 		
			dataobj.text = name
			dataobj.icon = icon
			return
		end
	end	
	dataobj.text = NOTASET
	dataobj.icon = QUESTION_MARK_ICON
	
end)