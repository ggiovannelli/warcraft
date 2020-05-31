local ADDON, namespace = ...
local L = namespace.L

local arg = {}
local UPDATEPERIOD, elapsed = 0.2, 0
local speed
local string_format = string.format
local locX, locY, mapID
local ShowCoord = false
 
local function Button_OnClick(rowline, name, button)
    if 		name == "1" then ShowCoord = not ShowCoord   
	elseif 	name == "2" then  ToggleFrame(WorldMapFrame)
	else 	ToggleBattlefieldMap() end	
end
 
local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "-"
})
  
local function OnRelease(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil  
end  
 
local function OnLeave(self)
	print("Leaving/Hiding broker frame")
	if self.tooltip and not self.tooltip:IsMouseOver() then
		self.tooltip:Release()
	end
end  
 
local function anchor_OnEnter(self)

	arg = {}

	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end
	
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 1, "LEFT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	
	-- tooltip:SetCellMarginV(7)
	
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,_G["GAMEOPTIONS_MENU"],"CENTER",1,0,15)
	tooltip:SetLineTextColor(row,1,1,0,1)
	
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
    row,col = tooltip:AddLine(L["DataBroker Info"])
    tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, "1")   
 
    row,col = tooltip:AddLine(_G["WORLDMAP_BUTTON"])
    tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, "2")   

    row,col = tooltip:AddLine(_G["BATTLEFIELD_MINIMAP"])
    tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, "3")   
 
    row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

local frame = CreateFrame("Frame")
frame:SetScript("OnUpdate", function(self, elap)
	elapsed = elapsed + elap
	if elapsed < UPDATEPERIOD then return end
	elapsed = 0
	
	if ShowCoord == true then
	
		local mapID = C_Map.GetBestMapForUnit("player")
		
		if mapID then
			local mapPos = C_Map.GetPlayerMapPosition(mapID, "player")
			if mapPos then
				locX, locY = mapPos:GetXY()
			end
		else
			locX = "0"
			locY = "0"
		end
		dataobj.text = string_format("%.1f %.1f", locX*100,locY*100)
	else 
		speed = (GetUnitSpeed("Player") / 7) * 100
		dataobj.text = string_format("%.1f", speed)
	end

end)