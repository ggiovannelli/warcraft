local ADDON = ...
local arg = {}


local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "Shot"
})

local frame = CreateFrame("Frame")

local function Button_OnClick(row, arg, button)

 	if arg and arg.param == "3" then
		LibQTip:Release(arg.tooltip)
		arg.tooltip = nil
		C_Timer.After(3, function()  
			PlaySoundFile("interface\\addons\\"..ADDON.."\\media\\camera.ogg", "Master")
			Screenshot()
		end)
	else
		PlaySoundFile("interface\\addons\\"..ADDON.."\\media\\camera.ogg", "Master")
		Screenshot()
	end
end

local function OnRelease(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil  
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

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,_G["GAMEOPTIONS_MENU"],"CENTER")
	tooltip:SetLineTextColor(row,1,1,0,1)
	
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
    row,col = tooltip:AddLine(_G["BINDING_NAME_SCREENSHOT"])
	arg[row] = { tooltip = tooltip, param = "now"}
    tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])
	
	row,col = tooltip:AddLine(_G["BINDING_NAME_SCREENSHOT"] .. " - delay 3 sec.")
	arg[row] = { tooltip = tooltip, param = "3"}
    tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])
	
    row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end


frame:RegisterEvent("ACHIEVEMENT_EARNED")
frame:SetScript("OnEvent", function(self, event, ...)

	
	if event == "ACHIEVEMENT_EARNED" then
		
		C_Timer.After(1, function()  
			Button_OnClick() 
		end)
		
	end
end)