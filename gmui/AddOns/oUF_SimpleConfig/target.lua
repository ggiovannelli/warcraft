
-- oUF_SimpleConfig: target
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Target Config
-----------------------------

L.C.target = {
  enabled = true,
  size = {240,26},
  point = {"LEFT",UIParent,"CENTER",120,-240},
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorTapping = true,
    colorDisconnected = true,
    colorClass = true,
    colorReaction = true,
    colorHealth = false,
    colorThreat = true,
    colorThreatInvers = true,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2,10},
        {"TOPRIGHT",-2,10},
      },
      size = 16,
	  -- outline = "","",
      tag = "[difficulty][name]|r",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2,0},
      size = 16,
	  outline = "","",
      tag = "[oUF_Simple:health]",
    },
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {240,5},
    point = {"TOP","BOTTOM",0,-4}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","LEFT",0,0},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {208,26},
	point = {"BOTTOMLEFT","TOPLEFT",32,16},
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      --font = STANDARD_TEXT_FONT,
     size = 14,

      outline = "","",
	  --align = "CENTER",
      --noshadow = true,
    },
    icon = {
      enabled = true,
      size = {26,26},
      point = {"RIGHT","LEFT",-6,0},
    },
  },
  buffs = {
   enabled = false,
    point = {"BOTTOMLEFT","RIGHT",-24,20},
    num = 5,
    cols = 5,
    size = 24,
    spacing = 5,
    -- initialAnchor = "TOPLEFT",
    growthX = "LEFT",
    growthY = "UP",
    disableCooldown = true,
  },
  debuffs = {
    enabled = true,
    point = {"TOPLEFT","RIGHT",-24,-28},
    num = 5,
    cols = 5,
    size = 24,
    spacing = 5,
    -- initialAnchor = "TOPLEFT",
    growthX = "LEFT",
    growthY = "DOWN",
    disableCooldown = false,
  },
}
