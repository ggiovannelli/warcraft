-- Inline Localization Snippet, by Morsker!
-- Works as either a standalone file, or as a snippet in a larger file.
-- Inspired by some stuff in Postal and AceLocale.
-- GLOBALS: rawset, geterrorhandler, tostring
do
local addonName, addonScope = ...
--[===[@debug@
local L = setmetatable({}, { __index = function(self, key) rawset(self, key, key); return key; end })
--@end-debug@]===]
--@non-debug@
local L = {
	["Can't keybind in combat."] = "Can't keybind in combat.",
	Full = "Full",
	["Full Screen"] = "Full Screen",
	["Hide Text"] = "Hide Text",
	["Left-Click"] = "Left-Click",
	["Middle-Click"] = "Middle-Click",
	["Right-Click"] = "Right-Click",
	["Show Text"] = "Show Text",
	["Toggle Windowed Mode"] = "Toggle Windowed Mode",
	Win = "Win",
}

setmetatable(L, { __index = function(self, key)
	rawset(self, key, key)
	geterrorhandler()(addonName..": Localization: Missing entry for '"..tostring(key).."'")
	return key
end })

local locale = GetLocale()
if locale == "deDE" then
L["Can't keybind in combat."] = "Es ist nicht möglich Tasten im Kampf zu belegen."
L["Full"] = "Voll"
L["Full Screen"] = "Vollbild"
L["Hide Text"] = "Verstecke Text."
L["Left-Click"] = "Links-Klick"
L["Middle-Click"] = "Mittel-Klick"
L["Right-Click"] = "Rechts-Klick"
L["Show Text"] = "Zeige Text."
L["Toggle Windowed Mode"] = "Fenster Modus umschalten"
L["Win"] = "Fenster"

elseif locale == "esEX" or locale == "exMX" then

elseif locale == "frFR" then

elseif locale == "itIT" then

elseif locale == "koKR" then
L["Can't keybind in combat."] = "전투 상태일 때 단축키를 사용할 수 없습니다."
L["Full"] = "전체"
L["Full Screen"] = "전체 화면"
L["Hide Text"] = "문자 숨김"
L["Left-Click"] = "왼쪽-클릭"
L["Middle-Click"] = "가운데-클릭"
L["Right-Click"] = "오른쪽-클릭"
L["Show Text"] = "문자 표시"
L["Toggle Windowed Mode"] = "창 모드 전환"
L["Win"] = "창"

elseif locale == "ptBR" then

elseif locale == "ruRU" then

elseif locale == "zhCN" then
L["Can't keybind in combat."] = "不可在战斗中绑定快捷键"
L["Full"] = "全屏"
L["Full Screen"] = "全屏幕"
L["Hide Text"] = "隐藏文字"
L["Left-Click"] = "左键点击"
L["Middle-Click"] = "中键点击"
L["Right-Click"] = "右键点击"
L["Show Text"] = "显示文字"
L["Toggle Windowed Mode"] = "切换窗口模式"
L["Win"] = "窗口"

elseif locale == "zhTW" then
L["Can't keybind in combat."] = "不可在戰鬥中綁定快捷鍵"
L["Full"] = "全屏"
L["Full Screen"] = "全螢幕"
L["Hide Text"] = "隱藏文字"
L["Left-Click"] = "左鍵點擊"
L["Middle-Click"] = "中鍵點擊"
L["Right-Click"] = "右鍵點擊"
L["Show Text"] = "顯示文字"
L["Toggle Windowed Mode"] = "切換視窗模式"
L["Win"] = "視窗"

end
--@end-non-debug@
addonScope.L = L
end
