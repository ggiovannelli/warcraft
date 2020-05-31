local ADDON = ...


-- ActionBars -------------------------------------------------------------------

--[[ DEBUG
hooksecurefunc(MultiBarRight, "SetScale", function(self, scale)

	print("DEBUG-SCALE: "..scale)

	if scale ~= 0.8 or tonumber(format("%.1f",self:GetScale())) ~= 0.8 then 
		if InCombatLockdown() then 
			print("DEBUG-COMBAT: in combat")
			C_Timer.After(1,self:SetScale(0.8))
			return
		else
			self:SetParent(UIParent)
			self:SetScale(0.8)
		end
	else 
		return
	end
	
end)
--]]
---hooksecurefunc(MultiBarLeft, "SetScale", function(self, scale)
---    if self:GetScale() ~= 0.8 then self:SetScale(0.8) end
---end)

local function ToggleBar(bar,alpha)
	for i=1,12 do
		_G[bar.."Button"..i]:SetAlpha(alpha)
		_G[bar.."Button"..i]:SetScript("OnEnter", function(self) for u=1,12 do _G[bar.."Button"..u]:SetAlpha(1) end end)
		_G[bar.."Button"..i]:SetScript("OnLeave", function(self) for u=1,12 do _G[bar.."Button"..u]:SetAlpha(alpha)end end)
	end
	_G[bar]:SetScript("OnEnter", function(self) for i=1,12 do _G[bar.."Button"..i]:SetAlpha(1) end end)
	_G[bar]:SetScript("OnLeave", function(self) for i=1,12 do _G[bar.."Button"..i]:SetAlpha(alpha) end end)
 end

 local function PositionFrame(frame, anchor, parent, posX, posY, scale)
    frame:SetMovable(true)
    frame:ClearAllPoints()
    frame:SetPoint(anchor, parent, posX, posY)
    frame:SetScale(scale)
    frame:SetUserPlaced(true)
    frame:SetMovable(false)
end

local function HideIt(frame)
	frame:HookScript("OnShow", frame.Hide)
	frame:SetAlpha(0)
	frame:Hide()
end


local function StyleBars(enabled)

	if enabled then 

		-- Hide the gryphons & background art on the action bar:
		-- PositionFrame(MainMenuBar,"BOTTOM", UIParent, 18, 5, 1)
		MainMenuBarArtFrame.PageNumber:SetAlpha(0)
		MainMenuBarArtFrame.LeftEndCap:SetAlpha(0)
		MainMenuBarArtFrame.RightEndCap:SetAlpha(0)
		HideIt(StatusTrackingBarManager)
		HideIt(MainMenuBarArtFrameBackground)

		-- Hide the quick join button above the chat window:
		HideIt(QuickJoinToastButton)

		-- Hide the Action bar up/down arrows:
		HideIt(ActionBarUpButton)
		HideIt(ActionBarDownButton)

		-- Hide the quick join button above the chat window:
		HideIt(QuickJoinToastButton)

		-- Hide the Action bar up/down arrows:
		HideIt(ActionBarUpButton)
		HideIt(ActionBarDownButton)

		-- Bags & Menu ------------------------------------------------------------------
		HideIt(MicroButtonAndBagsBar)

		--ChatFrameToggleVoiceDeafenButton
		HideIt(CharacterMicroButton)

		local MicroMenuButtons = {
			CharacterMicroButton,
			SpellbookMicroButton,
			TalentMicroButton,
			QuestLogMicroButton,
			GuildMicroButton,
			LFDMicroButton,
			CollectionsMicroButton,
			EJMicroButton,
			StoreMicroButton,
			MainMenuMicroButton
		}

		for i = 1, #MicroMenuButtons do
			HideIt(MicroMenuButtons[i])
		end

		AchievementFrame_LoadUI()
		AchievementMicroButton:SetAlpha(0)
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_ENTERING_WORLD" then
		ToggleBar("MultiBarBottomRight",0.1)
		ToggleBar("MultiBarRight",0.1)
		ToggleBar("MultiBarLeft",0.1)
		StyleBars(true)
	end
end)

