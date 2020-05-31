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

	L["Items reports"]		= "Report degli oggetti"
	L["No items yet"]		= "Nessun oggetto ancora"
	
	L["Whisp player"]		= "Sussura al player"
	L["Show item"]			= "Mostra oggetto"
	
	L["Min Quality"]		= "Qualita' minima"
	L["Equip Only"]			= "Solo equip"
	L["Myself"]				= "Me stesso"
	L["Demo"]				= "Mostra Demo"

	L["Hey, do you mind to trade me %s if you don't need it ?"] = "Hey, mi daresti %s se non ne hai bisogno ?"

	L["DataBroker"]			= "DataBroker"

return end

if LOCALE == "deDE" then
	-- German translations by icemeph
    L["Right-Click"]        = "Rechtsklick"
    L["Left-Click"]         = "Linksklick"
    L["Middle-Click"]       = "Mittelklick"
return end	

if LOCALE == "zhTW" then
	-- Chinese translations by BNS 
	L["Right-Click"] 		= "右鍵點擊"
	L["Left-Click"] 		= "左鍵點擊"
	L["Middle-Click"] 		= "中鍵點擊"
	
	L["Items reports"]		= "物品報告"
	L["No items yet"]		= "尚無物品"
	
	L["Whisp player"]		= "密語玩家"
	L["Show item"]			= "顯示物品"
	
	L["Min Quality"]		= "最低品質"
	L["Equip Only"]			= "只限可裝備"
	L["Myself"]				= "我自己"
	L["Demo"]				= "範例"

	L["Hey, do you mind to trade me %s if you don't need it ?"] = "您好！如果您並不需要 %s 可否交易給我呢？感謝！"
return end

if LOCALE == "zhCN" then
	-- Chinese translation by BNS
	L["Right-Click"] 		= "右键点击"
	L["Left-Click"] 		= "左键点击"
	L["Middle-Click"] 		= "中键点击"
	L["Items reports"]		= "物品报告"

	L["No items yet"]		= "尚无物品"
	
	L["Whisp player"]		= "密语玩家"
	L["Show item"]			= "显示物品"
	
	L["Min Quality"]		= "最低品质"
	L["Equip Only"]			= "只限可装备"
	L["Myself"]				= "我自己"
	L["Demo"]				= "范例"

	L["Hey, do you mind to trade me %s if you don't need it ?"] = "您好！如果您并不需要 %s 可否交易给我呢？感谢！"
return end