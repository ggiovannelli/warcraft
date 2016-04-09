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
local options = addon:NewModule("Options.Menu")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local function menuItems()
	local index = 0
	return function ()
		index = index + 1
		for name, order in pairs(addon.db.profile.menu) do
			if order == index then
				return name
			end
		end
	end
end

local function updateMenuDb(visibleItems)
	local menu = {}
	for i, item in visibleItems:Items() do
		local interface = addon.display:GetInterface(item:GetText())
		menu[interface.name] = i
	end
	-- Sets items that are not visible with zero so when the list of visible items is empty 
	--	AceDB won't change back to the default profile and everything will reset.
	for _, interface in addon.display:Interfaces() do
		local exists = menu[interface.name]
		if not exists then
			menu[interface.name] = 0
		end
	end
	addon.db.profile.menu = menu
	addon:UpdateMenu()
end

local function addAvailableItems(availableItems)
	for _, interface in addon.display:Interfaces() do
		local order = addon.db.profile.menu[interface.name]
		if order == 0 then
			local item = ui:CreateListItem()
			item:SetText(interface.title)
			availableItems:AddItem(item)
		end
	end
end

local function addVisibleItems(visibleItems)
	for name in menuItems() do
		local interface = addon.display:GetInterface(name)
		if interface and interface.title then
			local item = ui:CreateListItem()
			item:SetText(interface.title)
			visibleItems:AddItem(item)
		end
	end
end

local function reset(availableItems, visibleItems)
	visibleItems:Clear()
	addVisibleItems(visibleItems)
	updateMenuDb(visibleItems)
	
	availableItems:Clear()
	addAvailableItems(availableItems)
	
	addon:UpdateMenu()
end

function options:OnInitialize()	
	local order = addon.options:AddSubCategory(L["Menu"])
	
	local availableItems = ui:CreateList(order)
	availableItems:SetTitle("Available Interfaces")
	availableItems:SetPoint("TOPLEFT", 10, -80)
	availableItems:SetSize(220, 435)
	
	local visibleItems = ui:CreateList(order)
	visibleItems:SetTitle("Visible Menu Items")
	visibleItems:SetPoint("TOPLEFT", availableItems, "TOPRIGHT", 23, 0)
	visibleItems:SetSize(220, 435)
	
	reset(availableItems, visibleItems)
	
	local addToButton = ui:CreateButton(availableItems)
	addToButton:SetSize(24, 24)
	addToButton:SetPoint("CENTER", availableItems, "RIGHT", 12, 0)
	addToButton:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
	addToButton:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]])
	addToButton:OnClick(function()	
		availableItems:MoveSelectedTo(visibleItems)
		updateMenuDb(visibleItems)
	end)

	local removeFromButton = ui:CreateButton(availableItems)
	removeFromButton:SetSize(24, 24)
	removeFromButton:SetPoint("TOP", addToButton, "BOTTOM")
	removeFromButton:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]])
	removeFromButton:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Down]])
	removeFromButton:OnClick(function()
		visibleItems:MoveSelectedTo(availableItems)
		updateMenuDb(visibleItems)
	end)

	local moveUpButton = ui:CreateButton(visibleItems)
	moveUpButton:SetSize(24, 24)
	moveUpButton:SetPoint("TOPLEFT", visibleItems, "TOPRIGHT", 0, 5)
	moveUpButton:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollUp-Up]])
	moveUpButton:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollUp-Down]])
	moveUpButton:OnClick(function()
		visibleItems:MoveSelectedUp()
		updateMenuDb(visibleItems)
	end)
	
	local moveDownButton = ui:CreateButton(visibleItems)
	moveDownButton:SetSize(24, 24)
	moveDownButton:SetPoint("TOP", moveUpButton, "BOTTOM")
	moveDownButton:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
	moveDownButton:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
	moveDownButton:OnClick(function()
		visibleItems:MoveSelectedDown()
		updateMenuDb(visibleItems)
	end)
end
