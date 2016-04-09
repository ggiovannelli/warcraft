local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'PRIEST' then return end

local function Fortitude()
	return not GetRaidBuffTrayAuraInfo(2)
end	

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
	self:AddStandaloneBuff(21562, 'checkRequirement', Fortitude) -- Fortitude	

	self:AddMultiStandaloneBuffs(
		15473, -- Shadowform
		6346  -- Fear Ward
	)
end)
