# ============================================================
# checklog.ps1 -- report "Failed to load function" errors from the game log
# ============================================================
# WHY THIS EXISTS
#   A malformed command does NOT crash the pack: Minecraft logs
#   "Failed to load function tspire:..." and that function simply never runs
#   again. In the air that looks like "the boss does not use its skills".
#   v0.6.60 lost five functions that way (skullcrusher_kb / moltenlord_lava_zone /
#   recastking_summon / recastking_push / recastking_summon_go) and nothing in the
#   normal build -> deploy -> /reload loop said a word about it.
#
#   Run this right after /reload. It prints the function, the reported line, the
#   REAL source line and the parser message.
#
# USAGE
#   powershell -ExecutionPolicy Bypass -File tools\checklog.ps1
#   powershell -ExecutionPolicy Bypass -File tools\checklog.ps1 -Log "D:\...\latest.log"
#   The default log path may be pinned in tools\logpath.txt (UTF-8, one line).
# ============================================================

param(
    [string]$Log = ""
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Log)) {
    $logFile = Join-Path $PSScriptRoot 'logpath.txt'
    if (Test-Path $logFile) {
        $Log = (Get-Content $logFile -Raw -Encoding UTF8).Trim()
    }
}
if ([string]::IsNullOrWhiteSpace($Log)) {
    throw "No -Log given and tools\logpath.txt not found.`nCreate tools\logpath.txt containing the full path to latest.log (UTF-8), or pass -Log."
}
if (-not (Test-Path $Log)) { throw ("log not found: " + $Log) }

$fnRoot = Join-Path (Split-Path -Parent $PSScriptRoot) 'src\main\resources\data'

Write-Host "== tinkers-spire checklog ==" -ForegroundColor Cyan
Write-Host ("log: " + $Log) -ForegroundColor DarkGray
Write-Host "NOTE: the source line printed below is the CURRENT file on disk. If it already" -ForegroundColor DarkGray
Write-Host "      looks correct, the log entry is from an older load -- deploy, /reload, re-run." -ForegroundColor DarkGray

# latest.log is written in the platform default encoding (GBK here), NOT UTF-8.
$lines = Get-Content $Log -Encoding Default

# Only the LAST datapack load counts: the log keeps every earlier /reload, and
# reporting failures that were already fixed is worse than useless.
# A datapack (re)load on the server thread logs "Loaded <n> recipes" first, and
# the parser errors for that load follow it.
$start = 0
for ($i = $lines.Count - 1; $i -ge 0; $i--) {
    if ($lines[$i] -match 'Server thread/INFO\]: Loaded \d+ recipes') { $start = $i; break }
}
if ($start -gt 0) {
    Write-Host ("last datapack load at log line " + ($start + 1) + " (earlier failures ignored)") -ForegroundColor DarkGray
} else {
    Write-Host "no datapack-load marker found -- scanning the whole log" -ForegroundColor Yellow
}

$hits = 0
for ($i = $start; $i -lt $lines.Count; $i++) {
    $l = $lines[$i]
    if ($l -notmatch 'Failed to load function\s+([a-z0-9_]+:[a-z0-9_/.\-]+)') { continue }
    $name = $Matches[1]
    $msg = ''
    $ln = ''
    # the parser message sits on the next line(s): "... Whilst parsing command on line N: <msg> at position P"
    for ($j = $i + 1; $j -lt [Math]::Min($i + 4, $lines.Count); $j++) {
        if ($lines[$j] -match 'Whilst parsing command on line (\d+): (.*?) at position') {
            $ln = $Matches[1]
            $msg = $Matches[2]
            break
        }
    }

    Write-Host ""
    Write-Host ("FAIL  " + $name) -ForegroundColor Red
    if ($msg -ne '') { Write-Host ("      " + $msg) -ForegroundColor Yellow }

    # show the real source line
    $parts = $name.Split(':', 2)
    $srcPath = Join-Path $fnRoot ((Join-Path $parts[0] 'functions') + '\' + ($parts[1] -replace '/', '\') + '.mcfunction')
    if (Test-Path $srcPath) {
        if ($ln -ne '') {
            $src = [System.IO.File]::ReadAllLines($srcPath, [System.Text.Encoding]::UTF8)
            $idx = [int]$ln - 1
            Write-Host ("      line " + $ln + " of " + $parts[1] + ".mcfunction:") -ForegroundColor DarkGray
            if ($idx -ge 0 -and $idx -lt $src.Count) {
                Write-Host ("      | " + $src[$idx]) -ForegroundColor Gray
            } elseif ($src.Count -lt [int]$ln) {
                # NOTE: the parser counts lines the way Java does, so a file with
                # odd line endings can report a number past the end of the file.
                Write-Host ("      (file only has " + $src.Count + " lines -- check its line endings)") -ForegroundColor Yellow
            }
        } else {
            Write-Host ("      source: " + $srcPath) -ForegroundColor DarkGray
        }
    } else {
        Write-Host ("      source not found: " + $srcPath) -ForegroundColor DarkGray
    }
    $hits++
}

Write-Host ""
if ($hits -eq 0) {
    Write-Host "PASS  no function failed to load" -ForegroundColor Green
    exit 0
} else {
    Write-Host ("FAIL  " + $hits + " function(s) failed to load -- they never run until fixed") -ForegroundColor Red
    exit 1
}
