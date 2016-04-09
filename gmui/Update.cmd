@ECHO off

SET WOWPATH=C:\change_me

IF "%WOWPATH%"=="C:\change_me" (
    
	ECHO.  
	ECHO *** ERROR 
	ECHO You must set a valid wow path
	ECHO Now default values: %WOWPATH%
	ECHO.  
    	PAUSE
    	EXIT /B
)

RMDIR /s /q Addons.old
REN Addons Addons.old
MKDIR Addons

FOR /f %%i IN ('dir Addons.old /ad /b') DO XCOPY "%WOWPATH%\interface\Addons\%%i" Addons\%%i /e /s /i
PAUSE