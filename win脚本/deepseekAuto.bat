@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM 设置仓库路径
set "REPO_PATH=D:\zhuomian\笔记"

REM 设置提交消息（默认为自动提交）
set "COMMIT_MSG=Auto-commit from script"

:MAIN_MENU
cls
echo.
echo ===============================
echo 自动拉取/推送脚本 v1.0
echo ===============================
echo.
echo   1. auto_pull_v1.0 - 自动拉取更新 
echo   2. auto_push_v1.0 - 自动提交并推送 
echo   3. 打开仓库目录
echo   0. 退出
echo.
echo ===============================
set /p choice=请输入数字并回车: 

if "%choice%"=="1" goto auto_pull
if "%choice%"=="2" goto auto_push
if "%choice%"=="3" goto open_repo
if "%choice%"=="0" exit

echo.
echo ❌ 无效输入，请重新选择
pause
goto MAIN_MENU

:auto_pull
echo.
echo ===============================
echo 正在执行 AUTO_PULL v1.0...
echo ===============================
echo.

REM 检查是否在Git仓库中
git -C "%REPO_PATH%" rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ❌ 错误：该目录不是Git仓库
    pause
    goto MAIN_MENU
)

REM 获取当前分支
for /f "delims=" %%b in ('git -C "%REPO_PATH%" branch --show-current') do set "current_branch=%%b"

echo 仓库位置: %REPO_PATH%
echo 当前分支: !current_branch!
echo.

REM 拉取更新
echo 正在拉取远程更新...
git -C "%REPO_PATH%" pull origin !current_branch!

if errorlevel 1 (
    echo ❌ 拉取过程中出错
) else (
    echo ✅ 拉取成功完成
)

pause
goto MAIN_MENU

:auto_push
echo.
echo ===============================
echo 正在执行 AUTO_PUSH v1.0...
echo ===============================
echo.

REM 检查是否在Git仓库中
git -C "%REPO_PATH%" rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ❌ 错误：该目录不是Git仓库
    pause
    goto MAIN_MENU
)

REM 获取当前分支
for /f "delims=" %%b in ('git -C "%REPO_PATH%" branch --show-current') do set "current_branch=%%b"

echo 仓库位置: %REPO_PATH%
echo 当前分支: !current_branch!
echo.

REM 检查是否有未提交的更改
git -C "%REPO_PATH%" diff-index --quiet HEAD --
if errorlevel 1 (
    echo 检测到未提交的更改
    echo.
    
    REM 添加所有更改
    echo 正在添加所有更改...
    git -C "%REPO_PATH%" add --all
    
    REM 提交更改
    echo 正在提交更改...
    git -C "%REPO_PATH%" commit -m "%COMMIT_MSG%"
    
    REM 推送更改
    echo 正在推送更改...
    git -C "%REPO_PATH%" push origin !current_branch!
    
    if errorlevel 1 (
        echo ❌ 推送过程中出错
    ) else (
        echo ✅ 成功推送更改
    )
) else (
    echo 没有检测到更改，无需推送
)

pause
goto MAIN_MENU

:open_repo
echo.
echo 正在打开仓库目录...
start "" explorer "%REPO_PATH%"
goto MAIN_MENU