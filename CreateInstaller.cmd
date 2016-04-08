@ECHO OFF
SET VERSION=1.1
SET NAME=LockMicVolume
SET INSTALLER=InstallLockMicVolume
SET EXE=%NAME%,Uninstall,Stop%NAME%

(
    ECHO #include-once
    ECHO Global $Name = "%NAME%"
    ECHO Global $Version = "%VERSION%"
) > variables.au3

FOR %%i IN ("%EXE:,=" "%") DO "%ProgramFiles(x86)%\AutoIt3\Aut2Exe\Aut2exe.exe" /in ".\%NAME%\%%~i.au3" /out ".\%NAME%\%%~i.exe"
"%ProgramFiles(x86)%\AutoIt3\Aut2Exe\Aut2exe.exe" /in .\setup.au3 /out .\setup.exe

DEL %INSTALLER%.exe
"%ProgramFiles%\7-Zip\7z.exe" a Installer.7z .\* -r -x!*.db -x!*.cmd -x!*.md -x!*.gitignore -x!*.git -x!*.au3 -x!*.7z -x!*.sfx

(
    ECHO ^;^!@Install@!UTF-8^!
    ECHO Title="%NAME% v%VERSION% Installer"
    ECHO BeginPrompt="Do you want to install %NAME% v%VERSION%?"
    ECHO RunProgram="setup.exe"
    ECHO ^;^!@InstallEnd@^!
) > config.txt

COPY /b 7zS.sfx + config.txt + Installer.7z %INSTALLER%.exe

PAUSE
DEL Installer.7z
DEL config.txt
DEL variables.au3
DEL setup.exe
FOR %%i IN ("%EXE:,=" "%") DO DEL ".\%NAME%\%%~i.exe"