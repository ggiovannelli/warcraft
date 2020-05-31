local ADDON, namespace = ...
local L = namespace.L
local tooltip
local arg = {}

local prgname = "|cffffd200"..ADDON.."|r"

local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

local chanName = {"SELF", "LDB", "GROUP", "GUILD", "OFFICER"}
local deaths = {}

local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "-"
})

local frame = CreateFrame("Frame")

--- Defining local functions -----------------------------------------------------------

local function classcolor(destName)
	if not UnitExists(destName) then return string.format("\124cffff0000%s\124r", destName) end
	local _, class = UnitClass(destName)
	local color = _G["RAID_CLASS_COLORS"][class]
	return string.format("\124cff%02x%02x%02x%s\124r", color.r*255, color.g*255, color.b*255, destName)
end

local function number(v)
	if v <= 9999 then return v	
	elseif v >= 1000000 then return format("%.1fM", v/1000000)
	elseif v >= 10000 then return format("%.1fK", v/1000)
	end
end

local function unescape(String)
	local Result = tostring(String)
	Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
	Result = gsub(Result, "%[", "") -- Remove links.
	Result = gsub(Result, "%]", "") -- Remove links.
	-- Result = gsub(Result, "%-[^|]+", "")
	return Result
end

local function unescape2(String)
	local Result = tostring(String)
	Result = gsub(Result, "%[", "") -- Remove links.
	Result = gsub(Result, "%]", "") -- Remove links.
	-- Result = gsub(Result, "%-[^|]+", "")
	return Result
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

	LibQTip:Release(tooltip_legenda)
	tooltip_legenda = nil  

	local row,col
    tooltip_legenda = LibQTip:Acquire(ADDON.."tip_legenda", 2, "LEFT","RIGHT")
	self.tooltip_legenda = tooltip_legenda
    tooltip_legenda:SmartAnchorTo(self)
	tooltip_legenda:EnableMouse(true)
	tooltip_legenda.OnRelease = OnRelease_legenda
	tooltip_legenda.OnLeave = OnLeave_legenda
    tooltip_legenda:SetAutoHideDelay(.1, self)
	tooltip_legenda:SetScale(GMAUTOPSY_CFG["SCALE"])
	
 	row,col = tooltip_legenda:AddLine("")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["KNOWLEDGE_BASE"],"CENTER",2)
	
	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["PLAYER"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Show Spell"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Whisp Player"] .. "|r")

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,L["DataBroker"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Channel"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Report on|off"] .. "|r")

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
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["KNOWLEDGE_BASE"] .. "|r")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ALT_KEY"] .. " " ..MiddleButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["RESET"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ALT_KEY"] .. " " ..RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Demo"] .. "|r")

	tooltip_legenda:Show()

end

local function demoToolTip()
	
	local deaths = {}
	for i=1,15 do
		local sources = {"Udvud il macellaio", "Brown Marmot", "Wolf", "Black Mamba", "Calamir", "Umongris", "Drugon il Sangue Gelido"}
		local damages = {"Melee", 30455, 219602, 219349, 216043, 213590, 223689}
		local damage = damages[math.random(7)]
		
		if damage == "Melee" then 
			deaths[#deaths+1] = {
				timestamp 	= date("%H:%M:%S",timestamp),
				sourceName 	= sources[math.random(7)],
				destName 	= UnitName("player"),
				spell 		= "Melee",
				damage		= number(math.random(500000,2000000)),
				overkill	= number(math.random(500000))
			}
		else
			deaths[#deaths+1] = {
				timestamp 	= date("%H:%M:%S",timestamp),
				sourceName 	= sources[math.random(7)],
				destName 	= UnitName("player"),
				spell 		= GetSpellLink(damage),
				damage		= number(math.random(500000,2000000)),
				overkill	= number(math.random(500000))
			}
		end
	end
	return deaths
end

local function UpdateLDB()

	if GMAUTOPSY_CFG["ENABLED"] == false then
		dataobj.icon = "Interface\\Addons\\"..ADDON.."\\icon-off.tga"
		dataobj.text = string.format("|cffff0000%s|r", "OFF")
		frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else 
		dataobj.icon = "Interface\\Addons\\"..ADDON.."\\icon.tga"
		dataobj.text = string.format("|cff00ff00%s|r", chanName[GMAUTOPSY_CFG["CHANNEL"]])
		frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

local function OnRelease(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end  

local function Button_OnClick(row, arg, button)
   
   	LibQTip:Release(tooltip)
	tooltip = nil  
   
   	if button == "RightButton" then
	
		SendChatMessage(string.format(L["You was killed by %s with %s overkill %s"],arg.spell,arg.damage,arg.overkill),"WHISPER", nil, arg.destName)
		
	elseif button == "LeftButton" then

		if arg.spell == "Melee" then return end
		
		ShowUIPanel(ItemRefTooltip)
		
		if not ItemRefTooltip:IsShown() then
			
			ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")

		end
			
		ItemRefTooltip:SetHyperlink(arg.spell)		
		return

	elseif button == "MiddleButton" then
	-- nop
	end
end

local function anchor_OnEnter(self)

	arg = {}

	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 6,"LEFT","LEFT","LEFT","LEFT","RIGHT","RIGHT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	tooltip:SetScale(GMAUTOPSY_CFG["SCALE"])
 	
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
 
	if #deaths > 0 then 

		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Deaths Reports"],"CENTER",6)
		tooltip:SetColumnTextColor(1,1,1,0)
		row,col = tooltip:AddLine("")
	
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["Time"])
		tooltip:SetCell(row,2,L["Source"])
		tooltip:SetCell(row,3,L["Target"])
		tooltip:SetCell(row,4,L["Spell"])
		tooltip:SetCell(row,5,L["Damage"])
		tooltip:SetCell(row,6,L["Overkill"])
		tooltip:SetLineTextColor(row, 1, 1, 0)

		-- deaths=demoToolTip()
		
		for i=1, #deaths do
			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1,deaths[i]["timestamp"])
			tooltip:SetCell(row,2,deaths[i]["sourceName"])
			tooltip:SetCell(row,3,classcolor(deaths[i]["destName"]))
			tooltip:SetCell(row,4,deaths[i]["spell"])
			tooltip:SetCell(row,5,deaths[i]["damage"])
			tooltip:SetCell(row,6,deaths[i]["overkill"])
			
			arg[row] = { 
				timestamp=deaths[i]["timestamp"],
				sourceName=deaths[i]["sourceName"],
				destName=deaths[i]["destName"],
				spell=deaths[i]["spell"],
				damage=deaths[i]["damage"],
				overkill=deaths[i]["overkill"],
				tooltip=tooltip
			}
			tooltip:SetLineScript(row, 'OnMouseUp', Button_OnClick, arg[row])
		end
	else 
		row,col = tooltip:AddLine()
		tooltip:SetCell(row,1,L["No deaths recorded yet"],"CENTER",6)
	end

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,3,_G["ALT_KEY"] .. " " .. LeftButton .. prgname .. " |cffffd200" .. _G["KNOWLEDGE_BASE"] .. "|r","RIGHT",4,0,10)

	tooltip:UpdateScrolling(GetScreenHeight()-50)
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

	local config_changed = false
	
	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  

	LibQTip:Release(self.tooltip)
	self.tooltip = nil

	if IsShiftKeyDown() then 	
		if button == "LeftButton" then	
			if GMAUTOPSY_CFG["SCALE"] < 0.8 then return end
			GMAUTOPSY_CFG["SCALE"] = GMAUTOPSY_CFG["SCALE"] - 0.05
			config_changed = true
		end

		if button == "RightButton" then 
			if GMAUTOPSY_CFG["SCALE"] > 2 then return end
			GMAUTOPSY_CFG["SCALE"] = GMAUTOPSY_CFG["SCALE"] + 0.05
			config_changed = true
		end
		
		if button == "MiddleButton" then 
			GMAUTOPSY_CFG["SCALE"] = 1
			config_changed = true
		end
	end

	if 	IsAltKeyDown() then
		if 	button == "LeftButton" then 
			ShowLegenda(self)
		end
		
		if button == "RightButton" then
			deaths=demoToolTip()
		end
		
		if button == "MiddleButton" then 
			deaths = {}
		end
	end	


	if not IsModifierKeyDown() then 

		if button == "LeftButton" and GMAUTOPSY_CFG["ENABLED"] == true then
			if (GMAUTOPSY_CFG["CHANNEL"] == 5) then 					
				GMAUTOPSY_CFG["CHANNEL"] = 1
			else
				GMAUTOPSY_CFG["CHANNEL"] = GMAUTOPSY_CFG["CHANNEL"] + 1
			end
			-- config_changed = true
		end
	
		if button == "RightButton" then	
			GMAUTOPSY_CFG["ENABLED"] = not GMAUTOPSY_CFG["ENABLED"]
			-- config_changed = true
		end
	end	
	
	UpdateLDB()

	if config_changed == true then 
		print(string.format("|cFFFFFF00%s|r config: scale %s",ADDON,GMAUTOPSY_CFG["SCALE"]))
	end	
	
end


-- create frame to manage the kills -----------------------------------------------------------------------
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, ...)
	
	-- Manage defaults
	if event == "PLAYER_LOGIN" then 
		local GMAUTOPSY_DEFAULTS = { MAXREP=35, ENABLED=true,	CHANNEL=1, SCALE=1} 
		GMAUTOPSY_CFG = GMAUTOPSY_CFG or {}
		for k in pairs(GMAUTOPSY_DEFAULTS) do
			if GMAUTOPSY_CFG[k] == nil then GMAUTOPSY_CFG[k] = GMAUTOPSY_DEFAULTS[k] end
		end
	end
	
	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then	
		UpdateLDB()
	end
	
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then

		local timestamp, clevent, _, _, sourceName, _, _, destGUID, destName, _, _, prefixParam1, prefixParam2, _, suffixParam1, suffixParam2 = CombatLogGetCurrentEventInfo()
		local playerGUID
		local damagetype
		local autopsy_msg = nil
 		
		-- proceed with CLEU handling
		if not playerGUID then 
			playerGUID = UnitGUID("player") 
		end

		if (destGUID == playerGUID or (destName and UnitClass(destName))) and destGUID:sub(1,3) ~= "Pet" then
			
			sourceName = sourceName or "Unknown"
			
			if clevent == "SWING_DAMAGE" then
			
				if prefixParam2 > 0 then 
					autopsy_msg = string.format(L["%s: %s killed %s with %s melee overkill %s"],ADDON,sourceName, destName, prefixParam1, prefixParam2)
				
					deaths[#deaths+1] = {
						timestamp 	= date("%H:%M",timestamp),
						sourceName 	= sourceName,
						destName 	= destName,
						spell 		= _G["ACTION_SWING"],
						damage		= number(prefixParam1),
						overkill	= number(prefixParam2)
					}					
				end	

			elseif clevent == "SPELL_DAMAGE" or clevent == "SPELL_PERIODIC_DAMAGE" or clevent == "RANGE_DAMAGE" then
			
				if suffixParam2 > 0 then 
					autopsy_msg = string.format(L["%s: %s killed %s with %s damage of %s overkill %s"],ADDON, sourceName, classcolor(destName),suffixParam1,GetSpellLink(prefixParam1),suffixParam2)

					deaths[#deaths+1] = {
						timestamp 	= date("%H:%M",timestamp),
						sourceName 	= sourceName,
						destName 	= destName,
						spell 		= GetSpellLink(prefixParam1),
						damage		= number(suffixParam1),
						overkill	= number(suffixParam2)
					}					
				end				
			end	
			
			if #deaths >= GMAUTOPSY_CFG["MAXREP"] then table.remove(deaths, 1) end
		
			if autopsy_msg then 
			
				local autopsy_chn = chanName[GMAUTOPSY_CFG["CHANNEL"]]
				
				-- find the right GROUP, thanks to Dridzt code in the posts: http://www.wowinterface.com/forums/showthread.php?t=48320
				if GMAUTOPSY_CFG["CHANNEL"] == 3 then				
					if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
					  autopsy_chn = "INSTANCE_CHAT"
					elseif IsInRaid() then
					  autopsy_chn = "RAID"
					elseif IsInGroup() then
					  autopsy_chn = "PARTY"
					else
					  autopsy_chn = "SELF"
					end
				end
					
				if GMAUTOPSY_CFG["CHANNEL"] == 1 or autopsy_chn == "SELF" then 
					print(autopsy_msg)	
				end 
					
				if GMAUTOPSY_CFG["CHANNEL"] > 2 then 
					SendChatMessage(autopsy_msg, autopsy_chn)
				end 
			end			
		end
	end	
end)