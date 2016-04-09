Remember those gankers !

v1.0-2015062401
- bump toc for 6.2

v1.0-2015022501
- bump to for 6.1

v1.0-2014110301
- fix some global vars that should be locals.
- rewrite the code of the interface to better fit "stranger gankers" long names (name-otherservername).
- add the possibility to alert your guild friends with name and ganking zone
- cleanup of the code and fix some bugs.

v1.0-2014101501
- bump toc for 6.0.x
- modified the check of:
bit.band(tonumber(sourceGUID:sub(1,5)),0x00F) == 0
in:
sourceGUID:sub(1,3) == "Pet" or sourceGUID:sub(1,6) == "Player"

- rewrite most of the code for the configuration panel.

Now remgank uses true/false instead 1/0 for variables to reflect the CheckButton:SetChecked() change.
If you experience iussues after updating to this release, please visit the option panel in the addon 
configuration and press here and there to set the correct settings :-)
  
... or simply delete [WoW Path]\WTF\Account\YOUR_ACCOUNT\SavedVariables\Remgank.lua and restart with a fresh config.

P.s.
Beware this last action delete also the database of your gankers :-)
  
v1.0-2013091001
- bump toc for 5.4

v1.0-2013052101
- bump toc for 5.3

v1.0-2013033101
- Add a check to prevent adding yourself as ganker
- Fix a bug in the cleanup database code

v1.0-2013031601
- Fix a bug that happens when the name has an UpperCase letter
- Make some sanity code checks

v1.0-2013030701
- Fixed a bug that happens when the sourceGUID to be parsed is nil or ""

Something like this:
event = "COMBAT_LOG_EVENT_UNFILTERED"
event = "SPELL_DAMAGE"
hideCaster = true
sourceGUID = ""
sourceName = nil


v1.0-2013030402
- bump toc (really this time)

v1.0-2013030401
- bump toc
- fixed a scrollframe iussue (thanks to Lombra for the code)
