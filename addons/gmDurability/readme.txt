830-2020041701
- changed the savedvar
- added the scale to the tooltip
- now items can be clicked
- added a help tooltip

830-2020040401
- rewritten using libqtip

830-2020031501
- bump toc

820-2019062801
- bump toc

810-2018122201
- bump toc for 8.1

801-2018072101
- bump toc for 8.0

720-2017052001
- Localization: zhTW and zhCN. Thanks to BNS.
- Revised localization strings to use global strings. Thanks to myrroddin

720-2017051801
- Added localization.
Thanks to phanx for her excellent (as usual) tutorial on addons localization.
https://phanx.net/addons/tutorials/localize
- Localization: itIT
- Modify the clicks to change options using a + Shift to prevents misclicks. (suggested by ceylina)

720-2017050701
- Fix typos

720-2017042301
- Fix a problem with keystones (null price when depleted but grey quality)

v720-2017032801
- bump toc

v1.0-2016113001
- fixed a slot count

v1.0-2016111101
- added the forgotten NeckSlot :)

v1.0-2016110601
- Revert to the old LibDataBroker libs
- fix the double Artifact ilvl display

v1.0-2016110101
- Major rewrite using LibQTip

v1.0-2016102901
- display ilv/name/quality of the equipped slot item

v1.0-2016102601
- bump toc

v1.0-2016070901
- changed name and references into gmDurability

v1.0-2015100301
- some code rewriting. 
thanks to Phanx for the fixes and suggestions, you can check all of inputs here:
http://www.wowinterface.com/downloads/fileinfo.php?id=23599#comments

v1.0-2015062401
- bump toc for 6.2

v1.0-2015022501
- bump toc for 6.1
 
v1.0-2014121601
- Added itemlevel display

v1.0-2014110601
- Replace the custom formatted money function with "GetCoinTextureString(coins)".

v1.0-2014110501
- Added 3 lines of code to show the selling price of the greys items.

local _, itemCount = GetContainerItemInfo(bag, slot);
local _, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(name)
print(string_format("%s: selling %4s %s for %s", prgname, itemCount, name, moneyformat(vendorPrice * itemCount)))

v1.0-2014110301
- Added the autorepair (with guild funds if possible)
- Added the autosell of grey items
- Register a global array MYDURABILITY to save the preferences

v1.0-2014101501
- bump toc for 6.0

v1.0-2013091001
- bump toc for 5.4

v1.0-2013052101
- bump toc for 5.3

v1.0-2013051601
-- Initial release
