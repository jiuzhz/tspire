# Build the Tinkers' Spire boss-music resource pack into dist\tinkers-spire-resourcepack.zip
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File tools\build-rp.ps1
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $root 'resourcepack'
$dist = Join-Path $root 'dist'
$out  = Join-Path $dist 'tinkers-spire-resourcepack.zip'

if (-not (Test-Path $src)) { throw "resourcepack folder not found: $src" }
if (-not (Test-Path $dist)) { New-Item -ItemType Directory -Force -Path $dist | Out-Null }
if (Test-Path $out) { Remove-Item $out -Force }

# pack.mcmeta must sit at the ZIP ROOT (not inside a subfolder), so includeBaseDirectory = $false.
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
[System.IO.Compression.ZipFile]::CreateFromDirectory(
    $src, $out, [System.IO.Compression.CompressionLevel]::Optimal, $false)
$n = (Get-ChildItem $src -Recurse -File).Count

$kb = [math]::Round((Get-Item $out).Length / 1KB)
Write-Host ("built: {0}" -f $out)
Write-Host ("entries: {0}, size: {1} KB" -f $n, $kb)
Write-Host "install: copy the zip into .minecraft\resourcepacks\ and enable it in Options -> Resource Packs"
