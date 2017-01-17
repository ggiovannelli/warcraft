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
local gmfontsmenu

-- saved variables
GMFONTS = GMFONTS or {}

GMFONTS["N"] = GMFONTS["N"] 	or "WoW Default"
GMFONTS["B"] = GMFONTS["B"] 	or "WoW Default"
GMFONTS["BI"] = GMFONTS["BI"] 	or "WoW Default"
GMFONTS["I"] = GMFONTS["I"] 	or "WoW Default"
GMFONTS["NR"] = GMFONTS["NR"] 	or "WoW Default"


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

	UNIT_NAME_FONT     = GMFONTS["N"]
	DAMAGE_TEXT_FONT   = GMFONTS["NR"]
	STANDARD_TEXT_FONT = GMFONTS["N"]
	NAMEPLATE_FONT     = GMFONTS["B"]

	-- Base fonts
	SetFont(AchievementFont_Small,              GMFONTS["B"], 12)
	SetFont(FriendsFont_Large,                  GMFONTS["N"], 15, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Normal,                 GMFONTS["N"], 13, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Small,                  GMFONTS["N"], 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_UserText,               GMFONTS["NR"], 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameTooltipHeader,                  GMFONTS["B"], 15, "OUTLINE")
	SetFont(GameFont_Gigantic,                  GMFONTS["B"], 32, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameNormalNumberFont,               GMFONTS["B"], 11)
	SetFont(InvoiceFont_Med,                    GMFONTS["I"], 13, nil, 0.15, 0.09, 0.04)
	SetFont(InvoiceFont_Small,                  GMFONTS["I"], 11, nil, 0.15, 0.09, 0.04)
	SetFont(MailFont_Large,                     GMFONTS["I"], 15, nil, 0.15, 0.09, 0.04, 0.54, 0.4, 0.1, 1, -1)
	SetFont(NumberFont_OutlineThick_Mono_Small, GMFONTS["NR"], 13, "OUTLINE")
	SetFont(NumberFont_Outline_Huge,            GMFONTS["NR"], 30, "THICKOUTLINE", 30)
	SetFont(NumberFont_Outline_Large,           GMFONTS["NR"], 17, "OUTLINE")
	SetFont(NumberFont_Outline_Med,             GMFONTS["NR"], 15, "OUTLINE")
	SetFont(NumberFont_Shadow_Med,              GMFONTS["N"], 14)
	SetFont(NumberFont_Shadow_Small,            GMFONTS["N"], 12)
	SetFont(QuestFont_Shadow_Small,             GMFONTS["N"], 16)
	SetFont(QuestFont_Large,                    GMFONTS["N"], 16)
	SetFont(QuestFont_Shadow_Huge,              GMFONTS["B"], 19, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(QuestFont_Super_Huge,               GMFONTS["B"], 24)
	SetFont(ReputationDetailFont,               GMFONTS["B"], 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SpellFont_Small,                    GMFONTS["B"], 11)
	SetFont(SystemFont_InverseShadow_Small,     GMFONTS["B"], 11)
	SetFont(SystemFont_Large,                   GMFONTS["N"], 17)
	SetFont(SystemFont_Med1,                    GMFONTS["N"], 13)
	SetFont(SystemFont_Med2,                    GMFONTS["I"], 14, nil, 0.15, 0.09, 0.04)
	SetFont(SystemFont_Med3,                    GMFONTS["N"], 15)
	SetFont(SystemFont_OutlineThick_Huge2,      GMFONTS["N"], 22, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_Huge4,      GMFONTS["BI"], 27, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_WTF,    	GMFONTS["BI"], 31, "THICKOUTLINE", nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SystemFont_Outline_Small,           GMFONTS["NR"], 13, "OUTLINE")
	SetFont(SystemFont_Shadow_Huge1,            GMFONTS["B"], 20)
	SetFont(SystemFont_Shadow_Huge3,            GMFONTS["B"], 25)
	SetFont(SystemFont_Shadow_Large,            GMFONTS["N"], 17)
	SetFont(SystemFont_Shadow_Med1,             GMFONTS["N"], 13)
	SetFont(SystemFont_Shadow_Med2,             GMFONTS["N"], 14)
	SetFont(SystemFont_Shadow_Med3,             GMFONTS["N"], 15)
	SetFont(SystemFont_Shadow_Outline_Huge2,    GMFONTS["N"], 22, "OUTLINE")
	SetFont(SystemFont_Shadow_Small,            GMFONTS["B"], 11)
	SetFont(SystemFont_Small,                   GMFONTS["N"], 12)
	SetFont(SystemFont_Tiny,                    GMFONTS["N"], 11)
	SetFont(Tooltip_Med,                        GMFONTS["N"], 13)
	SetFont(Tooltip_Small,                      GMFONTS["B"], 12)
	SetFont(WhiteNormalNumberFont,              GMFONTS["B"], 11)

	-- Derived fonts
	SetFont(BossEmoteNormalHuge,     			GMFONTS["BI"], 27, "THICKOUTLINE")
	SetFont(CombatTextFont,          			GMFONTS["N"], 26)
	SetFont(ErrorFont,               			GMFONTS["I"], 16, nil, 60)
	SetFont(QuestFontNormalSmall,    			GMFONTS["B"], 13, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(WorldMapTextFont,        			GMFONTS["BI"], 31, "THICKOUTLINE",  40, nil, nil, 0, 0, 0, 1, -1)
	
	-- Other fonts definition taken from Phanx	
	SetFont(ChatBubbleFont,                     GMFONTS["N"], 13)
	SetFont(CoreAbilityFont,					GMFONTS["B"], 32)
	SetFont(DestinyFontHuge,                    GMFONTS["B"], 32)
	SetFont(DestinyFontLarge,                   GMFONTS["B"], 18)
	SetFont(Game18Font,                         GMFONTS["N"], 18)
	SetFont(Game24Font,                         GMFONTS["N"], 24) -- there are two of these, good job Blizzard
	SetFont(Game27Font,                         GMFONTS["N"], 27)
	SetFont(Game30Font,                         GMFONTS["N"], 30)
	SetFont(Game32Font,                         GMFONTS["N"], 32)
	SetFont(NumberFont_GameNormal,              GMFONTS["N"], 10)
	SetFont(NumberFont_Normal_Med,              GMFONTS["NR"], 14)
	
	SetFont(NumberFont_GameNormal,              GMFONTS["N"], 13) -- orig 10 -- inherited by WhiteNormalNumberFont, tekticles = 11
	SetFont(QuestFont_Enormous,                 GMFONTS["B"], 30)
	SetFont(QuestFont_Huge,                     GMFONTS["B"], 19)

	SetFont(QuestFont_Super_Huge_Outline,       GMFONTS["B"], 24, "OUTLINE")
	SetFont(SplashHeaderFont,                   GMFONTS["B"], 24)
	
	SetFont(SystemFont_Huge1,                   GMFONTS["N"], 20)
	SetFont(SystemFont_Huge1_Outline,           GMFONTS["N"], 20, "OUTLINE")
	
	SetFont(SystemFont_Outline,                 GMFONTS["NR"], 13, "OUTLINE")
	-- SetFont(SystemFont_OutlineThick_WTF2,   	GMFONTS["BI"], 36) -- SharedFonts.xml
	SetFont(SystemFont_Shadow_Huge2,       		GMFONTS["B"], 24) -- SharedFonts.xml

	SetFont(SystemFont_Shadow_Large2,           GMFONTS["N"], 19) -- SharedFonts.xml
	SetFont(SystemFont_Shadow_Large_Outline,    GMFONTS["N"], 17, "OUTLINE") -- SharedFonts.xml
	
	SetFont(SystemFont_Shadow_Med1_Outline,     GMFONTS["N"], 12, "OUTLINE") -- SharedFonts.xml
	SetFont(SystemFont_Shadow_Small2,           GMFONTS["N"], 11) -- SharedFonts.xml
	SetFont(SystemFont_Small2,                  GMFONTS["N"], 12) -- SharedFonts.xml
	
	
	for i=1,7 do
		local f = _G["ChatFrame"..i]
		local font, size = f:GetFont()
		f:SetFont(GMFONTS["N"], size)
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

	for k,v in pairs(GMFONTS) do	   
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
	--  of Transportation�s FHWA Series of Standard Alphabets. 
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
	
	LSM:Register("font", "Ubuntu Mono", fontpath .. "UbuntuMono-R.ttf")
	LSM:Register("font", "Ubuntu Mono Italic", fontpath .. "UbuntuMono-RI.ttf")
	LSM:Register("font", "Ubuntu Mono Bold", fontpath .. "UbuntuMono-B.ttf")
	LSM:Register("font", "Ubuntu Mono Bold Italic", fontpath .. "UbuntuMono-BI.ttf")

	-- Comic Neue is a casual script typeface released in 2014. It was designed 
	-- by Craig Rozynski as a more modern, refined version of the ubiquitous, 
	-- but frequently criticised typeface, Comic Sans.
	-- http://comicneue.com/
	LSM:Register("font", "ComicNeue", fontpath .. "ComicNeue-Regular.ttf")	
	LSM:Register("font", "ComicNeue Light", fontpath .. "ComicNeue-Light.ttf")	
	LSM:Register("font", "ComicNeue Bold", fontpath .. "ComicNeue-Bold.ttf")	


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
	
	
	-- Lato is a sans serif typeface family started in the summer of 2010 by Warsaw-based designer Lukasz Dziedzic 
	-- (Lato means Summer in Polish). In December 2010 the Lato family was published under the Open Font License 
	-- by his foundry tyPoland, with support from Google. 
	-- The Lato font family is available as a free download under the SIL Open Font License 1.1. 
	-- The fonts can be used without any limitations for commercial and non-commercial purposes. 
	-- They can be also freely modified if the terms of the license are observed.
	-- http://www.latofonts.com/lato-free-fonts/
	LSM:Register("font", "Lato", fontpath .. "Lato-Regular.ttf")
	LSM:Register("font", "Lato Bold", fontpath .. "Lato-Bold.ttf")
	LSM:Register("font", "Lato Italic", fontpath .. "Lato-Italic.ttf")
	LSM:Register("font", "Lato Bold Italic", fontpath .. "Lato-BoldItalic.ttf")
	LSM:Register("font", "Lato Thin", fontpath .. "Lato-Thin.ttf") 
		
	-- "The Happy Giraffe" is a font free for personal and charity use by Misti (https://mistifonts.com/)
	-- http://www.dafont.com/the-happy-giraffe.font
	LSM:Register("font", "Happy Giraffe", fontpath .. "The Happy Giraffe Demo.ttf")

	-- "Ladybug Love" is a font free for personal and charity use by Misti (https://mistifonts.com/)
	-- http://www.dafont.com/ladybug-love.font
	LSM:Register("font", "Lady Bug", fontpath .. "Ladybug Love Demo.ttf")
	
	-- Droid is a font family first released in 2007 and created by Ascender Corporation for use by 
	-- the Open Handset Alliance platform Android[1] and licensed under the Apache License. 
	-- The fonts are intended for use on the small screens of mobile handsets and were designed 
	-- by Steve Matteson of Ascender Corporation. 
	-- The name was derived from the Open Handset Alliance platform named Android
	LSM:Register("font", "Droid Sans Mono", fontpath .. "DroidSansMono.ttf")

	
	LSM:Register("font", "AD Mono", fontpath .. "a_d_mono.ttf")

	LSM:Register("font", "Terminus", fontpath .. "Terminus.ttf")
	LSM:Register("font", "Terminus Bold", fontpath .. "TerminusBold.ttf")
	
	
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
     
	GMFONTS["N"] 	= LSM_DEFAULT_FONT
	GMFONTS["B"] 	= LSM_DEFAULT_FONT
	GMFONTS["BI"] 	= LSM_DEFAULT_FONT
	GMFONTS["I"] 	= LSM_DEFAULT_FONT
	GMFONTS["NR"] 	= LSM_DEFAULT_FONT
   
	UpdateFonts()
	options.refresh()

end

----------------------------------------------------------------------------------


local textgmfonts = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textgmfonts:SetPoint("TOPLEFT", 230, -80)
textgmfonts:SetText("gmFonts sets")
options.textgmfonts = textgmfonts
 
local gmlistfonts = {} 
local gmlistfonts = {"Ubuntu", "Ubuntu Mono", "Ubuntu Light","Carlito", "PT Sans", "ComicNeue", "Candara", "Verdana", "Laurel", "Lato"}

local dropdown2 = PCD:New(options)
dropdown2:SetPoint("TOPLEFT", 230, -80)
dropdown2:SetList(gmlistfonts)
function dropdown2:OnValueChanged(text)
   
   	local gmfontset = {}
	gmfontset["Ubuntu"] = {"Ubuntu-R.ttf", "Ubuntu-B.ttf", "Ubuntu-BI.ttf", "Ubuntu-RI.ttf"}
	gmfontset["Ubuntu Mono"] = {"UbuntuMono-R.ttf", "UbuntuMono-B.ttf", "UbuntuMono-BI.ttf", "UbuntuMono-RI.ttf"}
	gmfontset["Ubuntu Light"] = {"Ubuntu-L.ttf", "Ubuntu-M.ttf", "Ubuntu-MI.ttf", "Ubuntu-L.ttf"}
	gmfontset["Carlito"] = {"Carlito-Regular.ttf", "Carlito-Bold.ttf", "Carlito-BoldItalic.ttf", "Carlito-Italic.ttf"}
	gmfontset["PT Sans"] = {"PT_Sans-Web-Regular.ttf", "PT_Sans-Web-Bold.ttf", "PT_Sans-Web-BoldItalic.ttf", "PT_Sans-Web-Italic.ttf"}
	gmfontset["ComicNeue"] = {"ComicNeue-Regular.ttf", "ComicNeue-Bold.ttf", "ComicNeue-Bold.ttf", "ComicNeue-Regular.ttf"}
	gmfontset["Candara"] = {"Candara.ttf", "Candarab.ttf", "Candaraz.ttf", "Candarai.ttf"}
	gmfontset["Verdana"] = {"Verdana.TTF", "Verdanab.TTF", "Verdanaz.TTF", "Verdanai.TTF"}
	gmfontset["Laurel"]={"lauren-normal.ttf", "lauren-bold.ttf", "lauren-italic.ttf", "lauren-bold-italic.ttf"}
	gmfontset["Lato"]={"Lato-Regular.ttf", "Lato-Bold.ttf", "Lato-Italic.ttf", "Lato-BoldItalic.ttf"}
	
	GMFONTS["N"] 	= fontpath .. gmfontset[text][1]
	GMFONTS["B"] 	= fontpath .. gmfontset[text][2]
	GMFONTS["BI"] 	= fontpath .. gmfontset[text][3]
	GMFONTS["I"] 	= fontpath .. gmfontset[text][4]
	GMFONTS["NR"] 	= fontpath .. gmfontset[text][1]
   
	UpdateFonts()
	options.refresh()
   
end


-- print the default values
local textdefaultn = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaultn:SetPoint("TOPLEFT", 16, -160)
textdefaultn:SetText(string_format("|cffffffff%s|r : %s","Normal",GMFONTS["N"] or "Default"))
options.textdefaultn = textdefaultn

local textdefaultb = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaultb:SetPoint("TOPLEFT", 16, -180)
textdefaultb:SetText(string_format("|cffffffff%s|r : %s","Bold",GMFONTS["B"] ))
options.textdefaultb = textdefaultb

local textdefaultbi = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaultbi:SetPoint("TOPLEFT", 16, -200)
textdefaultbi:SetText(string_format("|cffffffff%s|r : %s","BoldItalic",GMFONTS["BI"] ))
options.textdefaultbi = textdefaultbi

local textdefaulti = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaulti:SetPoint("TOPLEFT", 16, -220)
textdefaulti:SetText(string_format("|cffffffff%s|r : %s","Italic",GMFONTS["I"] ))
options.textdefaulti = textdefaulti

local textdefaultnr = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textdefaultnr:SetPoint("TOPLEFT", 16, -240)
textdefaultnr:SetText(string_format("|cffffffff%s|r : %s","Numbers",GMFONTS["NR"] ))
options.textdefaultnr = textdefaultnr

local textadvice = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormal")
textadvice:SetPoint("TOPLEFT", 16, -280)
textadvice:SetText(string_format("|cffffffff%s|r : %s","Hint","Reload UI after a font change..."))
options.textadvice = textadvice

-- WoW Default Fonts Button
local gmfonts_def_button = CreateFrame("button", gmfonts_def_button, options, "UIPanelButtonTemplate")
gmfonts_def_button:SetHeight(BUTTON_HEIGHT)
gmfonts_def_button:SetWidth(BUTTON_WIDTH)
gmfonts_def_button:SetPoint("TOPLEFT", 16, -320)
gmfonts_def_button:SetText("WoW Default")
gmfonts_def_button.tooltipText = "BEWARE: Silently initialize your fonts to default and reload your UI"
gmfonts_def_button:SetScript("OnClick",  
	function()

		GMFONTS = {}
		ReloadUI()
		
	end)  

-- WoW Default Fonts Button
local gmfonts_rld_button = CreateFrame("button", gmfonts_rld_button, options, "UIPanelButtonTemplate")
gmfonts_rld_button:SetHeight(BUTTON_HEIGHT)
gmfonts_rld_button:SetWidth(BUTTON_WIDTH)
gmfonts_rld_button:SetPoint("TOPLEFT", 180, -320)
gmfonts_rld_button:SetText("Reload UI")
gmfonts_rld_button.tooltipText = "Reload your UI"
gmfonts_rld_button:SetScript("OnClick",  
	function()

		ReloadUI()
		
	end)  

	
--- credits 
local credits = options:CreateFontString("$parentTitle", "ARTWORK", "SystemFont_Small")
credits:SetPoint("BOTTOMRIGHT", -16, 16)
credits:SetText("Font engine: |cffffd200tekticles|r by tekkub      Widget engine: |cffffd200PhanxConfig-Dropdown|r by phanx")
options.credits = credits	
	
function options.refresh()

	textdefaultn:SetText(string_format("|cffffffff%s|r : %s","Normal",GMFONTS["N"] ))
	textdefaultb:SetText(string_format("|cffffffff%s|r : %s","Bold",GMFONTS["B"] ))
	textdefaultbi:SetText(string_format("|cffffffff%s|r : %s","BoldItalic",GMFONTS["BI"] ))
	textdefaulti:SetText(string_format("|cffffffff%s|r : %s","Italic",GMFONTS["I"] ))
	textdefaultnr:SetText(string_format("|cffffffff%s|r : %s","Numbers",GMFONTS["NR"] ))

end

------------------------------------------
if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end
