@echo off
chcp 65001 >nul
set "REPO_PATH=D:\zhuomian\笔记"

REM Git Bash 自定义路径
set "CUSTOM_GIT_PATH=E:\Git\git-bash.exe"

:MENU
cls
echo.
echo ===============================
echo Select function:
echo.
echo   1. Open repository with Git Bash
echo   2. Run PowerShell script (pull + open VSCode)
echo   3. Create/check today's diary file
echo   0. Exit
echo ===============================
set /p choice=Enter number and press Enter:

if "%choice%"=="1" goto gitbash
if "%choice%"=="2" goto powershell_script
if "%choice%"=="3" goto create_diary
if "%choice%"=="0" exit

echo.
echo [ERROR] Invalid input, please choose again.
pause
goto MENU

:gitbash
echo [OK] Opening Git Bash...

if exist "%ProgramFiles%\Git\git-bash.exe" (
    start "" "%ProgramFiles%\Git\git-bash.exe" --cd="%REPO_PATH%"
) else if exist "%ProgramFiles(x86)%\Git\git-bash.exe" (
    start "" "%ProgramFiles(x86)%\Git\git-bash.exe" --cd="%REPO_PATH%"
) else if exist "%CUSTOM_GIT_PATH%" (
    start "" "%CUSTOM_GIT_PATH%" --cd="%REPO_PATH%"
) else (
    echo [ERROR] Git Bash not found, please check path.
    pause
)
exit

:powershell_script
echo [OK] Running PowerShell script pull_and_open.ps1...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0pull_and_open.ps1"
exit

:create_diary
echo [OK] Running PowerShell script create_diary.ps1...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0create_diary.ps1"
exit