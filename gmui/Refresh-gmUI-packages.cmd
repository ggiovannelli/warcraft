REM @echo off
rmdir /S /Q AddOns.old
ren Addons AddOns.old
mkdir AddOns
for /f %%i in ('dir AddOns.old /ad /b') do xcopy "c:\games\World of warcraft\interface\AddOns\%%i" AddOns\%%i /e /s /i
rmdir /S /Q "AddOns.old"
pause