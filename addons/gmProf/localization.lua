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
return end

if LOCALE == "zhCN" then
	-- Chinese translation by EKE
	L["Right-Click"] 		= "右键点击"
	L["Left-Click"] 		= "左键点击"
	L["Middle-Click"] 		= "中键点击"
return end