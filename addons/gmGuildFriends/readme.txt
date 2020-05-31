830-2020041801
- make the status icon a little bigger
- now add a + in the status if the players are in group with you (usefull if you want to raid invite :)
- fix the Left mouse click if not in guild

830-2020041301
- changed the saved var name. 
- make an hack to prevent playerinfo note overlap 
- prevent to click in combat to open guild and friends panel 
- if bnet account == character print only ones.

830-2020032601
- add a scrollbar if tooltip is long and limits to: (GetScreenHeight()-100)
- change the layout of LEVEL column

830-2020032501
- Add an option to filter out BNET friends actually not playing (for people with looong friends lists).

This can breaks your config. 
Please go in Interface --> Addons --> gmGuildFriends --> Press: "Reset and reloadUI"
This should be enough. If not you have to manual delete the SavedVariable when the game is close.
A message will appear on entering world about this.

- rewrite the layout and the display of bnet friends

830-2020032402
- fix a problem with BNET friends in WoW classic

830-2020032401
- used the justification of libqtip instead of custom code
Thanks to EKE for input on this :)
https://www.wowinterface.com/downloads/fileinfo.php?id=25522#comments

 
830-2020032205
- Added the player info note sub tip
- Added the option to use it or not
- Added the localization for some new strings

830-2020032204
- Call a GuildRoster() before building the guild tooltip.
- Update all the libs to the latest
- Add the options to hide/show the guild message of the day
This can breaks your config. 
Please go in Interface --> Addons --> gmGuildFriends --> Press: "Reset and reloadUI"
This should be enough. If not you have to manual delete the SavedVariable when the game is close.
A message will appear on entering world about this.
 
830-2020032203
- Fix ToggleGuildFrame() to real toogle :)
- Implement a minimum of options panel to hide/show section (guild/bnet/frame/legenda).
- Used the graphical mouse icons for legenda and prepare an option config: text/graphical

I am thinking also to split guild and friends in 2 ldb for who has lots of guild mates or friends.
It is not our case but may happens :)

830-2020032102
- Fix the display of long guild motd (word wrap at 69 line length).
- Replaced the zhCN localization (my fault, thanks EKE!)

830-2020032101
- first release
Thanks to all you guys in WoWI forum, in special way Vrul and Fizzlemizz for help and patience.
You are fantastic.
https://www.wowinterface.com/forums/showthread.php?p=335396