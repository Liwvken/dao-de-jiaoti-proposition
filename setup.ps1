# Daode yu Fazhi Proposition Toolkit - Windows Setup
# Run: powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host "=========================================" -ForegroundColor Green
Write-Host "  Daode yu Fazhi Toolkit Setup (Windows)" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillDir = "$env:USERPROFILE\.claude\skills"
$MemoryDir = "$env:USERPROFILE\.claude\memory"

# Ensure dirs exist
if (-not (Test-Path $SkillDir)) {
    New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
}
if (-not (Test-Path $MemoryDir)) {
    New-Item -ItemType Directory -Force -Path $MemoryDir | Out-Null
}

# 1. Install skills
Write-Host "[1/4] Installing skills..." -ForegroundColor Yellow
$skills = @("objective-question", "subjective-question", "scenario-judgment", "question-bank-manager")
foreach ($skill in $skills) {
    $target = "$SkillDir\$skill"
    $source = "$RepoDir\skills\$skill"
    if (Test-Path $target) {
        Remove-Item -Recurse -Force $target
    }
    Copy-Item -Recurse $source $target
    Write-Host "  OK: $skill"
}

# 2. Install memory files
Write-Host "[2/4] Installing reference files..." -ForegroundColor Yellow
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
Write-Host "  OK: reference files"

# 3. Install question bank
Write-Host "[3/4] Installing question bank..." -ForegroundColor Yellow
$qbTarget = "$MemoryDir\question-bank"
$qbSource = "$RepoDir\memory\question-bank"
if (Test-Path $qbTarget) {
    $backupDir = "$MemoryDir\question-bank-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
    Move-Item $qbTarget $backupDir
    Write-Host "  Old question bank backed up to $backupDir"
}
Copy-Item -Recurse $qbSource $qbTarget
Write-Host "  OK: question bank"

# 4. Done
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Restart Claude Code or type /reload-plugins"
Write-Host ""
Write-Host "  NOTE: Windows uses copy mode."
Write-Host "  To share new questions with other teachers:"
Write-Host "    1. Copy new .md files from"
Write-Host "       $MemoryDir\question-bank\"
Write-Host "       to $RepoDir\memory\question-bank\"
Write-Host "    2. cd $RepoDir"
Write-Host "    3. git add -A && git commit -m 'new questions' && git push"
Write-Host ""
Write-Host "  To get latest questions from others:"
Write-Host "    cd $RepoDir && git pull"
Write-Host "    then re-run this script"
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
