SLASH_GMCLEARCHAT1 = "/clear"
SLASH_GMCLEARCHAT2 = "/clearchat"

SlashCmdList.GMCLEARCHAT = function(cmd)
	cmd = cmd and strtrim(strlower(cmd))
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame"..i]
		if f:IsVisible() or cmd == "all" then f:Clear() end
	end
end