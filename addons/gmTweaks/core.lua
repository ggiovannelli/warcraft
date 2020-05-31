local ADDON = ...

local mediapath = "interface\\addons\\"..ADDON.."\\media\\"
local checkbox = {}

local function LoadDefaultSettings()
	GMTWEAKS = {
		{"color spell range", "color spell red/magenta based on range or out of mana", true, 1},
		{"druid travel mount hack", "if you press travel mount but you can't use it, automatically switch in cat form", true, 2},
		{"disable tooltip in combat", "disable tooltip in combat", true, 3},
		{"quest tracking disabled in instance", "quest tracking disabled in instance", true, 4},
		{"disable spiral and gcd", "disable spiral and gcd on actionbars buttons", true, 5},
		{"disable order hall", "disable order hall", true, 6},
		{"fade raid units", "fade raid units if they are out of range", true, 7},
		{"move tooltips", "move tooltips in bottom right", true, 8},
		{"move obj tracker", "move obj tracker a little bit further to prevent overlapping on some actionbars addons", false, 9},
		{"hide talking head", "hide talking head", true, 10},
		{"color nameplates on aggro", "Show the nameplates with aggro based color", true, 11},
		{"rare alert", "Play a sound and notify you about rare on the map", true, 12},
		{"move buff frame", "move buffs/debuffs frame a lttle bit down to prevent overlapping with some LDB broker display", true, 999},
		-- {"player class icons", "use new pictures for player class icons", true, 999},
		-- {"misc UI tweaks", "Modify the castbars and others UI things", true, 999},
	}

	GMTWEAKSCFG = {
		RAIDFADE = 0.5,
	}
	
end
local npcolors = {
		{1, 0, 0}, -- no aggro
		{1, 0.5, 0}, -- gaining aggro
		{1, 1, 0}, -- losing aggro
		{0, 1, 0} --aggro'd
	}
-- taken from https://wago.io/Uf4e9aVEy


local function HideFrame(frame)
	frame:HookScript("OnShow", frame.Hide)
	frame:SetAlpha(0)
	frame:Hide()
end

local function applysetting(index,enable)

	if enable then 
	
		if index == 1 then 		-- handles the out of range action bar colouring get from ImprovedBlizzardUI
			local function ActionButton_OnUpdate_Hook(self, elapsed)
				if(self.rangeTimer == TOOLTIP_UPDATE_TIME) then
					if(IsActionInRange(self.action) == false) then
						self.icon:SetVertexColor(1, 0, 0)
					else
						local canUse, amountMana = IsUsableAction( self.action )
						if(canUse) then
							self.icon:SetVertexColor( 1.0, 1.0, 1.0 )
						elseif(amountMana) then
							self.icon:SetVertexColor( 0.5, 0.5, 1.0 )
						else
							self.icon:SetVertexColor( 0.4, 0.4, 0.4 )
						end
					end
				end
			end
			hooksecurefunc('ActionButton_OnUpdate', ActionButton_OnUpdate_Hook)
		
		elseif index == 2 then -- disable druid hack

			if select(2,UnitClass("player"))=="DRUID" and enable then
				local frame = CreateFrame("Frame",nil,nil,"SecureHandlerStateTemplate")
				frame:SetFrameRef("StanceButton",StanceButton3)
				frame:SetAttribute("_onstate-form","self:GetFrameRef('StanceButton'):SetID(newstate)")
				RegisterStateDriver(frame,"form","[indoors,noswimming] 2; 3")
			end
		
		elseif index == 3 then -- disable tooltips in combat

			local IN_COMBAT 
			hooksecurefunc(GameTooltip, "SetAction", function(self)
				if IN_COMBAT then
					self:Hide()
				end
			end)
			local frame = CreateFrame("Frame")
			frame:SetScript("OnEvent", function(self, event, ...)
				if event == "PLAYER_REGEN_DISABLED" then
					IN_COMBAT = true
				elseif event == "PLAYER_REGEN_ENABLED" then    
					IN_COMBAT = false
				end
			end)
			frame:RegisterEvent("PLAYER_REGEN_DISABLED")
			frame:RegisterEvent("PLAYER_REGEN_ENABLED")

		elseif index == 4 then -- quest disable in raid

			local frame = CreateFrame("Frame")
				frame:RegisterEvent("GROUP_ROSTER_UPDATE")
				frame:SetScript("OnEvent", function(self, event)
				SetCVar("showQuestTrackingTooltips", IsInRaid() and 0 or 1)
			end)	

		elseif index == 5 then -- disable Spirals & Cooldowns

			for i,v in ipairs{"Action","MultiBarBottomLeft","MultiBarBottomRight","MultiBarRight","MultiBarLeft"} do	 
				for i = 1, 12 do
					local cooldown = _G[v .. 'Button' .. i .. 'Cooldown']
					cooldown:SetDrawBling(false)
					cooldown:SetDrawSwipe(false)
					cooldown:SetDrawEdge(false)
					cooldown:SetSwipeColor(0, 0, 0, 0)
				end
			end
		
		elseif index == 6 then  -- disable order hall

			OrderHall_LoadUI()
			HideFrame(OrderHallCommandBar)
				
		elseif index == 7 then -- enable raidfade
		
			-- a simple:
			-- _G["RAID_RANGE_ALPHA"] = GMTWEAKSCFG["RAIDFADE"] 
			-- seems not to work.

			local IN_RANGE_ALPHA = 1.0
			local OUT_OF_RANGE_ALPHA = GMTWEAKSCFG["RAIDFADE"]
			
			local function CompactUnitFrame_UpdateInRange_Hook(self, elapsed)
				
				if not self.optionTable.fadeOutOfRange then return end
				
				local inRange, checkedRange = UnitInRange(self.displayedUnit);
				if ( checkedRange and not inRange ) then	
					self:SetAlpha(OUT_OF_RANGE_ALPHA);
				else
					self:SetAlpha(IN_RANGE_ALPHA);
				end
			end
			hooksecurefunc("CompactUnitFrame_UpdateInRange", CompactUnitFrame_UpdateInRange_Hook)		
		
		elseif index == 8 then -- move tooltip

			GameTooltip:HookScript('OnTooltipSetUnit', function(self)
				self:ClearAllPoints()
				self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -75, 20)
			end)
			
			GameTooltip:HookScript('OnTooltipSetItem', function(self) 
				self:ClearAllPoints()
				self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -75, 20)
			end)
			
			GameTooltip:HookScript('OnTooltipSetSpell', function(self) 
				self:ClearAllPoints()
				self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -75, 20)
			end)			
		
		elseif index == 9 then -- move obj tracker

			local anchor = "TOPRIGHT" 
			local xOff= -115
			local yOff= -200

			ObjectiveTrackerFrame:ClearAllPoints()
			ObjectiveTrackerFrame:SetPoint(anchor,UIParent,xOff,yOff)
			hooksecurefunc(ObjectiveTrackerFrame,"SetPoint",function(self,anchorPoint,ObjectiveTrackerFrame,x,y)
				if anchorPoint~=anchor and x~=xOff and y~=yOff then				
					self:SetPoint(anchor,UIParent,xOff,yOff)
				end
			end)
	
		elseif index == 11 then  -- color nameplates	
	
			local npframe = CreateFrame("Frame")
			npframe:RegisterEvent("UNIT_THREAT_LIST_UPDATE")	
			npframe:RegisterEvent("NAME_PLATE_UNIT_ADDED")
			npframe:RegisterEvent("NAME_PLATE_UNIT_REMOVED")	
			npframe:RegisterEvent("UNIT_COMBAT")
			npframe:SetScript("OnEvent", function(self, event, unitid)
				local threat_level = UnitThreatSituation("player", unitid)
				if not unitid or not threat_level or UnitIsPlayer(unitid) then return end
						
				unitplate = C_NamePlate.GetNamePlateForUnit(unitid)
						
				if unitplate ~= nil then
					unitplate:GetChildren()["healthBar"]["barTexture"]:SetVertexColor(unpack(npcolors[threat_level+1]))
				end
			end)

		elseif index == 12 then  -- rare alert

			local blacklist = {
				[971] = true, -- Alliance garrison
				[976] = true, -- Horde garrison
			}

			local LastSeen 

			local rf = CreateFrame("Frame")
			rf:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
			rf:SetScript("OnEvent", function(self, event, vignetteGUID, onMiniMap)
				
				if not  C_VignetteInfo.GetVignetteInfo(vignetteGUID) then 
					return
				else
					local RareName = C_VignetteInfo.GetVignetteInfo(vignetteGUID).name
					local RareGUID = C_VignetteInfo.GetVignetteInfo(vignetteGUID).vignetteGUID

					if not RareName then
						RareName = "Unknown"
					end

					if blacklist[C_Map.GetBestMapForUnit("player")] then 
						return 
					else
						if RareGUID == LastSeen then
							return 
						else
							PlaySoundFile("interface\\addons\\"..ADDON.."\\media\\rare.ogg", "Master")
							RaidNotice_AddMessage(RaidWarningFrame, "Rare spotted: " .. RareName, ChatTypeInfo["RAID_WARNING"])
							LastSeen = RareGUID
						end
					end
				end
			end)	
		
		elseif index == 99999 then -- move buffs
			
			local xOff= -200
			local yOff= -30
			BuffFrame:ClearAllPoints()
			BuffFrame:SetPoint("TOPRIGHT", UIParent,xOff,yOff)
			BuffFrame.SetPoint = function() end

			-- BuffFrame:SetScale(0.9)
			-- BuffFrame.SetScale = function() end
			
			-- hooksecurefunc(BuffFrame, "SetPoint", function()
				-- BuffFrame:ClearAllPoints()
				-- BuffFrame:SetPoint("TOPRIGHT", UIParent,xOff,yOff)
			-- end)
			--hooksecurefunc(BuffFrame, "SetPoint", function(self)
				-- self:ClearAllPoints()
				--self:SetPoint("TOPRIGHT", UIParent,xOff,yOff)
			--end)
			
			MinimapCluster:ClearAllPoints()
			MinimapCluster:SetPoint("TOPRIGHT", UIParent,-5,yOff)
			MinimapCluster.SetPoint = function() end
			
		end
	end
end

LoadDefaultSettings()

-- Configuration Panel ----------------------------------------------------------------------------

local options = CreateFrame("Frame", ADDON .. "options", InterfaceOptionsFramePanelContainer)
options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
InterfaceOptions_AddCategory(options)

-- Title (title)
local title = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(options.name)
options.title = title

-- SubTitle (subtitle)
local subtext = options:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
subtext:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtext:SetPoint("RIGHT", -32, 0)
subtext:SetHeight(32)
subtext:SetJustifyH("LEFT")
subtext:SetJustifyV("TOP")
subtext:SetText(GetAddOnMetadata(ADDON, "Notes"))
options.subtext = subtext

for i = 1, #GMTWEAKS do
	checkbox[i] = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
	checkbox[i]:SetPoint("TOPLEFT", 18, (-70 - (30*i)))
	checkbox[i].Text:SetText(GMTWEAKS[i][1])
	checkbox[i].tooltipText = GMTWEAKS[i][2]
	checkbox[i]:SetChecked(GMTWEAKS[i][3])
	checkbox[i]:SetScript("OnClick", function(self)

		if checkbox[i]:GetChecked() then
			GMTWEAKS[i][3] = true
		else 
			GMTWEAKS[i][3] = false
		end	

	end)
end

local slider1 = CreateFrame("Slider", "$parentSNDFILE", options, "OptionsSliderTemplate")
-- slider1:SetPoint("BOTTOMLEFT", 10, 150)
slider1:SetPoint("TOPLEFT", 200, -70 - (30*7))
slider1:SetWidth(125)
slider1:SetMinMaxValues(1, 10)
slider1:SetValue(GMTWEAKSCFG["RAIDFADE"]*10)
slider1:SetValueStep(1)
slider1.value = slider1:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
slider1.value:SetPoint("TOP", slider1, "BOTTOM", 0, 0)
slider1:SetScript("OnValueChanged", function(self, value)
	self:SetValue(floor(value + 0.5))
	self.value:SetText(floor(value + 0.5)/10)
	GMTWEAKSCFG["RAIDFADE"] = floor(value + 0.5)/10
end)

-- WoW Default Fonts Button
local button1 = CreateFrame("button", ADDON .. "button1", options, "UIPanelButtonTemplate")
button1:SetHeight(40)
button1:SetWidth(150)
button1:SetPoint("BOTTOMLEFT", 10, 16)
button1:SetText("Reset and reload UI")
button1.tooltipText = "BEWARE: Reset your custom settings and reload your UI"
button1:SetScript("OnClick",  
	function()
		LoadDefaultSettings()
		ReloadUI()
	end)  
	
-- WoW Default Fonts Button
local button2 = CreateFrame("button", ADDON .. "button2", options, "UIPanelButtonTemplate")
button2:SetHeight(40)
button2:SetWidth(150)
button2:SetPoint("BOTTOMLEFT", 190, 16)
button2:SetText("Save and reload UI")
button2.tooltipText = "Save your settings and reload your UI"
button2:SetScript("OnClick",  
	function()
		ReloadUI()
	end)  	

--- credits  
local credits = options:CreateFontString("$parentTitle", "ARTWORK", "SystemFont_Small")
credits:SetPoint("BOTTOMRIGHT", -16, 16)
credits:SetText("version: |cffffd200"..GetAddOnMetadata(ADDON, "Version").."|r by |cffffd200"..GetAddOnMetadata(ADDON, "Author").."|r")
options.credits = credits		

function options.refresh()
	for i = 1, #GMTWEAKS do
		checkbox[i] = SetChecked(checkbox[i][3])
		slider1:SetValue(GMTWEAKSCFG["RAIDFADE"]*10)
	end
end

if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end

---------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")	
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, arg1)

-- Move Blizzard_ObjectiveTracker
	if event == "ADDON_LOADED" and arg1 == "Blizzard_ObjectiveTracker" then 
		applysetting(9, GMTWEAKS[9][3])

--  Blizzard_TalkingHeadUI
	elseif event == "ADDON_LOADED" and arg1 == "Blizzard_TalkingHeadUI" then
			if GMTWEAKS[10][3] then 
				hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
					TalkingHeadFrame:Hide()
				end)
			end
		
	elseif event == "ADDON_LOADED" and arg1 == "gmTweaks" then
	
		-- Set MAX camera distance
		SetCVar("cameraDistanceMaxZoomFactor","2.6")

		-- Set confirmation delete by button
		StaticPopupDialogs.DELETE_GOOD_ITEM=StaticPopupDialogs.DELETE_ITEM

		-- Set MAX buffs x rows
		BUFFS_PER_ROW = 32

	end

	if event == "PLAYER_LOGIN" then	
		for i = 1, #GMTWEAKS do
			applysetting(i,GMTWEAKS[i][3])
			checkbox[i]:SetChecked(GMTWEAKS[i][3])
			slider1:SetValue(GMTWEAKSCFG["RAIDFADE"]*10)
		end
	end
	
end)
