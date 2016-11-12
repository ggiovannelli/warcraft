local ADDON = ...

local ACTSPEC = {}
local MOUSECLICK = {"Left Click", "Shift-Left Click", "Ctrl-Left Click", "Alt-Left Click"}


local prgname = "|cffffd200gmSpecs|r"
local string_format = string.format
local tooltip

local _, class = UnitClass("player")

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("gmSpecs", {
	type = "data source",
	icon = "Interface\\Icons\\INV_Misc_QuestionMark.blp",
	text = "None"
})


local function BuildActiveSpec()

	local i,j
	local index = tonumber(index)
	local ptalenttree = {}


	local ActiveSpec = GetSpecialization()
	if ActiveSpec then
		local id, name, description, icon, background, role = GetSpecializationInfo(ActiveSpec)
		ACTSPEC = { id = id, name = name, description = description, icon = icon , background = background, role = role }
	end

	for i=1, GetMaxTalentTier()  do
	   for j=1, 3 do
			if select(4, GetTalentInfo(i,j,1)) == true then
				ptalenttree[i] = j
			end
	   end
	end

	ACTSPEC["tree"] = table.concat(ptalenttree,"-")
	
end

local function UpdateLDB()
		local currentSpec = GetSpecialization()
		if currentSpec ~= nil then		
			local id, name, description, icon, background, role = GetSpecializationInfo(currentSpec)		
			dataobj.text = name
			dataobj.icon = icon		
		else
			dataobj.icon = "Interface\\Icons\\INV_Misc_QuestionMark.blp"
			dataobj.text = "None"
		end
end


local frame = CreateFrame("Frame")
frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, ...)
			BuildActiveSpec()
			UpdateLDB()
end
)

dataobj.OnClick = function(self, button)  

	if InCombatLockdown() then 
		return 
	end

	if button == "RightButton" then
		ToggleTalentFrame()
    end
	
    if button == "LeftButton" then
	
		if IsShiftKeyDown() then 
			
			SetSpecialization(2)
		
		elseif (IsControlKeyDown() and class ~= "DEMONHUNTER") then 
			
			SetSpecialization(3)
		
		elseif (IsControlKeyDown() and class == "DEMONHUNTER") then
		
			return
		
		elseif (IsAltKeyDown() and class == "DRUID") then 
			
			SetSpecialization(4)		

		elseif (IsAltKeyDown() and class ~= "DRUID") then 
			
			return
		
		else 
		
			SetSpecialization(1)
		
		end
	end
	
end


function dataobj.OnTooltipShow(tooltip)

	tooltip:AddLine(ADDON)
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine(string_format("|T%s:0|t %s",ACTSPEC["icon"],ACTSPEC["name"]),ACTSPEC["tree"],1,1,1, 1,1,1)	
	tooltip:AddLine(" ")


	for index=1,GetNumSpecializations() do
		local id, name, description, icon, background, role = GetSpecializationInfo(index)
		tooltip:AddDoubleLine(MOUSECLICK[index],string_format("|T%s:0|t %s",icon,name))
	end
	
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine("Right Click", 	"Open Talents")
end