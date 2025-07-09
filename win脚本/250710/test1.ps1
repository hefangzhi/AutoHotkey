# 设置 UTF-8 输出防止乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 设置 Git 仓库路径
$repoPath = "D:\zhuomian\AutoHotkey"

# 检查路径是否存在
if (-Not (Test-Path $repoPath)) {
    Write-Error "❌ 仓库路径不存在：$repoPath"
    exit
}

# 进入仓库目录
Set-Location $repoPath

# 设置环境变量确保颜色支持
$env:GIT_PAGER = ''
$env:GIT_TERMINAL_PROMPT = 0
$env:GIT_FORCE_COLOR = 1

# === 执行 git 命令 ===

Write-Host "`n$ git fe"
git fetch

Write-Host "`n$ git lg --all"
git lg --all

Write-Host "`n$ git st"
git st

# === 等待用户输入 Y/N（或回车） ===

Write-Host ""
do {
    $key = Read-Host "是否继续执行？[Y/n]"
    if ($key -eq "") { $key = "y" }
} while ($key.ToLower() -ne "y" -and $key.ToLower() -ne "n")

if ($key.ToLower() -eq "n") {
    Write-Host "`n❗注释待完善功能，程序已退出。"
    exit
}

# === 后续操作继续放在这里 ===
Write-Host "`n✅ 继续执行后续功能..."
# TODO: 你的其他脚本逻辑放在这里

# -------- 后续功能开始 --------

# 1. 判断工作区是否干净
Write-Host "`n$ git st"
$statusOutput = git status
Write-Host $statusOutput

$cleanWorkTree = $statusOutput -match "nothing to commit, working tree clean"

if (-not $cleanWorkTree) {
    # 工作区不干净，提示用户继续或退出
    do {
        $key = Read-Host "`n工作区不干净，是否继续执行？[Y/n]"
        if ($key -eq "") { $key = "y" }
    } while ($key.ToLower() -ne "y" -and $key.ToLower() -ne "n")

    if ($key.ToLower() -eq "n") {
        Write-Host "`n❗功能待完善，程序退出。"
        exit
    }
} else {
    Write-Host "`n✅ 工作区干净，自动往下面执行。"
}

# 2. 判断本地与远程是否同步
# 先抓取远程信息（并打印）
Write-Host "`n$ git fetch"
$fetchOutput = git fetch
Write-Host $fetchOutput

# 获取本地 HEAD commit
Write-Host "`n$ git rev-parse HEAD"
$localCommit = (git rev-parse HEAD).Trim()
Write-Host $localCommit

# 获取远程 HEAD commit (以 origin/master 为例)
Write-Host "`n$ git rev-parse origin/master"
$remoteCommit = (git rev-parse origin/master).Trim()
Write-Host $remoteCommit

if ($localCommit -eq $remoteCommit) {
    Write-Host "`n✅ 本地与远程同步。"
} else {
    # 判断哪个更先进
    # 使用 git merge-base 判断共同祖先
    Write-Host "`n$ git merge-base HEAD origin/master"
    $baseCommit = (git merge-base HEAD origin/master).Trim()
    Write-Host $baseCommit

    if ($baseCommit -eq $remoteCommit) {
        # 远程是祖先，说明本地比远程新
        Write-Host "`n⚠️ 本地比远程更新，功能待完善。"
        # 这里也可以给选择，但题目没说，我先只提示退出
        exit
    } elseif ($baseCommit -eq $localCommit) {
        # 本地是祖先，远程比本地新
        do {
            $key = Read-Host "`n远程有更新，是否拉取？[Y/n]"
            if ($key -eq "") { $key = "y" }
        } while ($key.ToLower() -ne "y" -and $key.ToLower() -ne "n")

        if ($key.ToLower() -eq "n") {
            Write-Host "`n❗功能待完善，程序退出。"
            exit
        }

        # 3. 拉取代码
        Write-Host "`n$ git pull"
        $pullOutput = git pull
        Write-Host $pullOutput

    } else {
        # 两者有分叉，功能暂未处理
        Write-Host "`n⚠️ 本地和远程分叉，功能待完善。"
        exit
    }
}

# -------- 后续功能结束 --------
