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
	L["Shift"]				= "Maiuscola"
	L["Right-Click"] 		= "Tasto-Destro"
	L["Left-Click"] 		= "Tasto-Sinistro"
	L["Middle-Click"] 		= "Tasto-Centrale"
	L["%s: selling %s %s for %s"] = "%s: vendita %s %s per %s"
	L["repair with guild funds"] = "riparazione con fondi di gilda"
	L["repair"] = "riparazione"
	L["no repair, need more money"] = "nessuna riparazione, fondi insufficienti"
	L["Total %.1f - Equipped %.1f"] = "Totale %.1f - Equipaggiato %.1f"
	L["Auto repair"] = "Auto riparazione"
	L["Use guild funds"] = "Usa fondi di gilda"
	L["Auto sell junk"] = "Auto vendita spazzatura"
	L["Toggle auto repair"] = "Cambia auto riparazione"
	L["Toggle use of guild funds"] = "Cambia utilizzo fondi di gilda"
	L["Toggle auto sell"] = "Cambia auto vendita"
	L["below"] = "sotto"
	L["above"] = "sopra"
	L["average equipped"] = "media equipaggiati"
	L["Durability"] = "Integrita'"
	L["DataBroker"] = "Data Broker"
return end

if LOCALE == "zhTW" then
	-- Chinese translations by BNS :)
	L["Shift"] = "Shift"
	L["Right-Click"] = "右鍵"
	L["Left-Click"] = "左鍵"
	L["Middle-Click"] = "中鍵"
	L["%s: selling %s %s for %s"] = "%s：出售%s %s 獲得%s"
	L["repair with guild funds"] = "修理使用公會資金"
	L["repair"] = "修理"
	L["no repair, need more money"] = "沒有修理，需要更多金錢"
	L["Total %.1f - Equipped %.1f"] = "總計 %.1f - 已裝備 %.1f"
	L["Auto repair"] = "自動修理"
	L["Use guild funds"] = "使用公會資金"
	L["Auto sell junk"] = "自動出售垃圾"
	L["Toggle auto repair"] = "切換自動修理"
	L["Toggle use of guild funds"] = "切換使用公會資金"
	L["Toggle auto sell"] = "切換自動出售"
	L["below"] = "以下"
	L["above"] = "以上"
	L["average equipped"] = "平均已裝備"
	L["Durability"] = "耐久度"
return end

if LOCALE == "zhCN" then
	-- Chinese translations by BNS :)
	L["Shift"] = "Shift"
	L["Right-Click"] = "右键"
	L["Left-Click"] = "左键"
	L["Middle-Click"] = "中键"
	L["%s: selling %s %s for %s"] = "%s：出售%s %s 获得%s"
	L["repair with guild funds"] = "修理使用公会资金"
	L["repair"] = "修理"
	L["no repair, need more money"] = "没有修理，需要更多金钱"
	L["Total %.1f - Equipped %.1f"] = "总计 %.1f - 已装备 %.1f"
	L["Auto repair"] = "自动修理"
	L["Use guild funds"] = "使用公会资金"
	L["Auto sell junk"] = "自动出售垃圾"
	L["Toggle auto repair"] = "切换自动修理"
	L["Toggle use of guild funds"] = "切换使用公会资金"
	L["Toggle auto sell"] = "切换自动出售"
	L["below"] = "以下"
	L["above"] = "以上"
	L["average equipped"] = "平均已装备"
	L["Durability"] = "耐久度"
return end