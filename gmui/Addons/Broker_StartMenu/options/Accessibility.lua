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