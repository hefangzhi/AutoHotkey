# 设置控制台输出为UTF8编码，防止中文乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ==== 写入内容的函数：负责写示例日记内容 ====
function Add-DiaryContent {
    param (
        [string]$filePath,
        [datetime]$date,
        [string]$weekday
    )

    # 这里填写你所在城市的经纬度，比如北京（纬度：39.9042，经度：116.4074）
    $latitude = 39.9042
    $longitude = 116.4074

    # 格式化日期为yyyy-MM-dd
    $dateStr = $date.ToString("yyyy-MM-dd")

    # 调用Open-Meteo API 获取天气（今日当天）
    $apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,weathercode&timezone=auto&start_date=$dateStr&end_date=$dateStr"

    Write-Host "正在获取天气数据..." -ForegroundColor Cyan
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get -ErrorAction Stop
    }
    catch {
        Write-Host "天气接口请求失败，跳过天气数据。" -ForegroundColor Red
        $response = $null
    }

    $weatherText = ""
    if ($response -and $response.current_weather) {
        $cw = $response.current_weather
        $maxTemp = $response.daily.temperature_2m_max[0]
        $minTemp = $response.daily.temperature_2m_min[0]
        $precip = $response.daily.precipitation_sum[0]

        $weatherText = @"
【天气预报】
当前温度：$($cw.temperature)℃  
最大温度：$maxTemp℃  
最小温度：$minTemp℃  
降水量：$precip mm  
风速：$($cw.windspeed) km/h  
天气代码：$($cw.weathercode) （详见API文档）
"@
    }
    else {
        $weatherText = "天气数据暂不可用。"
    }

    $content = @"
$($date.Year)年$($date.Month)月$($date.Day)日 $weekday

这是今日的日记内容。你可以写一些感想、计划或者事件。

$weatherText

# todo
"@

    Set-Content -Path $filePath -Value $content -Encoding UTF8
    Write-Host "【函数 Add-DiaryContent】已向文件写入示例日记内容（含天气）。" -ForegroundColor Cyan
}

# ==== 写入内容的函数结束 ====

# 指定日记根路径，请根据需要修改
$rootPath = "D:\zhuomian\笔记\vscode笔记\1-日记"

# 获取今天时间信息
$today = Get-Date
$year = $today.Year
$month = $today.Month
$day = $today.Day

# 星期映射表
$weekdayMap = @{
    Sunday    = "星期日"
    Monday    = "星期一"
    Tuesday   = "星期二"
    Wednesday = "星期三"
    Thursday  = "星期四"
    Friday    = "星期五"
    Saturday  = "星期六"
}
$weekday = $weekdayMap[$today.DayOfWeek.ToString()]

# 打印今天日期
Write-Host "今天日期是：$year 年 $month 月 $day 日，$weekday" -ForegroundColor Cyan

# 生成无空格年月文件夹名，如 2025年7月
$monthFolderName = "${year}年${month}月"
$monthFolderPath = Join-Path $rootPath $monthFolderName

# 检查月份文件夹是否存在，不存在则创建
if (-Not (Test-Path $monthFolderPath)) {
    Write-Host "【提示】月份文件夹不存在，正在创建：$monthFolderPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $monthFolderPath | Out-Null
} else {
    Write-Host "月份文件夹已存在：$monthFolderPath" -ForegroundColor Green
}

# 拼接当日日记文件名，例如 250710.md
$fileName = "{0:D2}{1:D2}{2:D2}.md" -f ($year % 100), $month, $day
$fullFilePath = Join-Path $monthFolderPath $fileName

# 判断日记文件是否存在
if (-Not (Test-Path $fullFilePath)) {
    Write-Host "【提示】今日日记文件不存在，正在创建文件：$fullFilePath" -ForegroundColor Yellow
    New-Item -ItemType File -Path $fullFilePath | Out-Null
    Write-Host "【提示】开始填充日记内容..." -ForegroundColor Yellow

    # 调用写内容函数，写入示例内容
    Add-DiaryContent -filePath $fullFilePath -date $today -weekday $weekday

    Write-Host "【提示】日记内容填充完成。" -ForegroundColor Green
} else {
    Write-Host "今日日记文件已存在，无需创建：" -ForegroundColor Green
    Write-Host $fullFilePath
}
