local addonName, ns = ...

local ExtraQuestButton = CreateFrame('Button', addonName, UIParent, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate')
ExtraQuestButton:SetMovable(true)
ExtraQuestButton:RegisterEvent('PLAYER_LOGIN')
ExtraQuestButton:SetScript('OnEvent', function(self, event, ...)
	if(self[event]) then
		self[event](self, event, ...)
	elseif(self:IsEnabled()) then
		self:Update()
	end
end)

local visibilityState = '[extrabar][petbattle] hide; show'
local onAttributeChanged = [[
	if(name == 'item') then
		if(value and not self:IsShown() and not HasExtraActionBar()) then
			self:Show()
		elseif(not value) then
			self:Hide()
			self:ClearBindings()
		end
	elseif(name == 'state-visible') then
		if(value == 'show') then
			self:CallMethod('Update')
		else
			self:Hide()
			self:ClearBindings()
		end
	end

	if(self:IsShown() and (name == 'item' or name == 'binding')) then
		self:ClearBindings()

		local key = GetBindingKey('EXTRAACTIONBUTTON1')
		if(key) then
			self:SetBindingClick(1, key, self, 'LeftButton')
		end
	end
]]

function ExtraQuestButton:BAG_UPDATE_COOLDOWN()
	if(self:IsShown() and self:IsEnabled()) then
		local start, duration, enable = GetItemCooldown(self.itemID)
		if(duration > 0) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end

function ExtraQuestButton:BAG_UPDATE_DELAYED()
	self:Update()

	if(self:IsShown() and self:IsEnabled()) then
		local count = GetItemCount(self.itemLink)
		self.Count:SetText(count and count > 1 and count or '')
	end
end

function ExtraQuestButton:PLAYER_REGEN_ENABLED(event)
	self:SetAttribute('item', self.attribute)
	self:UnregisterEvent(event)
	self:BAG_UPDATE_COOLDOWN()
end

function ExtraQuestButton:UPDATE_BINDINGS()
	if(self:IsShown() and self:IsEnabled()) then
		self:SetItem()
		self:SetAttribute('binding', GetTime())
	end
end

function ExtraQuestButton:PLAYER_LOGIN()
	RegisterStateDriver(self, 'visible', visibilityState)
	self:SetAttribute('_onattributechanged', onAttributeChanged)
	self:SetAttribute('type', 'item')

	if(not self:GetPoint()) then
		self:SetPoint('CENTER', ExtraActionButton1)
	end

	self:SetSize(ExtraActionButton1:GetSize())
	self:SetScale(ExtraActionButton1:GetScale())
	self:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]])
	self:SetPushedTexture([[Interface\Buttons\CheckButtonHilight]])
	self:GetPushedTexture():SetBlendMode('ADD')
	self:SetScript('OnLeave', GameTooltip_Hide)
	self:SetClampedToScreen(true)
	self:SetToplevel(true)

	self.updateTimer = 0
	self.rangeTimer = 0
	self:Hide()

	local Icon = self:CreateTexture('$parentIcon', 'BACKGROUND')
	Icon:SetAllPoints()
	self.Icon = Icon

	local HotKey = self:CreateFontString('$parentHotKey', nil, 'NumberFontNormalGray')
	HotKey:SetPoint('BOTTOMRIGHT', -5, 5)
	self.HotKey = HotKey

	local Count = self:CreateFontString('$parentCount', nil, 'NumberFontNormal')
	Count:SetPoint('TOPLEFT', 7, -7)
	self.Count = Count

	local Cooldown = CreateFrame('Cooldown', '$parentCooldown', self, 'CooldownFrameTemplate')
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint('TOPRIGHT', -2, -3)
	Cooldown:SetPoint('BOTTOMLEFT', 2, 1)
	Cooldown:Hide()
	self.Cooldown = Cooldown

	local Artwork = self:CreateTexture('$parentArtwork', 'OVERLAY')
	Artwork:SetPoint('CENTER', -2, 0)
	Artwork:SetSize(256, 128)
	Artwork:SetTexture([[Interface\ExtraButton\Default]])
	self.Artwork = Artwork

	self:RegisterEvent('UPDATE_BINDINGS')
	self:RegisterEvent('BAG_UPDATE_COOLDOWN')
	self:RegisterEvent('BAG_UPDATE_DELAYED')
	self:RegisterEvent('WORLD_MAP_UPDATE')
	self:RegisterEvent('QUEST_LOG_UPDATE')
	self:RegisterEvent('QUEST_POI_UPDATE')
	self:RegisterEvent('QUEST_WATCH_LIST_CHANGED')
	self:RegisterEvent('QUEST_ACCEPTED')

	if(not WorldMapFrame:IsShown()) then
		SetMapToCurrentZone()
	end
end

local worldQuests = {}
function ExtraQuestButton:QUEST_REMOVED(event, questID)
	if(worldQuests[questID]) then
		worldQuests[questID] = nil

		self:Update()
	end
end

function ExtraQuestButton:QUEST_ACCEPTED(event, questLogIndex, questID)
	if(questID and not IsQuestBounty(questID) and IsQuestTask(questID)) then
		local _, _, worldQuestType = GetQuestTagInfo(questID)
		if(worldQuestType and not worldQuests[questID]) then
			worldQuests[questID] = questLogIndex

			self:Update()
		end
	end
end

ExtraQuestButton:SetScript('OnEnter', function(self)
	GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	GameTooltip:SetHyperlink(self.itemLink)
end)

ExtraQuestButton:SetScript('OnUpdate', function(self, elapsed)
	if(not self:IsEnabled()) then
		return
	end

	if(self.rangeTimer > TOOLTIP_UPDATE_TIME) then
		local HotKey = self.HotKey

		-- BUG: IsItemInRange() is broken versus friendly npcs (and possibly others)
		local inRange = IsItemInRange(self.itemLink, 'target')
		if(HotKey:GetText() == RANGE_INDICATOR) then
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
				HotKey:Show()
			elseif(inRange) then
				HotKey:SetTextColor(0.6, 0.6, 0.6)
				HotKey:Show()
			else
				HotKey:Hide()
			end
		else
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
			else
				HotKey:SetTextColor(0.6, 0.6, 0.6)
			end
		end

		self.rangeTimer = 0
	else
		self.rangeTimer = self.rangeTimer + elapsed
	end

	if(self.updateTimer > 5) then
		self:Update()
		self.updateTimer = 0
	else
		self.updateTimer = self.updateTimer + elapsed
	end
end)

ExtraQuestButton:SetScript('OnEnable', function(self)
	RegisterStateDriver(self, 'visible', visibilityState)
	self:SetAttribute('_onattributechanged', onAttributeChanged)
	self.Artwork:SetTexture([[Interface\ExtraButton\Default]])
	self:Update()
	self:SetItem()
end)

ExtraQuestButton:SetScript('OnDisable', function(self)
	if(not self:IsMovable()) then
		self:SetMovable(true)
	end

	RegisterStateDriver(self, 'visible', 'show')
	self:SetAttribute('_onattributechanged', nil)
	self.Icon:SetTexture([[Interface\Icons\INV_Misc_Wrench_01]])
	self.Artwork:SetTexture([[Interface\ExtraButton\Ultraxion]])
	self.HotKey:Hide()
end)

-- Sometimes blizzard does actually do what I want
local blacklist = {
	[113191] = true,
	[110799] = true,
	[109164] = true,
}

function ExtraQuestButton:SetItem(itemLink, texture)
	if(HasExtraActionBar()) then
		return
	end

	if(itemLink) then
		self.Icon:SetTexture(texture)

		if(itemLink == self.itemLink and self:IsShown()) then
			return
		end

		local itemID, itemName = string.match(itemLink, '|Hitem:(.-):.-|h%[(.+)%]|h')
		self.itemID = tonumber(itemID)
		self.itemName = itemName
		self.itemLink = itemLink

		if(blacklist[itemID]) then
			return
		end
	end

	local HotKey = self.HotKey
	local key = GetBindingKey('EXTRAACTIONBUTTON1')
	if(key) then
		HotKey:SetText(GetBindingText(key, 1))
		HotKey:Show()
	elseif(ItemHasRange(itemLink)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(InCombatLockdown()) then
		self.attribute = self.itemName
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('item', self.itemName)
		self:BAG_UPDATE_COOLDOWN()
	end
end

function ExtraQuestButton:RemoveItem()
	if(InCombatLockdown()) then
		self.attribute = nil
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('item', nil)
	end
end

local function GetClosestQuestItem()
	-- Basically a copy of QuestSuperTracking_ChooseClosestQuest from Blizzard_ObjectiveTracker
	local closestQuestLink, closestQuestTexture
	local shortestDistanceSq = 62500 -- 250 yards²
	local numItems = 0

	-- XXX: this API seems to be broken, we're tracking shit manually for now
	--[[
	for index = 1, GetNumWorldQuestWatches() do
		local questID = GetWorldQuestWatchInfo(index)
		if(questID) then
			local questLogIndex = GetQuestLogIndexByID(questID)
			local itemLink, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
			if(link) then
				local areaID = ns.questAreas[questID]
				if(not areaID) then
					areaID = ns.itemAreas[tonumber(string.match(link, 'item:(%d+)'))]
				end

				local _, _, _, _, _, isComplete = GetQuestLogTitle(questLogIndex)
				if(areaID and (type(areaID) == 'boolean' or areaID == GetCurrentMapAreaID())) then
					closestQuestLink = itemLink
					closestQuestTexture = texture
				elseif(not isComplete or (isComplete and showCompleted)) then
					local distanceSq = C_TaskQuest.GetDistanceSqToQuest(questID)
					if(distanceSq and distanceSq <= shortestDistanceSq) then
						shortestDistanceSq = distanceSq
						closestQuestLink = itemLink
						closestQuestTexture = texture
					end
				end

				numItems = numItems + 1
			end
		end
	end
	--]]

	-- XXX: temporary solution for the above
	for questID, questLogIndex in next, worldQuests do
		local itemLink, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
		if(itemLink) then
			local areaID = ns.questAreas[questID]
			if(not areaID) then
				areaID = ns.itemAreas[tonumber(string.match(itemLink, 'item:(%d+)'))]
			end

			local _, _, _, _, _, isComplete = GetQuestLogTitle(questLogIndex)
			if(areaID and (type(areaID) == 'boolean' or areaID == GetCurrentMapAreaID())) then
				closestQuestLink = itemLink
				closestQuestTexture = texture
			elseif(not isComplete or (isComplete and showCompleted)) then
				local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
				if(onContinent and distanceSq <= shortestDistanceSq) then
					shortestDistanceSq = distanceSq
					closestQuestLink = itemLink
					closestQuestTexture = texture
				end
			end

			numItems = numItems + 1
		end
	end

	if(not closestQuestLink) then
		for index = 1, GetNumQuestWatches() do
			local questID, _, questLogIndex, _, _, isComplete = GetQuestWatchInfo(index)
			if(questID and QuestHasPOIInfo(questID)) then
				local itemLink, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
				if(itemLink) then
					local areaID = ns.questAreas[questID]
					if(not areaID) then
						areaID = ns.itemAreas[tonumber(string.match(itemLink, 'item:(%d+)'))]
					end

					if(areaID and (type(areaID) == 'boolean' or areaID == GetCurrentMapAreaID())) then
						closestQuestLink = itemLink
						closestQuestTexture = texture
					elseif(not isComplete or (isComplete and showCompleted)) then
						local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
						if(onContinent and distanceSq <= shortestDistanceSq) then
							shortestDistanceSq = distanceSq
							closestQuestLink = itemLink
							closestQuestTexture = texture
						end
					end

					numItems = numItems + 1
				end
			end
		end
	end

	if(not closestQuestLink) then
		for questLogIndex = 1, GetNumQuestLogEntries() do
			local _, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(questLogIndex)
			if(not isHeader and QuestHasPOIInfo(questID)) then
				local itemLink, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
				if(itemLink) then
					local areaID = ns.questAreas[questID]
					if(not areaID) then
						areaID = ns.itemAreas[tonumber(string.match(itemLink, 'item:(%d+)'))]
					end

					if(areaID and (type(areaID) == 'boolean' or areaID == GetCurrentMapAreaID())) then
						closestQuestLink = itemLink
						closestQuestTexture = texture
					elseif(not isComplete or (isComplete and showCompleted)) then
						local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
						if(onContinent and distanceSq <= shortestDistanceSq) then
							shortestDistanceSq = distanceSq
							closestQuestLink = itemLink
							closestQuestTexture = texture
						end
					end

					numItems = numItems + 1
				end
			end
		end
	end

	return closestQuestLink, closestQuestTexture, numItems
end

local ticker
function ExtraQuestButton:Update()
	if(not self:IsEnabled() or self.locked) then
		return
	end

	local itemLink, texture, numItems = GetClosestQuestItem()
	if(itemLink) then
		self:SetItem(itemLink, texture)
	elseif(self:IsShown()) then
		self:RemoveItem()
	end

	if(numItems > 0 and not ticker) then
		ticker = C_Timer.NewTicker(30, function() -- might want to lower this
			ExtraQuestButton:Update()
		end)
	elseif(numItems == 0 and ticker) then
		ticker:Cancel()
		ticker = nil
	end
end

local Drag = CreateFrame('Frame', nil, ExtraQuestButton)
Drag:SetAllPoints()
Drag:SetFrameStrata('HIGH')
Drag:EnableMouse(true)
Drag:RegisterForDrag('LeftButton')
Drag:Hide()

Drag:SetScript('OnShow', function(self)
	ExtraQuestButton:Disable()
	self:RegisterEvent('PLAYER_REGEN_DISABLED')
end)

Drag:SetScript('OnHide', function(self)
	ExtraQuestButton:Enable()
	self:UnregisterEvent('PLAYER_REGEN_DISABLED')
end)

Drag:SetScript('OnEvent', function(self)
	self:Hide()
	ExtraQuestButton:StopMovingOrSizing()
end)

Drag:SetScript('OnDragStart', function()
	ExtraQuestButton:StartMoving()
end)

Drag:SetScript('OnDragStop', function()
	ExtraQuestButton:StopMovingOrSizing()
end)

SLASH_ExtraQuestButton1 = '/eqb'
SlashCmdList.ExtraQuestButton = function(message)
	if(InCombatLockdown()) then
		print('|cff33ff99ExtraQuestButton:|r', 'Cannot move during combat.')
		return
	end

	if(string.lower(message) == 'reset') then
		ExtraQuestButton:ClearAllPoints()
		ExtraQuestButton:SetPoint('CENTER', ExtraActionButton1)
		ExtraQuestButton:SetMovable(false)
		Drag:Hide()

		print('|cff33ff99ExtraQuestButton:|r', 'Reset to default position.')
		return
	end

	if(Drag:IsShown()) then
		Drag:Hide()
	else
		Drag:Show()
		ExtraQuestButton:Show()
	end
end
