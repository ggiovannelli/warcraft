--[[-------------------------------------------------------------------------
	Broker_WindowedMode
    Copyright (C) 2010-2012  Morsker
	Please contact Morsker through PM on wowace.com.

	A simple LDB display for Windowed Mode vs. Full Screen, with toggling either
	by click or keybind.

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------]]
--{{{ top
local addonName, BWM = ...
_G[addonName] = BWM
local L = BWM.L
local db
local dataobj
local frame = CreateFrame("Frame")
BWM.frame = frame
--}}}
--{{{ upvalues & globals
-- GLOBALS: BINDING_HEADER_BROKER_WINDOWEDMODE
-- GLOBALS: BINDING_NAME_BROKER_WINDOWDEDMODE_TOGGLE
-- GLOBALS: Broker_WindowedModeDB
-- GLOBALS: LibStub
-- GLOBALS: RestartGx
-- GLOBALS: hooksecurefunc
local GameTooltip = GameTooltip
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local InCombatLockdown = InCombatLockdown
local KEY_BINDING = KEY_BINDING
local SetCVar = SetCVar
local WINDOWED_MODE = WINDOWED_MODE
local _G = _G
local strlower = strlower
local strtrim = strtrim
--}}}

local print --{{{ Print with colored prefix.
do
	local prefix = "|cff33ff99"..addonName.."|r:"
	function print(...)
		_G.print(prefix, ...)
	end
end
--}}}

BINDING_HEADER_BROKER_WINDOWEDMODE = addonName --{{{ Globals for bindings
BINDING_NAME_BROKER_WINDOWDEDMODE_TOGGLE = L["Toggle Windowed Mode"]
--}}}

function BWM:ToggleWindowedMode()
	if GetCVarBool("gxWindow") then
		-- For consistancy with GraphicsQualityLevels.lua, we set both CVars to 0 when going Fullscreen.
		-- We remember the gxMaximize CVar though so we can restore it when leaving Fullscreen.
		db.maximize = GetCVar("gxMaximize")
		SetCVar("gxWindow", "0")
		SetCVar("gxMaximize", "0")
	else
		SetCVar("gxWindow", "1")
		SetCVar("gxMaximize", db.maximize)
	end
	RestartGx()
	if GameTooltip:IsShown() then
		GameTooltip:Hide()
	end
end

-- Updates the dataobj when the graphics system restarts.
local function UpdateDataObject()
	-- Credits: The "window" icons are from GoSquared. They're public domain, and this credit isn't
	-- necessary; it's just a courtesy:
	-- http://www.gosquared.com/liquidicity/archives/314
	if GetCVarBool("gxWindow") then
		dataobj.text = L["Win"]
		dataobj.icon = "Interface\\Addons\\Broker_WindowedMode\\bluewin.tga"
		dataobj.modeDescription = WINDOWED_MODE
		dataobj.otherModeDescription = L["Full Screen"]
	else
		dataobj.text = L["Full"]
		dataobj.icon = "Interface\\Addons\\Broker_WindowedMode\\squarewin.tga"
		dataobj.modeDescription = L["Full Screen"]
		dataobj.otherModeDescription = WINDOWED_MODE
	end
end

local function On_PLAYER_LOGOUT(self, event)
	if GetCVarBool("gxWindow") then
		db.maximize = GetCVar("gxMaximize")
	end
end

-- Wait for ADDON_LOADED. We need two things: 1) our "db" vars to be ready, and 2) some addon to provide LDB.
local function On_ADDON_LOADED(self, event, name)
	if event == "PLAYER_LOGOUT" then return On_PLAYER_LOGOUT(self, event) end
	if name == addonName then
		Broker_WindowedModeDB = Broker_WindowedModeDB or {}
		db = Broker_WindowedModeDB
		if db.showText == nil then
			db.showText = true
		end
		if db.maximize == nil then
			db.maximize = GetCVarBool("gxWindow") and GetCVar("gxMaximize") or "1"
		end
	end
	if not (db and LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)) then
		return
	end
	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", On_PLAYER_LOGOUT)

	dataobj = {}
	dataobj.type = (db.showText and "data source" or "launcher")
	UpdateDataObject()
	dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("WindowedMode", dataobj)
	hooksecurefunc("RestartGx", UpdateDataObject)
	hooksecurefunc("ConsoleExec", function(arg)
		if "gxrestart" == strlower(strtrim(arg)) then
			UpdateDataObject()
		end
	end)

	function dataobj:OnTooltipShow()
		self:AddLine(dataobj.modeDescription)
		self:AddDoubleLine(L["Left-Click"], dataobj.otherModeDescription)
		self:AddDoubleLine(L["Middle-Click"], (db.showText and L["Hide Text"] or L["Show Text"]))
		self:AddDoubleLine(L["Right-Click"], KEY_BINDING)
	end

	function dataobj:OnClick(button)
		if button == "LeftButton" then
			BWM:ToggleWindowedMode()
		elseif button == "MiddleButton" then
			db.showText = not db.showText
			dataobj.type = (db.showText and "data source" or "launcher")
		elseif button == "RightButton" then
			if not InCombatLockdown() then
				frame:Show()
			else
				print(L["Can't keybind in combat."])
			end
		end
	end
end
frame:SetScript("OnEvent",  On_ADDON_LOADED)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

-----------------------------------------------------------------------------
--  Keybind Frame
-----------------------------------------------------------------------------

--{{{ upvalues & globals
-- GLOBALS: BIND_KEY_TO_COMMAND
-- GLOBALS: FAILED
-- GLOBALS: GetBindingAction
-- GLOBALS: GetBindingFromClick
-- GLOBALS: GetBindingKey
-- GLOBALS: GetCurrentBindingSet
-- GLOBALS: IsAltKeyDown
-- GLOBALS: IsControlKeyDown
-- GLOBALS: IsShiftKeyDown
-- GLOBALS: KEY_BOUND
-- GLOBALS: KEY_UNBOUND_ERROR
-- GLOBALS: LoadBindings
-- GLOBALS: SaveBindings
-- GLOBALS: SetBinding
-- GLOBALS: TakeScreenshot
-- GLOBALS: format
-- GLOBALS: ipairs
--}}}

frame.binding = "BROKER_WINDOWDEDMODE_TOGGLE"
frame:Hide()
frame:SetScript("OnShow", function(self)
	self:SetFrameStrata("DIALOG")
	self:EnableKeyboard(true)
	self:SetClampedToScreen(true)
	self:SetPoint("CENTER", 0, _G.UIParent:GetHeight() / 7)
	self:SetBackdrop({
		bgFile=[[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile=[[Interface\Tooltips\UI-Tooltip-Border]], tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	self:SetBackdropColor(0, 0, 0)

	self.text = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	self.text:SetPoint("TOP", 0, -40)
	self.text:SetFormattedText(BIND_KEY_TO_COMMAND, _G["BINDING_NAME_"..self.binding])

	self:SetScript("OnShow", function(self)
		local width = self.text:GetWidth() + 80
		local height = self.text:GetHeight() + 80
		self:SetWidth(width)
		self:SetHeight(height)

		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end)
	self:GetScript("OnShow")(self)

	self:SetScript("OnHide", function(self)
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end)

	self:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			print(L["Can't keybind in combat."])
			self:Hide()
		end
	end)

	local unbindableKeys = {
		LALT = 1, LCTRL = 1, LSHIFT = 1,
		RALT = 1, RCTRL = 1, RSHIFT = 1,
		UNKNOWN = 1,
	}

	function frame:ClearBinds()
		local keys = {GetBindingKey(self.binding)}
		for i,key in ipairs(keys) do
			SetBinding(key, nil)
		end
		return keys
	end

	self:SetScript("OnKeyDown", function(self, key)
		if GetBindingFromClick(key) == "SCREENSHOT" then
			TakeScreenshot()
		elseif key == "ESCAPE" then
			if #self:ClearBinds() > 0 then
				print(format(KEY_UNBOUND_ERROR, _G["BINDING_NAME_"..self.binding]))
				SaveBindings(GetCurrentBindingSet())
			end
			self:Hide()
		elseif not unbindableKeys[key] then
			if IsShiftKeyDown()   then key = "SHIFT-"..key end
			if IsControlKeyDown() then key = "CTRL-"..key end
			if IsAltKeyDown()     then key = "ALT-"..key end

			self:ClearBinds()
			local oldAction = GetBindingAction(key)
			if SetBinding(key, self.binding) then
				if oldAction ~= "" then
					print(format(KEY_UNBOUND_ERROR, _G["BINDING_NAME_"..oldAction]))
				end
				print(KEY_BOUND..": "..key)
				SaveBindings(GetCurrentBindingSet())
			else
				print(KEY_BINDING..": "..FAILED)
				LoadBindings(GetCurrentBindingSet())
			end
			self:Hide()
		end
	end)
end)
