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
	L["Show Guild"]			= "Mostra gilda"
	L["Show Battle.net"]	= "Mostra amici Battle.net"
	L["Show FriendList"]	= "Mostra amici"
	L["Show Help"]			= "Mostra legenda"
	L["Show Guild Message"]	= "Mostra messaggio di gilda"
	L["Show Player Info"]	= "Mostra informazioni aggiuntive sui giocatori"
	L["Note"]				= "Note"
	L["Officer Note"]		= "Note del GM"
	L["Achievements Points"]= "Punti impresa"
	L["Show only playing Battle.net Friends"] = "Mostra solo amici Battle.net in gioco"
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
	L["Show Guild"]			= "顯示公會"
	L["Show Battle.net"]	= "顯示戰網"
	L["Show FriendList"]	= "顯示好友名單"
	L["Show Help"]			= "顯示幫助"
	L["Show Guild Message"]	= "顯示公會訊息"
	L["Show Player Info"]	= "顯示有關玩家的資訊"
	L["Note"]				= "註記"
	L["Officer Note"]		= "幹部註記"
	L["Achievements Points"]= "成就點數"
	L["Show only playing Battle.net Friends"] = "僅顯示正在遊戲中的戰網好友"
return end

if LOCALE == "zhCN" then
	-- Chinese translation by BNS & EKE
	L["Right-Click"] 		= "右键点击"
	L["Left-Click"] 		= "左键点击"
	L["Middle-Click"] 		= "中键点击"
	L["Show Guild"]			= "显示公会"
	L["Show Battle.net"]	= "显示战网"
	L["Show FriendList"]	= "显示好友名单"
	L["Show Help"]			= "显示帮助"
	L["Show Guild Message"] = "显示公会信息"
	L["Show Player Info"] 	= "显示有关玩家的信息"
	L["Note"] 				= "注记"
	L["Officer Note"] 		= "官员注记"
	L["Achievements Points"]= "成就点数"
	L["Show only playing Battle.net Friends"] = "仅显示正在游戏中的战网好友"
return end

