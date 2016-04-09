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

RMDIR /S /Q "%WOWPATH%\interface\Addons.old"
REN "%WOWPATH%\interface\Addons" Addons.old
MKDIR "%WOWPATH%\interface\Addons"
XCOPY Addons "%WOWPATH%\interface\Addons" /E
PAUSE