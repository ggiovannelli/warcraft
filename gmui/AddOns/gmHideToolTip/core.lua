-- Tooltip code and hooksecurefunc by sticklord
-- Thanks !
--
-- ideas and discussions here:
-- http://www.wowinterface.com/forums/showthread.php?p=307934

local ADDON = ...

local TOOLTIPDISABLED = 1
local prgname = "|cffffd200gmHideToolTip|r"
local IN_COMBAT
 
hooksecurefunc(GameTooltip, "SetAction", function(self)
	if (IN_COMBAT and TOOLTIPDISABLED == 1) then
		self:Hide()
	end
end)
 
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		IN_COMBAT = true
	elseif event == "PLAYER_REGEN_ENABLED" then    
		IN_COMBAT = false
	end
end)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

print (prgname .. ": |cffffd200/gmhtt|r to have tooltips back or hide again")

SLASH_HTT1 = "/gmhtt";
SlashCmdList["GMHTT"] = function() 
	
		if TOOLTIPDISABLED == 1 then 
			TOOLTIPDISABLED = 0
			print (prgname .. ": tooltips enabled in combat")
		else			
			TOOLTIPDISABLED = 1
			print (prgname .. ": tooltips disabled in combat")
		end
end