# SensAutoPush_V1.0_250703.ps1

# 仓库路径
$REPO_PATH = "H:\lhs\lhs_note"

# 获取当前日期（yyMMdd格式）
$today = Get-Date -Format "yyMMdd"
$commitMessage = "${today}_Company"

# 进入仓库目录
Set-Location $REPO_PATH

# 打印 git lg，优先用 lg，不存在则用 log
Write-Host ""
git lg 2>$null
if ($LASTEXITCODE -ne 0) {
    git log --oneline --graph --decorate --all
}

# 空一行
Write-Host ""

# 打印 git status，显示完整原生输出
git status

# 空一行
Write-Host ""

# 等待用户按任意键确认
Write-Host "Press any key to continue..." -ForegroundColor Yellow
[void][System.Console]::ReadKey($true)

# 暂存所有修改（确保所有变更被提交）
git add .

# 检查今天是否已有提交
$todayCommits = git log --since="00:00" --pretty=format:"%s" | Select-String $today

if ($todayCommits) {
    Write-Host "`nToday's commit exists, amending changes into it..."

    # amend 合并变动进当天已有提交，不改提交信息
    git commit --amend --no-edit 2>$null

    # 拉取最新，尝试rebase
    git pull --rebase
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Rebase failed, trying normal merge..."
        git pull
    }

    # 尝试推送
    git push
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Push failed, force pushing..."
        git push --force
    }

} else {
    Write-Host "`nNo commit for today, creating a new commit..."

    # 新建提交
    git commit -m $commitMessage 2>$null

    # 拉取最新，尝试rebase
    git pull --rebase
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Rebase failed, trying normal merge..."
        git pull
    }

    # 尝试推送
    git push
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Push failed, force pushing..."
        git push --force
    }
}

Write-Host "`nUpload completed successfully." -ForegroundColor Green
