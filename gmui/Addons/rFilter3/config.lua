
  -- // rFilter3
  -- // zork - 2012

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList = {}, {}, {}

  --local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")

  -----------------------------
  -- DEFAULT CONFIG
  -----------------------------

  cfg.highlightPlayerSpells = false  --player spells will have a blue border
  cfg.updatetime            = 0.1   --how fast should the timer update itself
  cfg.timeFontSize          = 15
  cfg.countFontSize         = 18

  if player_class == "SHAMAN" then
	cfg.rf3_BuffList = {
  
	{spellid = 53390, 
	spec = 3,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -110, y = -247 },
	unit = "player",
	validate_unit   = false,
	ismine          = true,
	desaturate      = true,
	match_spellid   = true,
	move_ingame     = false,
	hide_ooc        = false,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
  
  	{spellid = 73685, 
	spec = 3,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -70, y = -247 },
	unit = "player",
	validate_unit   = false,
	ismine          = true,
	desaturate      = true,
	match_spellid   = true,
	move_ingame     = false,
	hide_ooc        = false,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
  
  
  
  
	}
  end 
  
  if player_class == "DEATHKNIGHT" then
    
	cfg.rf3_BuffList = {    

	{ spellid = 114851, 
	spelllist = { 51460, },  -- Corruzione runica, Conversione del sangue 
	spec = nil,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -110, y = -247 },
	unit = "player",
	validate_unit   = false,
	ismine          = true,
	desaturate      = true,
	match_spellid   = true,
	move_ingame     = false,
	hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},  
	
	}
	cfg.rf3_DebuffList = {

	}
	cfg.rf3_CooldownList = {
	
	{spellid = 49222,  -- Scudo di Ossa
	spec = 1,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 140, y = -333 },
	desaturate      	= true,
	move_ingame	= false,
	hide_ooc 		= true,
	alpha = {cooldown = { frame = 1, icon = 1,},no_cooldown = { frame = 0, icon = 0,},},},  	
	
	{spellid = 56222,  --Taunt
	spec = 1,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 180, y = -333 },
	desaturate      	= true,
	move_ingame	= false,
	hide_ooc 		= true,
	alpha = {cooldown = { frame = 1, icon = 1,},no_cooldown = { frame = 0, icon = 0,},},},  	
	
	{spellid = 123693,  -- Risucchio della Piaga
	spec = nil,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x =220, y = -333 },
	desaturate      	= true,
	move_ingame	= false,
	hide_ooc 		= true,
	alpha = {cooldown = { frame = 1, icon = 1,},no_cooldown = { frame = 0, icon = 0,},},},  
	
	}
  end
  
  
  --warrior defaults
  if player_class == "WARRIOR" then
    --default warrior buffs
    cfg.rf3_BuffList = {
    
	{spellid = 112048, 
	spec = 3,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -110, y = -247 },
	unit = "player",
	validate_unit   = false,
	ismine          = true,
	desaturate      = true,
	match_spellid   = true,
	move_ingame     = false,
	hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
			
	{spellid = 32216, 
	spec = 3,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -70, y = -247 },
	unit = "player",
	validate_unit   = false,
	ismine          = true,
	desaturate      = true,
	match_spellid   = true,
	move_ingame     = false,
	hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},  
    
    }
    --default warrior debuffs
    cfg.rf3_DebuffList = {}
    --default warrior cooldowns
    cfg.rf3_CooldownList = {}
  end

  --rogue defaults
  if player_class == "ROGUE" then
    --default rogue buffs
    cfg.rf3_BuffList = {}
    --default rogue debuffs
    cfg.rf3_DebuffList = {}
    --default rogue cooldowns
    cfg.rf3_CooldownList = {}
  end

  --rogue defaults
  if player_class == "HUNTER" then
	
	cfg.rf3_BuffList = {
	
	{spellid = 82692, 
	spec = 1,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -70, y = -247 },
	unit = "player",
	validate_unit   = false,
	ismine          = true,
	desaturate      = true,
	match_spellid   = true,
	move_ingame     = false,
	hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},  
	
	{spellid = 118455, 
	spec = 1,
	size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -110, y = -247 },
	unit = "pet",
	validate_unit   = false,
	ismine          = true,
	desaturate      = true,
	match_spellid   = true,
	move_ingame     = false,
	hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
	
	}

	cfg.rf3_DebuffList = {}

	cfg.rf3_CooldownList = {}
  end

  
   if player_class == "MAGE" then

   cfg.rf3_BuffList = {
 
	{spellid = 12043, -- MAGE::ARCANE
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 10, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},  


	{spellid = 116014, -- MAGE::ARCANE
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -110, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},  			
		
	{spellid = 79683, -- MAGE::ARCANE MISSILI
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -30, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},  		
   
   } -- END BUFF MAGE

    cfg.rf3_DebuffList = {

	{spellid = 36032, -- MAGE::ARCANE
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -70, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},    	

	} -- END DEBUFF MAGE

    cfg.rf3_CooldownList = {
	
	
	}

	end
  
  
    if player_class == "DRUID" then

    cfg.rf3_BuffList = {

	
	--- BEAR ---------------------------------------------------------------------------
		  
	{spellid = 158792, -- BEAR:3:Polverizzazione
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -70, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
	
	{spellid = 61336, -- BEAR:3:Istinto di sopravvivenza
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -30, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
	alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
	
	{spellid = 22812, -- BEAR:3:Pelledura
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 10, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},

	{spellid = 132402, -- BEAR:3:Difesa Selvaggia
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 50, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
		
  
	--- CAT ---------------------------------------------------------------------------
	  
	{spellid = 106951, -- CAT:2:BERSERK
        spec = 2,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 50, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},

	
	{spellid = 5217, -- CAT:2:TIGER'S FURY
        spec = 2,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 90, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},

	--- MOONKIN ---------------------------------------------------------------------------

	{spellid = 171743, -- MOON:1:ECLIPSE LUNAR
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -70, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = false,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},

	{spellid = 171744, -- MOON:1:ECLIPSE SOLAR
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -70, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = false,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},		
		
	{spellid = 48505, -- MOON:1:STARFALL
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -30, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = false,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
	

	{spellid = 164545, -- MOON:1:ECLIPSE SOLAR
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 10, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = false,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},		
		
	{spellid = 164547, -- MOON:1:ECLIPSE SOLAR
        spec = 1,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 50, y = -247 },
        unit = "player",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = false,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},		
		
	} -- end DRUID BUFF
		
	
	
	
    --default druid debuffs
    cfg.rf3_DebuffList = {
	
		-- BEAR
	
	{spellid = 33745, -- Lacerazione
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -110, y = -247 },
        unit = "target",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},

	{spellid = 77758, -- falciata
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 90, y = -247 },
        unit = "target",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
	
		-- CAT
	
	
	{spellid = 155625, -- CAT:2:MOONFIRE
        spec = 2,
        size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -110, y = -247 },
        unit = "target",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
	  
	{spellid = 155722, -- CAT:2:GRAFFIO
        spec = 2,
        size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -70, y = -247 },
        unit = "target",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},

	{spellid = 1079, -- CAT:2:RIP
        spec = 2,
        size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -30, y = -247 },
        unit = "target",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
	

	{spellid = 106830, -- CAT:2:FALCIATA
        spec = 2,
        size = 32,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 10, y = -247 },
        unit = "target",
        validate_unit   = false,
        ismine          = true,
        desaturate      = true,
        match_spellid   = true,
        move_ingame     = false,
        hide_ooc        = true,
        alpha = {found = { frame = 1, icon = 1,},not_found = { frame = 0, icon = 0,},},},
	
	} -- end DRUID DEBUFF
	
    --default druid cooldowns
    cfg.rf3_CooldownList = {}
	
	
	
	
  end