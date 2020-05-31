830-2020041801
- rewrite in libqtip

830-2020031501
- bump toc

820-2019062801
- bump toc

815-2019041001
Some Menu entries could not be used in combat. 
So I have changed them, i.e:
"if not InCombatLockdown() then ToggleSpellBook(BOOKTYPE_SPELL); end" 

HEADS UP:
You can't directly click on the spells in SpellBook even if it was opened out of combat.
This fires an error because this action is available only for the Blizzard UI. 
You can only drag the spell on your actionbars or use them by keybind.  

815-2019040801
- initial release