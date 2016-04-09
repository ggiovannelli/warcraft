local ADDON = ...

local prgname = "|cffffd200gmGG|r"
local string_format = string.format
local name, realm = UnitName("player")

GMGG = {
     ENABLED = true,
 }

 local GGmsg = {
	"GG %s !!",
	"GZ %s !!",
	" 'gratz to our might guildmate %s :)",
	"complimenti %s !!! ",
	"gg %s",
	"gz %s",
	"GG",
	"gg",
	"gz :)",
	"GG ... e falli tutti te questi achivements :)",
	"gg !!!  Mi sembra che sia un achivement tosto eh ?",
	"GG !  Un giorno, forse, lo faro' pure io :) ",
	"GZ ! Non sono mai riuscito a farlo io :-)",
}
 
local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_GUILD_ACHIEVEMENT" then
		local _, _, _, _, pgname, _ = ...		
		if pgname == name then  
			SendChatMessage("GG a me !!", "GUILD")
		else	
			SendChatMessage(string_format(GGmsg[random(1,#GGmsg)],pgname), "GUILD")
		end
	end
end)	


