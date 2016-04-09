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
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local menu = {}

local dropdown = LibStub("Libra"):CreateDropdown("Menu")
dropdown.initialize = function(self, level)
	for index = 1, #menu do
		local value = menu[index]
		if value.text then
			value.index = index
			UIDropDownMenu_AddButton(value, level)
		end
	end
end

local function getMenuText(text, command)
	if not addon.db.profile.hideKeyBindings and command and GetBindingKey(command) then
		-- We cannot inline this because GetBindingKey may return more than one binding for a single command,
		--	and so when it returns more than one it messes up GetBindingText and we only need the first one.
		local binding = GetBindingKey(command)
		return text .. " (|cff82c5ff" .. GetBindingText(binding) .. FONT_COLOR_CODE_CLOSE .. ")"
	else
		return text
	end
end

local function insertItem(text, func)
	table.insert(menu, {
		text = text,
		notCheckable = 1,
		func = func,
	})
end

local function insertSeparator()
	if #menu > 0 then
		table.insert(menu, {
			text = "",
			notCheckable = 1,
			disabled = true,
		})
	end
end

local function insertInterface(name, order)
	local interface = addon.display:GetInterface(name)
	if interface and order > 0 then
		local inCombat = UnitAffectingCombat("player")
		
		local entry = {
			order = order,
			name = name,
			text = getMenuText(interface.title, interface.command),
			icon = interface.icon,
			notCheckable = 1,
			disabled = inCombat and interface.secure
		}
		
		if not inCombat and interface.button and interface.secure then
			entry.attributes = {
				["type"] = "click",
				["clickbutton"] = interface.button,
			}
		elseif interface.special then
			entry.func = function() addon.display:DisplayInterface(name) end
		else
			entry.func = interface.func
		end
		
		table.insert(menu, entry)
	end
end

local function comp(a, b)
	return a.order < b.order
end

function addon:BuildMenu()
	if not self.updateMenu then
		return
	end
	
	wipe(menu)
	for name, order in pairs(self.db.profile.menu) do
		insertInterface(name, order)
	end
	table.sort(menu, comp)
	
	if not self.db.profile.hideLogoutButtons then
		insertSeparator()
		insertItem(LOGOUT, function() 
			Logout() 
			HideUIPanel(GameMenuFrame) 
		end)
	end
	
	if not self.db.profile.hideLogoutButtons then
		insertItem(EXIT_GAME, function() 
			Quit()
			HideUIPanel(GameMenuFrame)
		end)
	end
	
	if not self.db.profile.hideReloadUIButton then
		insertSeparator()
		insertItem(L["Reload UI"], function() 
			ReloadUI()
		end)
	end
	
	if not self.db.profile.hideOptionsButton then
		insertSeparator()
		insertItem(L["Options"], function() 
			if not InterfaceOptionsFrame:IsVisible() then
				HideUIPanel(GameMenuFrame)
				InterfaceOptionsFrame_OpenToCategory(addon.name)
				InterfaceOptionsFrame_OpenToCategory(addon.name)
			else
				HideUIPanel(InterfaceOptionsFrame)
			end
		end)
	end
	
	self.updateMenu = false
end

function addon:UpdateMenu()
	dropdown:Close()
	addon.updateMenu = true
end

function addon:OpenMenu(frame, button)
	local name
	local isLeftButton = self.db.profile.mouseButton == 1 and button == "LeftButton"
	local isRightButton = self.db.profile.mouseButton == 2 and button == "RightButton"
	
	for _, v in pairs(self.db.profile.accessibility) do
		if not IsModifierKeyDown() and v.modifier == 1
		or IsAltKeyDown() and v.modifier == 4 
		or IsControlKeyDown() and v.modifier == 3 
		or IsShiftKeyDown() and v.modifier == 2 then
			name = v.name
			break
		end
	end
	
	if isLeftButton or isRightButton then
		addon.display:DisplayInterface(name)
	else
		dropdown:Toggle(nil, frame)
	end
end

function addon:IsMenuVisible()
	return dropdown:IsShown()
end