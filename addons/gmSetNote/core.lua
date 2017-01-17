
local function doit()
	for index = 1, GetNumGuildMembers() do
		
		local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(index)

		print("Analyze :" .. rank)
		
		if rank == "Social" or rank == "Freezed" then 
			
			print ("Set officer note")
			GuildRosterSetOfficerNote(index, rank)
		
		end
		
	end
end

SLASH_GMSN1 = "/gmsn"
SlashCmdList["GMSN"] = function(args) 

	doit()

end