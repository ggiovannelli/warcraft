-- A small addon for adding my preferred common used media in LibSharedMedia and/or
-- have them collected and referenced in one place only. :)

local ADDON = ...

-- Setup shared media
local LSM = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0", true)
local LSM_media = "Interface\\Addons\\"..ADDON.."\\LSM\\"

if LSM then	

	-- "Ace Futurism is a simple techno font inspired by multiple that already exist. 
	-- Was initially to be used in a game but the game halted being worked 
	-- on so I finished up the font and here it is."
	-- http://nalgames.com/fonts/all-fonts/
	LSM:Register("font", "Ace Futurism", LSM_media .. "fonts\\Ace_Futurism.ttf")

	-- 	Expressway is a sans-serif font family inspired by the U.S. Department 
	--  of Transportation’s FHWA Series of Standard Alphabets. 
	--  For the second half of the 20th Century, it was the font most used on road signs in U.S.,
	--  Canada, Mexico, Australia, Spain,Venezuela,the Netherlands, Brazil, Argentina, Taiwan, 
	--  Malaysia, Indonesia, India, Mongolia and New Zealand.
	-- Rather than sticking too closely to government specs, Expressway is 
	-- a more practical design that still holds on to that old, road sign feeling. 
	-- The full family has 7 weights, 2 widths plus italics for a total of 28 styles.
	-- This font includes a license that allows free commercial use: sometimes referred to as a desktop license.	
	LSM:Register("font", "ExpressWay", LSM_media .. "fonts\\expressway.ttf")
	
	-- Candara is a humanist sans-serif typeface designed by Gary Munch and commissioned by Microsoft. 
	-- It is part of the ClearType Font Collection, all starting with the letter C to reflect that 
	-- they were designed to work well with Microsoft's ClearType text rendering system. 
	-- The others are Calibri, Cambria, Consolas, Corbel and Constantia.	
	LSM:Register("font", "Candara", LSM_media .. "fonts\\Candara.ttf")

	-- It is part of Microsoft's TrueType core fonts:
	-- http://sourceforge.net/projects/corefonts/files/the%20fonts/
	LSM:Register("font", "Verdana", LSM_media .. "fonts\\Verdana.TTF")
		
	-- sounds
	LSM:Register("sound", "DungeonReady", LSM_media .. "sounds\\dungeonready.ogg")
	LSM:Register("sound", "Aggro", LSM_media .. "sounds\\aggro.ogg")
	
	-- simple bar texture
	LSM:Register("statusbar", "Minimalist", LSM_media .. "textures\\bars\\Minimalist.tga")
		
end

