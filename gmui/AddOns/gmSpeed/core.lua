local ADDON = ...

local UPDATEPERIOD, elapsed = 0.2, 0
local speed
local string_format = string.format
local prgname = "gmSpeed"

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject(prgname, {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
	text = "-"
})


local frame_ms = CreateFrame("Frame", ADDON.."_LDB")
frame_ms:SetScript("OnUpdate", function(self, elap)
	elapsed = elapsed + elap
	if elapsed < UPDATEPERIOD then return end
	elapsed = 0
	speed = (GetUnitSpeed("Player") / 7) * 100
	dataobj.text = string_format("%.1f", speed)
end
)