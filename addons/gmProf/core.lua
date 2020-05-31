local ADDON, namespace = ...
local L = namespace.L
 
local playerName = UnitName("player") 

local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

 
local function Button_OnClick(row, profindex, button)
	if button == "LeftButton" then 
		CastSpell(select(6,GetProfessionInfo(profindex)) + 1,BOOKTYPE_PROFESSION)
	else
		ToggleSpellBook(BOOKTYPE_PROFESSION)
	end
end
 
local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
	icon = "Interface\\Minimap\\Tracking\\Repair",
	text = _G["TRADE_SKILLS"]
})
  
local function OnRelease(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end  
 
local function anchor_OnEnter(self)

	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end
	
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 2, "LEFT", "LEFT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)

	row,col = tooltip:AddLine("")
	tooltip:SetCell(row,1,"|cffffd200" .. _G["SKILLS"] .. "|r","CENTER",2)
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
	local IHaveAProf = false
	for i = 1, select("#", GetProfessions()) do
		local profindex = select(i, GetProfessions())
		if profindex ~= nil then
			IHaveAProf = true
			local name, icon, rank, maxrank = GetProfessionInfo(profindex)
			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1,string.format("|T%s:0|t %s",icon,name),"LEFT")
			tooltip:SetCell(row,2,string.format("%d : %d",rank,maxrank),"RIGHT")
			tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, profindex)  
			if rank == maxrank then 
				tooltip:SetLineTextColor(row,0,1,0,1)
			end
		end
	end
	
	if IHaveAProf then
		row,col = tooltip:AddLine("")
		row,col = tooltip:AddLine("")
		
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,LeftButton .. "|cffffd200" .. _G["SKILL"] .. "|r","LEFT")
		tooltip:SetCell(row,2,RightButton .. "|cffffd200" .. _G["SPELLBOOK"] .. "|r","RIGHT")
	else 
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,_G["NO"] .." ".._G["TRADE_SKILLS"],"CENTER",2)
	end
	row,col = tooltip:Show()
	
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end