-- you can use the addon in a macro like this:
-- /gmpets [btn:2] rare; [mod:alt] funny; [mod:shift] remove;
-- so you use mouse:
-- btn:2 to summon a category "rare" pets
-- ALT+btn:1 for the "funny" ones 
-- SHIFT+btn:1 for dismiss the current pet (if any)
-- btn:1 for the full random.

-- if categories.lua is not found
gmPets_tbl = {}

local LibPetJournal = LibStub("LibPetJournal-2.0")
local prgname = "|cffffd200gmPets|r"
local summon_msg = prgname .. " is summoning... "
local IN_COMBAT

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		IN_COMBAT = true
	elseif event == "PLAYER_REGEN_ENABLED" then    
		IN_COMBAT = false
	end
end)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

SLASH_GMPETS1 = "/gmp"
SlashCmdList["GMPETS"] = function(args) 	

	local category=SecureCmdOptionParse(args);
	local args=SecureCmdOptionParse(args);
	
	if args:lower() == "help" then 
		print(prgname .. " commands")
		print("/gmp help - This help")
		print("/gmp remove - Dismiss an active pets")
		print("/gmp - Random summon a pet from your complete collection")
		print("/gmp <category> - Random summon a pet from your custom <category> ")
		return
		end
	
	if args:lower() == "remove" then 
		print(prgname .. " is dismiss the active companion")
		-- http://www.wowinterface.com/forums/showthread.php?p=298025#post298025
		C_PetJournal.SummonPetByGUID(C_PetJournal.GetSummonedPetGUID())
		return
	end 	

	if not category or IN_COMBAT then 
		return
	end
	
	category=category:lower()
	
	if category=="" then 		
		local number=random(1,LibPetJournal:NumPets())
		for i,petid in LibPetJournal:IteratePetIDs() do 
			local _, _, _, _, _, _, _, name, _, _, _, _, _, _, _,_,_ = C_PetJournal.GetPetInfoByPetID(petid)
			 if (i == number) then 
					C_PetJournal.SummonPetByGUID(petid)
					print (summon_msg .. name:lower())
			end
		end
	
	elseif gmPets_tbl[category] then	
			local number=random(1,#gmPets_tbl[category])
			local picked=gmPets_tbl[category][number]:lower()
			local msg = prgname .. " error: trying to summon \"" .. picked .. "\" from \"" .. category .. "\" category, but this was not found in your pets list."		
			for i,petid in LibPetJournal:IteratePetIDs() do 
				local _, _, _, _, _, _, _, name, _, _, _, _, _, _, _,_,_ = C_PetJournal.GetPetInfoByPetID(petid)
				if name:lower() == picked then 
					C_PetJournal.SummonPetByGUID(petid)
					msg = summon_msg .. name:lower()
					break
				end
			end
			print(msg)					
	else
		print(prgname .. " unable to find category ",category)
	end
end