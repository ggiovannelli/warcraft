local name, ns = ...
local cfg = CreateFrame('Frame')
local _, class = UnitClass('player')

  -----------------------------
  -- Media
  -----------------------------
  
local mediaPath = 'Interface\\AddOns\\oUF_Skaarj\\Media\\'
cfg.texture = mediaPath..'texture'
cfg.symbol = mediaPath..'symbol.ttf'
cfg.glow = mediaPath..'glowTex'
cfg.raidicons = mediaPath..'raidicons'

--Unit Frames Font

--Pixel
--cfg.font, cfg.fontsize, cfg.shadowoffsetX, cfg.shadowoffsetY, cfg.fontflag = mediaPath..'pixel.ttf', 12, 0, 0,  'Outlinemonochrome' -- '' for none THINOUTLINE Outlinemonochrome
cfg.font, cfg.fontsize, cfg.shadowoffsetX, cfg.shadowoffsetY, cfg.fontflag = mediaPath..'pixel.ttf', 12, 0, 0,  '' -- '' for none THINOUTLINE Outlinemonochrome

--Normal
-- cfg.font, cfg.fontsize, cfg.shadowoffsetX, cfg.shadowoffsetY, cfg.fontflag = mediaPath..'Calibri.ttf', 13, 1, -1,  '' 

  -----------------------------
  -- Unit Frames 
  -----------------------------

cfg.uf = {  
        raid = true,               -- Raid 
        boss = true,               -- Boss 
        arena = true,              -- Arena 
        party = true,              -- Party 
		tank = true,               -- Maintank 
		party_target = false,       -- Party target
		tank_target = true,        -- Maintank target
}

  -----------------------------
  -- Unit Frames Size
  -----------------------------

--player, target
cfg.player = { 
        width = 250 ,
        health = 27,
        power = 6,
        specific_power = 6,
}

--party, tank, arena, boss, focus
cfg.party = { 
        width = 165 ,
        health = 30,
        power = 3,
}

-- raid
cfg.raid = { 
        width = 55 ,
        health = 30,
        power = 3,
}

--pet, targettarget, focustarget, arenatarget, partytarget, maintanktarget
cfg.target = { 
        width = 90 ,
        height = 30,
}

  -----------------------------
  -- Unit Frames Positions
  -----------------------------
  
 cfg.unit_positions = { 				
             Player = { a = UIParent,           x= -260, y=  250},  
             Target = { a = UIParent,           x=  260, y=  250},  
       Targettarget = { a = 'oUF_SkaarjTarget', x=    0, y=   40},  
              Focus = { a = 'oUF_SkaarjPlayer', x= -105, y=  100},  
        Focustarget = { a = 'oUF_SkaarjFocus',  x=   95, y=    0},  
                Pet = { a = 'oUF_SkaarjPlayer', x=	  0, y=  -75},  
                Boss = { a = 'oUF_SkaarjTarget', x=  200, y=  250},  
               Tank = { a = UIParent, 			x= 	5, y=  -300},  
               Raid = { a = UIParent,           x=	 5, y=  -35},   
	          Party = { a = UIParent, 			x=   5, y=  -35},
              Arena = { a = 'oUF_SkaarjTarget', x=  120, y=  300},			  
}

  -----------------------------
  -- Unit Frames Options
  -----------------------------

cfg.options = { 
        portraits = false,               -- enables 3d portraits on player and target unit frames
        healcomm = false,
		raid_missinghp = false,           -- show/hide missing health text
		raid_incheal = false,
        specific_power = true,
		stagger_bar = true,
		cpoints = true,
		hidepower = true,                
		DruidMana = false,
		TotemBar = false,
		Maelstrom = false,
		MushroomBar = false,
		smooth = false,
		showPlayer = true,              -- show player in party
		showRaid = true,                 -- show party as raid 
		SpellRange = true,
		range_alpha = 0.2,
		disableRaidFrameManager = true,  -- disable default compact Raid Manager 
		pvp = false,                     -- pvp icon
		ResurrectIcon = true,
}

cfg.AltPowerBar = { 
		player = {
			enable = true,
			pos = {'BOTTOM', UIParent, 0, 170},
			width = 265,
			height = 10,
		},
		boss = {
			enable = true,
			pos = {'TOP', 0, 13},
			width = cfg.party.width,
			height = 9,
		},
}

cfg.EclipseBar = { 
        enable = true,
		Alpha = 0.2,
		pos = {'TOP', 'Player', 'BOTTOM', 0, -4},
        height = 6,
}

  -----------------------------
  -- Auras 
  -----------------------------

cfg.aura = {
        --player
        player_debuffs = false,
        player_debuffs_num = 18,
		--target
        target_debuffs = true,
        target_debuffs_num = 4,
        target_buffs = false,
        target_buffs_num = 4,		
		--focus
		focus_debuffs = true,
		focus_debuffs_num = 12,
		focus_buffs = false,
		focus_buffs_num = 8,
		--boss
		boss_buffs = true,
		boss_buffs_num = 4,
		boss_debuffs = true,
		boss_debuffs_num = 4,
		--target of target
		targettarget_debuffs = false,
		targettarget_debuffs_num = 4,
		--party
		party_buffs = false,
		party_buffs_num = 4,
		
		onlyShowPlayer = true,         -- only show player debuffs on target
        disableCooldown = true,         -- hide omniCC
        font = mediaPath..'pixel.ttf',
		fontsize = 11,
		fontflag = 'Outlinemonochrome',
}

  -----------------------------
  -- Plugins 
  -----------------------------

--ThreatBar
cfg.treat = {
        enable = false,
		text = false,
        pos = {'TOP', UIParent, 0, -10},
        width = 345,
		height = 7,
}

--Experience/Reputation
cfg.exp_rep = {
        enable = true,
		unlock = true,
        pos = {'TOP', UIParent, 'TOP', 0, -25},  				--requires unlock = true
        width = 250,                                          	--requires unlock = true
		height = 7,                                           	--requires unlock = true
		show_text_on_mouseover = true,
}

--GCD
cfg.gcd = {
        enable = false,
        pos = {'BOTTOM', UIParent, 0, 218},
        width = 229,
		height = 7,
}

--RaidDebuffs
cfg.RaidDebuffs = {
        enable = true,
        pos = {'CENTER'},
        size = 20,
		ShowDispelableDebuff = true,
		FilterDispellableDebuff = true,
		MatchBySpellName = false,
}

--Threat/DebuffHighlight
cfg.dh = {
        player = true,
		target = true,
		focus = true,
		pet = true,
		partytaget = false,
		party = true,
		arena = true,
		raid = true,
		targettarget = false,
}

--AuraWatch
cfg.aw = {
        enable = true,
        onlyShowPresent = true,
		anyUnit = true,
}

--AuraWatch Spells
cfg.spellIDs = {
	    DRUID = {
	            {33763, {0.2, 0.8, 0.2}},			    -- Lifebloom
	            {8936, {0.8, 0.4, 0}, 'TOPLEFT'},		-- Regrowth
	            {102342, {0.38, 0.22, 0.1}},		    -- Ironbark
	            {48438, {0.4, 0.8, 0.2}, 'BOTTOMLEFT'},	-- Wild Growth
	            {774, {0.8, 0.4, 0.8},'TOPRIGHT'},		-- Rejuvenation
	            },
	     MONK = {
	            {119611, {0.2, 0.7, 0.7}},			    -- Renewing Mist
	            {132120, {0.4, 0.8, 0.2}},			    -- Enveloping Mist
	            {124081, {0.7, 0.4, 0}},			    -- Zen Sphere
	            {116849, {0.81, 0.85, 0.1}},		    -- Life Cocoon
	            },
	  PALADIN = {
	            {20925, {0.9, 0.9, 0.1}},	            -- Sacred Shield
	            {6940, {0.89, 0.1, 0.1}, 'BOTTOMLEFT'}, -- Hand of Sacrifice
	            {114039, {0.4, 0.6, 0.8}, 'BOTTOMLEFT'},-- Hand of Purity
	            {1022, {0.2, 0.2, 1}, 'BOTTOMLEFT'},	-- Hand of Protection
	            {1038, {0.93, 0.75, 0}, 'BOTTOMLEFT'},  -- Hand of Salvation
	            {1044, {0.89, 0.45, 0}, 'BOTTOMLEFT'},  -- Hand of Freedom
	            {114163, {0.9, 0.6, 0.4}, 'RIGHT'},	    -- Eternal Flame
	            {53563, {0.7, 0.3, 0.7}, 'TOPRIGHT'},   -- Beacon of Light
	            },
	   PRIEST = {
	            {41635, {0.2, 0.7, 0.2}},			    -- Prayer of Mending
	            {33206, {0.89, 0.1, 0.1}},			    -- Pain Suppress
	            {47788, {0.86, 0.52, 0}},			    -- Guardian Spirit
	            {6788, {1, 0, 0}, 'BOTTOMLEFT'},	    -- Weakened Soul
	            {17, {0.81, 0.85, 0.1}, 'TOPLEFT'},	    -- Power Word: Shield
	            {139, {0.4, 0.7, 0.2}, 'TOPRIGHT'},     -- Renew
	            },
	   SHAMAN = {
	            {974, {0.2, 0.7, 0.2}},				    -- Earth Shield
	            {61295, {0.7, 0.3, 0.7}, 'TOPRIGHT'},   -- Riptide
	            },
	   HUNTER = {
	            {35079, {0.2, 0.2, 1}},				    -- Misdirection
	            },
	     MAGE = {
	            {111264, {0.2, 0.2, 1}},			    -- Ice Ward
	            },
	    ROGUE = {
	            {57933, {0.89, 0.1, 0.1}},			    -- Tricks of the Trade
	            },
	  WARLOCK = {
	            {20707, {0.7, 0.32, 0.75}},			    -- Soulstone
	            },
	  WARRIOR = {
	            {114030, {0.2, 0.2, 1}},			    -- Vigilance
	            {3411, {0.89, 0.1, 0.1}, 'TOPRIGHT'},   -- Intervene
	            },
 }
 
--oUF_MovableFrames	
cfg.MovableFrames = false
 
  -----------------------------
  -- Castbars 
  -----------------------------

-- Player
cfg.player_cb = {
        enable = true,
		pos = {'BOTTOMRIGHT', 0, -29},
        -- pos = {'BOTTOM', UIParent, 13, 150},
		width = 234,
		height = 15,
}

-- Target
cfg.target_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -28},
		height = 15,
		width = 234,
}

-- Focus
cfg.focus_cb = {
        enable = false,
        pos = {'BOTTOMRIGHT', 0, -23},
		height = 15,
		width = 150,
}

-- Boss
cfg.boss_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -16},
		height = 15,
		width = 150,
}

-- Party
cfg.party_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -19},
		height = 15,
		width = 150,
}

-- Arena
cfg.arena_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -19},
		height = 15,
		width = 187,
}

  -----------------------------
  -- Colors 
  -----------------------------

cfg.class_colorbars = true
cfg.colorClass_bg = false
cfg.hbg_multiplier = 1
  
cfg.Color = { 				
       Health = {r =  0.33,	g =  0.33, 	b =  0.33 },
	Health_bg = {r =  0.33,	g =  0.33, 	b =  0.33, a = 0.5},
	  Castbar = {r =  0,	g =  0.7, 	b =  1},
	  CPoints = {r =  .96,	g =  0.37, 	b =  0.34},
}

  -----------------------------
  -- CHARSPECIFIC REWRITES
  -----------------------------

local playername, _ = UnitName('player')

if playername == 'Чизкейк' then
	cfg.treat.width = 444
end

if playername == 'Волараукар' then
	--cfg.treat.width = 389
	cfg.treat.enable = false
end
  
if playername == 'Саварен' then
	cfg.treat.width = 500
	cfg.treat.enable = false
	cfg.dh.player = false
	cfg.gcd.enable = false
end

ns.cfg = cfg