local ADDON, namespace = ...
local L = namespace.L
local tooltip
local arg = {}

local playerName = UnitName("player")
local realmName = GetRealmName()

local short = {
	[247] = "ML",
	[244] = "AD",
	[245] = "FH",
	[246] = "TD",
	[353] = "SIEGE",
	[251] = "UNDR",
	[248] = "WM",
	[252] = "SOTS",
	[249] = "KR",
	[250] = "TOS",
	[369] = "YARD",
	[370] = "WORK"
}

local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "-"
}) 

local function UpdatePg()

	if UnitLevel("player") == GetMaxPlayerLevel() then				
	
		C_MythicPlus.RequestCurrentAffixes()
		C_MythicPlus.RequestMapInfo()
		C_MythicPlus.RequestRewards()
	
		-- Refresh the current player in the array
		GMKEYSTONE_NAMES[realmName.."-"..playerName] = {}
		GMKEYSTONE_NAMES[realmName.."-"..playerName]["NAME"] = realmName.."-"..playerName
		GMKEYSTONE_NAMES[realmName.."-"..playerName]["CLASS"] = select(2,UnitClass("player"))
		GMKEYSTONE_NAMES[realmName.."-"..playerName]["WEEKLYKEY"] = "-"
		GMKEYSTONE_NAMES[realmName.."-"..playerName]["MYKEY"] = "-"
		
		if C_MythicPlus.GetOwnedKeystoneChallengeMapID() then
			-- you have a keystone
			GMKEYSTONE_NAMES[realmName.."-"..playerName]["MYKEY"] = C_ChallengeMode.GetMapUIInfo(C_MythicPlus.GetOwnedKeystoneChallengeMapID()) .. " (" .. C_MythicPlus.GetOwnedKeystoneLevel() ..")"
			dataobj.text = short[C_MythicPlus.GetOwnedKeystoneChallengeMapID()] .. ":" .. C_MythicPlus.GetOwnedKeystoneLevel()
			
			-- you have done a dungeon+
			if C_MythicPlus.GetWeeklyChestRewardLevel() ~= 0 then 
				GMKEYSTONE_NAMES[realmName.."-"..playerName]["WEEKLYKEY"], _ = C_MythicPlus.GetWeeklyChestRewardLevel()
			end

		else -- you don't have a keystone

			-- but you have a reward ready
			if C_MythicPlus.IsWeeklyRewardAvailable() then 
				GMKEYSTONE_NAMES[realmName.."-"..playerName]["WEEKLYKEY"] = "*"
				dataobj.text = "ready"			
			end
			-- if you don't have a reward ready, MYKEY is already defined = "-" as default
		end
	end
end
 
local function Button_OnClick(row,arg,button)
    
	if button == "LeftButton" then
		
		if arg.name == realmName .. "-" .. playerName   then 

			for bag = 0,4,1 do 
				for slot = 1, GetContainerNumSlots(bag), 1 do 
					local id = GetContainerItemID(bag, slot)
					if (id and id == 158923) then 
						arg.key = GetContainerItemLink(bag,slot)
						break
					end
				end
			end	
		end
	
		SendChatMessage(string.format("%s : %s",arg.name,arg.key), IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or IsInGroup() and 'PARTY' or 'SAY')
		
	end
	
	LibQTip:Release(arg.tooltip)
	arg.tooltip = nil
	
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

	UpdatePg()

	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 3, "LEFT", "LEFT", "RIGHT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	row,col = tooltip:AddLine('','keystone','weekly')
	tooltip:SetLineTextColor(row,0,1,0)
	
	row,col = tooltip:AddSeparator()
	
	-- Show all Keys
	for name in pairs(GMKEYSTONE_NAMES) do	
	
		if GMKEYSTONE_NAMES[name]["MYKEY"] ~= "-" then 
	
			row,col = tooltip:AddLine()
			tooltip:SetCell(row, 1, GMKEYSTONE_NAMES[name]["NAME"])
			tooltip:SetCell(row, 2, GMKEYSTONE_NAMES[name]["MYKEY"])
			tooltip:SetCell(row, 3, GMKEYSTONE_NAMES[name]["WEEKLYKEY"])		
			local r = _G["RAID_CLASS_COLORS"][GMKEYSTONE_NAMES[name]["CLASS"]].r
			local g = _G["RAID_CLASS_COLORS"][GMKEYSTONE_NAMES[name]["CLASS"]].g
			local b = _G["RAID_CLASS_COLORS"][GMKEYSTONE_NAMES[name]["CLASS"]].b
			tooltip:SetCellTextColor(row, 1, r, g, b)
			
			arg[row] = { tooltip=tooltip, name = GMKEYSTONE_NAMES[name]["NAME"], key = GMKEYSTONE_NAMES[name]["MYKEY"] }
			tooltip:SetLineScript(row, 'OnMouseUp', Button_OnClick, arg[row])
			
		end
		
	end
	
    row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

dataobj.OnClick = function(self, button)  

	if InCombatLockdown() then return end

	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end

	if button == "LeftButton" then
		PVEFrame_ToggleFrame()
	end	
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")
frame:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")
frame:RegisterEvent("ITEM_PUSH")
-- frame:RegisterEvent('BAG_UPDATE')
frame:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)

	if event == "PLAYER_LOGIN" or event == "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE" or event == "MYTHIC_PLUS_NEW_WEEKLY_RECORD" or event == "ITEM_PUSH" then 
		UpdatePg()
	end
	
	if event == "CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN" then 
		for bag = 0,4,1 do 
			for slot = 1, GetContainerNumSlots(bag), 1 do 
				local id = GetContainerItemID(bag, slot)
				if (id and id == 158923) then 
					C_Timer.After(1, function()
						UseContainerItem(bag, slot)
					end)
					break
				end
			end
		end
	end
end)