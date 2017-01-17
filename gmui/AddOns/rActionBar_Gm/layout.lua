-- Based on:
-- rActionBar_Default: layout
-- zork, 2016

-- Default Bar Layout for rActionBar

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-- actionbar spiralcooldown, globalcd etc etc
-- to enable set it to false
-- to disable set it to true
local disablecooldown = true 

if disablecooldown then 
	for i,v in ipairs{"Action","MultiBarBottomLeft","MultiBarBottomRight","MultiBarRight","MultiBarLeft"} do
	 
		for i = 1, 12 do
			local cooldown = _G[v .. 'Button' .. i .. 'Cooldown']
			cooldown:SetDrawBling(false)
			cooldown:SetDrawSwipe(false)
			cooldown:SetDrawEdge(false)
			cooldown:SetSwipeColor(0, 0, 0, 0)
		end
	end
end


-----------------------------
-- Fader
-----------------------------

local fader = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
}

-----------------------------
-- BagBar
-----------------------------

local bagbar = {
  framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 5 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 2,
  numCols         = 6, --number of buttons per column
  startPoint      = "BOTTOMRIGHT", --start postion of first button: BOTTOMLEFT, TOPLEFT, TOPRIGHT, BOTTOMRIGHT
  fader           = fader,
}
-- don't want it :)
-- rActionBar:CreateBagBar(A, bagbar)

-----------------------------
-- MicroMenuBar
-----------------------------

local micromenubar = {
  framePoint      = { "TOP", UIParent, "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 28,
  buttonHeight    = 58,
  buttonMargin    = 0,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = fader,
}
-- don't want it :)
-- rActionBar:CreateMicroMenuBar(A, micromenubar)

-----------------------------
-- Bar1
-----------------------------

local bar1 = {
  framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 10 },
  frameScale      = 1,
  framePadding    = 2,
  buttonWidth     = 40,
  buttonHeight    = 40,
  buttonMargin    = 4,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
-- create it
rActionBar:CreateActionBar1(A, bar1)

-----------------------------
-- Bar2
-----------------------------

local bar2 = {
  framePoint      = { "BOTTOM", A.."Bar1", "TOP", 0, 0 },
  frameScale      = 1,
  framePadding    = 2,
  buttonWidth     = 40,
  buttonHeight    = 40,
  buttonMargin    = 4,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
-- create it
rActionBar:CreateActionBar2(A, bar2)

-----------------------------
-- Bar3
-----------------------------

local bar3 = {
  framePoint      = { "BOTTOM", A.."Bar2", "TOP", 0, 0 },
  frameScale      = 1,
  framePadding    = 2,
  buttonWidth     = 40,
  buttonHeight    = 40,
  buttonMargin    = 4,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}

-- don't want it :)
-- rActionBar:CreateActionBar3(A, bar3)

-----------------------------
-- Bar4
-----------------------------

local bar4 = {
  framePoint      = { "RIGHT", UIParent, "RIGHT", -5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
  fader           = fader,
}
-- create it
rActionBar:CreateActionBar4(A, bar4)

-----------------------------
-- Bar5
-----------------------------

local bar5 = {
  framePoint      = { "RIGHT", A.."Bar4", "LEFT", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
  fader           = fader,
}
-- create it
rActionBar:CreateActionBar5(A, bar5)

-----------------------------
-- StanceBar
-----------------------------

local stancebar = {
  framePoint      = { "BOTTOMLEFT", A.."Bar2", "TOPLEFT", -3, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
-- create it
rActionBar:CreateStanceBar(A, stancebar)

-----------------------------
-- PetBar
-----------------------------

--petbar
local petbar = {
  framePoint      = { "BOTTOMLEFT", A.."Bar2", "TOPLEFT", -3, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
-- create it
rActionBar:CreatePetBar(A, petbar)

-----------------------------
-- ExtraBar
-----------------------------

local extrabar = {
  framePoint      = { "BOTTOMLEFT", A.."Bar1", "BOTTOMRIGHT", 10, 10 },  
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 55,
  buttonHeight    = 55,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
-- create it
rActionBar:CreateExtraBar(A, extrabar)

-----------------------------
-- VehicleExitBar
-----------------------------

local vehicleexitbar = {
  framePoint      = { "BOTTOMLEFT", A.."Bar1", "BOTTOMRIGHT", 85, 10 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 55,
  buttonHeight    = 55,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
-- create it
rActionBar:CreateVehicleExitBar(A, vehicleexitbar)

-----------------------------
-- PossessExitBar
-----------------------------

local possessexitbar = {
  framePoint      = { "BOTTOMLEFT", A.."Bar1", "BOTTOMRIGHT", 85, 10 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 55,
  buttonHeight    = 55,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
-- create it
rActionBar:CreatePossessExitBar(A, possessexitbar)