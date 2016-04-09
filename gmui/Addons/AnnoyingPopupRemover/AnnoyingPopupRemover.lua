-- AnnoyingPopupRemover.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Licensed under the MIT License, as below.
--
-- Copyright (c) 2015 KyrosKrane Sylvanblade
--
--#########################################
--# License: MIT License
--#########################################

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

-- This add-on file removes a number of annoying pop-ups.
--	It removes the popup confirmation dialog when looting a bind-on-pickup item.
--	It removes the popup confirmation dialog when rolling on a bind-on-pickup item.
--	It removes the popup confirmation dialog when adding a BOP item to void storage, and that item is modified (gemmed, enchanted, or transmogged) or still tradable with the looting group.


--#########################################
--# Global Variables
--#########################################

-- Define a global for our namespace
local APR = { };

-- Define whether we're in debug mode or production mode. True means debug; false means production.
APR.DebugMode = false;

-- Set the current version so we can display it.
APR.Version = "v2.1-release";

-- Create the frame to hold our event catcher, and the list of events.
APR.Frame, APR.Events = CreateFrame("Frame"), {};

-- Create a holder to store dialogs we're removing, in case the user wants to restore them.
APR.StoredDialogs = {};

-- Get a local reference to these functions to speed up execution.
local rawset = rawset
local tostring = tostring
local select = select
local pairs = pairs
local type = type

-- Get the language used by the client.
APR.locale = GetLocale();


--#########################################
--# Localization
--#########################################

-- This bit of meta-magic makes it so that if we call L with a key that doesn't yet exist, a key is created automatically, and its value is the name of the key.  For example, if L["MyAddon"] doesn't exist, and I run print (L["MyAddon"]), the __index command causes the L table to automatically create a new key called MyAddon, and its value is set to tostring("MyAddon") -- same as the key name.
local L = setmetatable({ }, {__index = function(t, k)
	local v = tostring(k);
	rawset(t, k, v);
	return v;
end})

-- The above system effectively makes it so that we don't have to define the default, English-language values.  Just set the key name as the English value.
-- Set the default strings used here.  Other languages can override these as needed.
-- Not going to localize debug strings for now.

-- In another file, you can override these strings like:
--		if APR.locale == "deDE" then
--			L["APR"] = "German name of APR here";
--		end
-- That way, it preserves the default English strings in case of a missed translation.


--#########################################
--# Utility Functions
--#########################################

-- Print debug output to the chat frame.
function APR:DebugPrint(...)
	if (APR.DebugMode) then
		print ("|cff" .. "a00000" .. L["APR"] .. " " .. L["Debug"] .. ":|r", ...);
	end
end -- APR:DebugPrint


-- Print standard output to the chat frame.
function APR:ChatPrint(...)
	print ("|cff" .. "0066ff" .. L["APR"] ..":|r", ...);
end -- APR:ChatPrint()


-- Debugging code to see what the hell is being passed in...
function APR:PrintVarArgs(...)
	local n = select('#', ...)
	APR:DebugPrint ("There are ", n, " items in varargs.")
	local msg
	for i = 1, n do
		msg = select(i, ...)
		APR:DebugPrint ("Item ", i, " is ", msg);
	end
end -- APR:PrintVarArgs()


-- Dumps a table into chat. Not intended for production use.
function APR:DumpTable(tab, indent)
	if not indent then indent = 0 end
	if indent > 10 then
		APR:DebugPrint("Recursion is at 11 already; aborting.")
		return
	end
	for k, v in pairs(tab) do
		local s = ""
		if indent > 0 then
			for i = 0, indent do
				s = s .. "    ";
			end
		end
		if "table" == type(v) then
			s = s .. "Item " .. k .. " is sub-table." ;
			APR:DebugPrint(s);
			indent = indent + 1;
			APR:DumpTable(v, indent);
			indent = indent - 1;
		else
			s = s .. "Item " .. k .. " is " .. tostring(v);
			APR:DebugPrint(s);
		end
	end
end -- APR:DumpTable()


-- Splits a string into sections, based on a specified separator.
-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern).
-- example: APR:strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
-- Adapted from Lua manual: http://lua-users.org/wiki/SplitJoin
function APR:strsplit(delimiter, text)
  local list = {}
	local pos = 1
	if strfind("", delimiter, 1) then
		-- this would result in endless loops
		-- error("delimiter matches empty string!")

		-- return the entire string instead.
		tinsert(list, text)
		return list
	end
	while 1 do
		local first, last = strfind(text, delimiter, pos)
		if first then -- found?
			tinsert(list, strsub(text, pos, first-1))
			pos = last+1
		else
			tinsert(list, strsub(text, pos))
			break
		end
	end
	return list
end -- APR:strsplit()


--#########################################
--# Slash command handling
--#########################################

-- Set the default slash command.
SLASH_APR1 = "/apr"
SlashCmdList.APR = function (...) APR:HandleCommandLine(...) end


-- Respond to user chat-line commands.
function APR:HandleCommandLine(msg, editbox)
	-- no clue why the slash command handler passes in info about the message box itself, but it does...

	APR:DebugPrint ("msg is " .. msg);
	local Line = APR:strsplit("%s+", string.lower(msg));
	-- APR:DumpTable(Line);

	-- Validate parameters. Only 1 and 2 are checked; rest are ignored.
	if Line[2] then
		if "bind" == Line[2] or "loot" == Line[2] or "roll" == Line[2] or "void" == Line[2] then
			if "show" == Line[1] or "hide" == Line[1] then
				APR:TogglePopup(Line[2], Line[1])
				return;
			end
		-- Undocumented command to toggle the debug state from the command line.
		elseif "debug" == Line[1] then
			if "on" == Line[2] then
				APR:SetDebug(true);
				return;
			elseif "off" == Line[2] then
				APR:SetDebug(false);
				return;
			end
		end
	elseif Line[1] then
		if "status" == Line[1] then
			APR:PrintStatus();
			return;
		elseif "help" == Line[1] then
			APR:PrintHelp();
			return;
		end

	-- else no parameters specified
	end

	-- if we get here, then the validation failed.
	APR:ChatPrint(L["Error: unknown command."]);
	APR:PrintHelp();
end -- APR:HandleCommandLine()


-- Print the instructions for the user.
function APR:PrintHelp()
	APR:ChatPrint (L["Allowed commands for"] .. " " .. L["Annoying Pop-up Remover"] .. ":");
	APR:ChatPrint("/apr   show |cffFFCC00OR|r hide   bind |cffFFCC00OR|r roll |cffFFCC00OR|r void"); -- not localized on purpose
	APR:ChatPrint("/apr status"); -- not localized on purpose
	APR:ChatPrint("/apr help"); -- not localized on purpose
end -- APR:PrintHelp()


-- Print the status for a given popup type, or for all if not specified.
-- popup is optional
function APR:PrintStatus(popup)
	if not popup or "bind" == popup then
		if APR.DB.HideBind then
			APR:ChatPrint (L["Confirmation pop-up when |cff00ff00looting|r bind-on-pickup items will be |cff00ff00hidden|r."]);
		else
			APR:ChatPrint (L["Confirmation pop-up when |cffff0000looting|r bind-on-pickup items will be |cffff0000shown|r."]);
		end
	end
	if not popup or "roll" == popup then
		if APR.DB.HideRoll then
			APR:ChatPrint (L["Confirmation pop-up when |cff00ff00rolling|r on bind-on-pickup items will be |cff00ff00hidden|r."]);
		else
			APR:ChatPrint (L["Confirmation pop-up when |cffff0000rolling|r on bind-on-pickup items will be |cffff0000shown|r."]);
		end
	end
	if not popup or "void" == popup then
		if APR.DB.HideVoid then
			APR:ChatPrint (L["Confirmation pop-up when depositing modified items into |cff00ff00void storage|r will be |cff00ff00hidden|r."]);
		else
			APR:ChatPrint (L["Confirmation pop-up when depositing modified items into |cffff0000void storage|r will be |cffff0000shown|r."]);
		end
	end
end -- APR:PrintStatus()


-- Dispatcher function to call the correct show or hide function for the appropriate popup window.
-- popup is required, state is optional
function APR:TogglePopup(popup, state)
	-- The status message highlighting highlights the word "looting" for looting bind on pickup items. So, the user might use the keyword "loot" instead of "bind". Handle that here.
	if "loot" == popup then popup = "bind" end;

	if "bind" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupBind(true);
			elseif "hide" == state then
				APR:HidePopupBind(true);
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.");
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideBind then
				APR:ShowPopupBind(true);
			else
				APR:HidePopupBind(true);
			end
		end

	elseif "roll" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupRoll(true);
			elseif "hide" == state then
				APR:HidePopupRoll(true);
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.");
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideRoll then
				APR:ShowPopupRoll(true);
			else
				APR:HidePopupRoll(true);
			end
		end

	elseif "void" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupVoid(true);
			elseif "hide" == state then
				APR:HidePopupVoid(true);
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.");
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideVoid then
				APR:ShowPopupVoid(true);
			else
				APR:HidePopupVoid(true);
			end
		end

	else
		-- error, bad programmer, no cookie!
		DebugPrint("Error in APR:TogglePopup: unknown popup type " .. popup .. " passed in.");
		return false
	end
end -- APR:TogglePopup()


function APR:SetDebug(mode)
	if mode then
		APR.DebugMode = true;
		APR:ChatPrint ("Debug mode is now on.")
	else
		APR.DebugMode = false;
		APR:ChatPrint ("Debug mode is now off.")
	end
end -- APR:SetDebug()


--#########################################
--# Dialog toggling functions
--#########################################

-- Show and hide functions for each of the supported types
-- not documenting individually, as it should be clear what they do.

function APR:ShowPopupBind(printconfirm)
	APR:DebugPrint ("in APR:ShowPopupBind");
	if APR.DB.HideBind then
		-- Re-enable the dialog that pops to confirm looting BoP gear yourself.
		StaticPopupDialogs["LOOT_BIND"] = APR.StoredDialogs["LOOT_BIND"];
		APR.StoredDialogs["LOOT_BIND"] = nil;

		-- Mark that the dialog is shown.
		APR.DB.HideBind = false;

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("bind") end;
end -- APR:ShowPopupBind()


function APR:ShowPopupRoll(printconfirm)
	APR:DebugPrint ("in APR:ShowPopupRoll");
	if APR.DB.HideRoll then
		-- Re-enable the dialog for the event that triggers when rolling on BOP items.
		StaticPopupDialogs["CONFIRM_LOOT_ROLL"] = APR.StoredDialogs["CONFIRM_LOOT_ROLL"];
		APR.StoredDialogs["CONFIRM_LOOT_ROLL"] = nil;

		-- Mark that the dialog is shown.
		APR.DB.HideRoll = false;

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("roll") end;
end -- APR:ShowPopupRoll()


function APR:ShowPopupVoid(printconfirm)
	APR:DebugPrint ("in APR:ShowPopupVoid");
	if APR.DB.HideVoid then
		-- Re-enable the dialog for putting tradable or modified items into void storage.
		StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"] = APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"];
		APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"] = nil;

		-- Mark that the dialog is shown.
		APR.DB.HideVoid = false;

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("void") end;
end -- APR:ShowPopupVoid()


function APR:HidePopupBind(printconfirm, ForceHide)
	APR:DebugPrint ("in APR:HidePopupBind");
	if not APR.DB.HideBind or ForceHide then
		-- Disable the dialog that pops to confirm looting BoP gear yourself.
		APR.StoredDialogs["LOOT_BIND"] = StaticPopupDialogs["LOOT_BIND"];
		StaticPopupDialogs["LOOT_BIND"] = nil;

		-- Mark that the dialog is hidden.
		APR.DB.HideBind = true;

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("bind") end;
end -- APR:HidePopupBind()


function APR:HidePopupRoll(printconfirm, ForceHide)
	APR:DebugPrint ("in APR:HidePopupRoll");
	if not APR.DB.HideRoll or ForceHide then
		-- Disable the dialog for the event that triggers when rolling on BOP items.
		APR.StoredDialogs["CONFIRM_LOOT_ROLL"] = StaticPopupDialogs["CONFIRM_LOOT_ROLL"];
		StaticPopupDialogs["CONFIRM_LOOT_ROLL"] = nil;

		-- Mark that the dialog is hidden.
		APR.DB.HideRoll = true;

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("roll") end;
end -- APR:HidePopupRoll()


function APR:HidePopupVoid(printconfirm, ForceHide)
	APR:DebugPrint ("in APR:HidePopupVoid");
	if not APR.DB.HideVoid or ForceHide then
		-- Disable the dialog for putting tradable or modified items into void storage.
		APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"] = StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"];
		StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"] = nil;

		-- Mark that the dialog is hidden.
		APR.DB.HideVoid = true;

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("void") end;
end -- APR:HidePopupVoid()


--#########################################
--# Event hooks
--#########################################

-- Looting a BOP item triggers this event.
function APR.Events:LOOT_BIND_CONFIRM(Frame, ...)
	local id = ...;

	if (APR.DebugMode) then
		APR:DebugPrint ("In APR.Events:LOOT_BIND_CONFIRM");
		APR:DebugPrint ("Frame is ", Frame);
		APR:PrintVarArgs(...);
	end -- if APR.DebugMode

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideBind then
		APR:DebugPrint ("HideBind off, not auto confirming");
		return
	end;

	ConfirmLootSlot(id);
end -- APR.Events:LOOT_BIND_CONFIRM()


-- Rolling on a BOP item triggers this event.
function APR.Events:CONFIRM_LOOT_ROLL(...)
	if (APR.DebugMode) then
		APR:DebugPrint ("In APR.Events:CONFIRM_LOOT_ROLL");
		APR:PrintVarArgs(...);
	end -- if APR.DebugMode

	local id, rollType = ...;

	APR:DebugPrint ("id is ", id);
	APR:DebugPrint ("rollType is ", rollType);

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideRoll then
		APR:DebugPrint ("HideRoll off, not auto confirming");
		return
	end;

	ConfirmLootRoll(id, rollType);
end -- APR.Events:CONFIRM_LOOT_ROLL()


-- Depositing an item that's modified (gemmed, enchanted, or transmogged) or a BOP item still tradable in group triggers this event.
function APR.Events:VOID_DEPOSIT_WARNING(...)
	if (APR.DebugMode) then
		APR:DebugPrint ("In APR.Events:VOID_DEPOSIT_WARNING");
		APR:PrintVarArgs(...);
	end -- if APR.DebugMode

	-- Document the incoming parameters.
	local slot, itemLink = ...;
	APR:DebugPrint ("slot is ", slot);

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideVoid then
		APR:DebugPrint ("HideVoid off, not auto confirming");
		return
	end;

	-- prior to this event firing, the game triggers "VOID_STORAGE_DEPOSIT_UPDATE", which disables the transfer button and pops up the dialog.
	-- So, we simulate clicking OK with the UpdateTransferButton, and pass "nil" to indicate the warning dialog isn't showing.
	VoidStorage_UpdateTransferButton(nil);
end -- APR.Events:VOID_DEPOSIT_WARNING()


-- For debugging only.
function APR.Events:VOID_STORAGE_DEPOSIT_UPDATE(...)
	-- We don't actually do anything in this function; it's just for debugging.
	if (not APR.DebugMode) then return end;

	APR:DebugPrint ("In APR.Events:VOID_STORAGE_DEPOSIT_UPDATE");
	APR:PrintVarArgs(...);

	-- Document the incoming parameters.
	-- local slot = ...;

end -- APR.Events:VOID_STORAGE_DEPOSIT_UPDATE()


-- On-load handler for addon initialization.
function APR.Events:PLAYER_LOGIN(...)
	-- Announce our load.
	APR:ChatPrint (L["Annoying Pop-up Remover"] .. " " .. APR.Version .. " " .. L["loaded"] .. ". For help and options, type /apr help");

	-- Force the default Void Storage frame to load so we can override it.
	local isloaded, reason = LoadAddOn("Blizzard_VoidStorageUI")
	APR:DebugPrint ("Blizzard_VoidStorageUI isloaded is ", isloaded);
	APR:DebugPrint ("Blizzard_VoidStorageUI reason is ", reason);
end -- APR.Events:PLAYER_LOGIN()


function APR.Events:ADDON_LOADED(addon)
	APR:DebugPrint ("Got ADDON_LOADED for " .. addon);
	if addon == "AnnoyingPopupRemover" then
		-- Load the saved variables, or initialize if they don't exist yet.
		if APR_DB and APR_DB.HideBind ~= nil and APR_DB.HideRoll ~= nil and APR_DB.HideVoid ~= nil then
			APR:DebugPrint ("Loading existing saved var.");
			APR.DB = APR_DB
		else
			APR:DebugPrint ("No saved var, setting defaults.");
			APR.DB = {
				HideBind = true,
				HideRoll = true,
				HideVoid = true,
			} ;
		end

		APR:DebugPrint ("HideBind is " .. (APR.DB.HideBind and "true" or "false"));
		APR:DebugPrint ("HideRoll is " .. (APR.DB.HideRoll and "true" or "false"));
		APR:DebugPrint ("HideVoid is " .. (APR.DB.HideVoid and "true" or "false"));

		-- Hide the dialogs the user has selected.
		-- In this scenario, the DB variable is already true, but the dialog has not yet been hidden. So, we pass true to forcibly hide the dialogs.
		if APR.DB.HideBind then APR:HidePopupBind(false, true) end;
		if APR.DB.HideRoll then APR:HidePopupRoll(false, true) end;
		if APR.DB.HideVoid then APR:HidePopupVoid(false, true) end;

	end -- if AnnoyingPopupRemover
end -- APR.Events:PLAYER_LOGIN()


-- Save the db on logout.
function APR.Events:PLAYER_LOGOUT(...)
	APR:DebugPrint ("In PLAYER_LOGOUT, saving DB.");
	APR_DB = APR.DB;
end -- APR.Events:PLAYER_LOGOUT()


--#########################################
--# Implement the event handlers
--#########################################

-- Create the event handler function.
APR.Frame:SetScript("OnEvent", function(self, event, ...)
	APR.Events[event](self, ...); -- call one of the functions above
end);

-- Register all events for which handlers have been defined
for k, v in pairs(APR.Events) do
	APR:DebugPrint ("Registering event ", k);
	APR.Frame:RegisterEvent(k);
end


