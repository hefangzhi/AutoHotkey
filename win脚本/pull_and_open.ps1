# 设置仓库路径变量为你的本地笔记目录
# “repo” 是 “repository（仓库）” 的缩写。
$repoPath = "D:\zhuomian\笔记"


# 切换到仓库目录，确保后续 Git 操作在正确路径执行
Write-Host ""
Write-Host "==============================="
Write-Host "> Set-Location `"$repoPath`""
Write-Host "==============================="
Set-Location $repoPath



# 提示用户正在拉取最新代码
Write-Host ""
Write-Host "==============================="
Write-Host "正在拉取最新代码..."
Write-Host "==============================="
Write-Host "> git pull"
# 执行 git pull，并实时显示输出内容
git pull | ForEach-Object { Write-Host $_ }



# 检查是否存在合并冲突文件（使用 U 标识合并未解决文件）
Write-Host ""
Write-Host "==============================="
Write-Host "> git diff --name-only --diff-filter=U"
$conflicts = git diff --name-only --diff-filter=U



# ----------------------- 检测到冲突处理区 -----------------------
if ($conflicts) {
    Write-Host ""
    Write-Host "⚠️ 发现冲突文件:"
    $conflicts | ForEach-Object { Write-Host "  $_" }

    Write-Host ""
    Write-Host "请手动解决冲突后再继续。"

    # 打开 Git Bash 并执行 git lg 和 git status，方便查看日志和状态
    $gitBashPath = "E:\Git\git-bash.exe"
    if (Test-Path $gitBashPath) {
        Write-Host ""
        Write-Host "已打开 Git Bash，执行 git lg 和 git status："
        $bashCommands = "cd `"$repoPath`" && git lg && echo && git status && exec bash"
        Start-Process -FilePath $gitBashPath -ArgumentList "--cd=$repoPath -c `"$bashCommands`""
    } else {
        Write-Host ""
        Write-Host "未找到 Git Bash，请确认路径是否正确：$gitBashPath"
    }

    Write-Host ""
    Pause
    exit

} else {
    Write-Host ""
    Write-Host "✅ 拉取完成，没有冲突。"

    # 等待用户确认再继续
    Write-Host ""
    Write-Host "请按回车键继续后续操作..."
    [void][System.Console]::ReadLine()
}



# 提示用户将在 2 秒后自动打开 VSCode，提供取消（ESC）或立即打开（Enter）选项
Write-Host ""
Write-Host "==============================="
Write-Host "3秒后自动打开 VSCode，按 ESC 取消，按回车立即打开..."
Write-Host "==============================="


# 倒计时 2 秒，每秒检测一次键盘输入
for ($i = 2; $i -ge 1; $i--) {
    Write-Host ""
    Write-Host "剩余 $i 秒自动打开 VSCode..."

    $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

    while ($stopWatch.ElapsedMilliseconds -lt 1000) {
        if ([console]::KeyAvailable) {
            $key = [console]::ReadKey($true)

            if ($key.Key -eq 'Escape') {
                Write-Host ""
                Write-Host "已取消打开 VSCode。"
                exit

            } elseif ($key.Key -eq 'Enter') {
                Write-Host ""
                Write-Host "立即打开 VSCode..."
                Write-Host "> code `"$repoPath`""
                code $repoPath
                Start-Sleep -Milliseconds 500
                exit
            }
        }
        Start-Sleep -Milliseconds 50
    }
}


Write-Host ""
Write-Host "自动打开 VSCode..."
Write-Host "> code `"$repoPath`""
code $repoPath
Start-Sleep -Milliseconds 500
exit
