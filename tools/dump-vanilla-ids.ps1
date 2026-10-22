# ===========================================================================
# dump-vanilla-ids.ps1 -- unpack the vanilla language file once, so that
# tools\validate.ps1 rule 2.9b can check every minecraft:<id> we use.
# ===========================================================================
# WHY: two bugs shipped because nothing validated VANILLA registry ids --
#   mystery/turtle_save used minecraft:turtle_scute (the id is minecraft:scute)
#   mystery/props used minecraft:armor_stand as a BLOCK (it is an entity)
# Both are parse errors: the game logs "Failed to load function" and the whole
# function dies. This script only prepares data; validate.ps1 does the checking.
#
# The vanilla assets live in the Forge library jar
#   libraries\net\minecraft\client\<ver>\client-<ver>-extra.jar
# which we locate under the instance without hardcoding a non-ASCII path.
#
# Usage: powershell -ExecutionPolicy Bypass -File tools\dump-vanilla-ids.ps1
# NOTE: keep this file pure ASCII.
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root '_ref\assets\minecraft\lang'
New-Item -ItemType Directory -Force -Path $out | Out-Null

# 1) find the instance: <drive>\<dir>\<dir>\shipin3\...
$instance = $null
foreach ($d in (Get-ChildItem 'D:\' -Directory -ErrorAction SilentlyContinue)) {
    foreach ($e in (Get-ChildItem $d.FullName -Directory -ErrorAction SilentlyContinue)) {
        $cand = Join-Path $e.FullName 'shipin3'
        if (Test-Path $cand) { $instance = $cand; break }
    }
    if ($instance) { break }
}
if (-not $instance) { throw 'could not locate the shipin3 instance under D:\' }
Write-Host ("instance: {0}" -f $instance)

# 2) find client-*-extra.jar under .minecraft\libraries
$libs = Join-Path $instance '.minecraft\libraries\net\minecraft\client'
$jar = Get-ChildItem $libs -Recurse -File -Filter '*-extra.jar' -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $jar) { throw ("no client-*-extra.jar under " + $libs) }
Write-Host ("jar: {0}" -f $jar.Name)

# 3) extract the language files we care about
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($jar.FullName)
$found = 0
foreach ($n in 'en_us', 'zh_cn') {
    $e = $zip.Entries | Where-Object { $_.FullName -eq ("assets/minecraft/lang/{0}.json" -f $n) }
    if (-not $e) { Write-Host ("  {0}: not in this jar" -f $n); continue }
    $dest = Join-Path $out ("{0}.json" -f $n)
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($e, $dest, $true)
    Write-Host ("  {0} -> {1} bytes" -f $n, (Get-Item $dest).Length)
    $found++
}
$zip.Dispose()
if ($found -eq 0) { throw 'no language file extracted' }

# 4) quick summary so the operator sees the rule has data to work with
$lj = Get-Content (Join-Path $out 'en_us.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$it = @($lj.PSObject.Properties | Where-Object { $_.Name -like 'item.minecraft.*' }).Count
$bl = @($lj.PSObject.Properties | Where-Object { $_.Name -like 'block.minecraft.*' }).Count
$en = @($lj.PSObject.Properties | Where-Object { $_.Name -like 'entity.minecraft.*' }).Count
Write-Host ("done: {0} item / {1} block / {2} entity lang keys" -f $it, $bl, $en)
