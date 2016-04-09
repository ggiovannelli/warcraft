--[[
	Copyright (c) 2015 Eyal Solnik <Lynxium>

	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local addonName, addon = ...
local core = LibStub("Libra"):NewAddon(addonName, addon)

addon.display = LibStub("EasyDisplay-1.0")
addon.name = addonName:gsub("Broker_", "")

local defaults = {
	profile = {
		mouseButton = 1,
		numAddOns = 10,
		hideTooltip = false,
		hideTooltipAccessibilityBindings = false,
		hideLogoutButtons = true,
		hideReloadUIButton = false,
		hideOptionsButton = false,
		hideKeyBindings = true,
		menu = {
			character = 1,
			spellbook = 2,
			talents = 3,
			achievements = 4,
			questlog = 5,
			guild = 6,
			lfd = 7,
			collections = 8,
			journal = 9,
			social = 10,
			mainmenu = 11
		},
		accessibility = {
			{
				name = "bags",
				modifier = 1
			},
			{
				name = "questlog",
				modifier = 2
			},
			{
				name = "pvp",
				modifier = 3
			},
			{
				name = "social",
				modifier = 4
			}
		}
	}
}

addon.buttons = {
	KEY_BUTTON1,
	KEY_BUTTON2,
}

addon.modifiers = {
	NONE,
	SHIFT_KEY,
	CTRL_KEY,
	ALT_KEY
}

core:SetOnUpdate(function(self, elapsed)
	if addon:IsMenuVisible() or not addon.tooltip then
		return
	end
		
	local t = self.elapsed or 0
	self.elapsed = t + elapsed
	
	t = self.elapsed

	if t >= 1 then
		addon:UpdateTooltip()
		self.elapsed = nil
	end
end)

function core:OnInitialize()
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("UPDATE_BINDINGS")
	
	addon.db = LibStub("AceDB-3.0"):New("Broker_StartMenuDb", defaults, true)
	
	addon.db.RegisterCallback(addon, "OnProfileChanged", function()
		ReloadUI()
	end)

	addon.db.RegisterCallback(addon, "OnProfileCopied", function()
		ReloadUI()
	end)

	addon.db.RegisterCallback(addon, "OnProfileReset", function()
		ReloadUI()
	end)
	
	addon.dataobj = LibStub("LibDataBroker-1.1"):NewDataObject(addon.name, {
		type = "data source",
		icon = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
		text = addon.name,
		OnClick = function(self, button)
			addon:BuildMenu()
			if not addon.db.profile.blockInCombat or not UnitAffectingCombat("player") then
				addon:OpenMenu(self, button)
			end
			GameTooltip:Hide()
		end,
		OnEnter = function(self)
			local _, y = GetCursorPosition()
			local _, y2 = UIParent:GetCenter()
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			if y > y2 then
				GameTooltip:SetPoint("TOP", self, "BOTTOM")
			else
				GameTooltip:SetPoint("BOTTOM", self, "TOP")
			end
			addon:UpdateTooltip()
			addon.tooltip = true
		end,
		OnLeave = function(self)
			GameTooltip:Hide()
			addon.tooltip = nil
		end
	})
end

function core:PLAYER_REGEN_ENABLED()
	addon.dataobj.text = addon.name
	addon:UpdateMenu()
end

function core:PLAYER_REGEN_DISABLED()
	addon.dataobj.text = "|cffff0000In combat|r"
	addon:UpdateMenu()
end

function core:UPDATE_BINDINGS()
	addon:UpdateMenu()
end
