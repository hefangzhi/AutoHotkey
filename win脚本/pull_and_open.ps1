# pull_and_open.ps1

$repoPath = "D:\zhuomian\笔记"

Set-Location $repoPath

Write-Host "已为您🔄 正在拉取最新代码..."
git pull

$conflicts = git diff --name-only --diff-filter=U
if ($conflicts) {
    Write-Host "已为您⚠️ 发现冲突文件:"
    $conflicts | ForEach-Object { Write-Host "  $_" }
    Write-Host "已为您请手动解决冲突后再继续。"
    Pause
    exit
} else {
    Write-Host "已为您✅ 拉取完成，没有冲突。"
}

Write-Host
Write-Host "已为您3秒后自动打开 VSCode，按 ESC 取消，按回车立即打开..."

for ($i = 3; $i -ge 1; $i--) {
    Write-Host "已为您$i 秒后自动打开 VSCode..."

    $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()
    while ($stopWatch.ElapsedMilliseconds -lt 1000) {
        if ([console]::KeyAvailable) {
            $key = [console]::ReadKey($true)
            if ($key.Key -eq 'Escape') {
                Write-Host "已为您已取消打开 VSCode。"
                exit
            } elseif ($key.Key -eq 'Enter') {
                Write-Host "已为您立即打开 VSCode..."
                code $repoPath
                Start-Sleep -Milliseconds 500
                exit
            }
        }
        Start-Sleep -Milliseconds 50
    }
}

Write-Host "已为您自动打开 VSCode..."
code $repoPath
Start-Sleep -Milliseconds 500
exit
