@echo off
chcp 65001 >nul
:MENU
cls
echo ========================================
echo           Sens 自动推送脚本菜单
echo ========================================
echo [1] 执行 pull_and_open.ps1
echo [2] 执行 SensAutoPush_V1.0_250703.ps1
echo [0] 退出
echo.
set /p choice=请输入选项并按回车： 

if "%choice%"=="1" (
    echo 正在执行 pull_and_open.ps1 ...
    powershell -NoProfile -ExecutionPolicy Bypass -File "pull_and_open.ps1"
    echo 操作完成。
    goto END
) else if "%choice%"=="2" (
    echo 正在执行 SensAutoPush_V1.0_250703.ps1 ...
    powershell -NoProfile -ExecutionPolicy Bypass -File "SensAutoPush_V1.0_250703.ps1"
    echo 操作完成。
    goto END
) else if "%choice%"=="0" (
    echo 已退出。
    goto END
) else (
    echo 无效选项，请重新输入。
    timeout /t 2 >nul
    goto MENU
)

:END
pause
