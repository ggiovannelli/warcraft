local prgname = "|cffffd200gmUI|r"


SLASH_GMUI1 = "/gmui"
SlashCmdList["GMUI"] = function(args) 
	local cmd=SecureCmdOptionParse(args)
	cmd=cmd:lower()
	
	if cmd == "reset" then

		print(prgname .. ": resetting default units frames positions") 
	
		-- SlashCmdList["rab"]("reset")
		-- SlashCmdList["rmm"]("reset")
		-- SlashCmdList["rbf"]("reset")
		SlashCmdList["ouf_simple"]("reset")
		
	else
	
		print(prgname .. ":")
		print("/gmui  - This help")
		print("/gmui reset - Reset gmUI to the defaults")
		return
		
	end
end