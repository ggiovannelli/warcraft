-- Most of the addon code and fixes are by Vrul (really much appreciated)
-- You can check the forum here:
-- http://www.wowinterface.com/forums/showthread.php?t=54975

local ADDON, namespace = ...
local L = namespace.L
local tooltip
local arg = {}

local talents
local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "


local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Icons\\INV_Misc_QuestionMark.blp",
    text = "-"
})

local function StringTalent()

	talents = ""
	for tier = 1, GetMaxTalentTier()  do
		local talentTier = "x"
		for column = 1, 3 do
			local talentID, name, texture, selected = GetTalentInfo(tier, column, 1)
			if selected then
				talentTier = column
				break
			end
		end
		if talents ~= "" then
			talents = talents .. "." .. talentTier
		else
			talents = talentTier
		end
	end
	return talents
end


local function Button_OnClick(row,arg,button)

	if InCombatLockdown() then return end
	
	if button == "LeftButton" and GetSpecialization() ~= arg then
		SetSpecialization(arg.index)
	elseif button == "RightButton" then
		ToggleTalentFrame()
	end
	
	LibQTip:Release(arg.tooltip)
	arg.tooltip = nil
	
end
 
local function OnRelease(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end  

local function anchor_OnEnter(self)

	arg = {}
	
	if self.tooltip then
		LibQTip:Release(self.tooltip)
		self.tooltip = nil  
	end
	
    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 2, "LEFT", "LEFT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	    
    row,col = tooltip:AddLine("|cffffd200" .. L["Talent tree"] .."|r",StringTalent())
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	
	local currentSpec = GetSpecialization()
		
	for i = 1, GetNumSpecializations() do
		local id, name, description, icon, background, role = GetSpecializationInfo(i)

		row,col = tooltip:AddLine(string.format("|T%s:0|t %s",icon,name))
		
		if currentSpec == i then 
			tooltip:SetLineTextColor(row,0,1,0,1)
		else
			arg[row] = { tooltip=tooltip, index=i }
			tooltip:SetLineScript(row, 'OnMouseDown', Button_OnClick, arg[row])
		end
	end
	
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,LeftButton .. "|cffffd200" .. L["Specialization"] .. "|r","LEFT",1,0,15)
	tooltip:SetCell(row,2,RightButton .. "|cffffd200" .. L["Talents"] .. "|r","RIGHT")

    row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

dataobj.OnClick = function(self, button)

	if InCombatLockdown() then return end

	if button == "RightButton" then
		ToggleTalentFrame()
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
frame:SetScript("OnEvent", function(self, event, ...)
	
	local activeSpec = GetSpecialization()
	if activeSpec then
		local id, name, description, icon = GetSpecializationInfo(activeSpec)
		dataobj.text = name
		dataobj.icon = icon     
	else
		dataobj.icon = "Interface\\Icons\\INV_Misc_QuestionMark.blp"
		dataobj.text = "None"
	end

end)