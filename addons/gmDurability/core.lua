-- Code inspired by tekability (by tekkub) http://www.wowinterface.com/downloads/info9235

-- I used and loved so much this little addon till a friend of 
-- mine reports to me that the char durability numbers conflicts with 
-- other addon (like http://www.wowinterface.com/downloads/info21014-ItemLevelDisplay.html)

-- Because what we really use was only the tekability LDB feed I decide to rewrite
-- it removing everything else than LDB feed.

-- So gmDurability is born. It shows only the min durability of your items (even if adding all durability in tooltip could be easily done).


local ADDON, namespace = ...
local L = namespace.L

local prgname = "|cffffd200"..ADDON.."|r"

local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

local math_min = math.min
local string_format = string.format
local string_gsub = string.gsub
local table_insert = table.insert
local string_find = string.find
local tooltip

local GetDetailedItemLevel,milv,oilv,ailv

local function unescape(String)
  local Result = tostring(String)
  Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
  Result = gsub(Result, "%[", "") -- Remove links.
  Result = gsub(Result, "%]", "") -- Remove links.
  return Result
end

local arg = {}
 
local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Minimap\\Tracking\\Repair",
    text = "-"
}) 

-- working vars
local idx, perc
local format_color = "|cff%02x%02x%02x%s"
local durabilities = {}

local slots = {
	"HeadSlot",
	"NeckSlot",
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
	{1,1,1},
}

local function colorperc(arg)
	
	local arg = tonumber(arg)
	
	if     arg >= 0  	and arg < 0.25  then return 4
	elseif arg >= 0.25 	and arg < 0.50  then return 3
	elseif arg >= 0.50 	and arg < 0.75  then return 2
	elseif arg >= 0.75 	and	arg <= 1 	then return 1
	end

end

local function YesNo(arg)

	if GMDURABILITY_CFG[arg.param] == true then 
		arg.tooltip:SetCell(arg.row,3,L["YES"])
		arg.tooltip:SetCellTextColor(arg.row,3,0,1,0,1)
	else
		arg.tooltip:SetCell(arg.row,3,L["NO"])
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

	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil
	
	local row,col
    local tooltip_legenda = LibQTip:Acquire(ADDON.."tip_legenda", 2, "LEFT","RIGHT")
    self.tooltip_legenda = tooltip_legenda 
	tooltip_legenda:SmartAnchorTo(self)
	tooltip_legenda:EnableMouse(true)
	tooltip_legenda.OnRelease = OnRelease_legenda
	tooltip_legenda.OnLeave = OnLeave_legenda
    tooltip_legenda:SetAutoHideDelay(.1, self)
	tooltip_legenda:SetScale(GMDURABILITY_CFG["SCALE"])
	
 	row,col = tooltip_legenda:AddLine("")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["GAMEMENU_HELP"],"CENTER",2)
	
	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		
	row,col = tooltip_legenda:AddLine("")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL"] .. ": " .. string.format(format_color,255,0,0,L["below"]).."|r or " .. string.format(format_color,0,255,0,L["above"]).."|r " ..L["average equipped"],2)

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,L["Durability"] .. ": " .. string_format(format_color,255,0,0,"0-24")..	"|r ".. string_format(format_color,255,128,0,"25-49")..	"|r " ..string_format(format_color,255,255,0,"50-74")..	"|r " .. string_format(format_color,0,255,0,"75-100")..	"|r",2)

	row,col = tooltip_legenda:AddLine("")		
	row,col = tooltip_legenda:AddLine("")
	row,col = tooltip_legenda:AddLine("")		
	row,col = tooltip_legenda:AddLine("")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ITEMS"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["SHOW"] .. "|r")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["HIDE"] .. "|r")

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,L["DataBroker"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["CHARACTER"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["CHARACTER"] .. "|r")

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
	tooltip_legenda:SetCell(row,1,_G["ALT_KEY"] .. " " ..LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["GAMEMENU_HELP"] .. "|r")

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
 
	if button == "RightButton" then 
		HideUIPanel(ItemRefTooltip)
		LibQTip:Release(arg.tooltip)
		arg.tooltip = nil
	end 
 
	if button == "LeftButton" and arg.param == "item" then
	
		ShowUIPanel(ItemRefTooltip)
		
		if not ItemRefTooltip:IsShown() then
			
			ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")

		end
		
		ItemRefTooltip:SetHyperlink(arg.itemLink)
	
	elseif button == "LeftButton" then 

		GMDURABILITY_CFG[arg.param] = not GMDURABILITY_CFG[arg.param]
		LibQTip:Release(arg.tooltip)
		arg.tooltip = nil

	end
end
 
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

	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  

	LibQTip:Release(self.tooltip)
	self.tooltip = nil
	
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 3,"LEFT","LEFT","RIGHT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	tooltip:SetScale(GMDURABILITY_CFG["SCALE"])

	row,col = tooltip:AddLine("")

	row,col = tooltip:AddLine("")
	tooltip:SetCell(row,1,string_format(_G["ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL"] .. ": " .. L["Total %.1f - Equipped %.1f"], GetAverageItemLevel()),"CENTER",3)
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	if HasArtifactEquipped() then
		if  GetInventoryItemID("player", 17) then  -- artefatto doppio

			milv = GetDetailedItemLevelInfo(GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot")))
			oilv = GetDetailedItemLevelInfo(GetInventoryItemLink("player", GetInventorySlotInfo("SecondaryHandSlot")))
			
			if milv <= oilv then 
				ailv = oilv 
			else
				ailv = milv
			end
		else
			ailv = GetDetailedItemLevelInfo(GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot")))
		end
	end


	for idx=1, #slots do
		
		if GetInventoryItemLink("player", GetInventorySlotInfo(slots[idx])) then 			
			
			local tempdurability = colorperc(tonumber(durabilities[idx]/100))
						
			if idx > 14 and HasArtifactEquipped() then 				
				GetDetailedItemLevel = ailv
			else			
				GetDetailedItemLevel = GetDetailedItemLevelInfo(GetInventoryItemLink("player", GetInventorySlotInfo(slots[idx])))
			end
			
			if GetDetailedItemLevel <= select(2,GetAverageItemLevel()) then 
				GetDetailedItemLevel = 	string_format(format_color,255,0,0, GetDetailedItemLevel ) .. "|r"
			else
				GetDetailedItemLevel = 	string_format(format_color,0,255,0, GetDetailedItemLevel ) .. "|r"
			end

			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1,GetDetailedItemLevel)
			tooltip:SetCell(row,2,unescape(GetInventoryItemLink("player",GetInventorySlotInfo(slots[idx]))))	
			tooltip:SetCell(row,3,string_format(format_color, text_color[tempdurability][1]*255, text_color[tempdurability][2]*255,text_color[tempdurability][3]*255, durabilities[idx]) .."|r")
			arg[row] = { tooltip=tooltip, row=row, param="item", itemLink=GetInventoryItemLink("player",GetInventorySlotInfo(slots[idx]))}
			tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
			
		end
	end

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Auto repair"],2)
	arg[row] = { tooltip=tooltip, row=row, param="AUTOREPAIR" }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])
	
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Use guild funds"],2)
	arg[row] = { tooltip=tooltip, row=row, param="GUILDREPAIR"  }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,L["Auto sell junk"],2)
	arg[row] = { tooltip=tooltip, row=row, param="AUTOSELL"}
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,_G["ALT_KEY"] .. " " .. LeftButton .. " |cffffd200" .. _G["GAMEMENU_HELP"] .. "|r","RIGHT",3)
	
    row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

dataobj.OnClick = function(self, button)  

	local config_changed = false
	
	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  
	
	LibQTip:Release(self.tooltip)
	self.tooltip = nil

	if IsShiftKeyDown() then 	
		if button == "LeftButton" then	
			if GMDURABILITY_CFG["SCALE"] < 0.8 then return end
			GMDURABILITY_CFG["SCALE"] = GMDURABILITY_CFG["SCALE"] - 0.05
			config_changed = true
		end

		if button == "RightButton" then 
			if GMDURABILITY_CFG["SCALE"] > 2 then return end
			GMDURABILITY_CFG["SCALE"] = GMDURABILITY_CFG["SCALE"] + 0.05
			config_changed = true
		end
		
		if button == "MiddleButton" then 
			GMDURABILITY_CFG["SCALE"] = 1
			config_changed = true
		end
	end

	if IsAltKeyDown() then
		if 	button == "LeftButton" then 
			ShowLegenda(self)
		end
	end

	if not IsModifierKeyDown() then 
		if 	button == "RightButton" then  
			ToggleCharacter('PaperDollFrame')
		elseif button == "LeftButton" then
			ToggleCharacter('PaperDollFrame')
		end
	end
	
	if config_changed then 
		print(string.format("|cFFFFFF00%s|r config: scale %s",ADDON,GMDURABILITY_CFG["SCALE"]))
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", function(self, event, ...)

	if event == "PLAYER_LOGIN" then 
	
		GMDURABILITY_CFG = GMDURABILITY_CFG or {}
		local GMDURABILITY_DEFAULTS = {
			AUTOREPAIR = true,
			GUILDREPAIR = true,
			AUTOSELL = true,
			SCALE = 1
		}
		for k in pairs(GMDURABILITY_DEFAULTS) do
			if GMDURABILITY_CFG[k] == nil then GMDURABILITY_CFG[k] = GMDURABILITY_DEFAULTS[k] end
		end
		
		-- wipe old savedvars, to be removed in future releases
		GMDURABILITY = {}
		
	end
	-- UpdateLDB()
	
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
				table_insert(durabilities, "100")
			end
		end	
		
		if     mindurability >= 0  and  mindurability < 0.25   then perc = 4
		elseif mindurability >= 0.25 and  mindurability < 0.50   then perc = 3
		elseif mindurability >= 0.50 and  mindurability < 0.75   then perc = 2
		elseif mindurability >= 0.75 and mindurability <= 1 then perc = 1
		end
		
		dataobj.text = string_format(format_color, text_color[perc][1]*255, text_color[perc][2]*255, text_color[perc][3]*255, string_format("%d%%",mindurability*100)).."|r"

	elseif event =="MERCHANT_SHOW" then 
	
		local mymoney = GetMoney()

		-- sell greys
		if GMDURABILITY_CFG["AUTOSELL"] == true then 
			local bag, slot
			for bag = 0,4,1 do 
				for slot = 1, GetContainerNumSlots(bag), 1 do 
					local itemlink = GetContainerItemLink(bag,slot)
					if itemlink and  select(3, GetItemInfo(itemlink)) == 0 and select(11, GetItemInfo(itemlink)) then 						
						local _, itemCount = GetContainerItemInfo(bag, slot);
						UseContainerItem(bag,slot) 						
						print(string_format(L["%s: selling %s %s for %s"], prgname, itemCount, itemlink, GetCoinTextureString(select(11, GetItemInfo(itemlink)) * itemCount)))
					end
				end
			end
		end
		
		-- autorepair
		local cost = GetRepairAllCost()	
		if cost > 0 and CanMerchantRepair() and GMDURABILITY_CFG["AUTOREPAIR"] then	
					
			if CanWithdrawGuildBankMoney() and CanGuildBankRepair() and GMDURABILITY_CFG["GUILDREPAIR"] == true then
				RepairAllItems(1)
				print(prgname .. ": " .. L["repair with guild funds"] .. " " .. GetCoinTextureString(cost))
			else
				if mymoney >= cost then
					RepairAllItems()
					print(prgname .. ": " .. L["repair"] .. " " .. GetCoinTextureString(cost))
				else 
					print(prgname .. ": " .. L["no repair, need more money"])
				end
			end
		end	
	end
end)