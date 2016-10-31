-- creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected, mountID = C_MountJournal.GetMountInfoByID(mountID)


-- freely inspired by MountMe
-- http://www.wowinterface.com/downloads/info19197-MountMe.html

-- thanks to SDPhantom for hints and code fix
-- http://www.wowinterface.com/forums/member.php?u=34145

-- it can used in a macro like: 
-- /gmm [btn:2] category2; [swimming] category3; [mod:shift] category4; [mod:alt] favorites!; all! 

-- if categories.lua was not found
gmMounts_tbl = {}

local prgname = "|cffffd200gmMounts|r"
local table_insert = table.insert

SLASH_GMMOUNTS1 = "/gmm"
SlashCmdList["GMMOUNTS"] = function(args) 
	local category=SecureCmdOptionParse(args)
	category=category:lower()
	
	local AllMounts=C_MountJournal.GetMountIDs()
	
	if category=="" then
		print(prgname .. ":")
		print("/gmm  - This help")
		print("/gmm category - Summon a random mount from your 'category' list")
		print("/gmm favorites! - Summon a random mount from your favorite list")
		print("/gmm all! - Summon a random mount")
		return
		
	elseif category == "all!" then 
		
		local ValidMounts={}
		
		for index=1,#AllMounts do
			local name, _, _, isActive, isUsable, _, _, _, _, _, _, mountID = C_MountJournal.GetMountInfoByID(AllMounts[index])
			if  isUsable == true and isActive == false then
				table_insert(ValidMounts, mountID)
			end
		end	
		
		if #ValidMounts == 0 then 
				print(prgname .. " no valid mounts found to summon" )
				return
		end		
		
		local number=random(1,#ValidMounts)
		local name, _ = C_MountJournal.GetMountInfoByID(ValidMounts[number])
		C_MountJournal.SummonByID(ValidMounts[number])
		print(prgname .. " is summoning... " .. name)
		
		ValidMounts={}
		
	elseif category=="favorites!" then

		local FavoriteMounts={}
		
		for index=1,#AllMounts do
			local name, _, _, isActive, isUsable, _, isFavorite, _, _, _, _, mountID = C_MountJournal.GetMountInfoByID(AllMounts[index])
			if  isUsable == true and isActive == false and isFavorite == true then
				table_insert(FavoriteMounts, mountID)
			end
		end	
		
		if #FavoriteMounts == 0 then 
				print(prgname .. " no favorite mounts found to summon" )
				return
		end	
		
		-- if IsMounted() then Dismount() end
		
		local number=random(1,#FavoriteMounts)
		local name, _ = C_MountJournal.GetMountInfoByID(FavoriteMounts[number])
		C_MountJournal.SummonByID(FavoriteMounts[number])
		print(prgname .. " is summoning... " .. name)
		
		FavoriteMounts={}
		
	elseif gmMounts_tbl[category] then

		local CategoryMounts={}
		
		for i=1,#gmMounts_tbl[category] do
			
			local picked=gmMounts_tbl[category][i]:lower()
				
			for index=1,#AllMounts do
				local name, _, _, isActive, isUsable, _, _, _, _, _, _, mountID = C_MountJournal.GetMountInfoByID(AllMounts[index])	
				if  name:lower()==picked and isUsable == true and isActive == false then
					table_insert(CategoryMounts, mountID)
				end
			end
		end
				
		if #CategoryMounts == 0 then 
				print(prgname .. " no valid mounts found in custom category " .. category)
				return
		end
		
		-- if IsMounted() then Dismount() end
		
		local number=random(1,#CategoryMounts)
		local picked=CategoryMounts[number]			
		local name, _ = C_MountJournal.GetMountInfoByID(CategoryMounts[number])
		C_MountJournal.SummonByID(CategoryMounts[number])
		print(prgname .. " is summoning... " .. name)
		
		CategoryMounts={}
	
		
	else
	
		print(prgname .. " error: unable to find category " .. category .. " or categories.lua is missing")		
	
	end
end