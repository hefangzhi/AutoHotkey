@echo off
chcp 65001 >nul
set "REPO_PATH=D:\zhuomian\笔记"

REM Git Bash 自定义路径
set "CUSTOM_GIT_PATH=E:\Git\git-bash.exe"

:MENU
cls
echo.
echo ===============================
echo 请选择功能：
echo.
echo   1. 使用 Git Bash 打开仓库
echo   2. 执行 PowerShell 脚本（拉取 + 打开 VSCode）
echo   3. 创建或检测今日日记文件（create_diary.ps1）
echo   0. 退出
echo ===============================
set /p choice=请输入数字并回车：

if "%choice%"=="1" goto gitbash
if "%choice%"=="2" goto powershell_script
if "%choice%"=="3" goto create_diary
if "%choice%"=="0" exit

echo.
echo ❌ 无效输入，请重新选择。
pause
goto MENU

:gitbash
echo ✅ 正在打开 Git Bash...

if exist "%ProgramFiles%\Git\git-bash.exe" (
    start "" "%ProgramFiles%\Git\git-bash.exe" --cd="%REPO_PATH%"
) else if exist "%ProgramFiles(x86)%\Git\git-bash.exe" (
    start "" "%ProgramFiles(x86)%\Git\git-bash.exe" --cd="%REPO_PATH%"
) else if exist "%CUSTOM_GIT_PATH%" (
    start "" "%CUSTOM_GIT_PATH%" --cd="%REPO_PATH%"
) else (
    echo ❌ 未找到 Git Bash，请确认路径是否正确。
    pause
)
exit

:powershell_script
echo ✅ 正在运行 PowerShell 脚本 pull_and_open.ps1...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0pull_and_open.ps1"
exit

:create_diary
echo ✅ 正在运行 PowerShell 脚本 create_diary.ps1...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0create_diary.ps1"
exit
