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
local display = LibStub("EasyDisplay-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local function addons()
	local n = 1
	local count = 0
	local max = 40
	local addons = GetNumAddOns()
	return function ()
		for i = n, addons do
			local name, _, _, enabled = GetAddOnInfo(i)
			if count <= max and enabled then
				n = i + 1
				count = count + 1
				return name, GetAddOnMemoryUsage(i)
			end
		end
	end
end

local function getTotalMemUsage()
	UpdateAddOnMemoryUsage()
	
	local long, short
	local totalMem = 0
	
	for _, mem in addons() do
		totalMem = totalMem + mem
	end
	
	if totalMem > 0 then
		if totalMem > 1000 then
			totalMem = totalMem / 1000
			short = format("%.2f MB", totalMem)
			long = format(TOTAL_MEM_MB_ABBR, totalMem)
		else
			short = format("%.0f KB", totalMem)
			long = format(TOTAL_MEM_KB_ABBR, totalMem)
		end
	end
	
	return totalMem, long, short
end

local topAddOns = { }
local numAddOns = 0
local tooltip = GameTooltip

function addon:UpdateTooltip()
	local db = self.db.profile
	
	if db.hideTooltip then
		return
	end

	if numAddOns ~= db.numAddOns then
		for i=1, db.numAddOns do
			topAddOns[i] = { value = 0, name = "" }
		end
		numAddOns = db.numAddOns
	end

	local text = ""
	local i, j, k = 0, 0, 0
	
	tooltip:ClearLines()
	
	tooltip:AddLine(self.name, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)

	-- latency
	local _, _, latencyHome, latencyWorld = GetNetStats()
	text = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
	tooltip:AddLine(" ")
	tooltip:AddLine(text, 1.0, 1.0, 1.0)
	if SHOW_NEWBIE_TIPS == "1" then
		tooltip:AddLine(NEWBIE_TOOLTIP_LATENCY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	end
	tooltip:AddLine(" ")
	
	-- framerate
	text = format(MAINMENUBAR_FPS_LABEL, GetFramerate())
	tooltip:AddLine(text, 1.0, 1.0, 1.0)
	if SHOW_NEWBIE_TIPS == "1" then
		tooltip:AddLine(NEWBIE_TOOLTIP_FRAMERATE, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	end
	
	local bandwidth = GetAvailableBandwidth()
	if not bandwidth == 0 then
		tooltip:AddLine(" ")
		text = format(MAINMENUBAR_BANDWIDTH_LABEL, GetAvailableBandwidth())
		tooltip:AddLine(text, 1.0, 1.0, 1.0)
		if SHOW_NEWBIE_TIPS == "1" then
			tooltip:AddLine(NEWBIE_TOOLTIP_BANDWIDTH, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
		end
	end

	local percent = floor(GetDownloadedPercentage() * 100 + 0.5)
	if not percent == 0 then
		tooltip:AddLine(" ")
		text = format(MAINMENUBAR_DOWNLOAD_PERCENT_LABEL, percent)
		tooltip:AddLine(text, 1.0, 1.0, 1.0)
		if ( SHOW_NEWBIE_TIPS == "1" ) then
			tooltip:AddLine(NEWBIE_TOOLTIP_DOWNLOAD_PERCENT, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
		end
	end

	-- memory
	local totalMem, totalText = getTotalMemUsage()
	
	if totalMem > 0 then
		local mem
		
		for i = 1, db.numAddOns, 1 do
			topAddOns[i].value = 0
		end
		
		for name, mem in addons() do
			for j = 1, db.numAddOns, 1 do
				if mem > topAddOns[j].value then
					for k = db.numAddOns, 1, -1 do
						if k == j then
							topAddOns[k].value = mem
							topAddOns[k].name = name
							break
						elseif k ~= 1 then
							topAddOns[k].value = topAddOns[k-1].value
							topAddOns[k].name = topAddOns[k-1].name
						end
					end
					break
				end
			end
		end
		
		tooltip:AddLine(" ")
		tooltip:AddLine(totalText, 1.0, 1.0, 1.0)
		if SHOW_NEWBIE_TIPS == "1" then
			tooltip:AddLine(NEWBIE_TOOLTIP_MEMORY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
		end
		
		for i = 1, db.numAddOns, 1 do
			if topAddOns[i].value == 0 then
				break
			end
			
			local size = topAddOns[i].value
			
			if size > 1000 then
				size = size / 1000
				text = format(ADDON_MEM_MB_ABBR, size, topAddOns[i].name)
			else
				text = format(ADDON_MEM_KB_ABBR, size, topAddOns[i].name)
			end
			
			tooltip:AddLine(text, 1.0, 1.0, 1.0)
		end
	end
	
	-- accessibility
	if not db.hideTooltipAccessibilityBindings then
		tooltip:AddLine(" ")
		
		local text = ""

		for i, v in ipairs(db.accessibility) do 
			local mouseButton = addon.buttons[db.mouseButton]
			if v.modifier == 1 then
				text = ": |cffffffff" .. mouseButton .. "|r"
			else
				text = ": |cffffffff" .. mouseButton .. " + " .. addon.modifiers[v.modifier] .. "|r"
			end
			text = display:GetInterface(v.name).title .. text
			tooltip:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		end
	end
	
	tooltip:Show()
end