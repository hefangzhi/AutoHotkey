# 这是一个PowerShell语法的笔记

Windows PowerShell 是专为系统管理而设计的命令行 shell 和脚本语言。 它在 Linux 中的类似物称为 Bash 脚本。 Windows PowerShell 基于 .NET Framework 构建，可帮助 IT 专业人员控制和自动化管理 Windows 操作系统和 Windows Server 环境上运行的应用程序。

Windows PowerShell 命令称为cmdlet，可让您从命令行管理计算机。 Windows PowerShell 提供程序使您可以像访问文件系统一样轻松地访问数据存储，例如注册表和证书存储。

此外，Windows PowerShell 还拥有丰富的表达式解析器和完全开发的脚本语言。 简而言之，您可以完成使用 GUI 执行的所有任务以及更多任务。

# 一、注释

## 单行注释

使用 # 号，后面跟注释内容。例如：

```powershell
# 这是一个单行注释
Write-Output "Hello, World!"  # 这也是注释
```

## 多行注释

使用 <# 和 #> 包裹多行注释内容。例如：

```powershell
<#
这是多行注释的开始
可以写多行内容
这是多行注释的结束
#>
Write-Output "Hello, World!"
```

# 二、基础语法

## 1. Set-Location

Set-Location（兼容cmd中的命令cd）用于切换当前工作目录。

### 简写

| 命令      | 说明                                  |
| --------- | ------------------------------------- |
| `cd`    | 最常见的别名，等价于 `Set-Location` |
| `sl`    | 官方标准别名（Set-Location）          |
| `chdir` | 和 Linux/CMD 保持一致的别名           |

### 示例

```powershell
Set-Location 路径
# 示例：
Set-Location $repoPath
```

```powershell
cd D:\Projects\MyRepo       # ✅ 最常用
sl "C:\Users\sen\Desktop"   # ✅ 简洁清晰
chdir ..                    # ✅ 返回上层目录
```

---

## 2. 变量定义

PowerShell 使用 `$` 符号来定义变量。变量名区分大小写，推荐使用有意义的名称。

### 📌 基本变量定义

```powershell
# 定义字符串变量
$name = "Sen"

# 定义整数变量
$age = 25

# 定义布尔变量
$isAdmin = $true

# 定义数组变量
$fruits = @("apple", "banana", "orange")

# 定义哈希表（键值对）
$user = @{
    Name = "Sen"
    Age = 25
    Role = "Admin"
}
```

---

### 🔍 查看变量的值

```powershell
# 直接输出变量
$name
$age

# 使用 Write-Host 输出
Write-Host "姓名是 $name，年龄是 $age"

# 使用格式化字符串
Write-Output ("用户 {0} 年龄为 {1}" -f $name, $age)
```

---

### ✅ 特殊变量示例

```powershell
# 当前脚本所在路径
$PSScriptRoot

# 上一个命令的执行结果
$?

# 错误信息
$Error[0]
```

---

### 💡 小贴士

- 变量名不能以数字开头，如 `$1var` 是非法的。
- 字符串中如果包含变量，可以使用双引号：`"$name"`。
- 使用单引号 `'...'` 不会解析变量。

```powershell
$name = "Sen"
Write-Host "你好，$name"   # 输出: 你好，Sen
Write-Host '你好，$name'   # 输出: 你好，$name
```

---

### 🧹 清除变量

```powershell
Remove-Variable name
```

或

```powershell
$name = $null
```

## 3. PowerShell 打印信息笔记

PowerShell 提供多种方式在控制台打印信息，常用命令包括：

- `Write-Host`：直接输出到控制台（带颜色、不可重定向）
- `Write-Output`：输出对象，可用于管道或重定向
- `Write-Information`：写入信息流（可控制显示与否）
- `Write-Warning`：输出警告信息（黄色）
- `Write-Error`：输出错误信息（红色）
- `Write-Debug` / `Write-Verbose`：调试/详细信息（需显式开启）

---

### ✅ 1. Write-Host（最常用，直接打印）

```powershell
Write-Host "程序启动完成"
Write-Host "用户名：" -NoNewline
Write-Host $env:USERNAME -ForegroundColor Cyan
```

- 支持设置颜色 `-ForegroundColor` 和 `-BackgroundColor`
- `-NoNewline` 不换行

---

### ✅ 2. Write-Output（用于输出对象）

```powershell
Write-Output "这是一条输出信息"
"也可以这样直接写，默认是输出"
```

- 可以将信息传给管道或重定向到文件
- 用于脚本函数返回值推荐使用此命令

---

### ✅ 3. Write-Warning（警告信息）

```powershell
Write-Warning "文件未找到，跳过此步骤"
```

- 默认以黄色显示
- 属于警告流，可以通过参数捕获

---

### ✅ 4. Write-Error（错误信息）

```powershell
Write-Error "致命错误：操作失败"
```

- 默认以红色显示
- 会增加 `$Error` 全局数组内容

---

### ✅ 5. Write-Information（信息流，默认不显示）

```powershell
Write-Information "任务已完成"
```

- 默认不显示，可通过 `$InformationPreference = "Continue"` 开启
- 可用于区分日志层级

---

### ✅ 6. Write-Debug / Write-Verbose（调试信息）

```powershell
Write-Debug "调试信息"
Write-Verbose "详细执行步骤"
```

需开启对应开关：

```powershell
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
```

---

### 📦 示例：综合演示

```powershell
Write-Host "🚀 程序启动..."
Write-Output "开始处理数据..."

if (!(Test-Path "data.txt")) {
    Write-Warning "⚠️ 文件 data.txt 不存在"
} else {
    Write-Host "✅ 文件已找到"
}

Write-Debug "检查完毕"
Write-Verbose "正在读取文件内容"
Write-Error "模拟错误：数据格式异常"
```

---

### 🎯 总结

| 命令                  | 用途           | 可重定向 | 显示颜色 |
| --------------------- | -------------- | -------- | -------- |
| `Write-Host`        | 控制台直接打印 | ❌       | ✅       |
| `Write-Output`      | 输出到管道     | ✅       | ❌       |
| `Write-Warning`     | 输出警告       | ✅       | ✅ 黄    |
| `Write-Error`       | 输出错误       | ✅       | ✅ 红    |
| `Write-Information` | 信息流输出     | ✅       | ❌       |
| `Write-Debug`       | 调试信息       | ✅       | ❌       |
| `Write-Verbose`     | 详细信息       | ✅       | ❌       |

---

> ✅ 建议：常规提示用 `Write-Host`，脚本返回用 `Write-Output`，问题/日志用 `Write-Warning` 或 `Write-Error` 区分。

---

## 4. 执行外部命令

直接输入命令即可调用外部程序，如git、code等。

```powershell
git pull
code $repoPath
```

---

## 5. 条件语句 if/else

用于判断条件并执行不同分支。

```powershell
if ($conflicts) {
    # 条件为真时执行
} else {
    # 条件为假时执行
}
```

---

## 6. 管道与ForEach-Object

管道|用于将前一命令的输出传递给后一命令，ForEach-Object遍历集合。

```powershell
$conflicts | ForEach-Object { Write-Host $_ }
```

---

## 7. 循环 for

for循环用于重复执行。

```powershell
for ($i = 3; $i -ge 1; $i--) {
    Write-Host $i
}
```

---

## 8. while循环

while循环用于条件成立时持续执行。

```powershell
while ($stopWatch.ElapsedMilliseconds -lt 1000) {
    # 循环体
}
```

---

## 9. 退出脚本 exit

exit用于终止脚本执行。

```powershell
exit
```

---

## 10. 暂停脚本 Pause

Pause用于暂停脚本，等待用户操作。

```powershell
Pause
```

---

## 11. Start-Sleep

Start-Sleep用于让脚本暂停指定时间。

```powershell
Start-Sleep -Milliseconds 500
```

---

## 12. 读取键盘输入

通过[console]::ReadKey和[console]::KeyAvailable检测和读取键盘输入。

```powershell
if ([console]::KeyAvailable) {
    $key = [console]::ReadKey($true)
    if ($key.Key -eq 'Escape') {
        # 处理ESC
    } elseif ($key.Key -eq 'Enter') {
        # 处理回车
    }
}
```

---

## 13. .NET类调用

可以直接调用.NET类，如[System.Diagnostics.Stopwatch]。

```powershell
$stopWatch = [System.Diagnostics.Stopwatch]::StartNew()
```
