LDB Mini Durability, auto repair, sell grey and ilv display

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
