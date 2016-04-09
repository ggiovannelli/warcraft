local mediaFolder = "Interface\\AddOns\\InfinityPlates\\Media\\"	-- don't touch this ...

local TEXTURE = mediaFolder.."dM3"				-- castbar texture
local FONT = mediaFolder.."impact.ttf"			-- name font
local FONT2 = mediaFolder.."Infinity Gears.ttf" -- percent HP font
local FONTSIZE = 13								-- name size
local FONTSIZE2 = 20							-- percent value size
local FONTFLAG = "THINOUTLINE"					-- "THINOUTLINE", "OUTLINE MONOCHROME", "OUTLINE", "THICKOUTLINE" or nil = no outline
local FONTFLAG2 = "THINOUTLINE"					-- percent value flag
local FontShadowOffset = 0						-- 0 = no shadow

local abbrevNumb = 18							-- names longer than that get abbreviated; "Raider's Trainings Dummy" becomes "R.T. Dummy"

local showIC = true								-- automatically show in combat
local hideOOC = false							-- automatically hide out of combat

local blankTex = "Interface\\Buttons\\WHITE8x8"	
local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]

local showcbtext = false						-- show/hide castbar text

-------------------
-- END OF CONFIG --
-------------------
local hpHeight = 3
local hpWidth = 60
local cbIconSize = 25
local cbHeight = 5
local cbWidth = 110
local bgAlpha = 0.5

local numChildren = -1
local frames = { }

local InfinityPlates = CreateFrame("Frame")
InfinityPlates:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

local function QueueObject(parent, object)
	parent.queue = parent.queue or { }
	parent.queue[object] = true
end

-- replace some crap with a dummy
local dummy = function()
	return
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(nil)
			object.SetTexture = dummy
		elseif (object:GetObjectType() == 'FontString') then
			object.ClearAllPoints = dummy
			object.SetFont = dummy
			object.SetPoint = dummy
			object:Hide()
			object.Show = dummy
			object.SetText = dummy
			object.SetShadowOffset = dummy
		else
			object:Hide()
			object.Show = dummy
		end
	end
end

-- string format
local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 240 then
				pos = pos + 4
			elseif c > 225 then
				pos = pos + 3
			elseif c > 192 then
				pos = pos + 2
			else
				pos = pos + 1
			end
			if (len == i) then
				break
			end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:SetSize(38, cbIconSize + 6)
	frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -17)
	frame:GetStatusBarTexture():SetHorizTile(true)

	if(frame.shield:IsShown()) then
		frame:SetStatusBarColor(0.9, 0, 1, 1)
	end
end

local OnValueChanged = function(self, curValue)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.hp.name:SetTextColor(1, 1, 1)
	frame.hp:SetScale(1)
	frame.cb:Hide()
	
	frame.hasClass = nil
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil

	frame:SetScript("OnUpdate", nil)
end

-- change some colors
local function Colorize(frame)
	local r, g, b = frame.healthOriginal:GetStatusBarColor()

	for class, _ in pairs(RAID_CLASS_COLORS) do
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			frame.hasClass = true
			frame.isFriendly = false
			frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
			return
		end
	end

	if (r + b + b) > 2 then
		r, g, b = 125 / 255, 125 / 255, 160 / 255
	elseif g + b == 0 then -- hostile
		r, g, b = 255 / 255, 45 / 255, 45 / 255
		frame.isFriendly = false
	elseif r + b == 0 then -- friendly npc
		r, g, b = 50 / 255, 210 / 255, 50 / 255
		frame.isFriendly = true
	elseif r + g > 1.95 then -- neutral
		r, g, b = 245 / 255, 230 / 255, 20 / 255
		frame.isFriendly = false
	elseif r + g == 0 then -- friendly player
		r, g, b = 70 / 255, 180 / 255, 100 / 255
		frame.isFriendly = true
	else -- enemy player
		frame.isFriendly = false
	end

	frame.hasClass = false
	frame.hp:SetStatusBarColor(r, g, b)		-- yey it's invisible but wtf ...
	frame.hp.name:SetTextColor(r, g, b)
end

local function UpdateObjects(frame)
	local frame = frame:GetParent()
	local name = frame.hp.oldname:GetText()	
	
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(hpWidth, hpHeight)	
	frame.hp:SetPoint('TOP', frame, 'TOP', 0, -15)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)

	-- update colors
	Colorize(frame)

	-- set name text and shorten it
	local newName = (string.len(name) > abbrevNumb) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or frame.hp.oldname:GetText()
	frame.hp.name:SetText(newName)

	HideObjects(frame)
end

local function SkinObjects(frame, nameFrame)
	local hp, ab, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local oldname = nameFrame:GetRegions()
	local _, cbborder, cbshield, cbicon, cbname, _ = cb:GetRegions()
	local offset = UIParent:GetScale() / hp:GetEffectiveScale()
	local backdrop = {edgeFile = blankTex, edgeSize = offset}

	frame.healthOriginal = hp

	-- hp
	hp:HookScript('OnShow', UpdateObjects)
	hp:SetStatusBarTexture(mediaFolder.."empty")
	frame.hp = hp

	hp.value = frame:CreateFontString(nil, "OVERLAY")	
	hp.value:SetFont(FONT2, FONTSIZE2, FONTFLAG2)
	hp.value:SetShadowColor(0, 0, 0, 0.4)
	hp.value:SetPoint("BOTTOM", hp, "TOP", 0, 0)
	hp.value:SetTextColor(1,1,1)
	hp.value:SetShadowOffset(1, -1)

	-- name
	hp.name = frame:CreateFontString(nil, 'OVERLAY')
	hp.name:SetPoint('TOP', hp, 'BOTTOM', 0, 0)
	hp.name:SetFont(FONT, FONTSIZE, FONTFLAG)
	hp.oldname = oldname
	
	hp:HookScript('OnShow', UpdateObjects)
	frame.hp = hp

	-- threat
	if not frame.threat then
		frame.threat = threat
	end

	frame.HLthreat = hp:CreateFontString(nil, "OVERLAY")	
	frame.HLthreat:SetFont(FONT2, FONTSIZE2, FONTFLAG2)
	frame.HLthreat:SetPoint("RIGHT", hp.value, "LEFT", -2, 0)
	frame.HLthreat:SetShadowOffset(FontShadowOffset, -FontShadowOffset)

	-- cast
	frame.Cborder = CreateFrame("Frame", nil, cb)
	frame.Cborder:SetPoint("TOPLEFT", cb, -offset, offset)
	frame.Cborder:SetPoint("BOTTOMRIGHT", cb, offset, -offset)
	frame.Cborder:SetBackdrop(backdrop)
	frame.Cborder:SetBackdropBorderColor(0, 0, 0)

	local cbbg2 = cb:CreateTexture(nil, 'BORDER')
	cbbg2:SetAllPoints(cb)
	cbbg2:SetTexture(1 / 3, 1 / 3, 1 / 3, bgAlpha)

	cb:SetFrameLevel(1)
	cb:SetStatusBarTexture(TEXTURE)

	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOP", hp, "BOTTOM", 0, -20)
	cbicon:SetSize(32, cbIconSize)
	cbicon:SetTexCoord(.07, .93, .07, .93)
	cbicon:SetDrawLayer("OVERLAY")
	cb.cbicon = cbicon
	
	-- castbar text
	cbname:ClearAllPoints()
	if showcbtext then
		cbname:SetPoint("TOP", cbicon, "BOTTOM", 0, -8)	
		cbname:SetFont(FONT, FONTSIZE - 2, FONTFLAG)
	end
	cb.cbname = cbname

	frame.CIborder = CreateFrame("Frame", nil, cb)
	frame.CIborder:SetPoint("TOPLEFT", cbicon, -offset, offset)
	frame.CIborder:SetPoint("BOTTOMRIGHT", cbicon, offset, -offset)
	frame.CIborder:SetBackdrop(backdrop)
	frame.CIborder:SetBackdropBorderColor(0, 0, 0)

	local cbiconbg = cb:CreateTexture(nil, 'BACKGROUND')
	cbiconbg:SetPoint('BOTTOMRIGHT', cbicon, offset, -offset)
	cbiconbg:SetPoint('TOPLEFT', cbicon, -offset, offset)
	cbiconbg:SetTexture(0, 0, 0)

	cb.shield = cbshield
	cbshield:ClearAllPoints()
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)
	frame.cb = cb
	
	-- raidicon
	raidicon:ClearAllPoints()
	raidicon:SetPoint("RIGHT", hp.name, "LEFT", -4, 0)
	raidicon:SetSize(cbIconSize, cbIconSize)
	raidicon:SetTexture(mediaFolder.."raidicons")
	frame.raidicon = raidicon

	overlay:SetTexture(0, 0, 0, 0)
	overlay:SetAllPoints(hp)
	frame.overlay = overlay
	
	hp.oldlevel = oldlevel
	hp.boss = bossicon
	hp.elite = elite
	
	-- hide crap
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)

	UpdateObjects(hp)
	UpdateCastbar(cb)

	frame:HookScript('OnHide', OnHide)
	frames[frame] = true
	frame.done = true			-- make it work with PlateBuffs	
end

-- highlight mouseover plate
local function HighlightSelected(frame, ...)
	if(frame.overlay:IsShown()) then
		frame.hp.name:SetShadowColor(0, 0, 0, 1)
		frame.hp.name:SetShadowOffset(2.5, -1.75)
	else
		frame.hp.name:SetShadowColor(0, 0, 0, 0)
		frame.hp.name:SetShadowOffset(0, 0)
	end
end

-- threat indication
local function UpdateThreat(frame, elapsed)
	if(frame.threat:IsShown()) then
		local _, val = frame.threat:GetVertexColor()
		if(val > 0.7) then
			frame.HLthreat:SetTextColor(1, 1, 0)
			frame.HLthreat:SetText(">")
		else
			frame.HLthreat:SetTextColor(1, 0, 0)
			frame.HLthreat:SetText(">")
		end
	else
		frame.HLthreat:SetText(" ")
	end
end

-- kill level text for sure
local function KillLevelText(frame, ...)
	if frame and frame.hp.oldlevel and frame.hp.oldlevel:IsShown() then
		frame.hp.oldlevel:Hide()
	end
end

-- kill elite texture for sure ... I mean it ... DIE! ... god damn it
local function KillElite(frame, ...)
	if frame and frame.hp.elite and frame.hp.elite:IsShown() then
		frame.hp.elite:Hide()
	end
end

-- force name text to be behind other nameplates, unless it is our target
local function AdjustNameLevel(frame, ...)
	if UnitName("target") == frame.hp.oldname:GetText() and frame:GetParent():GetAlpha() == 1 then
		frame.hp.name:SetDrawLayer("OVERLAY")
	else
		frame.hp.name:SetDrawLayer("BORDER")
	end
end

-- health value
local function ShowHealth(frame, ...)
	local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d = (valueHealth/maxHealth)*100
	local perc = math.floor(d+.5)

	-- only show health value for targets not at full health
	if (d < 100 and d > 1) then 		-- 1 because cosmetic reasons 
		frame.hp.value:SetText(perc)
	else
		frame.hp.value:SetText(" ") 	-- needs to be " " or the threat indicator is misplaced on full hp targets
	end

	if(d <= 35 and d >= 25) then
		frame.hp.value:SetTextColor(253/255, 238/255, 80/255)
	elseif(d < 25 and d >= 20) then
		frame.hp.value:SetTextColor(250/255, 130/255, 0/255)
	elseif(d < 20) then
		frame.hp.value:SetTextColor(200/255, 20/255, 40/255)
	else
		frame.hp.value:SetTextColor(1,1,1)
	end	
end

local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame and frame:GetParent():IsShown() then
			functionToRun(frame, ...)
		end
	end
end

local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)

		if frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d") then
			local child1, child2 = frame:GetChildren()
			SkinObjects(child1, child2)
			frame.isSkinned = true
		end
	end
end

-- make it happen
InfinityPlates:SetScript('OnUpdate', function(self, elapsed)
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if(self.elapsed and self.elapsed > 0.2) then
		ForEachPlate(UpdateThreat, self.elapsed)
		ForEachPlate(AdjustNameLevel)
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end

	ForEachPlate(HighlightSelected)
	ForEachPlate(ShowHealth)
	ForEachPlate(KillLevelText)
	ForEachPlate(Colorize)
	ForEachPlate(KillElite)
end)

-- set some CVars
if hideOOC then
	InfinityPlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	function InfinityPlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end
end

if showIC then
	InfinityPlates:RegisterEvent("PLAYER_REGEN_DISABLED")
	function InfinityPlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

InfinityPlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function InfinityPlates:PLAYER_ENTERING_WORLD()
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("nameplateShowEnemyTotems", 1)
	SetCVar("bloatnameplates", 0)
	SetCVar("bloatthreat", 0)
	SetCVar("bloattest", 0)
	SetCVar("ShowVKeyCastbar", 1)
end