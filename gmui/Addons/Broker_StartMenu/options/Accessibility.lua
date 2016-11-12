local addonName, addon = ...
local ui = addon:GetModule("Options.UI")
local options = addon:NewModule("Options.Accessibility")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function options:OnInitialize()
    local accessibility = addon.options:AddSubCategory(L["Accessibility"])
	accessibility:SetDescription(L["Bind up to four menu items to the mouse which you can use to open them quickly by clicking on the broker display."])
	
	local titles = {}
	for _, interface in addon.display:Interfaces() do
		if not interface.secure then
			table.insert(titles, interface.title)
		end
	end
	
	local buttons = {
		[KEY_BUTTON1] = 1,
		[KEY_BUTTON2] = 2,
	}
	
	local options = {
		{
			type = "Dropdown",
			text = L["Mouse Setting"],
			get = function()
				return addon.buttons[addon.db.profile.mouseButton]
			end,
			set = function(_, value)
				addon.db.profile.mouseButton = buttons[value]
			end,
			menuList = addon.buttons
		}
	}
	
	for i in pairs(addon.db.profile.accessibility) do
		table.insert(options, {
			type = "Dropdown",
			text = addon.modifiers[i],
			get = function()
				local interface = addon.display:GetInterface(addon.db.profile.accessibility[i].name)
				return interface.title
			end,
			set = function(_, value)
				local interface = addon.display:GetInterface(value)
				addon.db.profile.accessibility[i].name = interface.name
			end,
			menuList = titles
		})
	end
	
	table.insert(options, {
		type = "CheckButton",
		text = L["Hide the bindings from the tooltip"],
		get = function()
			return addon.db.profile.hideTooltipAccessibilityBindings
		end,
		set = function()
			addon.db.profile.hideTooltipAccessibilityBindings = not addon.db.profile.hideTooltipAccessibilityBindings
		end
	})
	
	accessibility:CreateOptions(options)

	accessibility:SetupControls()
end