
do
	local f = CreateFrame ("frame")
	local AddonName = ...
	f:RegisterEvent ("ADDON_LOADED")
	
	local AdjustCamera = function()
		if (not InCombatLockdown()) then
			SetCVar ("cameraDistanceMaxZoomFactor", 2.6)
			MoveViewOutStart (50000)
			f.Ticker:Cancel()
			f = nil
		end
	end
	
	f:SetScript ("OnEvent", function (self, event, ...)
		if (AddonName == ...) then
			f.Ticker = C_Timer.NewTicker (1, AdjustCamera)
			f:UnregisterEvent ("ADDON_LOADED")
			AddonName = nil
		end
	end)
end
