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
local options = addon:NewModule("Options.Profiles")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function options:OnInitialize()	
    local profiles = addon.options:AddSubCategory(L["Profiles"])
    profiles:SetDescription(L["You can change the active database profile, so you can have different settings for every character.\n\nAltering profiles reloads the UI immediately."])

    local frame = LibStub("Libra"):CreateAceDBControls(addon.db, profiles)
    
    frame:SetPoint("TOP", -100, -100);
 end