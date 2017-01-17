-- I want to say thanks to the people in wowinterface forum for the help, code and over all ... patience :-)
-- Phanx, Torhal, Tageshi, SDPhantom, cokedrivers and all the others. 
-- http://www.wowinterface.com/forums/showthread.php?p=299262#post299184

local ADDON = ...
local prgname = "|cffffd200gmProf|r"
local playerName = UnitName("player")
local string_format = string.format
local tooltip

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("gmProf", {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
	text = playerName .. " profs"
})

-- idea and code by SDPhantom ----------
dataobj.OnClick = function(self, button)  

	if InCombatLockdown() then 
		return 
	end

	
--  Get profession IDs
    local prof1,prof2,_=GetProfessions()
	
--  Select based on button pressed
    local name, tex, offset
	
    if (button == "LeftButton" and prof1) then
        name, tex, _, _, _, offset = GetProfessionInfo(prof1)
		CastSpell(offset+1,BOOKTYPE_PROFESSION)
    elseif (button == "RightButton" and prof2) then
        name, tex, _, _, _, offset = GetProfessionInfo(prof2)
		CastSpell(offset+1,BOOKTYPE_PROFESSION)
    elseif button == "MiddleButton" then
        ToggleSpellBook(BOOKTYPE_PROFESSION)
        return
    end
end

function dataobj.OnTooltipShow(tooltip)
	local i

	tooltip:AddLine(ADDON)
	tooltip:AddLine(" ")
	
	-- code by: cokedrivers 
	-- http://www.wowinterface.com/downloads/info19814-nData.html
	for i = 1, select("#", GetProfessions()) do
		local v = select(i, GetProfessions())
		if v ~= nil then
			local name, icon, rank, maxrank = GetProfessionInfo(v)
			tooltip:AddDoubleLine(string_format("|T%s:0|t %s",icon, name), string_format("%d / %d",rank, maxrank) ,1,1,1, 1,1,1)	
		end
	end
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine("Left Click", 	"Profession #1")
	tooltip:AddDoubleLine("Right Click", 	"Profession #2")
	tooltip:AddDoubleLine("Middle Click", 	"Spellbook")
end