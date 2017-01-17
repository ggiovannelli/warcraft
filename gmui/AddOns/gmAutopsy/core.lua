-- Most of the comments to the code (and the "well written" part of it :-) are by Phanx, whom I thanks for the helps and patience in explaining. 

local ADDON = ...

-- set some default values
GMAUTOPSY = {
     ENABLED = true,
     CHANNEL = 1,
}

GMAUTOPSY_OUTNAM = {"SELF", "LDB", "GROUP", "GUILD", "OFFICER"}

local GMAUTOPSY_REPORT = {}
local prgname = "|cffffd200gmAutopsy|r"
local string_format = string.format

local function color(destName)
	if not UnitExists(destName) then return string_format("\124cffff0000%s\124r", destName) end
	local _, class = UnitClass(destName)
	local color = _G["RAID_CLASS_COLORS"][class]
	return string_format("\124cff%02x%02x%02x%s\124r", color.r*255, color.g*255, color.b*255, destName)
end

local number = function(v)
	if v <= 9999 then return v	
	elseif v >= 1000000 then return format("%.1fM", v/1000000)
	elseif v >= 10000 then return format("%.1fK", v/1000)
	end
end

local function unescape(String)
	local Result = tostring(String)
	Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
	Result = gsub(Result, "%[", "") -- Remove links.
	Result = gsub(Result, "%]", "") -- Remove links.
	return Result
end


local function demoToolTip()

	for line=1,30 do

		local sources = {"Udvud il macellaio", "Brown Marmot", "Wolf", "Black Mamba", "Calamir", "Umongris", "Drugon il Sangue Gelido"}
		local damages = {"Melee", 30455, 219602, 219349, 216043, 213590, 223689}
		local damage = damages[math.random(7)]
		
		if damage == "Melee" then 
		
			GMAUTOPSY_REPORT[#GMAUTOPSY_REPORT+1] = {
				timestamp 	= date("%H:%M:%S",timestamp),
				sourceName 	= sources[math.random(7)],
				destName 	= color(UnitName("player")),
				spell 		= "Melee",
				damage		= number(math.random(500000,2000000)),
				overkill	= number(math.random(500000))
			}

		else

			GMAUTOPSY_REPORT[#GMAUTOPSY_REPORT+1] = {
				timestamp 	= date("%H:%M:%S",timestamp),
				sourceName 	= sources[math.random(7)],
				destName 	= color(UnitName("player")),
				spell 		= unescape(GetSpellLink(damage)),
				damage		= number(math.random(500000,2000000)),
				overkill	= number(math.random(500000))
			}


		end
	end
end

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject(ADDON, {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
	text = "-",
})

local frame = CreateFrame("Frame")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function UpdateLDB()

	if (GMAUTOPSY["ENABLED"] == false) then
		dataobj.icon = "Interface\\Addons\\"..ADDON.."\\icon-off.tga"
		dataobj.text = string_format("|cffff0000%s|r", "OFF")
		frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		-- print(string_format("%s: monitor is |cffff0000%s|r",prgname,"OFF"))
	else 
		dataobj.icon = "Interface\\Addons\\"..ADDON.."\\icon.tga"
		dataobj.text = string_format("|cff00ff00%s|r", GMAUTOPSY_OUTNAM[GMAUTOPSY["CHANNEL"]])
		frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		-- print(string_format("%s: enabled on [|cff00ff00%s|r] channel ", prgname, GMAUTOPSY_OUTNAM[GMAUTOPSY["CHANNEL"]]))
	end
end

function dataobj.OnClick(self, button)  

	if (button == "LeftButton" and GMAUTOPSY["ENABLED"] == true) then
		
		if (GMAUTOPSY["CHANNEL"] == 5) then 					
			GMAUTOPSY["CHANNEL"] = 1
		else
			GMAUTOPSY["CHANNEL"] = GMAUTOPSY["CHANNEL"] + 1
		end			
		
	elseif button == "RightButton" then	GMAUTOPSY["ENABLED"] = not GMAUTOPSY["ENABLED"]

	elseif button == "MiddleButton" then 

		GMAUTOPSY_REPORT = {} 
		
		if IsAltKeyDown() then 
	
			demoToolTip()
	
		end 
	end
	
	UpdateLDB()	
end

function dataobj.OnTooltipShow(tooltip)
	tooltip:AddLine(ADDON)	
	tooltip:AddLine(" ")
	
	if #GMAUTOPSY_REPORT > 0 then
	
		tooltip:AddLine("Latest " .. #GMAUTOPSY_REPORT .. " saved reports:", 1,1,1)
		tooltip:AddLine(" ")
	
		for line = 1, #GMAUTOPSY_REPORT do
	
			tooltip:AddDoubleLine(
				
				string_format("%s |cFFFF0000%s|r killed %s with %s", 
					GMAUTOPSY_REPORT[line]["timestamp"],
					GMAUTOPSY_REPORT[line]["sourceName"],
					GMAUTOPSY_REPORT[line]["destName"],
					GMAUTOPSY_REPORT[line]["spell"]
				),
				
				string_format("%s | %s", 
					GMAUTOPSY_REPORT[line]["damage"],
					GMAUTOPSY_REPORT[line]["overkill"]
				), 
				1,1,1,1,1,1
			)					
		end
	
	else
		tooltip:AddLine("No records to show yet",1,1,1)
	end
	
	tooltip:AddLine(" ")	
	tooltip:AddDoubleLine("Left Click", 		"Toggle Channel")
	tooltip:AddDoubleLine("Right Click", 		"Switch On|Off")
	tooltip:AddDoubleLine("Middle Click",		"Clear Tooltip")
	tooltip:AddDoubleLine("ALT-Middle Click",	"Demo Tooltip")
end


frame:SetScript("OnEvent", function(self, event, ...)
	
	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then	
	
		UpdateLDB()

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then 
	
		local timestamp, clevent, _, _, sourceName, _, _, destGUID, destName, _, _, prefixParam1, prefixParam2, _, suffixParam1, suffixParam2 = ...	
		local playerGUID
		local damagetype
		local autopsy_msg = nil
 		
		-- proceed with CLEU handling
		if not playerGUID then 
			playerGUID = UnitGUID("player") 
		end
		
		if destGUID == playerGUID or (destName and UnitClass(destName)) then

			sourceName = sourceName or "Someone"
			
			if clevent == "SWING_DAMAGE" then
			
				if prefixParam2 > 0 then 
					autopsy_msg = string_format("gmAutopsy: %s killed %s with %s Melee overkill %s", sourceName, destName, prefixParam1, prefixParam2)
				
					GMAUTOPSY_REPORT[#GMAUTOPSY_REPORT+1] = {
						timestamp 	= date("%H:%M:%S",timestamp),
						sourceName 	= sourceName,
						destName 	= color(destName),
						spell 		= "Melee",
						damage		= number(prefixParam1),
						overkill	= number(prefixParam2)
					}					
				end
			
			elseif clevent == "SPELL_DAMAGE" or clevent == "SPELL_PERIODIC_DAMAGE" or clevent == "RANGE_DAMAGE" then
			
				if suffixParam2 > 0 then 
					autopsy_msg = string_format("gmAutopsy: %s killed %s with %s damage of %s overkill %s", sourceName, destName, suffixParam1, GetSpellLink(prefixParam1), suffixParam2)

					GMAUTOPSY_REPORT[#GMAUTOPSY_REPORT+1] = {
						timestamp 	= date("%H:%M:%S",timestamp),
						sourceName 	= sourceName,
						destName 	= color(destName),
						spell 		= GetSpellLink(prefixParam1),
						damage		= number(suffixParam1),
						overkill	= number(suffixParam2)
					}					
				end				
			end

			
			if #GMAUTOPSY_REPORT >= 30 then table.remove(GMAUTOPSY_REPORT, 1) end
 			
			if autopsy_msg then 
			
				local autopsy_chn = GMAUTOPSY_OUTNAM[GMAUTOPSY["CHANNEL"]]

				if 	GMAUTOPSY["CHANNEL"] == 1 or autopsy_chn == "SELF" then 
					print(autopsy_msg)	
				end 
				
				-- find the right GROUP, thanks to Dridzt code in the posts: http://www.wowinterface.com/forums/showthread.php?t=48320
				if GMAUTOPSY["CHANNEL"] == 3 then				
					if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
					  autopsy_chn = "INSTANCE_CHAT"
					elseif IsInRaid() then
					  autopsy_chn = "RAID"
					elseif IsInGroup() then
					  autopsy_chn = "PARTY"
					else
					  autopsy_chn = "SELF"
					end
				end
								
				if (GMAUTOPSY["CHANNEL"] > 2 )then 
					SendChatMessage(autopsy_msg, autopsy_chn)
				end 
			end			
		end
	end
end)