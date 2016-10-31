-- Code inspired by tekability (by tekkub) http://www.wowinterface.com/downloads/info9235

-- I used and loved so much this little addon till a friend of 
-- mine reports to me that the char durability numbers conflicts with 
-- other addon (like http://www.wowinterface.com/downloads/info21014-ItemLevelDisplay.html)

-- Because what we really use was only the tekability LDB feed I decide to rewrite
-- it removing everything else than LDB feed.

-- So gmDurability is born. It shows only the min durability of your items (even if adding all durability in tooltip could be easily done).

local ADDON = ...

local math_min = math.min
local string_format = string.format
local string_gsub = string.gsub
local table_insert = table.insert
local string_find = string.find
local tooltip

local function unescape(String)
  local Result = tostring(String)
  Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
  Result = gsub(Result, "%[", "") -- Remove links.
  Result = gsub(Result, "%]", "") -- Remove links.
  return Result
end


GMDURABILITY = {
     AUTOREPAIR = true,
     GUILDREPAIR = true,
     AUTOSELL = true,
}


-- working vars
local prgname = "|cffffd200gmDurability|r"
local idx, perc
local format_color = "|cff%02x%02x%02x%s"
local durabilities = {}

local slots = {
	"HeadSlot",
	"ShoulderSlot",
		"BackSlot", -- no durability
	"ChestSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
		"Finger0Slot", -- no durability
		"Finger1Slot", -- no durability
		"Trinket0Slot", -- no durability
		"Trinket1Slot", -- no durability		
	"MainHandSlot",
	"SecondaryHandSlot",
}

local text_color = {
	{0,1,0},
	{1,1,0},
	{1,0.5,0},
	{1,0,0},
}

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("GmDurability", {
	type = "data source",
	icon = "Interface\\Minimap\\Tracking\\Repair",
	text = "100%",
})

local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", function(self, event, ...)
	
	if event == "UPDATE_INVENTORY_DURABILITY" then
		
				local mindurability = 1
				durabilities = {}
				
				for idx=1, #slots do
					local slotid = GetInventorySlotInfo(slots[idx])
					local durability, maxdurability = GetInventoryItemDurability(slotid)  
															
					if durability and (durability and maxdurability and maxdurability ~= 0) then	
						table_insert(durabilities, tostring(string_format("%d", (durability/maxdurability)*100)))
						mindurability = math_min(durability/maxdurability, mindurability)		  
					else
						table_insert(durabilities, "-")
					end
				end	
				
				if     mindurability >= 0  and  mindurability < 0.25   then perc = 4
				elseif mindurability >= 0.25 and  mindurability < 0.50   then perc = 3
				elseif mindurability >= 0.50 and  mindurability < 0.75   then perc = 2
				elseif mindurability >= 0.75 and mindurability <= 1 then perc = 1
				end
				
				dataobj.text = string_format(format_color, text_color[perc][1]*255, text_color[perc][2]*255, text_color[perc][3]*255, string_format("%d%%",mindurability*100)).."|r"
				
				dataobj.OnClick = function(self, button)  

					if 		button == "LeftButton" 	then GMDURABILITY["AUTOREPAIR"] = not GMDURABILITY["AUTOREPAIR"] 					
					elseif 	button == "MiddleButton" then GMDURABILITY["GUILDREPAIR"] = not GMDURABILITY["GUILDREPAIR"] 					
					elseif 	button == "RightButton" 	then GMDURABILITY["AUTOSELL"] = not GMDURABILITY["AUTOSELL"] 
					end
					
				end
	
	elseif event =="MERCHANT_SHOW" then 
	
				local mymoney = GetMoney()

				-- sell greys
				if GMDURABILITY["AUTOSELL"] == true then 
					local bag, slot
					for bag = 0,4,1 do 
						for slot = 1, GetContainerNumSlots(bag), 1 do 
							local name = GetContainerItemLink(bag,slot)
							if name and string_find(name,"ff9d9d9d") then 
								
								local _, itemCount = GetContainerItemInfo(bag, slot);
								local _, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(name)
								UseContainerItem(bag,slot) 
								
								print(string_format("%s: selling %s %s for %s", prgname, itemCount, name, GetCoinTextureString(vendorPrice * itemCount)))
							end
						end
					end
				end
				
				-- autorepair
				local cost = GetRepairAllCost()	
				if cost > 0 and CanMerchantRepair() and GMDURABILITY["AUTOREPAIR"] then	
							
					if CanWithdrawGuildBankMoney() and CanGuildBankRepair() and GMDURABILITY["GUILDREPAIR"] == true then
						RepairAllItems(1)
						print(prgname .. ": repair with guild funds " .. GetCoinTextureString(cost))
					else
						if mymoney >= cost then
							RepairAllItems()
							print(prgname .. ": repair " .. GetCoinTextureString(cost))
						else 
							print(prgname .. ": no repair, need more money")
						end
					end
				end	
	
	
	end
end)


function dataobj.OnTooltipShow(tooltip)
	-- tooltip:AddLine(prgname .. " v" .. GetAddOnMetadata(prgname, "Version"))
	tooltip:AddLine(ADDON)
	tooltip:AddLine(" ")
	
	tooltip:AddLine(string_format("Item Level: Global %.1f  Equipped %.1f", GetAverageItemLevel()) ,1,1,1)
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine("name","% durability",1,1,1, 1,1,1)
	
	for idx=1, #slots do
			if GetInventoryItemLink("player", GetInventorySlotInfo(slots[idx])) then 
				tooltip:AddDoubleLine(GetDetailedItemLevelInfo(GetInventoryItemLink("player", GetInventorySlotInfo(slots[idx]))) .. " - ".. 
				unescape(GetInventoryItemLink("player", GetInventorySlotInfo(slots[idx]))), durabilities[idx],1,1,1, 1,1,1)
			end
	end
	tooltip:AddLine(" ")
	
	if GMDURABILITY["AUTOREPAIR"] == true then 
		tooltip:AddDoubleLine("Repair", "YES", 1,1,1,0,1,0)
	else
		tooltip:AddDoubleLine("Repair", "NO", 1,1,1,1,0,0)
	end
	
	if GMDURABILITY["GUILDREPAIR"] == true then 
		tooltip:AddDoubleLine("Use guild funds", "YES", 1,1,1,0,1,0)
	else
		tooltip:AddDoubleLine("Use guild funds", "NO", 1,1,1,1,0,0)
	end
	
	if GMDURABILITY["AUTOSELL"] == true then 
		tooltip:AddDoubleLine("Sell junk", "YES", 1,1,1,0,1,0)
	else
		tooltip:AddDoubleLine("Sell junk", "NO", 1,1,1,1,0,0)
	end
	
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine("Left Click", "Toggle Repair")
	tooltip:AddDoubleLine("Middle Click", "Toggle Guild funds")
	tooltip:AddDoubleLine("Right Click", "Toggle Sell")
	
end