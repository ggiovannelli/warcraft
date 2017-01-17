local ADDON = ...

local string_format = string.format

local multi = {
    25, 50, 90, 140, 200,
    275, 375, 500, 650, 850,
    1100, 1400, 1775, 2250, 2850,
    3600, 4550, 5700, 7200, 9000,
    11300, 14200, 17800, 22300, 24900
};

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("gmXp", {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
	text = "-",
})

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("ARTIFACT_XP_UPDATE")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

frame:SetScript("OnEvent", function(self, event, ...)

	if UnitLevel("player") == GetMaxPlayerLevel() then 
	
		if HasArtifactEquipped() then 
		
			local ArtPower, ArtPointsSpent= select(5,C_ArtifactUI.GetEquippedArtifactInfo());
			dataobj.text = string_format("A:%s %.1f%%", ArtPointsSpent, ArtPower/C_ArtifactUI.GetCostForPointAtRank(ArtPointsSpent)*100)
	
		else 
			
			dataobj.text = "L: " .. UnitLevel("player")		

		end
	
	else	
	
		dataobj.text = string_format("L:%s %.1f%%", UnitLevel("player"), UnitXP("player")/UnitXPMax("player")*100)
	
	end
	
end)	


function dataobj.OnTooltipShow(tooltip)

	tooltip:AddLine(ADDON)
	tooltip:AddLine(" ")
	
	if UnitLevel("player") == GetMaxPlayerLevel() then
		
		tooltip:AddDoubleLine("Max content level", UnitLevel("player"), 1, 1, 1, 0, 1, 0)		

	else
	
		tooltip:AddDoubleLine("Level", UnitLevel("player"), 1, 1, 1, 0, 1, 0)
		tooltip:AddDoubleLine("Current XP", UnitXP("player"), 1, 1, 1, 0, 1, 0)
		tooltip:AddDoubleLine("Remaining XP", UnitXPMax("player") - UnitXP("player"), 1, 1, 1, 1, 0, 0)
		tooltip:AddDoubleLine("Progress in this level", string_format("%.1f%%", UnitXP("player")/UnitXPMax("player")*100) , 1, 1, 1, 0, 1, 0)
		tooltip:AddDoubleLine("Remaining rested", GetXPExhaustion() or 0, 1, 1, 1, 0, 1, 0)

	end
	
	if HasArtifactEquipped() then 
	
		local ArtName,ArtIcon,ArtPower,ArtPointsSpent = select(3,C_ArtifactUI.GetEquippedArtifactInfo());
		local ArtNextRank=C_ArtifactUI.GetCostForPointAtRank(ArtPointsSpent)
		local kl = select(2,GetCurrencyInfo(1171))
		local km = multi[kl] or 0
		local delta = ArtNextRank-ArtPower
	
		tooltip:AddLine(" ")
		tooltip:AddDoubleLine("Artifact", ArtName,1, 1, 1, 0, 1, 1)
		tooltip:AddDoubleLine("Rank", ArtPointsSpent, 1, 1, 1, 0, 1, 0)
		tooltip:AddDoubleLine("Power",ArtPower, 1, 1, 1, 0, 1, 0)

		if (delta) >= 0 then 
			tooltip:AddDoubleLine("Power to next rank",delta, 1, 1, 1, 1, 0, 0)
		else
			tooltip:AddDoubleLine("Power in excess in rank",abs(delta), 1, 1, 1, 1, 1, 0)				
		end

		tooltip:AddDoubleLine("Progress in rank", string_format("%.1f%%", ArtPower/ArtNextRank*100) , 1, 1, 1, 0, 1, 0)
		tooltip:AddLine(" ")
		tooltip:AddDoubleLine("Knownledge level", kl,1, 1, 1, 0, 1, 0)
		tooltip:AddDoubleLine("Knownledge multiplier", km .."%" ,1, 1, 1, 0, 1, 0)
		
	end	
		
end
