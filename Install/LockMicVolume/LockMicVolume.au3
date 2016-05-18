#NoTrayIcon
#include "..\variables.au3"
#include <Misc.au3>
#include <MsgBoxConstants.au3>
Global $Title = $Name & " v" & $Version
If _Singleton($Name & "B9mmEGD9YhIF", 1) = 0 Then
    MsgBox($MB_ICONWARNING, $Title, $Name & " is already running!")
    Exit
EndIf
#include <WinAPIFiles.au3>
FileChangeDir(@ScriptDir)
Local $Volume = 65536, $Percent = IniRead(@AppDataCommonDir & "\" & $Name & "\" & $Name & ".ini", "Settings", "VolumePercent", "")
If $Percent = "" Then
    $Percent = 100
Else
    $Percent = Floor(Number($Percent))
EndIf
If $Percent <= 0 then
    $Volume = 0
ElseIf $Percent < 100 Then
    $Volume = Round($Volume * $Percent / 100)
EndIf
While 1
    Local $return = RunWait($Name & "NirCmd.exe loop 172800 500 setsysvolume " & $Volume & " default_record", @ScriptDir, @SW_HIDE)
    If $return <> 0 Or @error <> 0 Then
        Exit
    EndIf
WEnd