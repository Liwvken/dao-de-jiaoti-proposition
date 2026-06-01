# 道德与法治命题工具包 - Windows 一键安装脚本
# 使用方法：右键这个文件 → "使用 PowerShell 运行"
# 或者在终端里输入：powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host "=========================================" -ForegroundColor Green
Write-Host "  道德与法治命题工具包 安装脚本 (Windows)" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillDir = "$env:USERPROFILE\.claude\skills"
$MemoryDir = "$env:USERPROFILE\.claude\projects\-Users-liwvken\memory"

# 1. 安装技能
Write-Host "[1/4] 安装技能到 $SkillDir ..." -ForegroundColor Yellow

$skills = @("objective-question", "subjective-question", "scenario-judgment", "question-bank-manager")
foreach ($skill in $skills) {
    $target = "$SkillDir\$skill"
    $source = "$RepoDir\skills\$skill"

    # 删除旧的（副本或旧链接）
    if (Test-Path $target) {
        Remove-Item -Recurse -Force $target
        Write-Host "  🔄 已移除旧版 $skill，重新链接"
    }

    # 创建符号链接（需要管理员权限，不行就用 junction）
    try {
        New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
        Write-Host "  ✓ $skill 链接完成"
    } catch {
        Write-Host "  ⚠ 符号链接失败，尝试复制方式..." -ForegroundColor Red
        Copy-Item -Recurse $source $target
        Write-Host "  ✓ $skill 复制完成（非链接模式，更新需重新运行本脚本）"
    }
}

# 2. 安装记忆参考文件
Write-Host "[2/4] 安装参考文件到 $MemoryDir ..." -ForegroundColor Yellow

if (-not (Test-Path $MemoryDir)) {
    New-Item -ItemType Directory -Force -Path $MemoryDir | Out-Null
}

$memoryFiles = @(
    "proposition-general-requirements.md",
    "textbook-7a.md", "textbook-7b.md",
    "textbook-8a.md", "textbook-8b.md",
    "textbook-xi-reader.md"
)

foreach ($file in $memoryFiles) {
    $target = "$MemoryDir\$file"
    $source = "$RepoDir\memory\$file"

    if ((Test-Path $target) -and (-not (Test-Path "$target" -PathType Container))) {
        Remove-Item -Force $target
    }

    try {
        New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
    } catch {
        Copy-Item $source $target
    }
}
Write-Host "  ✓ 参考文件安装完成"

# 3. 安装试题库
Write-Host "[3/4] 安装试题库（双向同步模式）..." -ForegroundColor Yellow

$qbTarget = "$MemoryDir\question-bank"
$qbSource = "$RepoDir\memory\question-bank"

# 备份旧的（非链接的）试题库
if ((Test-Path $qbTarget) -and (-not (Test-Path "$qbTarget" -PathType Container))) {
    # 是文件不是目录，删掉
    Remove-Item -Force $qbTarget
}

if (Test-Path $qbTarget) {
    # 检查是不是链接
    $item = Get-Item $qbTarget
    if ($item.LinkType -ne "SymbolicLink") {
        $backupDir = "$MemoryDir\question-bank-backup-" + (Get-Date -Format "yyyyMMdd")
        Move-Item $qbTarget $backupDir
        Write-Host "  ⚠ 旧试题库已备份到 $backupDir"
    } else {
        Remove-Item -Force $qbTarget
    }
}

try {
    New-Item -ItemType SymbolicLink -Path $qbTarget -Target $qbSource -Force | Out-Null
    Write-Host "  ✓ 试题库链接完成（双向同步模式）"
} catch {
    Write-Host "  ⚠ 符号链接失败，使用复制方式（更新需重新运行本脚本）" -ForegroundColor Red
    Copy-Item -Recurse $qbSource $qbTarget
    Write-Host "  ✓ 试题库复制完成"
}

# 4. 完成
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  安装完成！" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  请重启 Claude Code 或输入 /reload-plugins 生效。"
Write-Host ""
Write-Host "  如果技能未加载，在 Claude Code 里输入："
Write-Host "  claude plugin enable objective-question@skills-dir"
Write-Host "  claude plugin enable subjective-question@skills-dir"
Write-Host "  claude plugin enable scenario-judgment@skills-dir"
Write-Host "  claude plugin enable question-bank-manager@skills-dir"
Write-Host ""
Write-Host "  📌 使用提示："
Write-Host "    - 你存的新题自动保存在 git 仓库里"
Write-Host "    - git pull 获取最新试题"
Write-Host "    - git add + commit + push 分享你的题"
Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
