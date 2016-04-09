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

local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true, false)

L["Reload UI"] = true
L["Options"] = true

L["Block the menu in combat"] = true
L["Hide the logout and exit items from the menu"] = true
L["Hide the reload item from the menu"] = true
L["Hide the options item from the menu"] = true
L["Hide key bindings from the menu"] = true

L["Tooltip"] = true
L["Hide tooltip"] = true
L["Max number of addons to display"] = true

L["Accessibility"] = true
L["Bind up to four menu items to the mouse which you can use to open them quickly by clicking on the broker display."] = true
L["Mouse Setting"] = true
L["Hide the bindings from the tooltip"] = true

L["Menu"] = true
L["Sort the order of the menu items.\n\nNote, having no sorting order (zero) hides the item from the menu."] = true

L["Profiles"] = true
L["You can change the active database profile, so you can have different settings for every character.\n\nAltering profiles reloads the UI immediately."] = true