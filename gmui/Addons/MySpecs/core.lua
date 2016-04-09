local ADDON = ...

local PRISPEC = {}
local SECSPEC = {}

local prgname = "|cffffd200MySpecs|r"
local string_format = string.format
local tooltip


local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("MySpecs", {
	type = "data source",
	icon = "Interface\\Icons\\INV_Misc_QuestionMark.blp",
	text = "None"
})


local function BuildSpec()

	local i,j
	local index = tonumber(index)
	local ptalenttree = {}
	local stalenttree = {}

	local primarySpec = GetSpecialization(false, false, 1)
	if primarySpec ~= nil then
		local id, name, description, icon, background, role = GetSpecializationInfo(primarySpec)
		PRISPEC = { id = id, name = name, description = description, icon = icon , background = background, role = role }
	end
	
	local secondarySpec = GetSpecialization(false, false, 2)
	if secondarySpec ~= nil then
		local id, name, description, icon, background, role = GetSpecializationInfo(secondarySpec)
		SECSPEC = { id = id, name = name, description = description, icon = icon , background = background, role = role }
	end

	for i=1, GetMaxTalentTier()  do
	   for j=1, 3 do
			if select(4, GetTalentInfo(i,j,1)) == true then
				ptalenttree[i] = j
			end

			if secondarySpec ~= nil then
				if select(4, GetTalentInfo(i,j,2)) == true then 
					stalenttree[i] = j
				end 
			end
	   end
	end

	PRISPEC["tree"] = table.concat(ptalenttree,"-")
	SECSPEC["tree"] = table.concat(stalenttree,"-")

							
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
			BuildSpec()
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
        
		if GetActiveSpecGroup() == 1 then
			SetActiveSpecGroup(2)
		elseif GetActiveSpecGroup() == 2 then
			SetActiveSpecGroup(1)
		end
		
    end

end


function dataobj.OnTooltipShow(tooltip)

	tooltip:AddLine(ADDON)
	tooltip:AddLine(" ")

	local primarySpec = GetSpecialization(false, false, 1)
		if primarySpec ~= nil then
			tooltip:AddDoubleLine(string_format("|T%s:0|t %s",PRISPEC["icon"],PRISPEC["name"]),PRISPEC["tree"],1,1,1, 1,1,1)	
		end

	local secondarySpec = GetSpecialization(false, false, 2)
		if secondarySpec ~= nil then
			local id, name, description, icon, background, role = GetSpecializationInfo(secondarySpec)
			tooltip:AddLine(" ")
			tooltip:AddDoubleLine(string_format("|T%s:0|t %s",SECSPEC["icon"],SECSPEC["name"]),SECSPEC["tree"],1,1,1, 1,1,1)
		end

	tooltip:AddLine(" ")
	tooltip:AddDoubleLine("Left Click", "Change Active Spec")
	tooltip:AddDoubleLine("Right Click", "Open Talents")
end