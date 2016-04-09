local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'SHAMAN' then return end

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
	local db = self.db.profile
	local function Shield()
		local shield = db.categories[L['Elemental Shield']]
		return not UnitAura("player", shield)
	end

	local buff = self:GetCategory(L['Elemental Shield']):addMulti(
		  324, -- Lightning Shield
		52127, -- Water Shield
		  974  -- Earth Shield
	)
	buff.checkRequirement = Shield	

	self:AddStandaloneBuff(546, 'checkRequirement', IsSwimming ) -- Water Walking
end)
