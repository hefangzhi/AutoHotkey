@echo off
chcp 65001
setlocal enabledelayedexpansion

:: 固定仓库路径
set REPO_PATH=H:\lhs\lhs_note

:: Git Bash 路径
set GIT_BASH_PATH=C:\Program Files\Git\git-bash.exe

:: VS Code 启动命令（如果 code 命令不可用，请改成完整路径）
set VSCODE_CMD=code

:: 进入仓库目录
cd /d %REPO_PATH%

:: 显示当前仓库路径
echo ============================================
echo 当前仓库路径：%REPO_PATH%
echo ============================================

:: 获取当前分支
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set CURRENT_BRANCH=%%b

:: 拉取远程最新代码
echo 正在拉取远程分支 %CURRENT_BRANCH%...
git pull origin %CURRENT_BRANCH%

:: 判断是否拉取成功
if errorlevel 1 (
    echo ============================================
    echo 拉取或合并失败，请手动处理冲突！
    echo 正在启动 Git Bash...
    echo ============================================
    start "" "%GIT_BASH_PATH%" --cd="%REPO_PATH%"
    exit /b
) else (
    echo ============================================
    echo 拉取并合并成功，显示日志和状态
    echo ============================================
    git lg --all
    git status

    :: 启动 VS Code
    echo ============================================
    echo 正在启动 VS Code...
    echo ============================================
    start "" %VSCODE_CMD% %REPO_PATH%

    pause
)
