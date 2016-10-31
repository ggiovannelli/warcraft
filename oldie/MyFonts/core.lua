-- it was a small addon for adding my preferred fonts in LibSharedMedia
-- now is also an addon to change your UI default fonts.

-- the most important part of the code (and probably the well written one :) is taken by "tekticles" http://www.wowinterface.com/downloads/info8786-tekticles.html
-- Also the defaults fonts typo and size are taken by "tekticles"

local ADDON = ...

local size={}
local prgname = "|cffffd200MyFonts|r"
local string_format = string.format

local BUTTON_HEIGHT = 40
local BUTTON_WIDTH = 150

local lsmfontsmenu
local myfontsmenu

MYFONTS = {
	N = "WoW Default",
	B = "WoW Default",
	BI = "WoW Default",
	I = "WoW Default",
	NR = "WoW Default",
}


-- Setup shared media
local LSM = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0", true)
local PCD = LibStub("PhanxConfig-Dropdown")
local fontpath = "Interface\\Addons\\"..ADDON.."\\fonts\\"

----- Begin code taken by "http://www.wowinterface.com/downloads/info8786-tekticles.html"
-- by Tekkub: http://www.tekkub.net/addons

local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)	
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

local function UpdateFonts()

	-- to be used in future
	size = {sm = 9, me = 11, la = 15, hu = 17, gi = 25, zn = 100, zs = 20, zp = 30}
	
	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}

	UNIT_NAME_FONT     = MYFONTS["N"]
	DAMAGE_TEXT_FONT   = MYFONTS["NR"]
	STANDARD_TEXT_FONT = MYFONTS["N"]

	-- Base fonts
	SetFont(AchievementFont_Small,              MYFONTS["B"], 12)
	SetFont(FriendsFont_Large,                  MYFONTS["N"], 15, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Normal,                 MYFONTS["N"], 13, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Small,                  MYFONTS["N"], 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_UserText,               MYFONTS["NR"], 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameTooltipHeader,                  MYFONTS["B"], 15, "OUTLINE")
	SetFont(GameFont_Gigantic,                  MYFONTS["B"], 32, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameNormalNumberFont,               MYFONTS["B"], 11)
	SetFont(InvoiceFont_Med,                    MYFONTS["I"], 13, nil, 0.15, 0.09, 0.04)
	SetFont(InvoiceFont_Small,                  MYFONTS["I"], 11, nil, 0.15, 0.09, 0.04)
	SetFont(MailFont_Large,                     MYFONTS["I"], 15, nil, 0.15, 0.09, 0.04, 0.54, 0.4, 0.1, 1, -1)
	SetFont(NumberFont_OutlineThick_Mono_Small, MYFONTS["NR"], 13, "OUTLINE")
	SetFont(NumberFont_Outline_Huge,            MYFONTS["NR"], 30, "THICKOUTLINE", 30)
	SetFont(NumberFont_Outline_Large,           MYFONTS["NR"], 17, "OUTLINE")
	SetFont(NumberFont_Outline_Med,             MYFONTS["NR"], 15, "OUTLINE")
	SetFont(NumberFont_Shadow_Med,              MYFONTS["N"], 14)
	SetFont(NumberFont_Shadow_Small,            MYFONTS["N"], 12)
	SetFont(QuestFont_Shadow_Small,             MYFONTS["N"], 16)
	SetFont(QuestFont_Large,                    MYFONTS["N"], 16)
	SetFont(QuestFont_Shadow_Huge,              MYFONTS["B"], 19, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(QuestFont_Super_Huge,               MYFONTS["B"], 24)
	SetFont(ReputationDetailFont,               MYFONTS["B"], 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SpellFont_Small,                    MYFONTS["B"], 11)
	SetFont(SystemFont_InverseShadow_Small,     MYFONTS["B"], 11)
	SetFont(SystemFont_Large,                   MYFONTS["N"], 17)
	SetFont(SystemFont_Med1,                    MYFONTS["N"], 13)
	SetFont(SystemFont_Med2,                    MYFONTS["I"], 14, nil, 0.15, 0.09, 0.04)
	SetFont(SystemFont_Med3,                    MYFONTS["N"], 15)
	SetFont(SystemFont_OutlineThick_Huge2,      MYFONTS["N"], 22, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_Huge4,      MYFONTS["BI"], 27, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_WTF,    	MYFONTS["BI"], 31, "THICKOUTLINE", nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SystemFont_Outline_Small,           MYFONTS["NR"], 13, "OUTLINE")
	SetFont(SystemFont_Shadow_Huge1,            MYFONTS["B"], 20)
	SetFont(SystemFont_Shadow_Huge3,            MYFONTS["B"], 25)
	SetFont(SystemFont_Shadow_Large,            MYFONTS["N"], 17)
	SetFont(SystemFont_Shadow_Med1,             MYFONTS["N"], 13)
	SetFont(SystemFont_Shadow_Med2,             MYFONTS["N"], 14)
	SetFont(SystemFont_Shadow_Med3,             MYFONTS["N"], 15)
	SetFont(SystemFont_Shadow_Outline_Huge2,    MYFONTS["N"], 22, "OUTLINE")
	SetFont(SystemFont_Shadow_Small,            MYFONTS["B"], 11)
	SetFont(SystemFont_Small,                   MYFONTS["N"], 12)
	SetFont(SystemFont_Tiny,                    MYFONTS["N"], 11)
	SetFont(Tooltip_Med,                        MYFONTS["N"], 13)
	SetFont(Tooltip_Small,                      MYFONTS["B"], 12)
	SetFont(WhiteNormalNumberFont,              MYFONTS["B"], 11)

	-- Derived fonts
	SetFont(BossEmoteNormalHuge,     MYFONTS["BI"], 27, "THICKOUTLINE")
	SetFont(CombatTextFont,          MYFONTS["N"], 26)
	SetFont(ErrorFont,               MYFONTS["I"], 16, nil, 60)
	SetFont(QuestFontNormalSmall,    MYFONTS["B"], 13, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(WorldMapTextFont,        MYFONTS["BI"], 31, "THICKOUTLINE",  40, nil, nil, 0, 0, 0, 1, -1)

	for i=1,7 do
		local f = _G["ChatFrame"..i]
		local font, size = f:GetFont()
		f:SetFont(MYFONTS["N"], size)
	end

	-- I have no idea why the channel list is getting fucked up
	-- but re-setting the font obj seems to fix it
	for i=1,MAX_CHANNEL_BUTTONS do
		local f = _G["ChannelButton"..i.."Text"]
		f:SetFontObject(GameFontNormalSmallLeft)
		-- function f:SetFont(...) error("Attempt to set font on ChannelButton"..i) end
	end

	for _,butt in pairs(PaperDollTitlesPane.buttons) do butt.text:SetFontObject(GameFontHighlightSmallLeft) end

end

--- End tekkub copied code :-)


local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function()

	-- some check to prevent to call UpdateFonts() without a defined font.
	local k,v
	local checkfont = 0

	for k,v in pairs(MYFONTS) do	   
	   checkfont=1	   
	   if v == "WoW Default" then 
		  checkfont = 0
	   end
	end

	if checkfont == 1 then UpdateFonts() end

end)



if LSM then	
	-- "Ace Futurism is a simple techno font inspired by multiple that already exist. 
	-- Was initially to be used in a game but the game halted being worked 
	-- on so I finished up the font and here it is."
	-- http://nalgames.com/fonts/all-fonts/
	LSM:Register("font", "Ace Futurism", fontpath .. "Ace_Futurism.ttf")
	
	
	-- 	Expressway is a sans-serif font family inspired by the U.S. Department 
	--  of Transportation’s FHWA Series of Standard Alphabets. 
	--  For the second half of the 20th Century, it was the font most used on road signs in U.S.,
	--  Canada, Mexico, Australia, Spain,Venezuela,the Netherlands, Brazil, Argentina, Taiwan, 
	--  Malaysia, Indonesia, India, Mongolia and New Zealand.
	-- Rather than sticking too closely to government specs, Expressway is 
	-- a more practical design that still holds on to that old, road sign feeling. 
	-- The full family has 7 weights, 2 widths plus italics for a total of 28 styles.
	-- This font includes a license that allows free commercial use: sometimes referred to as a desktop license.
	LSM:Register("font", "ExpressWay", fontpath .. "expressway.ttf")

	
	-- PT Sans is a drop in replacement of Myriad font by Adobe
	-- It is licensed under the OFL 1.1.
	-- https://www.google.com/fonts/specimen/PT+Sans
	LSM:Register("font", "PT Sans", fontpath .. "PT_Sans-Web-Regular.ttf")
	LSM:Register("font", "PT Sans Bold", fontpath .. "PT_Sans-Web-Bold.ttf")
	LSM:Register("font", "PT Sans Bold Italic", fontpath .. "PT_Sans-Web-BoldItalic.ttf")
	LSM:Register("font", "PT Sans Italic", fontpath .. "PT_Sans-Web-Italic.ttf")
	
	-- Carlito is a drop in replacement for Calibri Fonts. 
	-- Metrically compatible with the current MS default font Calibri. 
	-- It is licensed under the OFL 1.1.
	-- http://blogs.gnome.org/uraeus/2013/10/10/a-thank-you-to-google/
	LSM:Register("font", "Carlito", fontpath .. "Carlito-Regular.ttf")
	LSM:Register("font", "Carlito Bold", fontpath .. "Carlito-Bold.ttf")
	LSM:Register("font", "Carlito Italic", fontpath .. "Carlito-Italic.ttf")
	LSM:Register("font", "Carlito Bold Italic", fontpath .. "Carlito-BoldItalic.ttf")
	
	-- The Ubuntu Font Family are a set of matching new libre/open fonts 
	-- in development during 2010-2011. The development is being funded by Canonical Ltd 
	-- on behalf the wider Free Software community and the Ubuntu project. 
	-- The technical font design work and implementation is being undertaken by Dalton Maag.
	-- http://font.ubuntu.com/
	LSM:Register("font", "Ubuntu", fontpath .. "Ubuntu-R.ttf")
	LSM:Register("font", "Ubuntu Italic", fontpath .. "Ubuntu-RI.ttf")
	LSM:Register("font", "Ubuntu Condensed", fontpath .. "Ubuntu-C.ttf")
	LSM:Register("font", "Ubuntu Bold", fontpath .. "Ubuntu-B.ttf")
	LSM:Register("font", "Ubuntu Bold Italic", fontpath .. "Ubuntu-BI.ttf")
	LSM:Register("font", "Ubuntu Light", fontpath .. "Ubuntu-L.ttf")	
	LSM:Register("font", "Ubuntu Light Italic", fontpath .. "Ubuntu-LI.ttf")
	LSM:Register("font", "Ubuntu Medium", fontpath .. "Ubuntu-M.ttf")	
	LSM:Register("font", "Ubuntu Medium Italic", fontpath .. "Ubuntu-MI.ttf")	
	
	-- Comic Neue is a casual script typeface released in 2014. It was designed 
	-- by Craig Rozynski as a more modern, refined version of the ubiquitous, 
	-- but frequently criticised typeface, Comic Sans.
	-- http://comicneue.com/
	LSM:Register("font", "ComicNeue", fontpath .. "ComicNeue-Regular.ttf")	
	LSM:Register("font", "ComicNeue Light", fontpath .. "ComicNeue-Light.ttf")	
	LSM:Register("font", "ComicNeue Bold", fontpath .. "ComicNeue-Bold.ttf")	

	
	
	-- Calibri is a humanist sans-serif typeface family designed by Lucas de Groot. 
	-- In Microsoft Office 2007, it replaced Times New Roman as the default typeface in Word 
	-- and replaced Arial as the default in PowerPoint, Excel, Outlook, and WordPad. 
	-- It continues to be the default in Microsoft Office 2010 and 2013.
	--
	-- Calibri are here to emulate tekticles UI fonts.
	-- No reason to have them, being "Carlito" a free drop in replacement
	-- ... but someone wants Calibri so here they are.
	LSM:Register("font", "Calibri", fontpath .. "Calibri.ttf")	
	LSM:Register("font", "Calibri Italic", fontpath .. "CalibriItalic.ttf")	
	LSM:Register("font", "Calibri Bold", fontpath .. "CalibriBold.ttf")	
	LSM:Register("font", "Calibri Bold Italic", fontpath .. "CalibriBoldItalic.ttf")


	-- Candara is a humanist sans-serif typeface designed by Gary Munch and commissioned by Microsoft. 
	-- It is part of the ClearType Font Collection, all starting with the letter C to reflect that 
	-- they were designed to work well with Microsoft's ClearType text rendering system. 
	-- The others are Calibri, Cambria, Consolas, Corbel and Constantia.
	LSM:Register("font", "Candara", fontpath .. "Candara.ttf")
	LSM:Register("font", "Candara Bold", fontpath .. "Candarab.ttf")
	LSM:Register("font", "Candara Italic", fontpath .. "Candarai.ttf")
	LSM:Register("font", "Candara Bold Italic", fontpath .. "Candaraz.ttf")
	
	
	-- Verdana is a humanist sans-serif typeface designed by Matthew Carter for Microsoft Corporation, 
	-- with hand-hinting done by Thomas Rickner, then at Monotype. The name "Verdana" is based on verdant (something green), 
	-- and Ana (the name of Howlett's eldest daughter).
	-- According to a study of online fonts by the Software Usability and Research Laboratory at Wichita State University, 
	-- participants preferred Verdana to be the best overall font choice and it was also perceived as being among 
	-- the most legible fonts.
	-- It is part of Microsoft's TrueType core fonts:
	-- http://sourceforge.net/projects/corefonts/files/the%20fonts/
	LSM:Register("font", "Verdana", fontpath .. "Verdana.TTF")
	LSM:Register("font", "Verdana Bold", fontpath .. "Verdanab.TTF")
	LSM:Register("font", "Verdana Italic", fontpath .. "Verdanai.TTF")
	LSM:Register("font", "Verdana Bold Italic", fontpath .. "Verdanaz.TTF")

	-- Lauren is a font developed by Computer Support Corporation. It is a free for personal use.
	-- Add per request of  mothandras on Curseforge
	LSM:Register("font", "Lauren", fontpath .. "lauren-normal.ttf")
	LSM:Register("font", "Lauren Bold", fontpath .. "lauren-bold.ttf")
	LSM:Register("font", "Lauren Italic", fontpath .. "lauren-italic.ttf")
	LSM:Register("font", "Lauren Bold Italic", fontpath .. "lauren-bold-italic.ttf")
	
	
end

-- Configuration Panel -------------------------------------------------------------------------------------

local options = CreateFrame("Frame", ADDON.."Options", InterfaceOptionsFramePanelContainer)
options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
InterfaceOptions_AddCategory(options)

local title = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(options.name)
options.title = title

local textmenu = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textmenu:SetPoint("TOPLEFT", 16, -48)
textmenu:SetText("Please select your default UI fonts:")
options.textmenu = textmenu

local textlsmfonts = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textlsmfonts:SetPoint("TOPLEFT", 16, -80)
textlsmfonts:SetText("SharedMedia Fonts")
options.textlsmfonts = textlsmfonts

local lsmfonts = {} 
local lsmfonts = LSM:List("font")

local dropdown = PCD:New(options)
dropdown:SetPoint("TOPLEFT", 16, -80)
dropdown:SetList(lsmfonts)
function dropdown:OnValueChanged(text,value)

	local LSM_DEFAULT_FONT = LSM:Fetch("font", value)
     
	MYFONTS["N"] 	= LSM_DEFAULT_FONT
	MYFONTS["B"] 	= LSM_DEFAULT_FONT
	MYFONTS["BI"] 	= LSM_DEFAULT_FONT
	MYFONTS["I"] 	= LSM_DEFAULT_FONT
	MYFONTS["NR"] 	= LSM_DEFAULT_FONT
   
	UpdateFonts()
	options.refresh()

end

----------------------------------------------------------------------------------


local textmyfonts = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textmyfonts:SetPoint("TOPLEFT", 230, -80)
textmyfonts:SetText("My Sets")
options.textmyfonts = textmyfonts
 
local mylistfonts = {} 
local mylistfonts = {"Ubuntu", "Ubuntu Light","Carlito", "PT Sans", "ComicNeue", "Calibri", "Candara", "Verdana", "Laurel"}

local dropdown2 = PCD:New(options)
dropdown2:SetPoint("TOPLEFT", 230, -80)
dropdown2:SetList(mylistfonts)
function dropdown2:OnValueChanged(text)
   
   	local myset = {}
	myset["Ubuntu"] = {"Ubuntu-R.ttf", "Ubuntu-B.ttf", "Ubuntu-BI.ttf", "Ubuntu-RI.ttf"}
	myset["Ubuntu Light"] = {"Ubuntu-L.ttf", "Ubuntu-M.ttf", "Ubuntu-MI.ttf", "Ubuntu-L.ttf"}
	myset["Carlito"] = {"Carlito-Regular.ttf", "Carlito-Bold.ttf", "Carlito-BoldItalic.ttf", "Carlito-Italic.ttf"}
	myset["PT Sans"] = {"PT_Sans-Web-Regular.ttf", "PT_Sans-Web-Bold.ttf", "PT_Sans-Web-BoldItalic.ttf", "PT_Sans-Web-Italic.ttf"}
	myset["ComicNeue"] = {"ComicNeue-Regular.ttf", "ComicNeue-Bold.ttf", "ComicNeue-Bold.ttf", "ComicNeue-Regular.ttf"}
	myset["Calibri"] = {"Calibri.ttf", "CalibriBold.ttf", "CalibriBoldItalic.ttf", "CalibriItalic.ttf"}
	myset["Candara"] = {"Candara.ttf", "Candarab.ttf", "Candaraz.ttf", "Candarai.ttf"}
	myset["Verdana"] = {"Verdana.TTF", "Verdanab.TTF", "Verdanaz.TTF", "Verdanai.TTF"}
	myset["Laurel"]={"lauren-normal.ttf.ttf", "lauren-bold.ttf", "lauren-italic.ttf", "lauren-bold-italic.ttf"}

	
	MYFONTS["N"] 	= fontpath .. myset[text][1]
	MYFONTS["B"] 	= fontpath .. myset[text][2]
	MYFONTS["BI"] 	= fontpath .. myset[text][3]
	MYFONTS["I"] 	= fontpath .. myset[text][4]
	MYFONTS["NR"] 	= fontpath .. myset[text][1]
   
	UpdateFonts()
	options.refresh()
   
end


-- print the default values
local textdefaultn = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaultn:SetPoint("TOPLEFT", 16, -160)
textdefaultn:SetText(string_format("|cffffffff%s|r : %s","Normal",MYFONTS["N"] or "Default"))
options.textdefaultn = textdefaultn

local textdefaultb = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaultb:SetPoint("TOPLEFT", 16, -180)
textdefaultb:SetText(string_format("|cffffffff%s|r : %s","Bold",MYFONTS["B"] ))
options.textdefaultb = textdefaultb

local textdefaultbi = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaultbi:SetPoint("TOPLEFT", 16, -200)
textdefaultbi:SetText(string_format("|cffffffff%s|r : %s","BoldItalic",MYFONTS["BI"] ))
options.textdefaultbi = textdefaultbi

local textdefaulti = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaulti:SetPoint("TOPLEFT", 16, -220)
textdefaulti:SetText(string_format("|cffffffff%s|r : %s","Italic",MYFONTS["I"] ))
options.textdefaulti = textdefaulti

local textdefaultnr = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaultnr:SetPoint("TOPLEFT", 16, -240)
textdefaultnr:SetText(string_format("|cffffffff%s|r : %s","Numbers",MYFONTS["NR"] ))
options.textdefaultnr = textdefaultnr


-- WoW Default Fonts Button
local myfonts_def_button = CreateFrame("button", myfonts_def_button, options, "UIPanelButtonTemplate")
myfonts_def_button:SetHeight(BUTTON_HEIGHT)
myfonts_def_button:SetWidth(BUTTON_WIDTH)
myfonts_def_button:SetPoint("TOPLEFT", 16, -280)
myfonts_def_button:SetText("WoW Default")
myfonts_def_button.tooltipText = "BEWARE: Silently initialize your fonts to default and reload your UI"
myfonts_def_button:SetScript("OnClick",  
	function()

		MYFONTS = {}
		ReloadUI()
		
	end)  

-- WoW Default Fonts Button
local myfonts_rld_button = CreateFrame("button", myfonts_rld_button, options, "UIPanelButtonTemplate")
myfonts_rld_button:SetHeight(BUTTON_HEIGHT)
myfonts_rld_button:SetWidth(BUTTON_WIDTH)
myfonts_rld_button:SetPoint("TOPLEFT", 180, -280)
myfonts_rld_button:SetText("Reload UI")
myfonts_rld_button.tooltipText = "Reload your UI"
myfonts_rld_button:SetScript("OnClick",  
	function()

		ReloadUI()
		
	end)  

	
--- credits 
local credits = options:CreateFontString("$parentTitle", "ARTWORK", "SystemFont_Small")
credits:SetPoint("BOTTOMRIGHT", -16, 16)
credits:SetText("Font engine: |cffffd200tekticles|r by tekkub      Widget engine: |cffffd200PhanxConfig-Dropdown|r by phanx")
options.credits = credits	
	
function options.refresh()

	textdefaultn:SetText(string_format("|cffffffff%s|r : %s","Normal",MYFONTS["N"] ))
	textdefaultb:SetText(string_format("|cffffffff%s|r : %s","Bold",MYFONTS["B"] ))
	textdefaultbi:SetText(string_format("|cffffffff%s|r : %s","BoldItalic",MYFONTS["BI"] ))
	textdefaulti:SetText(string_format("|cffffffff%s|r : %s","Italic",MYFONTS["I"] ))
	textdefaultnr:SetText(string_format("|cffffffff%s|r : %s","Numbers",MYFONTS["NR"] ))

end

------------------------------------------
if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end