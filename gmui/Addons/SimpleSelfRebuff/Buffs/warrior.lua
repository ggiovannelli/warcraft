local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'WARRIOR' then return end

local stamina = GetSpellInfo(469)
local attackpower = GetSpellInfo(6673)

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
	local function Shout()
		if self.db.profile.categories[L['Shout']] == stamina then
			return not (GetRaidBuffTrayAuraInfo(2))
		elseif self.db.profile.categories[L['Shout']] == attackpower then
			return not (GetRaidBuffTrayAuraInfo(3))
		end
	end

	local buff = self:GetCategory(L['Shout'])
		:add( 6673, 'subcat', 'attackpower') -- Battle Shout
		:add( 469, 'subcat', 'stamina') -- Commanding Shout
	buff.checkRequirement = Shout	
end)
