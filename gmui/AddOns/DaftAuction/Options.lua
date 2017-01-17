local addonName, addonTable = ... ;

addonTable.UNDERCUT = .97; -- .97 is a 3% undercut
addonTable.PRICEBY = "QUALITY"; -- When no matches are found, set price based on QUALITY or VENDOR

-- PRICE BY QUALITY CONFIG
-- where 1000 = 1 gold
addonTable.POOR_PRICE = 100000;
addonTable.COMMON_PRICE = 200000;
addonTable.UNCOMMON_PRICE = 2000000;
addonTable.RARE_PRICE = 5000000;
addonTable.EPIC_PRICE = 10000000;

-- PRICE BY VENDOR CONFIG
-- where formula is vendor price * multiplier
addonTable.POOR_MULTIPLIER = 200;
addonTable.COMMON_MULTIPLIER = 320;
addonTable.UNCOMMMON_MULTIPLIER = 450;
addonTable.RARE_MULTIPLIER = 600;
addonTable.EPIC_MULTIPLIER = 700;