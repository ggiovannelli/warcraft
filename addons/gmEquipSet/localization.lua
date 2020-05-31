-- Thanks to phanx for her excellent (as usual) tutorial on addons localization.
-- https://phanx.net/addons/tutorials/localize

local _, namespace = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

namespace.L = L

local LOCALE = GetLocale()

if LOCALE == "enUS" then
	-- The EU English game client also
	-- uses the US English locale code.
return end

if LOCALE == "itIT" then
	-- Italian translations by me
	L["Right-Click"] 		= "Tasto-Destro"
	L["Left-Click"] 		= "Tasto-Sinistro"
	L["Middle-Click"] 		= "Tasto-Centrale"
	L["Equipment Sets"] 	= "Set di equipaggiamento:"
	L["Equip Set"] 			= "Usa set"
	L["Set Manager"] 		= "Gestore set"	
	L["Save Set"]			= "Salva set"
	L["Set saved"] 			= "Set salvato"
	L["No Set"]				= "Nessun Set"
return end

if LOCALE == "deDE" then
	-- German translations by icemeph
    L["Right-Click"]        = "Rechtsklick"
    L["Left-Click"]         = "Linksklick"
    L["Middle-Click"]       = "Mittelklick"
    L["Equipment Sets"]    = "Ausrüstungssätze"
    L["Equip Set"]      	= "Ausrüstungssatz"
    L["Set Manager"]    	= "Ausrüstungsmanager"    
    L["Save Set"]       	= "Ausrüstungssatz speichern"
    L["Set saved"]      	= "Ausrüstungssatz gespeichert"
return end	

if LOCALE == "zhTW" then
	-- Chinese translations by BNS 
	L["Right-Click"] 		= "右鍵點擊"
	L["Left-Click"] 		= "左鍵點擊"
	L["Middle-Click"] 		= "中鍵點擊"
	L["Equipment Sets"] 	= "套裝設置"
	L["Equip Set"] 			= "裝備套裝"
	L["Set Manager"] 		= "套裝管理"	
	L["Save Set"]			= "儲存套裝"
	L["Set saved"] 			= "套裝已儲存"
return end

if LOCALE == "zhCN" then
	-- Chinese translations by EKE
	L["Right-Click"] = "右键点击"
	L["Left-Click"] = "左键点击"
	L["Middle-Click"] = "中键点击"
	L["Equipment Sets"] = "套装设置"
	L["Equip Set"] = "装备套装"
	L["Set Manager"] = "套装管理"
	L["Save Set"] = "储存套装"
	L["Set saved"] = "套装已储存"
return end