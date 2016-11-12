REM @echo off
rmdir /s /q AddOns.old
ren Addons AddOns.old
mkdir AddOns
for /f %%i in ('dir AddOns.old /ad /b') do xcopy "c:\games\World of warcraft\interface\AddOns\%%i" AddOns\%%i /e /s /i
pause