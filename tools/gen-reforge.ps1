# Generate tinkers-spire "reforge" data: item modifiers + artisan branch functions.
#
# DESIGN (design doc 3.1.2 / 3.6): at an artisan node the player can pay gold to
# reroll the MATERIALS of the tinker tool in their main hand. The tool itself,
# its modifiers/upgrades and its durability are preserved.
#
# WHY item modifiers and not loot tables:
#   tconstruct:add_tool_data is registered as a normal LootItemFunction, so it is
#   also usable from an ITEM MODIFIER.  /item modify <target> <slot> <modifier>
#   applies it to the item ALREADY in the slot, which means:
#     - we never have to know the tool type at generation time
#     - upgrades / modifiers / durability survive (bytecode only calls
#       tool.setMaterials(mat); it does not go through createTool)
#   A loot-table route would have replaced the whole stack and wiped upgrades.
#
# WHY one modifier per (slotCount, floor) instead of per tool:
#   add_tool_data requires `materials` to have exactly one entry per tool slot,
#   and the slot count varies per tool.  We know the slot count at generation
#   time (from tool_definitions), so we branch on the held item id and reuse a
#   modifier keyed by slot count.  That is 4 slot counts x 3 floors = 12 files
#   instead of 45 tools x 3 floors = 135.
#
# Slot count source: the tool's `tconstruct:part_stats` module `parts` array, or
# for the single-material tools (battlesign, war_pick, plate_*, ...) the
# `tconstruct:material_stats` module `stat_types` array.
#
# NOTE: keep this file pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI).

$ErrorActionPreference = 'Stop'

$root     = Split-Path -Parent $PSScriptRoot
$resDir   = Join-Path $root 'src\main\resources'
$modDir   = Join-Path $resDir 'data\tspire\item_modifiers\reforge'
$fnDir    = Join-Path $resDir 'data\tspire\functions\artisan'
$tcSource = (Get-Content (Join-Path $PSScriptRoot 'tc-source.txt') -Raw -Encoding UTF8).Trim()

New-Item -ItemType Directory -Force -Path $modDir | Out-Null
New-Item -ItemType Directory -Force -Path $fnDir  | Out-Null
Get-ChildItem -File $modDir -Filter *.json -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem -File $fnDir -Filter reforge_f*.mcfunction -ErrorAction SilentlyContinue | Remove-Item -Force

# ---------------------------------------------------------------------------
# TUNABLE PARAMETERS
#   $floors -- per-floor material tier range used when rerolling
#   $exclude -- material predicate excluding integration/compat materials
# ---------------------------------------------------------------------------
$floors = @(
    [ordered]@{ id = 'f1'; n = 1; min = 0; max = 2 },
    [ordered]@{ id = 'f2'; n = 2; min = 2; max = 3 },
    [ordered]@{ id = 'f3'; n = 3; min = 3; max = 4 }
)
$exclude = [ordered]@{
    type          = 'mantle:inverted'
    inverted_type = 'mantle:tag'
    tag           = 'tspire:compat_excluded'
}

function Write-Utf8 { param([string]$Path, [string]$Body)
    [System.IO.File]::WriteAllText($Path, $Body, (New-Object System.Text.UTF8Encoding($false)))
}
function Json-Str { param([string]$S) return ($S -replace '\\','\\' -replace '"','\"') }

# ---------------------------------------------------------------------------
# read tool definitions -> { id = slotcount }
# ---------------------------------------------------------------------------
$defDir = Join-Path $tcSource 'data\tconstruct\tinkering\tool_definitions'
$toolSlots = [ordered]@{}
Get-ChildItem $defDir -File -Filter *.json | ForEach-Object {
    $j  = Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    $ps = $j.modules | Where-Object { $_.type -eq 'tconstruct:part_stats' }     | Select-Object -First 1
    $ms = $j.modules | Where-Object { $_.type -eq 'tconstruct:material_stats' } | Select-Object -First 1
    $n = 0
    if ($ps -and @($ps.parts).Count -gt 0) { $n = @($ps.parts).Count }
    elseif ($ms)                          { $n = @($ms.stat_types).Count }
    if ($n -ge 1) { $toolSlots['tconstruct:' + $_.BaseName] = $n }
}
$slotCounts = @($toolSlots.Values | Sort-Object -Unique)
Write-Host ("tools with materials: {0}  slot counts: {1}" -f $toolSlots.Count, ($slotCounts -join ','))

# ---------------------------------------------------------------------------
# 1) item modifiers: reforge/s<slots>_f<floor>.json
# ---------------------------------------------------------------------------
foreach ($sc in $slotCounts) {
    foreach ($f in $floors) {
        $mats = @()
        for ($i = 0; $i -lt $sc; $i++) {
            $mats += [ordered]@{
                type     = 'tconstruct:random'
                tier     = [ordered]@{ min = $f.min; max = $f.max }
                material = $exclude
            }
        }
        $obj = [ordered]@{
            function  = 'tconstruct:add_tool_data'
            materials = $mats
            damage    = 0
        }
        $json = $obj | ConvertTo-Json -Depth 12
        Write-Utf8 (Join-Path $modDir ("s{0}_{1}.json" -f $sc, $f.id)) $json
    }
}
Write-Host ("  item modifiers: {0} files" -f ($slotCounts.Count * $floors.Count))

# ---------------------------------------------------------------------------
# 2) per-floor branch functions: artisan/reforge_f<1..3>.mcfunction
#    Each branch matches the held item id and applies the modifier for that
#    tool's slot count.  store success sets #REF so the caller knows it worked.
# ---------------------------------------------------------------------------
foreach ($f in $floors) {
    $s = New-Object System.Text.StringBuilder
    [void]$s.AppendLine("# AUTO-GENERATED by tools/gen-reforge.ps1 -- do not edit by hand.")
    [void]$s.AppendLine(("# Reforge the held tool using the floor {0} material pool (tier {1}..{2})." -f $f.n, $f.min, $f.max))
    [void]$s.AppendLine("# Runs AS the player. #REF = 1 when something was actually rerolled.")
    [void]$s.AppendLine("")
    [void]$s.AppendLine("scoreboard players set #REF tspire_timer 0")
    foreach ($id in $toolSlots.Keys) {
        $sc = $toolSlots[$id]
        [void]$s.AppendLine(("execute if entity @s[nbt={{SelectedItem:{{id:""{0}""}}}}] store success score #REF tspire_timer run item modify entity @s weapon.mainhand tspire:reforge/s{1}_{2}" -f $id, $sc, $f.id))
    }
    Write-Utf8 (Join-Path $fnDir ("reforge_f{0}.mcfunction" -f $f.n)) $s.ToString()
    Write-Host ("  artisan/reforge_f{0}.mcfunction  ({1} tools)" -f $f.n, $toolSlots.Count)
}

Write-Host "done: reforge data generated"
