local ADDON, namespace = ...
local L = namespace.L
local tooltip
local arg = {}
 
local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "-"
}) 

local frame = CreateFrame("Frame")

local function Button_OnClick(row,arg,button)
 
	if C_CVar.GetCVar("gxMaximize") == "0" then
		C_CVar.SetCVar("gxMaximize", "1")
		dataobj.text = "Screen"
	else 
		C_CVar.SetCVar("gxMaximize", "0")
		dataobj.text = "Win"	
	end	
	UpdateWindow()
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
	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end
	
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 1, "CENTER")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	
    row,col = tooltip:AddLine(L["Toggle Video"])
	arg[row] = { tooltip=tooltip }
	tooltip:SetLineScript(row, 'OnMouseUp', Button_OnClick, arg[row])

    row,col = tooltip:Show()
end
 
function dataobj.OnEnter(self)
    anchor_OnEnter(self)
end
 
function dataobj.OnLeave(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end


frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
frame:RegisterEvent("UI_SCALE_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("CVAR_UPDATE")
frame:SetScript("OnEvent", function(self, event, ...)
	if C_CVar.GetCVar("gxMaximize") == "0" then
		dataobj.text = "Win"
	else	
		dataobj.text = "Screen"		
	end
end)