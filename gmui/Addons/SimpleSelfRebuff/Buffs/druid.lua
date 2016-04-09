local SimpleSelfRebuff = LibStub("AceAddon-3.0"):GetAddon("SimpleSelfRebuff", true)
if select(2, UnitClass('player')) ~= 'DRUID' then return end

local function Stats()
	return not (GetRaidBuffTrayAuraInfo(1))
end	

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)

	local db = self.db.profile
	self.options.args.general.args.notWhileShapshifted = {
			type = 'toggle',
			name = L["Disable while shapeshifted"],
			desc = L["Disable rebuffing while shapeshifted."],
			width = 'double',
			get  = function() return db.disableWhileShapshifted end,
			set  = function(info, v) 
				db.disableWhileShapshifted = v
				self:CheckRebuff()
			end,		
	}
	
	local function Shift()
		return not self.db.profile.disableWhileShapshifted or GetShapeshiftForm(true) == 0
	end
	self:AddStandaloneBuff(1126, 'checkRequirement', Stats) -- Mark of the Wild
end)
