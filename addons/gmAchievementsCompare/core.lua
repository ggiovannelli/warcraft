-- All this code is not by me but it is (well written as usual) by Phanx :)
-- You can check the discussion here:
-- http://www.wowinterface.com/forums/showthread.php?p=311463#post311463

local tooltip = CreateFrame("GameTooltip", "gmAchievementsCompareTooltip", UIParent, "GameTooltipTemplate")
tooltip:EnableMouse(true)
tooltip:SetToplevel(true)
tooltip:SetMovable(true)
tooltip:SetFrameStrata("TOOLTIP")
tooltip:Hide()
tooltip:SetSize(128, 64)
tooltip:SetPoint("BOTTOM", 150, 80)
tooltip:SetPadding(16,0)
tooltip:RegisterForDrag("LeftButton")
tooltip:SetScript("OnDragStart", tooltip.StartMoving)
tooltip:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	ValidateFramePosition(self)
end)

GameTooltip_OnLoad(tooltip)
tinsert(UISpecialFrames, "gmAchievementsCompareTooltip")

local close = CreateFrame("Button", nil, tooltip)
close:SetSize(32, 32)
close:SetPoint("TOPRIGHT", 1, 0)
close:SetScript("OnClick", function() HideUIPanel(tooltip) end)
close:SetNormalTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Up]])
close:SetPushedTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Down]])
close:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
close:GetHighlightTexture():SetBlendMode("ADD")
tooltip.closeButton = close

hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(ItemRefTooltip, link)
	local linkType, id = strsplit(":", link)
	if linkType == "achievement" then
		local achievementLink = GetAchievementLink(id)
		ShowUIPanel(tooltip)
		if not tooltip:IsShown() then
			tooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
		end
		tooltip:SetHyperlink(achievementLink)
	end
end)