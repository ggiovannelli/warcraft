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
	-- Italian translations by me :)
	L["Character"]			= "Personaggio"
	L["Spellbook"]			= "Grimorio e abilità"
	L["Specialization and Talents"] = "Specializzazione e talenti"
	L["Achievements"]		= "Imprese"
	L["Quest Log"]			= "Registro missioni"
	L["Guild"]				= "Gilda e comunità"
	L["Group Finder"]		= "Ricerca Gruppi"
	L["Collections"]		= "Collezioni"
	L["Adventure Guide"]	= "Guida alle avventure"
	L["Game Menu"]			= "Menu di gioco"
	L["Reload UI"]			= "Ricarica UI"
	L["Total addon(s):"]	= "Addon(s) totali:"
	L["Number of addons:"]	= "Numero di addons:"
	L["Reset and reload UI"] = "Reset e ricarica UI"
	L["Reset settings and reload UI"] = "Reset dei settaggi e ricarica UI" 
	L["Save and reload UI"]	= "Salva e ricarica UI"
	L["Save settings and reload your UI"] = "Salva e ricarica UI"
	L["version"] 			= "versione"
	L["Show Icons"]			= "Mostra icone"
	L["Show Bind Keys"]		= "Mostra tasti associati"
return end
