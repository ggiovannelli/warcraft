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
local ui = addon:NewModule("Options.UI")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

LibStub("Libra"):EmbedWidgets(ui)

local function compByName(a, b)
	return a:GetText():lower() < b:GetText():lower()
end

local function createSeparator(parent, from, to)
	local line = parent:CreateTexture()
	line:SetPoint(unpack(from))
	line:SetPoint(unpack(to))
	line:SetHeight(1)
	line:SetTexture(0.8, 0.8, 0.8, 0.5)
end

function ui:CreateSeparator(parent)
	if parent.label then
		parent:SetPoint("RIGHT", -31, 0)
		parent:SetHeight(1)
		parent.label:ClearAllPoints()
		parent.label:SetPoint("CENTER")
		createSeparator(parent, {"LEFT", parent}, {"RIGHT", parent.label, "LEFT", -5, 0})
		createSeparator(parent, {"RIGHT", parent}, {"LEFT", parent.label, "RIGHT", 5, 0})
	else
		local relativeTo = parent.desc or parent
		createSeparator(parent, {"BOTTOMLEFT", parent.desc, 0, 0}, {"BOTTOMRIGHT", parent.desc, 0, 0})
	end
end

function ui:CreateListItem()
	local frame = CreateFrame("Button")
	frame:SetSize(220, 16)
	frame:SetPushedTextOffset(0, 0)
	frame:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
	
	local font = frame:CreateFontString(nil, nil, "GameFontHighlight")
	font:SetJustifyH("LEFT")
	font:SetAllPoints()
	
	frame:SetFontString(font)
	
	local item = {}

	function item:Select()
		frame.selected = true
		frame:LockHighlight()
	end

	function item:Deselect()
		frame.selected = false
		frame:UnlockHighlight()
	end
    
    function item:Remove()
		self:Deselect()
        
        font:Hide()
        font:SetText(nil)
        font:ClearAllPoints()
        font = nil
        
        frame:Hide()
        frame:SetScript("OnClick", nil)
		frame:SetParent(nil)
        frame:ClearAllPoints()
		frame = nil
        
        item = nil;
	end
	
	function item:IsSelected()
		return frame.selected
	end
	
	function item:SetText(value)
		frame:SetText(value)
	end
	
	function item:GetText()
		return frame:GetText()
	end
	
	function item:Copy(destItem)
		destItem:SetText(self:GetText())
	end
	
	frame:SetScript("OnClick", function() 
		if not item:IsSelected() then
			item:Select()
		else
			item:Deselect()
		end
	end)

	item.frame = frame
	
	return item
end

function ui:CreateList(parent)
	parent = parent.frame or parent
	
	local frame = CreateFrame("Frame", nil, parent)

	local title = frame:CreateFontString(nil, nil, "GameFontNormal")
	title:SetPoint("TOP", 0, 20)
	title:SetText(name)
	title:SetSize(220, 16)

	local bg = frame:CreateTexture(nil, "BORDER")
	bg:SetTexture(0.3, 0.3, 0.3)
	bg:SetBlendMode("MOD")
	bg:SetAllPoints()

	local border = frame:CreateTexture(nil, "BORDER", nil, -1)
	border:SetTexture(0.5, 0.5, 0.5, 0.3)
	border:SetPoint("TOPLEFT", bg, -1, 1)
	border:SetPoint("BOTTOMRIGHT", bg, 1, -1)	
	
	local count = 0
	local list, items = {}, {}
	
	function list:SetTitle(value)
		title:SetText(value)
	end
	
	function list:SetSize(width, height)
		frame:SetSize(width, height)
	end
	
	function list:SetPoint(point, relativeTo, ...)
		frame:SetPoint(point, type(relativeTo) == "table" and relativeTo.frame or relativeTo, ...)
	end
	
	function list:AddItem(item)
		count = count + 1
		
		table.insert(items, item)
		
		local child = item.frame
		child:SetParent(frame)
        
		if count == 1 then
			child:SetPoint("TOPLEFT", frame, 10, -10)
		else
			local parent = items[count - 1].frame
			child:SetPoint("TOP", parent, "BOTTOM")
		end
	end
	
	function list:RemoveItem(index)
		local item = table.remove(items, index)
		
		if not item then
			return
		end
		
		if item:IsSelected() then
			item:Deselect()
		end
        
        item:Remove();
        
		count = count - 1
	end
	
	function list:Update()
		for i, item in ipairs(items) do
			local child = item.frame
			child:ClearAllPoints()
			if i == 1 then
				child:SetPoint("TOPLEFT", frame, 10, -10)
			else
				local parent = items[i - 1].frame
				child:SetPoint("TOP", parent, "BOTTOM")
			end
		end
	end
	
	function list:Items()
		return ipairs(items)
	end
	
	local function reverse()
		local i = #items + 1
		return function ()
			i = i - 1
			if i > 0 then return i, items[i] end
		end
	end
	
	function list:Sort(comp)
		table.sort(items, comp)
		self:Update()
	end
	
	function list:CopyItem(item)
		local destItem = ui:CreateListItem()
		item:Copy(destItem)
		self:AddItem(destItem)
	end
	
	function list:MoveSelectedTo(destList)
		for i, item in reverse() do
			if item:IsSelected() then
				destList:CopyItem(item)
				self:RemoveItem(i)
			end	
		end
		destList:Sort(compByName)
		self:Sort(compByName)
	end
	
	local function selectedItems()
		local i = 0
		local n = 0
		local max = #items
		return function ()
			while n <= max do
				n = n + 1
				local item = items[n]
				if item and item:IsSelected() then
					i = i + 1
					return i, n, item
				end
			end
			return nil
		end
	end
	
	local function swap(sourceIndex, destIndex)
		items[sourceIndex], items[destIndex] = items[destIndex], items[sourceIndex]
	end
	
	local function moveSelected(up)
		local selectedIndices = {}
		for i, n in selectedItems() do
			selectedIndices[i] = n
		end
		local i = up and 1 or #selectedIndices
		local selectedIndex = selectedIndices[i]
		while selectedIndex do
			local index = up and selectedIndex - 1 or selectedIndex + 1
			if count >= index and index > 0 then
				swap(selectedIndex, index)
			end
			i = up and i + 1 or i - 1
			selectedIndex = selectedIndices[i]
		end
	end
	
	function list:MoveSelectedDown()
		moveSelected()
		self:Update()
	end
	
	function list:MoveSelectedUp()
		moveSelected(true)
		self:Update()
	end
	
	function list:Clear()
		for i in reverse() do
			self:RemoveItem(i)
		end
	end
	
	list.frame = frame
	
	return list
end

function ui:CreateButton(parent)
	parent = parent.frame or parent
	
	local frame = CreateFrame("Button", nil, parent)
	frame:SetSize(24, 24)
	frame:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
	
	local button = {}
	
	function button:SetSize(width, height)
		frame:SetSize(width, height)
	end
	
	function button:SetPoint(point, relativeTo, ...)
		frame:SetPoint(point, type(relativeTo) == "table" and relativeTo.frame or relativeTo, ...)
	end
	
	function button:SetNormalTexture(texture)
		frame:SetNormalTexture(texture)
	end

	function button:SetPushedTexture(texture)
		frame:SetPushedTexture(texture)
	end
	
	function button:OnClick(handler)
		frame:SetScript("OnClick", function() 
			handler()
		end)
	end
	
	button.frame = frame
	
	return button
end