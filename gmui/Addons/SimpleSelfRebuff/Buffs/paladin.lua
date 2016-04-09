local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'PALADIN' then return end

local mastery = GetSpellInfo(19740)
local stats = GetSpellInfo(20217)

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
	local function Blessing()
		if self.db.profile.categories[L['Blessing']] == mastery then
			return not GetRaidBuffTrayAuraInfo(8)
		elseif self.db.profile.categories[L['Blessing']] == stats then
			return not GetRaidBuffTrayAuraInfo(1)
		end
	end

	local buff = self:GetCategory(L['Blessing'])
		:add( 20217, 'subcat', 'stats') -- Blessing of Kings
		:add( 19740, 'subcat', 'mastery') -- Blessing of Might
	buff.checkRequirement = Blessing
			
	self:AddStandaloneBuff(25780) -- Righteous Fury
end)
