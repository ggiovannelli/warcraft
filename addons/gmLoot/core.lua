local ADDON = ...

local prgname = "|cffffd200gmLoot|r"
local string_format = string.format
local tooltip

GMLOOT = {
     COINS = true,
     QUEST = true,
}


local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("gmLoot", {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
	text = "None"
})

local function UpdateLDB()

		local autoloot = GetCVar("autoLootDefault")

		if autoloot ==  "1" 	then 
			dataobj.text = "auto"
			dataobj.icon = "Interface\\Addons\\"..ADDON.."\\icon-all.tga"
		else
			dataobj.text = "man"
			dataobj.icon = "Interface\\Addons\\"..ADDON.."\\icon.tga"
		end
		
end

local frame = CreateFrame("Frame")
frame:RegisterEvent('CVAR_UPDATE')
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent('LOOT_OPENED')
frame:SetScript("OnEvent", function(self, event, ...)

	if event == "CVAR_UPDATE" or event == "PLAYER_ENTERING_WORLD"then
		  
			UpdateLDB()
		  
	elseif event == "LOOT_OPENED" then
		  
			if  GetCVarBool("autoLootDefault") then return end	
				
				-- code adapted and simplified by semiautolooter --
				local loot_count = GetNumLootItems()
				for slot = 1, loot_count do
					local _,_,_,_,locked,isQuestItem = GetLootSlotInfo(slot)
					if isQuestItem == true and not locked and GMLOOT["QUEST"] == true then
						LootSlot(slot);
					-- elseif GetLootSlotType(slot) == LOOT_SLOT_MONEY and not locked and GMLOOT["COINS"] == true then
					elseif GetLootSlotType(slot) > 1 and not locked and GMLOOT["COINS"] == true then
						LootSlot(slot);
					end
			end			  
	end
end)	


function dataobj.OnClick(self, button)    


	if 		button == "RightButton" then  GMLOOT["QUEST"] = not GMLOOT["QUEST"]	
	
	elseif 	button == "MiddleButton" then GMLOOT["COINS"] = not GMLOOT["COINS"]
	
	elseif 	button == "LeftButton" then
	
		if GetCVarBool("autoLootDefault") then 
			SetCVar( "autoLootDefault", "0", true )
		else
			SetCVar( "autoLootDefault", "1", true )
		end
		
		UpdateLDB()
		
	 end

end

function dataobj.OnTooltipShow(tooltip)

	tooltip:AddLine(ADDON)
	tooltip:AddLine(" ")
	
	if GetCVarBool("autoLootDefault") then 
		tooltip:AddDoubleLine("Loot mode", "auto", 1,1,1,0,1,0)
	else
		tooltip:AddDoubleLine("Loot mode", "manual", 1,1,1,1,0,0)
	end	

	if GMLOOT["COINS"] == true then 
		tooltip:AddDoubleLine("AutoLoot coins / currencies", "YES", 1,1,1,0,1,0)
	else
		tooltip:AddDoubleLine("AutoLoot coins / currencies", "NO", 1,1,1,1,0,0)
	end
	
	if GMLOOT["QUEST"] == true then 
		tooltip:AddDoubleLine("AutoLoot quest items", "YES", 1,1,1,0,1,0)
	else
		tooltip:AddDoubleLine("AutoLoot quest items", "NO", 1,1,1,1,0,0)
	end
	
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine("Left Click", "Toggle Loot Mode")
	tooltip:AddDoubleLine("Middle Click", "Toggle AutoLoot coins")
	tooltip:AddDoubleLine("Right Click", "Toggle AutoLoot quest items")

end

