local ADDON = ...
local tooltip

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("gmVideoSwitch", {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\bluewin.tga",
	text = "-"
})

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("CVAR_UPDATE")
frame:SetScript("OnEvent", function(self, event, ...)
	
	if GetCVarBool("gxWindow") then
		dataobj.text = "Window"
	else	
		dataobj.text = "Screen"		
	end
	
	
end)	


dataobj.OnClick = function(self, button)  
	
	if 	button == "RightButton" then 
	
		if GetCVarBool("gxWindow") then			
			SetCVar("gxWindow", "0")	
		else	
			SetCVar("gxWindow", "1")
		end
		
		RestartGx()
	end
	
end

function dataobj.OnTooltipShow(tooltip)

	tooltip:AddLine(ADDON)
	tooltip:AddLine(" ")

	if GetCVarBool("gxWindow") then	
		tooltip:AddDoubleLine("Right Click", "FullScreen", 1,1,1,0,1,0)
	else
		tooltip:AddDoubleLine("Right Click", "Window Mode", 1,1,1,0,1,0)
	end
end

