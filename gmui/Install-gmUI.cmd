@echo off

echo -
echo ------ Installazione gmUI
echo -


echo -
echo ------ Selezione cartella di installazione di World of Warcraft
echo -

binary\OpenFolderBox "C:" "Seleziona la cartella di installazione di WoW"> wow.txt

IF %ERRORLEVEL% EQU 2 (

  echo Procedura Terminata... Uscita
  pause
  exit

)

set /p WOW=<wow.txt


if exist "%WOW%\wow.exe" (

	echo -
	echo ------ WoW.exe trovato nella cartella World of Warcraft ... OK
	echo -

) else (

	echo -
	echo ------ WoW.exe NON trovato nella cartella World of Warcraft ... Uscita
	echo -
	pause
	exit
)


echo -
echo ------ Creazione archivio Addons ("%WOW%\your_old_addons.zip")
echo -

del /F "%WOW%\your_old_addons.zip"
binary\7za.exe a -bd "%WOW%\your_old_addons.zip" "%WOW%\Interface\AddOns"

echo -
echo ------ Copia Addons UI
echo -

rmdir /S /Q "%WOW%\Interface\AddOns"
mkdir "%WOW%\interface\AddOns"
xcopy AddOns "%WOW%\interface\AddOns" /E /Q


echo -
echo ------ Selezione cartella configurazioni account ("%WOW%\WTF\Account\NOME_TUO_ACCOUNT_WOW")
echo -

binary\OpenFolderBox "%WOW%\WTF\Account" "Scegli il tuo nome account\n(solitamente nella dir WTF/Account)"> account.txt
set /p ACCOUNT=<account.txt

echo -
echo ------ Creazione archivio vecchi settaggi ("%WOW%\your_old_settings.zip")
echo -

del /F "%WOW%\your_old_settings.zip"
binary\7za.exe a -bd "%WOW%\your_old_settings.zip" "%ACCOUNT%"

echo -
echo ------ Copia Settings UI
echo -

rmdir /S /Q "%ACCOUNT%"
mkdir "%ACCOUNT%"
mkdir "%ACCOUNT%\SavedVariables"
xcopy SavedVariables "%ACCOUNT%\SavedVariables" /E /Q

echo -
echo ------ Ripulitura
echo -

del /F account.txt
del /F wow.txt

pause