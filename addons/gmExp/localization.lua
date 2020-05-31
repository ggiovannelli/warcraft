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
	-- Italian translations go here
	L["Shift"]					= "Maiuscola"
	L["Right-Click"] 			= "Tasto-Destro"
	L["Left-Click"] 			= "Tasto-Sinistro"
	L["Middle-Click"] 			= "Tasto-Centrale"
	L["Max content level"]		= "Livello Massimo"
	L["Level"]					= "Livello"
	L["Current XP"]				= "XP Attuale"
	L["Remaining XP"]			= "XP Rimanente"
	L["Level Progress %"]		= "Progresso Livello %"
	L["Remaining rested"]		= "Bonux XP Rimanente"
	L["Artifact"]				= "Artefatto"
	L["Rank"]					= "Rango"
	L["Artifact Power"]			= "Potenza Artefatto"
	L["Power to next rank"]		= "Potenza per prossimo rango"
	L["Power in excess in rank"] = "Potenza in eccesso nel rango"
	L["Progress in rank %"]		= "Progresso nel rango %"
	L["Knowledge level"]		= "Livello Conoscenza"
	L["Knowledge multiplier %"] = "Moltiplicatore Conoscenza %"	
	L["Short Numbers"]			= "Numberi Abbreviati"
	L["Long Numbers"]			= "Numeri Standard"
return end

if LOCALE == "zhTW" or LOCALE == "zhCN" then
-- chinese translations by BNS
	L["Shift"] 				= "Shift"
	L["Right-Click"] 			= "右鍵-點擊"
	L["Left-Click"]         	= "左鍵-點擊"
	L["Middle-Click"]       	= "中鍵-點擊"        
	L["Max content level"]  	= "最大滿等級"
	L["Level"]              	= "等級"
	L["Current XP"]         	= "目前經驗值"
	L["Remaining XP"]       	= "剩餘經驗值"
	L["Level Progress %"]   	= "等級進度 %"
	L["Remaining rested"]   	= "剩餘休息獎勵"
	L["Artifact"]           	= "神兵"
	L["Rank"]               	= "等級"
	L["Artifact Power"]     	= "神兵之力"
	L["Power to next rank"] 	= "神兵升級還剩"
	L["Power in excess in rank"]= "神兵之力過量"
	L["Progress in rank %"] 	= "等級進度 %"
	L["Knowledge level"]   	= "知識等級"
	L["Knowledge multiplier %"]= "知識乘數 %"        
	L["Short Numbers"]      	= "簡短數字"
	L["Long Numbers"]       	= "完整數字"
return end

if LOCALE == "frFR" then
	L["Shift"]          = "Maj"
	L["Right-Click"]        = "Clique droit"
	L["Left-Click"]         = "Clique gauche"
	L["Middle-Click"]       = "Clique roulette"
	L["Max content level"]      = "niveau contenu max"
	L["Level"]                  = "niveau"
	L["Current XP"]             = "XP actuelle"
	L["Remaining XP"]           = "XP restante"
	L["Level Progress %"]       = "% du niveau"
	L["Remaining rested"]       = "Repos restant"
	L["Artifact"]               = "Artéfact"
	L["Rank"]                   = "Rang"
	L["Artifact Power"]         = "Puissance prodigieuse"
	L["Power to next rank"]     = "Puissance pour rang suivant"
	L["Power in excess in rank"]= "Puissance en trop au rang"
	L["Progress in rank %"]     = "Progrès du rang %"
	L["Knowledge level"]        = "Niveau de connaissance"
	L["Knowledge multiplier %"] = "Multiplicateur connaissance %"
	L["Short Numbers"]          = "Nombres courts"
	L["Long Numbers"]           = "Nombres longs"
return end