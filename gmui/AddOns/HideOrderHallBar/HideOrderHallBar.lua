-- License: Public Domain

local b = OrderHallCommandBar
b:SetScript("OnShow", b.Hide)
b:Hide()

UIParent:UnregisterEvent("UNIT_AURA")
