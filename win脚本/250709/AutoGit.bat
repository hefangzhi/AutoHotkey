@echo off
chcp 65001
REM ===============================================
REM 自动 Git 智能同步脚本 - 完美防呆版
REM 功能：
REM 1. 拉取最新代码
REM 2. 检查是否有改动（无改动立即退出）
REM 3. 检查是否存在同名提交（当日）
REM 4. 有改动：存在同名提交则 --amend，否则正常提交
REM 5. 仅有提交时才推送
REM ===============================================

REM 设置仓库路径
set REPO_PATH=H:\lhs\lhs_note

REM 检查 git 是否安装
git --version >nul 2>&1
if errorlevel 1 (
    echo 错误：未检测到 Git，请确认已安装并配置环境变量。
    pause
    exit /b
)

REM 进入仓库路径
cd /d %REPO_PATH%

echo 当前仓库路径：%cd%

REM 拉取最新远程代码
git pull

REM 检查是否有改动（无改动立即退出）
git status --porcelain > temp_status.txt
for /f %%i in ('find /c /v "" ^< temp_status.txt') do set CHANGE_COUNT=%%i
del temp_status.txt

if %CHANGE_COUNT%==0 (
    echo 没有检测到任何改动，操作结束。
    pause
    exit /b
)

REM 获取当前日期，格式：YYMMDD
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set dt=%%i
set DATE=%dt:~2,2%%dt:~4,2%%dt:~6,2%

REM 组装提交备注
set COMMIT_MSG=%DATE%_Company

REM 暂存全部改动
git add .

REM 获取最新提交备注
for /f "delims=" %%i in ('git log -1 --pretty^=format:"%%s"') do set LAST_COMMIT=%%i

REM 初始化提交标志
set COMMIT_FLAG=0

REM 判断是否已有今日提交
if "%LAST_COMMIT%"=="%COMMIT_MSG%" (
    echo 已存在今日提交，合并提交到上一条（使用 --amend）
    git commit --amend --no-edit
    set COMMIT_FLAG=1
) else (
    echo 创建新提交：%COMMIT_MSG%
    git commit -m "%COMMIT_MSG%"
    set COMMIT_FLAG=1
)

REM 只有提交了才执行 push
if "%COMMIT_FLAG%"=="1" (
    echo 正在推送到远程仓库...
    git push --force
    echo 操作完成，已推送，提交备注：%COMMIT_MSG%
) else (
    echo 未进行提交，跳过推送。
)

pause
