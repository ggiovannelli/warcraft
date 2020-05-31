local ADDON = ...

local mediapath = "interface\\addons\\"..ADDON.."\\media\\"

local function HideIt(frame)
	frame:SetAlpha(0)
	frame:HookScript("OnShow", frame.Hide)
	frame:Hide()
end


local function StyleMiniMap(enabled)

	if enabled then 
		-- Minimap stuffs ---------------------------------------------------------------

		HideIt(MiniMapWorldMapButton)
		HideIt(MinimapZoomIn)
		HideIt(MinimapZoomOut)

		-- Minimap zone text
		HideIt(MinimapZoneTextButton)
		MinimapBorderTop:SetAlpha(0)

		-- Hide GarrisonLandingPageMinimapButton
		HideIt(GarrisonLandingPageMinimapButton)
		GarrisonLandingPageMinimapButton:ClearAllPoints()
		GarrisonLandingPageMinimapButton:UnregisterAllEvents()
		

		-- MiniMapTracking: rminimap settings
		MiniMapTracking:SetParent(Minimap)
		MiniMapTracking:SetScale(1)
		MiniMapTracking:ClearAllPoints()
		MiniMapTracking:SetPoint("TOPLEFT",Minimap,5,-5)
		MiniMapTrackingButton:SetHighlightTexture (nil)
		MiniMapTrackingButton:SetPushedTexture(nil)
		MiniMapTrackingBackground:Hide()
		MiniMapTrackingButtonBorder:Hide()
		MiniMapTracking:SetFrameStrata("HIGH")
		 
		-- MiniMapMail: rminimap settings
		MiniMapMailFrame:ClearAllPoints()
		MiniMapMailFrame:SetPoint("BOTTOMRIGHT",Minimap,-0,0)
		MiniMapMailIcon:SetTexture(mediapath.."mail")
		MiniMapMailBorder:SetTexture("Interface\\Calendar\\EventNotificationGlow")
		MiniMapMailBorder:SetBlendMode("ADD")
		MiniMapMailBorder:ClearAllPoints()
		MiniMapMailBorder:SetPoint("CENTER",MiniMapMailFrame,0.5,1.5)
		MiniMapMailBorder:SetSize(27,27)
		MiniMapMailBorder:SetAlpha(0)

		-- Calendar: rminimap settings
		-- HideIt(GameTimeFrame)
		GameTimeFrame:SetParent(Minimap)
		GameTimeFrame:SetScale(0.6)
		GameTimeFrame:ClearAllPoints()
		GameTimeFrame:SetPoint("TOPRIGHT",Minimap,-18,-18)
		GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
		GameTimeFrame:GetNormalTexture():SetTexCoord(0,1,0,1)
		GameTimeFrame:SetNormalTexture(mediapath.."calendar")
		GameTimeFrame:SetPushedTexture(nil)
		GameTimeFrame:SetHighlightTexture (nil)

		-- Remove the display of mounts with VehicleSeatIndicator
		HideIt(VehicleSeatIndicator)

		Minimap:EnableMouseWheel(true)
		Minimap:SetScript('OnMouseWheel', function(self, delta)
			if delta > 0 then
				Minimap_ZoomIn()
			else
				Minimap_ZoomOut()
			end
		end)
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "VARIABLES_LOADED" then
		StyleMiniMap(true)
	end
end)