@echo off
echo Dateien entpacken...
IF exist container.7z GOTO PASSWORD
GOTO NOCONTAINER
:PASSWORD
::enter password
set "psCommand=powershell -Command "$pword = read-host 'Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p

7za.exe x -r container.7z -y -p%password% *
GOTO END

:NOCONTAINER
IF not exist "container" GOTO NOFOLDER

:FOLDER
echo Der Container wurde noch nicht verschlüsselt.
pause
GOTO END

:NOFOLDER
echo Es gibt noch keinen verschlüsselten Container, Ordner wird erstellt...
mkdir container
pause

:END
start container\