; -----------------------------
; ✅ 启动提示
; -----------------------------
MsgBox, 64, 虚拟桌面助手, 脚本已开启, 3

; -----------------------------
; ✅ Win + Q → 切换到左虚拟桌面
; -----------------------------
#q::
SendInput, ^#{Left}
ToolTip, ✅ 已切换到左侧桌面
SetTimer, RemoveToolTip, -1500
return

; -----------------------------
; ✅ Win + W → 切换到右虚拟桌面
; -----------------------------
#w::
SendInput, ^#{Right}
ToolTip, ✅ 已切换到右侧桌面
SetTimer, RemoveToolTip, -1500
return

; -----------------------------
; ✅ 清除提示
; -----------------------------
RemoveToolTip:
ToolTip
return

; ========================================
; ✅ 配置文件（与脚本同目录）
; ========================================
ConfigFile := A_ScriptDir . "\config.ini"

; 读取保存的路径，默认 E:\
IniRead, Folder1, %ConfigFile%, Folders, Folder1, E:\

; ========================================
; ✅ Win + Z → 快捷菜单
; ========================================
#z::
Menu, QuickMenu, Add, 1 - 打开文件夹 [%Folder1%], MenuOpen1
Menu, QuickMenu, Add, a - 设置文件夹路径, MenuSetFolder1
Menu, QuickMenu, Show
Menu, QuickMenu, DeleteAll
return

MenuOpen1:
Run, explorer.exe %Folder1%
return

MenuSetFolder1:
InputBox, NewFolder, 设置文件夹路径, 输入文件夹路径（当前: %Folder1%）, , 400, 150, , , , , %Folder1%
if (!ErrorLevel && NewFolder != "")
{
    Folder1 := NewFolder
    IniWrite, %Folder1%, %ConfigFile%, Folders, Folder1
    ToolTip, ✅ 文件夹已设置为: %Folder1%
    SetTimer, RemoveToolTip, -2000
}
return

; -----------------------------
; ✅ 退出脚本提示
; -----------------------------
OnExit("ExitFunc")

ExitFunc() {
    MsgBox, 48, 虚拟桌面助手, 脚本已关闭, 3
}
