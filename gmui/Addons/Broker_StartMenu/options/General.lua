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
local ui = addon:GetModule("Options.UI")
local options = addon:NewModule("Options.General")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function options:OnInitialize()
	local parent = ui:CreateOptionsFrame(addon.name)
	parent:SetDescription(GetAddOnMetadata(addonName, "Notes"))

	parent:CreateOptions({
		{
			type = "CheckButton",
			text = L["Block the menu in combat"],
			get = function()
				return addon.db.profile.blockInCombat
			end,
			set = function()
				addon.db.profile.blockInCombat = not addon.db.profile.blockInCombat
			end
		},
		{
			type = "CheckButton",
			text = L["Hide the logout and exit items from the menu"],
			get = function()
				return addon.db.profile.hideLogoutButtons
			end,
			set = function()
				addon.db.profile.hideLogoutButtons = not addon.db.profile.hideLogoutButtons
				addon:UpdateMenu()
			end
		},
		{
			type = "CheckButton",
			text = L["Hide the reload item from the menu"],
			get = function()
				return addon.db.profile.hideReloadUIButton
			end,
			set = function()
				addon.db.profile.hideLogoutButtons = not addon.db.profile.hideLogoutButtons
				addon:UpdateMenu()
			end
		},
		{
			type = "CheckButton",
			text = L["Hide the options item from the menu"],
			get = function()
				return addon.db.profile.hideOptionsButton
			end,
			set = function()
				addon.db.profile.hideOptionsButton = not addon.db.profile.hideOptionsButton
				addon:UpdateMenu()
			end
		},
		{
			type = "CheckButton",
			text = L["Hide key bindings from the menu"],
			get = function()
				return addon.db.profile.hideKeyBindings
			end,
			set = function()
				addon.db.profile.hideKeyBindings = not addon.db.profile.hideKeyBindings
				addon:UpdateMenu()
			end
		},
		{
			type = "Custom",
			text = L["Tooltip"],
			--[[init = function(control)	
				ui:CreateSeparator(control)
			end]]
		},
		{
			type = "CheckButton",
			text = L["Hide tooltip"],
			get = function()
				return addon.db.profile.hideTooltip
			end,
			set = function()
				addon.db.profile.hideTooltip = not addon.db.profile.hideTooltip
			end
		},
		{
			type = "Slider",
			text = L["Max number of addons to display"],
			width = 560,
			step = 1,
			min = 1,
			max = 40,
			get = function()
				return addon.db.profile.numAddOns
			end,
			set = function(_, value)
				addon.db.profile.numAddOns = value
			end
		}
	})
	
	parent:SetupControls()
	
    addon.options = parent;
end
