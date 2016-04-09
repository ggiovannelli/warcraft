local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'HUNTER' then return end

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
	self:AddMultiStandaloneBuffs(
		77769 -- Trap Launcher
	)
end)
