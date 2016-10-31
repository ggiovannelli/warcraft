-- you can use the addon in a macro like this:
-- /gimb [btn:2] rare; [mod:alt] funny; [mod:shift] remove;
-- so you use mouse:
-- btn:2 to summon a category "rare" pets
-- ALT+btn:1 for the "funny" ones 
-- SHIFT+btn:1 for dismiss the current pet (if any)
-- btn:1 for the full random.

-- if categories.lua is not found
MyPets_gimb = {}

-- future use
GimbolinoDB = {}

local LibPetJournal = LibStub("LibPetJournal-2.0")
local prgname = "|cffffd200gimbolino|r"
local summon_msg = prgname .. " is summoning... "

SLASH_GIMBOLINO1 = "/gimbolino"
SLASH_GIMBOLINO2 = "/gimb"
SlashCmdList["GIMBOLINO"] = function(args) 	

	local category=SecureCmdOptionParse(args);
	local args=SecureCmdOptionParse(args);
	
	if args:lower() == "help" then 
		print(prgname .. " commands")
		print("/gimb help - This help")
		print("/gimb remove - Dismiss an active pets")
		print("/gimb - Random summon a pet from your complete collection")
		print("/gimb <category> - Random summon a pet from your custom <category> ")
		return
		end
	
	if args:lower() == "remove" then 
		print(prgname .. " is dismiss the active companion")
		-- http://www.wowinterface.com/forums/showthread.php?p=298025#post298025
		C_PetJournal.SummonPetByGUID(C_PetJournal.GetSummonedPetGUID())
		return
	end 	

	if not category then 
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
	
	elseif MyPets_gimb[category] then	
			local number=random(1,#MyPets_gimb[category])
			local picked=MyPets_gimb[category][number]:lower()
			local msg = prgname .. " error:\ngimb was trying to summon \"" .. picked .. "\" from \"" .. category .. "\" category, but this was not found in your pets list.\nPlease check this."		
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