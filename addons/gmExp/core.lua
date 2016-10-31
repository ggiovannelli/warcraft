local ADDON = ...

local string_format = string.format


local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("gmXp", {
	type = "data source",
	icon = "Interface\\Icons\\Inv_misc_enchantedscroll",
	text = "-",
})

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("ARTIFACT_XP_UPDATE")

frame:SetScript("OnEvent", function(self, event, ...)

	if UnitLevel("player") == GetMaxPlayerLevel() then 
	
		dataobj.text = "L: " .. UnitLevel("player")
	
	else	
	
		dataobj.text = string_format("L: %s %.1f%%", UnitLevel("player"), UnitXP("player")/UnitXPMax("player")*100)
	
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
		tooltip:AddDoubleLine("Current Percentage", string_format("%.1f%%", UnitXP("player")/UnitXPMax("player")*100) , 1, 1, 1, 0, 1, 0)
		tooltip:AddDoubleLine("Remaining Rested", GetXPExhaustion() or 0, 1, 1, 1, 0, 1, 0)

	end
	
	if HasArtifactEquipped() then 
	
		local _, _, ArtName, ArtIcon, ArtPower, ArtPointsSpent, _, _, _, _, _, _ = C_ArtifactUI.GetEquippedArtifactInfo();
		local ArtNextRank=C_ArtifactUI.GetCostForPointAtRank(ArtPointsSpent)
		
		tooltip:AddLine(" ")
		tooltip:AddLine("Artifact: " .. ArtName,1, 1, 1, 0, 1, 0)
		tooltip:AddDoubleLine("Rank", ArtPointsSpent, 1, 1, 1, 0, 1, 0)
		tooltip:AddDoubleLine("Power", ArtPower .. "/" .. ArtNextRank , 1, 1, 1, 0, 1, 0)
		
	end	
		
end
