# 道德与法治命题工具包 - Windows 一键安装脚本
# 使用方法：在终端里输入：
# powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host "=========================================" -ForegroundColor Green
Write-Host "  道德与法治命题工具包 安装脚本 (Windows)" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillDir = "$env:USERPROFILE\.claude\skills"
$MemoryDir = "$env:USERPROFILE\.claude\memory"

# 确保目录存在
if (-not (Test-Path $SkillDir)) {
    New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
}
if (-not (Test-Path $MemoryDir)) {
    New-Item -ItemType Directory -Force -Path $MemoryDir | Out-Null
}

# 1. 安装技能（复制方式，Windows 上最稳定）
Write-Host "[1/4] 安装技能..." -ForegroundColor Yellow
$skills = @("objective-question", "subjective-question", "scenario-judgment", "question-bank-manager")
foreach ($skill in $skills) {
    $target = "$SkillDir\$skill"
    $source = "$RepoDir\skills\$skill"
    if (Test-Path $target) {
        Remove-Item -Recurse -Force $target
    }
    Copy-Item -Recurse $source $target
    Write-Host "  ✓ $skill 安装完成"
}

# 2. 安装记忆参考文件
Write-Host "[2/4] 安装参考文件..." -ForegroundColor Yellow
$memoryFiles = @(
    "proposition-general-requirements.md",
    "textbook-7a.md", "textbook-7b.md",
    "textbook-8a.md", "textbook-8b.md",
    "textbook-xi-reader.md"
)
foreach ($file in $memoryFiles) {
    $target = "$MemoryDir\$file"
    $source = "$RepoDir\memory\$file"
    if (Test-Path $target) {
        Remove-Item -Force $target
    }
    Copy-Item $source $target
}
Write-Host "  ✓ 参考文件安装完成"

# 3. 安装试题库
Write-Host "[3/4] 安装试题库..." -ForegroundColor Yellow
$qbTarget = "$MemoryDir\question-bank"
$qbSource = "$RepoDir\memory\question-bank"

if (Test-Path $qbTarget) {
    $backupDir = "$MemoryDir\question-bank-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
    Move-Item $qbTarget $backupDir
    Write-Host "  ⚠ 旧试题库已备份到 $backupDir"
}
Copy-Item -Recurse $qbSource $qbTarget
Write-Host "  ✓ 试题库安装完成"

# 4. 完成
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  安装完成！" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  重启 Claude Code 或输入 /reload-plugins 生效。"
Write-Host ""
Write-Host "  📌 注意：Windows 上使用复制模式。"
Write-Host "    存新题后，如需分享给其他老师："
Write-Host "    1. 把 memory/question-bank/ 下新增的 .md 文件"
Write-Host "       复制到 $RepoDir\memory\question-bank\ 对应目录"
Write-Host "    2. cd $RepoDir"
Write-Host "    3. git add -A && git commit -m ""新增试题"" && git push"
Write-Host ""
Write-Host "    获取最新题库："
Write-Host "    cd $RepoDir && git pull"
Write-Host "    然后重新运行本脚本"
Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
