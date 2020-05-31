local ADDON, namespace = ...
local L = namespace.L
local tooltip
local arg = {}

local prgname = "|cffffd200"..ADDON.."|r"

local LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
local RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
local MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "
 
local LibQTip = LibStub('LibQTip-1.0')
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
 
local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
    text = "-"
}) 

local frame = CreateFrame("Frame")

local function UpdateLDB()
	local otot=0 
	local ntot=0
	local free,bagtype
	
	for i=0,4 do 
		free,bagtype=GetContainerNumFreeSlots(i)
		if bagtype == 0 then 
			ntot = ntot + free
		else
			otot = otot + free
		end 
	end
	
	if otot == 0 then 
		dataobj.text = ntot 
	else
		dataobj.text = ntot .. " : " .. otot
	end
end


local function OnRelease_legenda(self)
	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  
end  
 
local function OnLeave_legenda(self)
	if self.tooltip_legenda and not self.tooltip_legenda:IsMouseOver() then
		self.tooltip_legenda:Release()
	end
end  

local function ShowLegenda(self)
	
	arg = {}

	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil
	
	local row,col
    local tooltip_legenda = LibQTip:Acquire(ADDON.."tip_legenda", 2, "LEFT","RIGHT")
    self.tooltip_legenda = tooltip_legenda 
	tooltip_legenda:SmartAnchorTo(self)
	tooltip_legenda:EnableMouse(true)
	tooltip_legenda.OnRelease = OnRelease_legenda
	tooltip_legenda.OnLeave = OnLeave_legenda
    tooltip_legenda:SetAutoHideDelay(.1, self)
	tooltip_legenda:SetScale(GMBAGSSLOTS_CFG["SCALE"])
	
 	row,col = tooltip_legenda:AddLine("")
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["KNOWLEDGE_BASE"],"CENTER",2)
	
	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,L["Bag List"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Toggle Bag"] .. "|r")

	row,col = tooltip_legenda:AddLine("")	
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,L["DataBroker"],"CENTER",2)
	row,col = tooltip_legenda:AddSeparator()
	row,col = tooltip_legenda:AddLine()
	
	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Open all bags"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. L["Close all bags"] .. "|r")

	row,col = tooltip_legenda:AddLine("")		
	row,col = tooltip_legenda:AddLine("")		

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["SHIFT_KEY"] .. " " .. LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200 - " .. _G["UI_SCALE"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["SHIFT_KEY"] .. " " ..RightButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200 + " .. _G["UI_SCALE"] .. "|r")

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["SHIFT_KEY"] .. " " ..MiddleButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200 1.0 " .. _G["UI_SCALE"] .. "|r")

	row,col = tooltip_legenda:AddLine("")		
	row,col = tooltip_legenda:AddLine("")	

	row,col = tooltip_legenda:AddLine()
	tooltip_legenda:SetCell(row,1,_G["ALT_KEY"] .. " " ..LeftButton)
	tooltip_legenda:SetCell(row,2,"|cffffd200" .. _G["KNOWLEDGE_BASE"] .. "|r")
	
	tooltip_legenda:Show()
end


local function Button_OnClick(row,arg,button)
	
	ToggleBag(arg.bagnum)

end
 
local function OnRelease(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end  
 
local function OnLeave(self)
	if self.tooltip and not self.tooltip:IsMouseOver() then
		self.tooltip:Release()
	end
end  
 
local function anchor_OnEnter(self)

	local free,tot,bagname,bagtype,delta
	arg = {}

	LibQTip:Release(self.tooltip)
	self.tooltip = nil  

    local row,col
    local tooltip = LibQTip:Acquire(ADDON.."tip", 2, "LEFT", "RIGHT")
    self.tooltip = tooltip 
    tooltip:SmartAnchorTo(self)
	tooltip:EnableMouse(true)
	tooltip.OnRelease = OnRelease
	tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)
	tooltip:SetScale(GMBAGSSLOTS_CFG["SCALE"])

	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,prgname,"CENTER",2)

	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")

	
	for i=0,4 do 
		if GetBagName(i) then	
			free,bagtype=GetContainerNumFreeSlots(i)
			tot=GetContainerNumSlots(i)
			bagname=GetBagName(i)
						
			if bagtype == 0 then delta = 0 else delta = 1 end
			
			row,col = tooltip:AddLine()
			tooltip:SetCell(row,1,bagname)
			tooltip:SetCell(row,2,free.." : "..tot)
			if free == 0 then
				tooltip:SetCellTextColor(row,2,1,0,delta,1)
			else
				tooltip:SetCellTextColor(row,2,0,1,delta,1)
			end
			arg[row] = { tooltip=tooltip, bagnum = i }
			tooltip:SetLineScript(row, 'OnMouseUp', Button_OnClick, arg[row])
		end 
	end
	
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine("")
	row,col = tooltip:AddLine()
	tooltip:SetCell(row,1,_G["ALT_KEY"] .. " " .. LeftButton .. " |cffffd200" .. _G["KNOWLEDGE_BASE"] .. "|r","RIGHT",2)

	
	row,col = tooltip:Show()
end
 
dataobj.OnEnter = function(self)
    anchor_OnEnter(self)
end
 
dataobj.OnLeave = function(self)
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

dataobj.OnClick = function(self, button)  

	local config_changed = false
	
	LibQTip:Release(self.tooltip_legenda)
	self.tooltip_legenda = nil  
	
	LibQTip:Release(self.tooltip)
	self.tooltip = nil

	if IsShiftKeyDown() then 	
		if button == "LeftButton" then	
			if GMBAGSSLOTS_CFG["SCALE"] < 0.8 then return end
			GMBAGSSLOTS_CFG["SCALE"] = GMBAGSSLOTS_CFG["SCALE"] - 0.05
			config_changed = true
		end

		if button == "RightButton" then 
			if GMBAGSSLOTS_CFG["SCALE"] > 2 then return end
			GMBAGSSLOTS_CFG["SCALE"] = GMBAGSSLOTS_CFG["SCALE"] + 0.05
			config_changed = true
		end
		
		if button == "MiddleButton" then 
			GMBAGSSLOTS_CFG["SCALE"] = 1
			config_changed = true
		end
	end

	if IsAltKeyDown() then
		if 	button == "LeftButton" then 
			ShowLegenda(self)
		end
	end

	if not IsModifierKeyDown() then 
		if 	button == "RightButton" then  
			CloseAllBags()
		elseif button == "LeftButton" then
			OpenAllBags()
		end
	end
	
	if config_changed then 
		print(string.format("|cFFFFFF00%s|r config: scale %s",ADDON,GMBAGSSLOTS_CFG["SCALE"]))
	end
end

frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)

	if event == "PLAYER_LOGIN" then 
		GMBAGSSLOTS_CFG = GMBAGSSLOTS_CFG or {}
		local GMBAGSSLOTS_DEFAULTS = { SCALE = 1}
		for k in pairs(GMBAGSSLOTS_DEFAULTS) do
			if GMBAGSSLOTS_CFG[k] == nil then GMBAGSSLOTS_CFG[k] = GMBAGSSLOTS_DEFAULTS[k] end
		end
	end
	UpdateLDB()
end)