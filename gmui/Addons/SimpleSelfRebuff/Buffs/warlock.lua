local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'WARLOCK' then return end

local function DarkIntent()
	return not (GetRaidBuffTrayAuraInfo(2) and GetRaidBuffTrayAuraInfo(5))
end	

local function petExists(buff)
	return (UnitExists('pet') and not UnitIsDead('pet'))
end

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
	self:AddStandaloneBuff( 109773, 'checkRequirement', DarkIntent ) -- Dark Intent
	self:AddStandaloneBuff( 108503, 'checkRequirement', petExists ) -- Grimoire of Sacrifice
	self:AddStandaloneBuff(5697, 'checkRequirement', IsSwimming ) -- Unending Breath
end)
