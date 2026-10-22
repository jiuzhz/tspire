# safe-deploy.ps1 -- validate FIRST, and only build+deploy when it passes.
# NOTE: keep this file pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI).
# USAGE: powershell -NoProfile -ExecutionPolicy Bypass -File tools\safe-deploy.ps1
# Exit: 0 = validated+built+deployed, 1 = validate FAILED (nothing built).
$ErrorActionPreference = 'Stop'
$tools = $PSScriptRoot

Write-Host '=== 0/3 player clicks ==='
& node (Join-Path $tools 'gen-click-triggers.js')
if ($LASTEXITCODE -ne 0) { Write-Host '*** click generation FAILED ***'; exit 1 }

Write-Host '=== 1/3 validate ==='
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $tools 'validate.ps1')
if ($LASTEXITCODE -ne 0) {
    Write-Host ''
    Write-Host '*** validate FAILED -- aborted, nothing was built or deployed ***'
    exit 1
}

Write-Host ''
Write-Host '=== 2/3 build ==='
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $tools 'build.ps1')
if ($LASTEXITCODE -ne 0) { Write-Host '*** build FAILED ***'; exit 1 }

Write-Host ''
Write-Host '=== 3/3 deploy ==='
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $tools 'deploy.ps1')
if ($LASTEXITCODE -ne 0) { Write-Host '*** deploy FAILED ***'; exit 1 }

Write-Host ''
Write-Host 'OK: validated + built + deployed.'