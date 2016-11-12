local addonName, addon = ...
local options = addon:NewModule("Options.Profiles")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function options:OnInitialize()	
    local profiles = addon.options:AddSubCategory(L["Profiles"])
    profiles:SetDescription(L["You can change the active database profile, so you can have different settings for every character.\n\nAltering profiles reloads the UI immediately."])

    local frame = LibStub("Libra"):CreateAceDBControls(addon.db, profiles)
    
    frame:SetPoint("TOP", -100, -100);
 end