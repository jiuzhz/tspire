# ============================================================
# backup-doc.ps1 -- snapshot the design document before each build
# ============================================================
# WHY THIS EXISTS
#   2026-09-24: an edit script of mine deleted a table in the design doc and then
#   wrote a single string back as the whole file -- 4264+ lines became 102 bytes.
#   There was no git, no .bak and no shadow copy, so 75% of the file had to be
#   recovered from session transcripts (see docs\RECOVERY-REPORT.md).
#   From now on every build copies the doc into docs\doc-snapshots\ first.
#
# USAGE
#   powershell -ExecutionPolicy Bypass -File tools\backup-doc.ps1 [-Keep 10]
#   build.ps1 calls it automatically (a failure never blocks the build).
#
# The doc path lives in tools\docpath.txt (UTF-8, one line) so this script stays
# pure ASCII -- PowerShell 5.1 reads BOM-less .ps1 as ANSI.
# ============================================================

param([int]$Keep = 10)

$ErrorActionPreference = 'Stop'

$repo = Split-Path -Parent $PSScriptRoot
$pathFile = Join-Path $PSScriptRoot 'docpath.txt'

if (-not (Test-Path $pathFile)) {
    Write-Host "backup-doc: tools\docpath.txt not found -- skipped" -ForegroundColor Yellow
    exit 0
}
$doc = (Get-Content $pathFile -Raw -Encoding UTF8).Trim()
if ([string]::IsNullOrWhiteSpace($doc) -or -not (Test-Path $doc)) {
    Write-Host ("backup-doc: design doc not found ({0}) -- skipped" -f $doc) -ForegroundColor Yellow
    exit 0
}

$dir = Join-Path $repo 'docs\doc-snapshots'
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$dest  = Join-Path $dir ("design-{0}.md" -f $stamp)
Copy-Item $doc $dest -Force

Get-ChildItem $dir -Filter 'design-*.md' |
    Sort-Object LastWriteTime -Descending |
    Select-Object -Skip $Keep |
    Remove-Item -Force -ErrorAction SilentlyContinue

$len = (Get-Item $dest).Length
Write-Host ("backup-doc: {0} ({1:N0} bytes)" -f $dest, $len)
