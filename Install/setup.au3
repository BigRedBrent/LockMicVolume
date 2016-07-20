#NoTrayIcon
#include "variables.au3"
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
Global $Title = $Name & " v" & $Version & " Installer"
If _Singleton($Name & " Installer" & "B9mmEGD9YhIF", 1) = 0 Then
    MsgBox($MB_ICONWARNING, $Title, $Name & " Installer" & " is already running!")
    Exit
EndIf
ProcessClose($Name & ".exe")
ProcessClose($Name & "NirCmd.exe")
If DirCopy($Name, @ProgramFilesDir & "\" & $Name, 1) And FileCreateShortcut(@ProgramFilesDir & "\" & $Name & "\" & $Name & ".exe", @StartupCommonDir & "\" & $Name & ".lnk", @ProgramFilesDir & "\" & $Name) Then
    If FileExists(@ProgramFilesDir & "\" & $Name & "\" & $Name & ".ini") Then
        FileCopy(@ProgramFilesDir & "\" & $Name & "\" & $Name & ".ini", @AppDataCommonDir & "\" & $Name & "\" & $Name & ".ini", $FC_OVERWRITE + $FC_CREATEPATH)
        FileDelete(@ProgramFilesDir & "\" & $Name & "\" & $Name & ".ini")
    EndIf
    Local $Percent = IniRead(@AppDataCommonDir & "\" & $Name & "\" & $Name & ".ini", "Settings", "VolumePercent", "")
    If $Percent = "" Then
        $Percent = 100
    Else
        $Percent = Floor(Number($Percent))
    EndIf
    If $Percent < 0 then
        $Percent = 0
    ElseIf $Percent > 100 Then
        $Percent = 100
    EndIf
    While 1
        Local $strNumber = InputBox($Title, @CRLF & @CRLF & @CRLF & "Enter the volume percent that you want your default recording device to be locked to:", $Percent)
        If @error <> 0 Then
            Exit
        EndIf
        Local $number = Floor(Number($strNumber))
        If $number >= 0 And $number <= 100 Then
            $Percent = $number
            ExitLoop
        EndIf
        MsgBox($MB_ICONWARNING, $Title, "You did not enter a valid number!")
    WEnd
    DirCreate(@AppDataCommonDir & "\" & $Name)
    If IniWrite(@AppDataCommonDir & "\" & $Name & "\" & $Name & ".ini", "Settings", "VolumePercent", $Percent) And RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $Name, "DisplayName", "REG_SZ", $Name & " v" & $Version) And RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $Name, "UninstallString", "REG_SZ", '"' & @ProgramFilesDir & "\" & $Name & '\Uninstall.exe"') Then
        Run(@ProgramFilesDir & "\" & $Name & "\" & $Name & ".exe", @ProgramFilesDir & "\" & $Name)
        MsgBox($MB_OK, $Title, "Successfully installed " & $Name & " v" & $Version & ".")
        Exit
    EndIf
EndIf
MsgBox($MB_ICONWARNING, $Title, "Failed to install " & $Name & " v" & $Version & "!")