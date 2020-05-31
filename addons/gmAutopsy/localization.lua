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
	L["Time"] 				= "Orario"
	L["Source"]				= "Sorgente"
	L["Target"]				= "Bersaglio"
	L["Spell"]				= "Incantesimo"
	L["Damage"]				= "Danno"
	L["Overkill"]			= "Eccedenza"
	L["Channel"] 			= "Canale"
	L["Report on|off"]		= "Report On/Off"
	L["Reset Data"]			= "Reset dei dati"
	L["Demo"]				= "Mostra Demo"
	L["No deaths recorded yet"] = "Nessuna uccisione registrata"
	L["Whisp Player"]		= "Sussura al player"
	L["Show Spell"]			= "Mostra Incantesimo"
	L["You was killed by %s with %s overkill %s"] = "Sei stato ucciso da %s con %s eccedenza di %s" 
	L["%s: %s killed %s with %s damage of %s overkill %s"] = "%s: %s ha ucciso %s con %s danno di %s eccessivo di %s"
	L["%s: %s killed %s with %s melee overkill %s"] = "%s: %s ha ucciso %s con %s melee eccessivo di %s"
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
	L["Time"] 				= "時間"
	L["Source"]				= "來源"
	L["Target"]				= "目標"
	L["Spell"]				= "法術"
	L["Damage"]				= "傷害"
	L["Overkill"]			= "過量"
	L["Channel"] 			= "頻道"
	L["Report on|off"]		= "報告 On/Off"
	L["Reset Data"]			= "重設數據"
	L["Demo"]				= "範例"
	L["No deaths recorded yet"] = "尚未有死亡紀錄"		
	L["Whisp Player"]		= "密語玩家"
	L["Show Spell"]			= "顯示法術"
	L["You was killed by %s with %s overkill %s"] = "你被擊殺透由%s 傷害%s 過量%s" 
	L["%s: %s killed %s with %s damage of %s overkill %s"] = "%s: %s 擊殺了%s 透由%s 傷害為%s 過量%s"
	L["%s: %s killed %s with %s melee overkill %s"] = "%s: %s 擊殺了%s 傷害為%s近戰攻擊 過量%s"
return end

if LOCALE == "zhCN" then
	-- Chinese translation by BNS
	L["Right-Click"] 		= "右键点击"
	L["Left-Click"] 		= "左键点击"
	L["Middle-Click"] 		= "中键点击"
	L["Time"] 				= "时间"
	L["Source"]				= "来源"
	L["Target"]				= "目标"
	L["Spell"]				= "法术"
	L["Damage"]				= "伤害"
	L["Overkill"]			= "过量"
	L["Channel"] 			= "频道"
	L["Report on|off"]		= "报告 On/Off"
	L["Reset Data"]			= "重设数据"
	L["Demo"]				= "范例"
	L["No deaths recorded yet"] = "尚未有死亡纪录"
	L["Whisp Player"]		= "密语玩家"
	L["Show Spell"]			= "显示法术"
	L["You was killed by %s with %s overkill %s"] = "你被击杀透由%s 伤害%s 过量%s" 
	L["%s: %s killed %s with %s damage of %s overkill %s"] = "%s: %s 击杀了%s 透由%s 伤害为%s 过量%s"
	L["%s: %s killed %s with %s melee overkill %s"] = "%s: %s 击杀了%s 伤害为%s近战攻击 过量%s"
return end