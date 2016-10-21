#NoTrayIcon
#RequireAdmin
#include "..\variables.au3"
Local $Title = $Name & " v" & $Version & " Uninstaller"
#include <MsgBoxConstants.au3>
#include "_SelfDelete.au3"

If MsgBox($MB_YESNO + $MB_ICONQUESTION, $Title, "Do you want to uninstall " & $Name & " v" & $Version & "?") <> $IDYES Then Exit

ProcessClose("LockMicVolume.exe")
ProcessClose("LockMicVolumeNirCmd.exe")
ProcessWaitClose("LockMicVolume.exe")
ProcessWaitClose("LockMicVolumeNirCmd.exe")

Local $delete = StringSplit("LockMicVolume.exe,LockMicVolumeNirCmd.exe,StopLockMicVolume.exe," & @StartupCommonDir & "\" & $Name & ".lnk", ",")
FileChangeDir(@ScriptDir)
For $i = 1 To $delete[0]
    If FileExists($delete[$i]) And Not FileDelete($delete[$i]) Then Exit MsgBox($MB_ICONWARNING, $Title, "Failed to delete " & '"' & $delete[$i] & '"' & "!" & @CRLF & @CRLF & "Check to see if " & '"' & $delete[$i] & '"' & " is currently running and try again.")
Next

If ( RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $Name, "DisplayName") <> "" Or RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $Name, "UninstallString") <> "" ) And Not RegDelete("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $Name) Then Exit MsgBox($MB_ICONWARNING, $Title, "Failed to delete uninstaller registry key!")

If MsgBox($MB_YESNO + $MB_ICONQUESTION, $Title, "Do you want to keep the settings files?") <> $IDYES Then DirRemove(@AppDataCommonDir & "\" & $Name, 1)

_SelfDelete(5, 1, 1)
If @error Then Exit MsgBox($MB_ICONWARNING, "_SelfDelete()", "The script must be a compiled exe to work correctly.")