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
