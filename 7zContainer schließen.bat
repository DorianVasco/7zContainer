@echo off
IF not exist "container" GOTO NOCONTAINER
echo Dateien packen und verschlüsseln...
::auswählen
::set /p sel= "1 für Entpacken, 2 für Packen"
::if "%sel%" == "1" echo Entpacken...
::if "%sel%" == "2" echo Packen...

:PASSWORD
::enter password
set "psCommand=powershell -Command "$pword = read-host 'Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p

::repeat password
set "psCommand=powershell -Command "$pword = read-host 'Repeat Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password2=%%p

if %password% == %password2% GOTO PACK
echo Passwoerter stimmen nicht überein.. nochmal versuchen:
GOTO PASSWORD

::if "%sel%" == "1" GOTO UNPACK
::if "%sel%" == "2" GOTO PACK


:PACK
del container.7z
7za.exe a -r container.7z -y -p%password% -mhe container\* -mx0
rmdir /s/q container
GOTO END

:NOCONTAINER
echo Es exisiert noch kein Container, der Ordner wird jetzt erstellt...
mkdir container
pause
START container\

:UNPACK
::7za.exe x -r container.7z -y -p%password% *

:END