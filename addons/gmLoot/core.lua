local ADDON = ...
local tooltip
local arg = {}

GMLOOT = {
     COINS = true,
     QUEST = true,
	 REAGS = true,
	 SCALE = 1,
}

local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "-"
}) 

-- LibStub("LibDBIcon-1.0"):Register(ADDON, dataobj, mmobjDB)
--- or
-- local icon = LibStub("LibDBIcon-1.0")
-- icon:Register(ADDON, dataobj, xxxminimapicondb)

local frame = CreateFrame("Frame")

local function YesNo(arg)

	if arg.param == "LOOTMODE" then
		local autoloot = GetCVar("autoLootDefault")
		if autoloot == "1" then 
			arg.tooltip:SetCell(arg.row,2,_G["YES"])
			arg.tooltip:SetCellTextColor(arg.row,2,0,1,0,1)
		else
			arg.tooltip:SetCell(arg.row,2,_G["NO"])
			arg.tooltip:SetCellTextColor(arg.row,2,1,0,0,1)
		end
	else 
		if GMLOOT[arg.param] == true then 
			arg.tooltip:SetCell(arg.row,2,_G["YES"])
			arg.tooltip:SetCellTextColor(arg.row,2,0,1,0,1)
		else
			arg.tooltip:SetCell(arg.row,2,_G["NO"])
			arg.tooltip:SetCellTextColor(arg.row,2,1,0,0,1)
		end
	end
end 

local function UpdateLDB()

		local autoloot = GetCVar("autoLootDefault")

		if autoloot == "1" 	then 
			dataobj.text = "auto"
			dataobj.icon = "Interface\\Addons\\"..ADDON.."\\icon-auto.tga"
		else
			dataobj.text = "man"
			dataobj.icon = "Interface\\Addons\\"..ADDON.."\\icon.tga"
		end	
end

local function Button_OnClick(row,arg,button)
	
	if InCombatLockdown() then return end

	if arg.param == "LOOTMODE" then 
		if GetCVarBool("autoLootDefault") then 
			SetCVar( "autoLootDefault", "0")
		else
			SetCVar( "autoLootDefault", "1")
		end
	else
		GMLOOT[arg.param] = not GMLOOT[arg.param]
	end
	
	LibQTip:Release(arg.tooltip)
	arg.tooltip = nil
	UpdateLDB()
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
    local tooltip = LibQTip:Acquire(ADDON.."tip", 2, "LEFT", "RIGHT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	tooltip:SetScale(GMLOOT["SCALE"])
	
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,ADDON .. " " .. _G["GAMEOPTIONS_MENU"],"CENTER",2)
	tooltip:SetCellTextColor(row,1,1,1,0,1)
	
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
    
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,"Auto loot")
	arg[row] = { tooltip=tooltip, row=row, param="LOOTMODE"  }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])
	
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,"Auto loot currencies")
	arg[row] = { tooltip=tooltip, row=row, param="COINS"  }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,"Auto loot quest items")
	arg[row] = { tooltip=tooltip, row=row, param="QUEST"  }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,"Auto deposit reagents")
	arg[row] = { tooltip=tooltip, row=row, param="REAGS"  }
	tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])	
	YesNo(arg[row])

    row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
	anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

function dataobj.OnClick(self, button)

	if InCombatLockdown() then return end
	
	if IsShiftKeyDown() then 	

		LibQTip:Release(self.tooltip)
		self.tooltip = nil

		if button == "LeftButton" then	
			if GMLOOT["SCALE"] < 0.8 then return end
			GMLOOT["SCALE"] = GMLOOT["SCALE"] - 0.05
		end

		if button == "RightButton" then 
			if GMLOOT["SCALE"] > 2 then return end
			GMLOOT["SCALE"] = GMLOOT["SCALE"] + 0.05		
		end
		
		if button == "MiddleButton" then 
			GMLOOT["SCALE"] = 1		
		end
		
		print(string.format("|cFFFFFF00%s|r config: scale %s",ADDON,GMLOOT["SCALE"]))
		
	end
end

frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('CVAR_UPDATE')
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent('LOOT_OPENED')
frame:RegisterEvent("BANKFRAME_OPENED")
frame:SetScript("OnEvent", function(self, event, arg1, ...)

	if event == "ADDON_LOADED" and arg1 == ADDON then 

		-- default 1 for the scale of tooltip if not found
		if GMLOOT["SCALE"] == nil then GMLOOT["SCALE"] = 1 end
		frame:UnregisterEvent("ADDON_LOADED")
	
	elseif event == "CVAR_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
	
		UpdateLDB()  

	elseif event == "LOOT_OPENED" then
		  
		if  GetCVarBool("autoLootDefault") then return end	
			
		-- code adapted and simplified by semiautolooter --
		local loot_count = GetNumLootItems()
		for slot = 1, loot_count do
			local _,_,_,_,locked,isQuestItem = GetLootSlotInfo(slot)
			if isQuestItem == true and not locked and GMLOOT["QUEST"] == true then
				LootSlot(slot);
			elseif GetLootSlotType(slot) > 1 and not locked and GMLOOT["COINS"] == true then
				LootSlot(slot);
			end
		end			  
	elseif event == "BANKFRAME_OPENED" and GMLOOT["REAGS"] == true then
		DepositReagentBank()		
	end
end)	