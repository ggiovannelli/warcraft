830-2020041701
- added in legenda SHIFT+MIDDLE
- modified the globals string for help
- when enter in tooltip close legenda if open

830-2020040601
- rewritten using libqtip
- addeded tooltip scale
- added a legenda and modified the action keys|mouse
- changed the way defaults are loaded
 
830-2020031501
- bump toc

820-2019062801
- bump toc

810-2018122201
- Bump Toc for 8.1

801-2018083101
- Localization: frFR. Thanks to Tasunke.

801-2018081901
- Used a better (and locale friendly, I hope :) way to get the "Heart of Azeroth" name

801-2018081801
- Initial release for tracking again legion artifacts and bfa azerite neck.

801-2018072101
- Removed Artifact related informations
- Bump Toc for 8.0

730-2018030401
- Added a simple pg list (name,level,ilv) of some pg (default=24).
It can be enabled/disabled by editing core.lua line 16, i.e:
local list_enable = false 

The number of max pg can be modified in line 17 of core.lua, i.e:
local list_maxpgnum = 10

The list is not ordered.

730-2017121701
- Added Left-click to show Artifact

730-2017100801
- Added billions to the short format

730-2017083001
- Bump Toc for 7.3
- Artifact knowledge can't be read from currency (1171) anymore.
http://www.wowinterface.com/forums/showthread.php?t=55690
- Change AK multiplicators according:
http://www.wowhead.com/artifact-knowledge-guide

from:
local multi = {
    25, 50, 90, 140, 200,
    275, 375, 500, 650, 850,
    1100, 1400, 1775, 2250, 2850,
    3600, 4550, 5700, 7200, 9000,
    11300, 14200, 17800, 22300, 24900,
	100000, 130000,170000,220000,290000,
	380000,490000,640000,830000,1080000,
	1400000,1820000,2370000,3080000,4000000,
	5200000,6760000,8790000,11430000,14860000,
	19320000,25120000,32660000,42460000,55200000
};

to:
local multi = {
    25, 50, 90, 140, 200,
    275, 375, 500, 650, 850,
    1100, 1400, 1775, 2250, 2850,
    3600, 4550, 5700, 7200, 9000,
    11300, 14200, 17800, 22300, 24900,
	100000, 130000,170000,220000,290000,
	380000,490000,640000,830000,1080000,
	1400000,1820000,2370000,3080000,4000000,
	16000000,20800000,27040000,35150000,45700000,
	59400000,77250000,100400000,130500000,169650000,
	220550000,286750000,372750000,484600000,630000000
};

At the end I prefer to not display AK anymore being too expensive check it for a value equal for all players.

- Modify the clicks to change options using a + Shift to prevents misclicks.

720-2017051802
- Fixed typo

720-2017042302
- Localization: zhTW and zhCN. Thanks to BNS.

720-2017042301
- Add Localization support
- Localization: itIT
Thanks to phanx for her excellent (as usual) tutorial on addons localization.
https://phanx.net/addons/tutorials/localize

720-2017042101
- Short/long number format also for knowledge multipliers

720-2017033001
- Short/long number format with click.

720-2017032901
- Fixes (hopefully) for new syntax on artifact functions 

720-2017032801
- bump toc
- added new artifact multipliers

1.0-2016121501
- code cleanup
- show current artifact power and % progress in the rank if max content level and
have an artifact equipped.
- change icon

1.0-2016113001
- cosmetic change and colors modified

1.0-2016112701
- tooltip layout changes 

1.0-2016112101
- minor changes
- added the knownledge level and multipliers
- to do: the artifact fishing pole should be treated differently

1.0-2016102601
- bump toc

1.0-2016090401
- cosmetics

1.0-2016090201
- track artifact (if equipped)

1.0-2016090101
- initial release
