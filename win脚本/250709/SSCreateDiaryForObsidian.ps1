# 基础目录，请根据你实际修改
$baseDir = "E:\My Git\SS_note_obsidian\1-日记"

# 获取当前日期
$now = Get-Date
$yearMonthFolder = "{0}年{1}月" -f $now.Year, $now.Month
$targetDir = Join-Path $baseDir $yearMonthFolder

# 文件名格式 yyMMdd.md
$fileName = "{0:yyMMdd}.md" -f $now
$filePath = Join-Path $targetDir $fileName

try {
    # 判断文件是否存在
    if (Test-Path $filePath) {
        Write-Host "文件已存在：$filePath"
        Write-Host "按任意键退出..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit
    }

    # 创建月份目录（如果不存在）
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "已创建目录：$targetDir"
    }

    # 创建image目录和日期子目录
    $imageBaseDir = Join-Path $targetDir "image"
    if (-not (Test-Path $imageBaseDir)) {
        New-Item -ItemType Directory -Path $imageBaseDir -Force | Out-Null
        Write-Host "已创建图片目录：$imageBaseDir"
    }

    $dateImageFolder = $now.ToString("yyMMdd")
    $imageDir = Join-Path $imageBaseDir $dateImageFolder
    if (-not (Test-Path $imageDir)) {
        New-Item -ItemType Directory -Path $imageDir -Force | Out-Null
        Write-Host "已创建日期图片目录：$imageDir"
    }

    # 计算星期几中文
    $dayMap = @{
        Monday = "一"
        Tuesday = "二"
        Wednesday = "三"
        Thursday = "四"
        Friday = "五"
        Saturday = "六"
        Sunday = "日"
    }

    $weekdayChinese = $dayMap[$now.DayOfWeek.ToString()]

    # 第一行：年月日 星期几
    $line1 = "{0:yyyy年M月d日} 星期{1}" -f $now, $weekdayChinese

    # 第二部分内容
    $line2 = "这是今日的日记内容。你可以写一些感想、计划或者事件。"

    # 组合内容数组
    $content = @(
        $line1
        ""
        $line2
        ""
        "# todo"
        ""
    )

    # 写入文件（UTF8）
    $content | Out-File -FilePath $filePath -Encoding utf8

    Write-Host "已创建文件：$filePath"
    Write-Host "按任意键退出..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} catch {
    Write-Error "执行过程中出错：$_"
    Write-Host "按任意键退出..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}