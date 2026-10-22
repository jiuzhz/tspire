# Deploy tinkers-spire to a Minecraft save as an UNPACKED FOLDER.
#
# Why a folder and not a zip:
#   - Iteration is much faster: edit one file, /reload, done.
#   - No zip-separator pitfalls (see build.ps1 for that story).
#   - Minecraft keeps the zip file handle open while running, so a deployed
#     zip cannot be overwritten or deleted without closing the game.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File tools\deploy.ps1
#   powershell -ExecutionPolicy Bypass -File tools\deploy.ps1 -Datapacks "D:\path\to\saves\world\datapacks"
#
# NOTE: keep this file pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI).

param(
    [string]$Datapacks = ""
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $root 'src\main\resources'

# Default target: the project's test save. The path contains CJK characters,
# which is exactly why it is a parameter here and not a hardcoded literal
# in an ASCII-only script -- pass it in, or edit target.txt.
if ([string]::IsNullOrWhiteSpace($Datapacks)) {
    $targetFile = Join-Path $PSScriptRoot 'target.txt'
    if (-not (Test-Path $targetFile)) {
        throw "No -Datapacks given and tools\target.txt not found.`nCreate tools\target.txt containing the full path to your save's datapacks folder (UTF-8), or pass -Datapacks."
    }
    $Datapacks = (Get-Content $targetFile -Raw -Encoding UTF8).Trim()
}

if (-not (Test-Path $Datapacks)) { throw "datapacks folder not found: $Datapacks" }

$dest = Join-Path $Datapacks 'tinkers-spire'
$targetRoot = [System.IO.Path]::GetFullPath($Datapacks).TrimEnd('\')
$resolvedDest = [System.IO.Path]::GetFullPath($dest)
if (-not $resolvedDest.StartsWith(($targetRoot + '\'), [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Deployment destination escaped datapacks: $resolvedDest"
}

# A deployed zip with the same pack would duplicate every function/registry
# entry. Refuse to deploy until it is gone.
$zip = Join-Path $Datapacks 'tinkers-spire.zip'
if (Test-Path $zip) {
    try {
        Remove-Item $zip -Force
        Write-Host "removed stale tinkers-spire.zip"
    } catch {
        throw "Cannot remove $zip -- it is locked by a running game. Close Minecraft, or run in-game: /datapack disable `"file/tinkers-spire.zip`" then /reload, then retry."
    }
}

if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
Copy-Item $src $dest -Recurse -Force

$n = (Get-ChildItem -Recurse -File $dest).Count
Write-Host ("deployed {0} files -> {1}" -f $n, $dest)
Write-Host "now run in-game:  /reload"
