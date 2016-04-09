local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'ROGUE' then return end

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
	local function Lethal()
		local poison = self.db.profile.categories["Lethal"]
		return not UnitAura("player", poison)
	end
	local buff = self:GetCategory("Lethal"):addMulti(
		2823, -- Deadly Poison
		8679  -- Wound Poison
	)
	buff.checkRequirement = Lethal

	local function NonLethal()
		local poison = self.db.profile.categories["Non-Lethal"]
		return not UnitAura("player", poison)
	end
	local buff = self:GetCategory("Non-Lethal"):addMulti(
		3408, -- Crippling Poison 
		108211 -- Leeching Poison
	)
	buff.checkRequirement = NonLethal
end)
