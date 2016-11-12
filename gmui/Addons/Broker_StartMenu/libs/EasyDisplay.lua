assert(LibStub, "EasyDisplay-1.0 requires LibStub")

local lib, minor = LibStub:NewLibrary("EasyDisplay-1.0", 13)
if not lib then return end
minor = minor or 0

local GetUIPanel = GetUIPanel
local HideUIPanel = HideUIPanel
local ShowUIPanel = ShowUIPanel
local UIPanelWindows = UIPanelWindows

--[[ LOCALIZATION ]]

local BAGS = "Bags"
local CALENDAR = "Calendar"
local CHARACTER_MSG = "|cffFFFF00Cannot display interface '%s' because the character level is too low.|r"

--[[ INTERFACES ]]

--[[
	name (string) 
	The name to access the interface.
	
	title (string)
	A human-readable name that describes the interface.
	
	alias (string)
	An optional name to access the interface.
	
	frameName (string) 
	The name of the frame as it appears in the UIPanelWindows table
	or the name of the frame as it appears in the ProtectedFrames table.
	
	button (frame)
	The button that responsible to open the interface in the default UI.
	
	level (number) 
	The minimum level that is required to display the interface to the player.
	
	func (function)
	The function that responsible to display the interface.
	
	special (boolean)
	Indicates that it requires special handling before it can be displayed.
	
	secure (boolean)
	Indicates that it needs to be opened from a secure context.
	
	command (string)
	The name of the command for key bindings.
]]

local interfaces = {
	{
		name = "achievements",
		title = ACHIEVEMENT_BUTTON,
		alias = "achi",
		frameName = "AchievementFrame",
		button = AchievementMicroButton,
		command = "TOGGLEACHIEVEMENT",
		func = function() ToggleAchievementFrame() end,
	},
	{
		name = "addons",
		title = ADDONS,
		frameName = "AddonList",
		special = true,
		func = function() 
			if not AddonList:IsVisible() then
				ShowUIPanel(AddonList)
				AddonList.hideMenu = true
			else
				HideUIPanel(AddonList)
			end
		end,
	},
	{
		name = "backpack",
		title = BACKPACK_TOOLTIP,
		command = "TOGGLEBACKPACK",
		func = function() 
			if IsModifierKeyDown() then
				ToggleAllBags()
			else
				ToggleBackpack()
			end
		end,
	},
	{
		name = "bags",
		title = BAGS,
		command = "OPENALLBAGS",
		func = function() ToggleAllBags() end,
	},
	{
		name = "calendar",
		title = CALENDAR,
		alias = "cal",
		frameName = "CalendarFrame",
		func = function() ToggleCalendar() end,
	},
	{
		name = "character",
		title = CHARACTER_BUTTON,
		alias = "char",
		frameName = "CharacterFrame",
		--button = CharacterMicroButton,
		command = "TOGGLECHARACTER0",
		func = function() ToggleCharacter("PaperDollFrame") end,
	},
	{
		name = "collections",
		title = COLLECTIONS,
		alias = "pets",
		frameName = "PetJournalParent",
		button = CompanionsMicroButton,
		secure = true,
		command = "TOGGLECOLLECTIONS",
		func = function() ToggleCollectionsJournal() end,
	},
	{
		name = "guild",
		title = LOOKINGFORGUILD,
		frameName = "GuildFrame",
		button = GuildMicroButton,
		secure = true,
		command = "TOGGLEGUILDTAB",
		func = function() ToggleGuildFrame() end,
	},
	{
		name = "help",
		title = HELP_BUTTON,
		frameName = "HelpFrame",
		button = HelpMicroButton,
		func = function() ToggleHelpFrame() end,
	},
	{
		name = "interface",
		title = UIOPTIONS_MENU,
		frameName = "InterfaceOptionsFrame",
		secure = true,
		special = true,
		func = function()
			if not InterfaceOptionsFrame:IsVisible() then
				ShowUIPanel(InterfaceOptionsFrame)
				InterfaceOptionsFrame.lastFrame = GameMenuFrame
				InterfaceOptionsFrame.hideMenu = true
			else
				HideUIPanel(InterfaceOptionsFrame)
			end
		end,
	},
	{
		name = "journal",
		title = ENCOUNTER_JOURNAL,
		frameName = "EncounterJournal",
		level = SHOW_LFD_LEVEL,
		button = EJMicroButton,
		secure = true,
		command = "TOGGLEENCOUNTERJOURNAL",
		func = function() ToggleEncounterJournal() end,
	},
	{
		name = "keybindings",
		title = KEY_BINDINGS,
		alias = "keys",
		frameName = "KeyBindingFrame",
		special = true,
		func = function()
			if not KeyBindingFrame:IsVisible() then
				ShowUIPanel(KeyBindingFrame)
				KeyBindingFrame.hideMenu = true
			else
				HideUIPanel(KeyBindingFrame)
			end
		end,
	},
	{
		name = "lfd",
		title = DUNGEONS_BUTTON,
		frameName = "LFDParentFrame",
		level = SHOW_LFD_LEVEL,
		button = LFDMicroButton,
		secure = true,
		command = "TOGGLEGROUPFINDER",
		func = function() ToggleLFDParentFrame() end,
	},
	{
		name = "lfr",
		title = RAID_FINDER,
		frameName = "LFRParentFrame",
		level = SHOW_LFD_LEVEL,
		func = function() ToggleRaidFrame() end,
	},
	{
		name = "mac",
		title = MAC_OPTIONS,
		frameName = "MacOptionsFrame",
		special = true,
		func = function()
			if not MacOptionsFrame:IsVisible() then
				ShowUIPanel(MacOptionsFrame)
				MacOptionsFrame.hideMenu = true
			else
				HideUIPanel(MacOptionsFrame)
			end
		end,
	},
	{
		name = "macro",
		title = MACROS,
		frameName = "MacroFrame",
		special = true,
		func = function()
			if not MacroFrame:IsVisible() then
				ShowUIPanel(MacroFrame)
			else
				HideUIPanel(MacroFrame)
			end
		end,
	},
	{
		name = "mainmenu",
		title = MAINMENU_BUTTON,
		alias = "menu",
		frameName = "GameMenuFrame",
		--button = MainMenuMicroButton,
		command = "TOGGLEGAMEMENU",
		func = function()
            -- Calling ToggleGameMenu() causes the UI to taint.
			if not GameMenuFrame:IsShown() then
				if VideoOptionsFrame:IsShown() then
					VideoOptionsFrameCancel:Click()
				elseif AudioOptionsFrame:IsShown() then
					AudioOptionsFrameCancel:Click()
				elseif InterfaceOptionsFrame:IsShown() then
					InterfaceOptionsFrameCancel:Click()
				end	
				CloseMenus()
				CloseAllWindows()
				ShowUIPanel(GameMenuFrame)
			else
				HideUIPanel(GameMenuFrame)
			end
		end,
	},
	{
		name = "options",
		title = SYSTEMOPTIONS_MENU,
		alias = "system",
		frameName = "VideoOptionsFrame",
		secure = true,
		special = true,
		func = function()
			if not VideoOptionsFrame:IsVisible() then
				ShowUIPanel(VideoOptionsFrame)
				VideoOptionsFrame.lastFrame = GameMenuFrame
				VideoOptionsFrame.hideMenu = true
			else
				HideUIPanel(VideoOptionsFrame)
			end
		end,
	},
	{
		name = "pvp",
		title = PLAYER_V_PLAYER,
		frameName = "PVPFrame",
		level = SHOW_PVP_LEVEL,
		button = PVPMicroButton,
		secure = true,
		func = function() TogglePVPUI() end,
	},
	{
		name = "questlog",
		title = QUESTLOG_BUTTON,
		alias = "ql",
		frameName = "QuestLogFrame",
		button = QuestLogMicroButton,
		command = "TOGGLEQUESTLOG",
		func = function() ToggleQuestLog() end,
	},
	{
		name = "shops",
		title = BLIZZARD_STORE,
		func = function() ToggleStoreUI() end,
	},
	{
		name = "social",
		title = SOCIAL_BUTTON,
		alias = "soc",
		frameName = "FriendsFrame",
		special = true,
		func = function() ToggleFriendsFrame() end,
	},
	{
		name = "spellbook",
		title = SPELLBOOK_ABILITIES_BUTTON,
		alias = "sb",
		frameName = "SpellBookFrame",
		button = SpellbookMicroButton,
		secure = true,
		command = "TOGGLESPELLBOOK",
		func = function() ToggleFrame(SpellBookFrame) end,
	},
	{
		name = "talents",
		title = TALENTS_BUTTON,
		alias = "tal",
		frameName = "PlayerTalentFrame",
		level = SHOW_TALENT_LEVEL,
		button = TalentMicroButton,
		secure = true,
		command = "TOGGLETALENTS",
		func = function() ToggleTalentFrame() end,
	},
	{
		name = "time",
		title = TIMEMANAGER_TITLE,
		frameName = "TimeManagerFrame",
		func = function() ToggleTimeManager() end,
	},
	{
		name = "whatsnew",
		title = GAMEMENU_NEW_BUTTON,
		special = true,
		func = function() SplashFrame_Open() end,
	}
}

-- if we're not using a mac client, remove the interface from the table.
if IsMacClient() ~= 1 then
	for i, v in ipairs(interfaces) do
		if v.name == "mac" then
			table.remove(interfaces, i) 
			break
		end
	end
end

-- We need to show addons only when we have at least one addon available.
if GetNumAddOns() <= 0 then
	for i, v in ipairs(interfaces) do
		if v.name == "addons" then
			table.remove(interfaces, i) 
			break
		end
	end
end

local function comp(a, b)
	return a.title:lower() < b.title:lower()
end

table.sort(interfaces, comp)

--[[ APIs ]]

--[[ GetInterface(name) - Gets the interface by a given name, alias or title.

	Arguments.
	name - (string) The name, alias or title of the interface to display.
	
	Returns.
	interface - (table) The interface entry.
	index - (number) The index of interface in the table.
	
]]

function lib:GetInterface(name)
	local interface, index  = nil, 0
	if  name and type(name) == "string" then
		for i, v in ipairs(interfaces) do
			if v.name == name or v.alias == name or v.title == name then
				interface = v
				index = i
				break
			end
		end
	end
	return interface, index
end

--[[ GetInterfaceByIndex(index) - Gets the interface by a given index

	Arguments.
	index - (number) The index of the interface to display.
	
	Returns.
	interface - (table) The interface entry.
	
]]

function lib:GetInterfaceByIndex(index)
	local interface
	if  index and type(index) == "number" then
		interface = interfaces[index]
	end
	return interface
end

--[[ Interfaces() - Traverses over the interfaces. 

	Returns.
	iterator - (function) An iterator to traverse over the interfaces.
	
]]

function lib:Interfaces()
	return ipairs(interfaces)
end

--[[ InterfacesCount() - Counts the amount if interfaces we have.

	Returns.
	iterator - (function) An iterator to traverse over the interfaces.
	
]]

local count = #interfaces

function lib:InterfacesCount()
	return count
end

--[[ DisplayInterface(name) - Displays the interface.

	Arguments.
	name - (string) The key, alias  or title of the interface to display.
	
]]

-- A list of all the interfaces that require the GameMenuFrame to be closed before opening them.
GameMenu_OptionFrames = {
	["VideoOptionsFrame"] = true,
	["AudioOptionsFrame"] = true,
	["InterfaceOptionsFrame"] = true,
	["MacOptionsFrame"] = true,
	["KeyBindingFrame"] = true,
	["AddonList"] = true
}

-- A list of all of the interfaces that must be loaded before they can be displayed.
LoD_AddonFrames = {
	["PlayerTalentFrame"] = TalentFrame_LoadUI,
	["AchievementFrame"] = AchievementFrame_LoadUI,
	["CalendarFrame"] = Calendar_LoadUI,
	["KeyBindingFrame"] = KeyBindingFrame_LoadUI,
	["MacroFrame"] = MacroFrame_LoadUI,
	["TimeManagerFrame"] = TimeManager_LoadUI,
	["GuildFrame"] = GuildFrame_LoadUI,
	["EncounterJournal"] = EncounterJournal_LoadUI
}

-- Hides the GameMenuFrame and resets the hideMenu flag.
-- The hideMenu flag dictates whether the GameMenuFrame should be hidden when the interface is closed.
local function hideUIPanel(self)
	if self.hideMenu then
		HideUIPanel(GameMenuFrame)
		self.hideMenu = nil
	end
end

function lib:DisplayInterface(name)
	local interface = self:GetInterface(name)
	if interface and interface.func and type(interface.func) == "function" then
		if interface.frameName then
		
			local playerLevel = UnitLevel("player")
			-- Check whether the player is in appropriate level for the interface to be displayed.
			if interface.level and tonumber(interface.level) and playerLevel < interface.level  then
				print(CHARACTER_MSG:format(interface.frameName))
				return
			end
			
			local loadLoD = LoD_AddonFrames[interface.frameName]
			-- Check whether it should preload the associated addon.
			if loadLoD then loadLoD() end
			
			-- Manages the display of the interfaces.
			local panel = UIPanelWindows[interface.frameName]
			local centerFrame = not (GetUIPanel("left") or GetUIPanel("right") or GetUIPanel("doublewide")) and GetUIPanel("center")
			
			if panel and panel.area ~= "center" and centerFrame and centerFrame:IsShown() then
				HideUIPanel(centerFrame)
			end
			
			-- Display the interface.
			interface.func()
			
			-- This hides the GameMenuFrame when the interface is opened through this function.
			if GameMenu_OptionFrames[interface.frameName] then
				local frame = _G[interface.frameName]
				if frame then
					frame:HookScript("OnHide", hideUIPanel) 
				end
				GameMenu_OptionFrames[interface.frameName] = nil
			end
			
		-- The interface does not have a frameName entry so just run the function to display it.
		else
			interface.func()
		end
	end
end
