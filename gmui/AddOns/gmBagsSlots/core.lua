local ADDON = ...

local string_format = string.format
local prgname = "gmBagsSlots"

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("gmBagsSlots", {
	type = "data source",
	icon = "Interface\\Icons\\Inv_misc_bag_10",
	text = "-",
})


local function UpdateLDB()

	local otot=0 
	local ntot=0
	local free,bagtype
	
	for i=0,4 do 
		free,bagtype=GetContainerNumFreeSlots(i)
		if bagtype == 0 then 
			ntot = ntot + free
		else
			otot = otot + free
		end 
	end
	
	if otot == 0 then 
		dataobj.text = ntot 
	else
		dataobj.text = ntot .. " : " .. otot
	end
	
end

local frame = CreateFrame("Frame", ADDON.."_LDB")
frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, ...)

	UpdateLDB()
	
end
)

dataobj.OnClick = function(self, button)  

	if 	button == "RightButton" then  
		
		CloseAllBags()
		
	elseif button == "LeftButton" then
	
		OpenAllBags()
		-- ToggleBackpack();
		
	end

end

function dataobj.OnTooltipShow(tooltip)

	tooltip:AddLine(ADDON)
	tooltip:AddLine(" ")
	
	local free,tot,bagname,bagtype,delta

	for i=0,4 do 
		free,bagtype=GetContainerNumFreeSlots(i)
		tot=GetContainerNumSlots(i)
		bagname=GetBagName(i)
		
		if bagtype == 0 then 
			
			delta = 0
		
		else 
		
			delta = 1
		
		end
		
		if free == 0 then
			tooltip:AddDoubleLine(bagname, free.."/"..tot, 1,1,1,1,0,delta)
		else
			tooltip:AddDoubleLine(bagname, free.."/"..tot, 1,1,1,0,1,delta)
		end	
		
	end
	
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine("Left Click", "Open Bags")
	tooltip:AddDoubleLine("Right Click", "Close Bags")

end