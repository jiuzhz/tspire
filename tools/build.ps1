# Build tinkers-spire datapack zip.
#
# IMPORTANT: do NOT use Compress-Archive here.
# On Windows, Compress-Archive stores entry names with BACKSLASH separators
# (e.g. "data\minecraft\tags\functions\load.json"). Java's zip reader treats
# backslash as a literal character in the file name, so Minecraft finds
# pack.mcmeta at the zip root (the pack appears to load) but finds NO data
# inside it -- silently. Entries must be written with FORWARD slashes.
#
# NOTE: keep this file pure ASCII. Windows PowerShell 5.1 reads BOM-less
# .ps1 as ANSI, so non-ASCII literals would break parsing.

$ErrorActionPreference = 'Stop'

# Snapshot the design doc first (2026-09-24: a script overwrote it; see tools\backup-doc.ps1).
# A failure here must never block the build.
try { & (Join-Path $PSScriptRoot 'backup-doc.ps1') | Out-Null } catch { Write-Host ("backup-doc failed (ignored): " + $_) -ForegroundColor Yellow }

& node (Join-Path $PSScriptRoot 'gen-click-triggers.js')
if ($LASTEXITCODE -ne 0) { throw 'click generation failed' }

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $root 'src\main\resources'
$outDir = Join-Path $root 'dist'
$version = (Get-Content (Join-Path $PSScriptRoot 'version.txt') -Raw -Encoding UTF8).Trim()
if ($version -notmatch '^v[0-9]+[.][0-9]+[.][0-9]+$') { throw 'invalid tools/version.txt' }
$out = Join-Path $outDir (('tinkers-spire-{0}.zip' -f $version))

if (-not (Test-Path $src)) { throw "source not found: $src" }
if (-not (Test-Path (Join-Path $src 'pack.mcmeta'))) { throw "pack.mcmeta missing at zip root" }

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
if (Test-Path $out) { Remove-Item $out -Force }

$zip = [System.IO.Compression.ZipFile]::Open($out, 'Create')
try {
    $files = Get-ChildItem -Recurse -File $src
    foreach ($f in $files) {
        $rel = $f.FullName.Substring($src.Length + 1).Replace('\', '/')
        [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $zip, $f.FullName, $rel, [System.IO.Compression.CompressionLevel]::Optimal)
    }
} finally {
    $zip.Dispose()
}

# verify: every entry must use forward slashes
$bad = @()
$z = [System.IO.Compression.ZipFile]::OpenRead($out)
try {
    foreach ($e in $z.Entries) { if ($e.FullName.Contains('\')) { $bad += $e.FullName } }
    $count = $z.Entries.Count
    $names = @($z.Entries | ForEach-Object { $_.FullName })
} finally {
    $z.Dispose()
}

if ($bad.Count -gt 0) { throw ("backslash entries found: " + ($bad -join ', ')) }
$required = @('pack.mcmeta', 'data/minecraft/tags/functions/load.json', 'data/minecraft/tags/functions/tick.json', 'data/tspire/functions/start/build_ready.mcfunction', 'data/tspire/functions/map/runtime/row_1.mcfunction', 'data/tspire/functions/map/build_row_16.mcfunction')
$missing = @($required | Where-Object { $names -notcontains $_ })
if ($missing.Count -gt 0) { throw ('missing required archive entries: ' + ($missing -join ', ')) }

$size = (Get-Item $out).Length
Write-Host ("built: {0}" -f $out)
Write-Host ("entries: {0}, size: {1} bytes, separators: OK" -f $count, $size)
