#Persistent
#SingleInstance Force
#Include Lib\AutoHotInterception.ahk

DllCall("SetProcessDPIAware")

global ScreenshotDir := "D:\Screenshots"
if !FileExist(ScreenshotDir)
    FileCreateDir, %ScreenshotDir%

SetTimer, ForceKeys, 100
SetNumLockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff

AHI := new AutoHotInterception()

Loop, 5 {
    AHI.SubscribeKey(A_Index, 58, true, Func("OnCapsLock"))
}

Return

ForceKeys:
    if !GetKeyState("NumLock", "T")
        SetNumLockState, On
    if GetKeyState("CapsLock", "T")
        SetCapsLockState, Off
    if GetKeyState("ScrollLock", "T")
        SetScrollLockState, Off
Return

OnCapsLock(state) {
    if (state == 1) {
        SendEvent, ^!+{F12}
    }
}

TakeScreenshot() {
    FilePath := ScreenshotDir "\Screen_" A_Now ".png"
    
    w := A_ScreenWidth
    h := A_ScreenHeight
    
    PS_Cmd := "[Reflection.Assembly]::LoadWithPartialName('System.Drawing'); "
    PS_Cmd .= "[Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); "
    PS_Cmd .= "$sig = '[DllImport(""user32.dll"")] public static extern bool SetProcessDPIAware();'; "
    PS_Cmd .= "Add-Type -MemberDefinition $sig -Name 'Win32' -Namespace 'Utils'; "
    PS_Cmd .= "[Utils.Win32]::SetProcessDPIAware(); " 
    PS_Cmd .= "$bmp = New-Object Drawing.Bitmap(" . w . "," . h . "); "
    PS_Cmd .= "$g = [Drawing.Graphics]::FromImage($bmp); "
    PS_Cmd .= "$g.CopyFromScreen(0,0,0,0, $bmp.Size, [Drawing.CopyPixelOperation]::SourceCopy); "
    PS_Cmd .= "$bmp.Save('" . FilePath . "', [Drawing.Imaging.ImageFormat]::Png); "
    PS_Cmd .= "$g.Dispose(); $bmp.Dispose();"

    Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "%PS_Cmd%",, Hide
}

Launch_Mail::TakeScreenshot()
Browser_Home::TakeScreenshot()
Launch_Media::SendEvent, ^!+{F12}

; Volume_Down::Send {F13}
; Volume_Up::Send {F13}
; Volume_Mute::Send {F13}
; Media_Next::Send {F13}
; Media_Prev::Send {F13}
; Media_Play_Pause::Send {F13}
; Media_Stop::Send {F13}