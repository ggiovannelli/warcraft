local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'MAGE' then return end

local function Brilliance() 
	return not (GetRaidBuffTrayAuraInfo(5) and GetRaidBuffTrayAuraInfo(7)) 
end

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)
	local buff = self:GetCategory(L['Intellect']):addMulti(
		1459, -- Arcane Brilliance
	    61316 -- Dalaran Brilliance
	)
	buff.checkRequirement = Brilliance 

	self:AddStandaloneBuff( 11426 ) -- Ice Barrier
end)
