-- Inventorian Locale
-- Please use the Localization App on WoWAce to Update this
-- http://www.wowace.com/projects/inventorian/localization/

local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "enUS", true, debug)
L["%s's Bank"] = true
L["%s's Inventory"] = true
L["<Left-Click> to automatically sort this bag"] = true
L["<Left-Click> to switch characters"] = true
L["<Left-Click> to toggle the bag display"] = true
L["<Right-Click> to deposit reagents into the reagent bank"] = true
L["<Right-Click> to show the bank contents"] = true
L["Bags"] = true
L["Cached"] = true
L["Click to purchase"] = true
L["Install BagBrother to get access to the inventory of other characters."] = true
L["Reagents"] = true

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "deDE")
if L then
L["%s's Bank"] = "Bank von %s"
L["%s's Inventory"] = "Inventar von %s"
L["<Left-Click> to automatically sort this bag"] = "<Linksklick>, um die Tasche automatisch zu sortieren"
L["<Left-Click> to switch characters"] = "<Linksklick>, um Charakter zu wechseln"
L["<Left-Click> to toggle the bag display"] = "<Linksklick>, um die Taschenanzeige umzuschalten"
L["<Right-Click> to deposit reagents into the reagent bank"] = "<Rechtsklick>, um Reagenzien im Materiallager einzulagern."
L["<Right-Click> to show the bank contents"] = "<Rechtsklick>, um den Bankinhalt anzuzeigen."
L["Bags"] = "Taschen"
L["Cached"] = "Zwischengespeichert"
L["Click to purchase"] = "Zum Kaufen klicken"
L["Install BagBrother to get access to the inventory of other characters."] = "Installiere das Addon BagBrother, um Zugriff auf den Inventar anderer Charaktere zu bekommen."
L["Reagents"] = "Reagenzien"
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "esES")
if L then
L["%s's Bank"] = "Banco de %s"
L["%s's Inventory"] = "Mochila de %s"
L["<Left-Click> to toggle the bag display"] = "<Clic izquierda> para mostrar/ocultar las bolsas"
L["Bags"] = "Mochila"
L["Click to purchase"] = "Clic para comprar"
L["Reagents"] = "Componentes"
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "esMX")
if L then
L["%s's Bank"] = "Banco de %s"
L["%s's Inventory"] = "Mochila de %s"
L["<Left-Click> to toggle the bag display"] = "<Clic izquierda> para mostrar/ocultar las bolsas"
L["Bags"] = "Mochila"
L["Click to purchase"] = "Clic para comprar"
L["Reagents"] = "Componentes"
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "frFR")
if L then
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "itIT")
if L then
L["%s's Bank"] = "Banca di %s"
L["%s's Inventory"] = "Inventario di %s"
L["<Left-Click> to automatically sort this bag"] = "<Click Sinistro> per ordinare in automatico questa borsa"
L["<Left-Click> to switch characters"] = "<Click Sinistro> per spostarsi su un'altro personaggio"
L["<Left-Click> to toggle the bag display"] = "<Click Sinistro> per attivare la visualizzazione delle borse"
L["<Right-Click> to deposit reagents into the reagent bank"] = "<Click Destro> per depositare i reagenti nella banca per reagenti"
L["<Right-Click> to show the bank contents"] = "<Click Destro> per mostrare i contenuti della banca"
L["Bags"] = "Borse"
L["Cached"] = "Archiviato"
L["Click to purchase"] = "Clicca per comprare"
L["Install BagBrother to get access to the inventory of other characters."] = "Installa BagBrother per accedere all'inventario degli altri personaggi."
L["Reagents"] = "Reagenti"
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "koKR")
if L then
L["%s's Bank"] = "%s의 은행"
L["%s's Inventory"] = "%s의 가방"
L["<Left-Click> to automatically sort this bag"] = "<왼쪽-클릭>으로 가방 자동 정리"
L["<Left-Click> to switch characters"] = "<왼쪽-클릭>으로 다른 캐릭터 선택"
L["<Left-Click> to toggle the bag display"] = "<왼쪽 클릭>으로 가방 표시"
L["<Right-Click> to deposit reagents into the reagent bank"] = "<오른쪽-클릭>으로 재료은행에 재료 보관"
L["<Right-Click> to show the bank contents"] = "<오른쪽-클릭>하여 은행 아이템 표시"
L["Bags"] = "가방"
L["Cached"] = "저장됨"
L["Click to purchase"] = "클릭하여 구매"
L["Install BagBrother to get access to the inventory of other characters."] = "BagBrother 애드온이 설치되어 있으면 다른 캐릭터의 가방을 볼 수 있습니다."
L["Reagents"] = "재료"
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "ptBR")
if L then
L["%s's Bank"] = "Banco de %s"
L["%s's Inventory"] = "Inventário de %s"
L["<Left-Click> to toggle the bag display"] = "<Clique> para mostrar/ocultar as bolsas"
L["Bags"] = "Bolsas"
L["Click to purchase"] = "Clique para comprar"
L["Reagents"] = "Reagentes"
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "ruRU")
if L then
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "zhCN")
if L then
end

L = LibStub("AceLocale-3.0"):NewLocale("Inventorian", "zhTW")
if L then
L["%s's Bank"] = "%s的銀行"
L["%s's Inventory"] = "%s的背包"
L["<Left-Click> to automatically sort this bag"] = "<左鍵點擊>來自動排序背包"
L["<Left-Click> to switch characters"] = "<左鍵點擊>來切換角色"
L["<Left-Click> to toggle the bag display"] = "<左鍵點擊>以切換背包顯示"
L["<Right-Click> to deposit reagents into the reagent bank"] = "<右鍵點擊>來存放材料到材料銀行"
L["<Right-Click> to show the bank contents"] = "<右鍵點擊>來顯示銀行內容"
L["Bags"] = "背包"
L["Cached"] = "已快取"
L["Click to purchase"] = "點擊以購買"
L["Install BagBrother to get access to the inventory of other characters."] = "安裝BagBrother來獲取其他角色的背包數據。"
L["Reagents"] = "材料"
end
