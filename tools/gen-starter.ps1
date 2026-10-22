# Generate the tinkers-spire opening draft (design doc 2.1 / 2.2 / 2.3).
#
# TWO steps, as specified:
#   step 1  ARMOR    the four armour pieces, ALL IN ONE screen, one pick each.
#                    For every slot the player sees 3 candidates (one per set):
#                      plate_*      (high defence)
#                      travelers_*  (medium, extra upgrade slot)
#                      slime_*      (low, special ability)
#                    12 candidates total, pick exactly 4 (one per slot).
#   step 2  WEAPON   five distinct weapons from the section 2.3 pool,
#                    the player picks exactly 2. At most one shield.
#
# Materials come from the material definition data:
#   armour  -> tier 0..1   (section 2.2 "zero quality = tier 0 + tier 1")
#   weapon  -> tier 0..2   (floor 1 pool)
# Each slot is filled with a material that actually declares that slot's stat
# type, so we never build a piece nobody can craft (the "useless part" bug).
#
# WHY PRE-GENERATE: the chat menu must be able to print the concrete material of
# every candidate (see the attributes BEFORE choosing), and 1.20.1 cannot read
# So the whole draft is rolled here and written out as literal text.
#
# The 17 items (12 armour + 5 weapon) are parked in a Lock-ed chest in the prep
# room; the click handlers copy the chosen one out of that chest.
#
# NOTE: keep this file pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI).
# NOTE: command arguments use SINGLE spaces only.

$ErrorActionPreference = 'Stop'

$root     = Split-Path -Parent $PSScriptRoot
$resDir   = Join-Path $root 'src\main\resources'
$starterDir = Join-Path $resDir 'data\tspire\functions\starter'
$runDir     = Join-Path $resDir 'data\tspire\functions\run'
$tcSource = (Get-Content (Join-Path $PSScriptRoot 'tc-source.txt') -Raw -Encoding UTF8).Trim()

New-Item -ItemType Directory -Force -Path $starterDir | Out-Null
Get-ChildItem -File $starterDir -Filter *.mcfunction -ErrorAction SilentlyContinue | Remove-Item -Force

# ---------------------------------------------------------------------------
# TUNABLE PARAMETERS
#   $DRAFT_COUNT   -- how many pre-rolled drafts (one is picked per run)
#   $ARMOR_TIERS   -- material tier range for starting armour  (doc 2.2: 0..1)
#   $WEAPON_TIERS  -- material tier range for starting weapons (floor 1 pool)
#   $ARMOR_SETS    -- the three armour sets, per slot
#   $WEAPON_POOL   -- the section 2.3 weapon pool, with slot counts
# ---------------------------------------------------------------------------
$DRAFT_COUNT  = 6
$ARMOR_TIERS  = @{ min = 0; max = 1 }
# v0.6.28: player feedback -- in the opening draft, the travelers set and the slime
# set are allowed to roll TIER-2 materials (plate armour stays at the original
# 0..1 band). Keyed by the armour set key used in $ARMOR_SETS.
$ARMOR_TIER_OVERRIDE = @{
    'travelers' = @{ min = 0; max = 2 }
    'slime'     = @{ min = 0; max = 2 }
}
$WEAPON_TIERS = @{ min = 0; max = 1 }   # v0.7.51 (design doc): starting weapons roll tier 0..1 only; the scythe is the sole exception (see below)

# slot order matters: it is the index used in the chest and in the function names
$ARMOR_SLOTS = @(
    @{ key = 'helmet';     label = 'head' },
    @{ key = 'chestplate'; label = 'chest' },
    @{ key = 'leggings';   label = 'legs' },
    @{ key = 'boots';      label = 'feet' }
)

$ARMOR_SETS = @(
    @{ key = 'plate';     label = 'plate' },
    @{ key = 'travelers'; label = 'travelers' },
    @{ key = 'slime';     label = 'slime' }
)

# $ARMOR_SETS is applied to $ARMOR_SLOTS as "<set>_<slot>"; this table holds the
# few ids whose suffix does not match the slot key.
# Tool-definition file names are NOT always the registered item id.  Known
# mismatches (verified against assets/tconstruct/lang/zh_cn.json):
#   slime_chestplate (definition) -> slimy_chestplate (item)
# Everything else must resolve to an item.tconstruct.<id> lang key, otherwise
# the generator ABORTS instead of shipping a datapack that fails to load.
$ARMOR_ID_OVERRIDE = @{
    'slime_chestplate' = 'slimy_chestplate'
    'travelers_helmet' = 'travelers_helmet'
}

$WEAPON_POOL = @(
    @{ id = 'tconstruct:sword';         slots = 3; shield = $false },
    @{ id = 'tconstruct:dagger';        slots = 2; shield = $false },
    @{ id = 'tconstruct:scythe';        slots = 4; shield = $false },
    @{ id = 'tconstruct:cleaver';       slots = 4; shield = $false },
    @{ id = 'tconstruct:crossbow';      slots = 3; shield = $false },
    # v0.7.45 (player request, option B): starting draft swaps broad_axe for sledge_hammer + vein_hammer.
#   broad_axe stays obtainable elsewhere (fusing / reforging / reward pools); only the draft changes.
#   slots must match the TiC tool definition, otherwise we roll parts nobody can craft.
@{ id = 'tconstruct:sledge_hammer'; slots = 4; shield = $false },
@{ id = 'tconstruct:vein_hammer';   slots = 4; shield = $false },
    @{ id = 'tconstruct:javelin';       slots = 4; shield = $false },
    @{ id = 'tconstruct:longbow';       slots = 4; shield = $false },
    @{ id = 'tconstruct:plate_shield';     slots = 2; shield = $true },
    @{ id = 'tconstruct:travelers_shield'; slots = 2; shield = $true }
)

# ---------------------------------------------------------------------------
# material data
# ---------------------------------------------------------------------------
$defDir   = Join-Path $tcSource 'data\tconstruct\tinkering\materials\definition'
$statsDir = Join-Path $tcSource 'data\tconstruct\tinkering\materials\stats'

$matTier = @{}
Get-ChildItem $defDir -File -Filter *.json | ForEach-Object {
    $j = Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    $k = @($j.PSObject.Properties.Name)
    if ($k -contains 'condition') { return }
    if ($k -contains 'redirect')  { return }
    if ($j.hidden -eq $true)      { return }
    $matTier['tconstruct:' + $_.BaseName] = [int]$j.tier
}
$statMats = @{}
Get-ChildItem $statsDir -File -Filter *.json | ForEach-Object {
    $id = 'tconstruct:' + $_.BaseName
    $j = Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($p in $j.stats.PSObject.Properties.Name) {
        if (-not $statMats.ContainsKey($p)) { $statMats[$p] = @() }
        $statMats[$p] += $id
    }
}

# part item -> stat type. Not present in the JSON data, so it is spelled out
# (same table tools/gen-rewards.ps1 uses).
$PART_STAT = @{
    'small_blade' = 'tconstruct:head'; 'broad_blade' = 'tconstruct:head'
    'small_axe_head' = 'tconstruct:head'; 'pick_head' = 'tconstruct:head'
  # v0.7.49: these were MISSING -> stat lookup returned null -> ANY material could fill the slot
  'hammer_head' = 'tconstruct:head'
  'broad_axe_head' = 'tconstruct:head'
  'adze_head' = 'tconstruct:head'
  'large_plate' = 'tconstruct:head'
    'tool_handle' = 'tconstruct:handle'; 'tough_handle' = 'tconstruct:handle'
    'tool_binding' = 'tconstruct:binding'; 'tough_binding' = 'tconstruct:binding'
    'bow_limb' = 'tconstruct:limb'; 'bow_grip' = 'tconstruct:grip'
    'bowstring' = 'tconstruct:bowstring'; 'arrow_head' = 'tconstruct:arrow_head'
    'helmet_plating' = 'tconstruct:plating_helmet'
    'chestplate_plating' = 'tconstruct:plating_chestplate'
    'leggings_plating' = 'tconstruct:plating_leggings'
    'boots_plating' = 'tconstruct:plating_boots'
    'maille' = 'tconstruct:maille'
    'shield_core' = 'tconstruct:shield_core'
}

# per-slot stat types for a tool, read from its tool definition
$toolStatCache = @{}
function Get-ToolStats {
    param([string]$Id)
    if ($toolStatCache.ContainsKey($Id)) { return $toolStatCache[$Id] }
    $short = $Id -replace '^tconstruct:', ''
    $file  = Join-Path $tcSource ("data\tconstruct\tinkering\tool_definitions\{0}.json" -f $short)
    if (-not (Test-Path $file)) { throw ("no tool definition for {0}" -f $Id) }
    $j = Get-Content $file -Raw -Encoding UTF8 | ConvertFrom-Json
    $ps = $j.modules | Where-Object { $_.type -eq 'tconstruct:part_stats' }     | Select-Object -First 1
    $ms = $j.modules | Where-Object { $_.type -eq 'tconstruct:material_stats' } | Select-Object -First 1
    $stats = @()
    if ($ps -and @($ps.parts).Count -gt 0) {
        # A part_stats entry is one of:
        #   "tconstruct:small_blade"                       -> look the stat up in PART_STAT
        #   { item = "tconstruct:helmet_plating", scale }  -> ditto
        #   { stat = "tconstruct:plating_helmet", scale }  -> the stat IS given
        foreach ($p in @($ps.parts)) {
            $stat = $null
            if ($p -is [string]) {
                $short2 = $p -replace '^tconstruct:', ''
                if ($PART_STAT.ContainsKey($short2)) { $stat = $PART_STAT[$short2] }
            } else {
                $keys = @($p.PSObject.Properties.Name)
                if ($keys -contains 'stat') {
                    $stat = $p.stat
                } elseif ($keys -contains 'item') {
                    $short2 = $p.item -replace '^tconstruct:', ''
                    if ($PART_STAT.ContainsKey($short2)) { $stat = $PART_STAT[$short2] }
                }
            }
            $stats += $stat
        }
    } elseif ($ms) {
        # stat_types entries may also be objects: { stat = "...", scale = ... }
        foreach ($s in @($ms.stat_types)) {
            if ($null -eq $s) { $stats += $null; continue }
            if ($s -is [string]) { if ([string]::IsNullOrWhiteSpace($s)) { $stats += $null } else { $stats += $s } ; continue }
            $keys2 = @($s.PSObject.Properties.Name)
            if ($keys2 -contains 'stat') { $stats += $s.stat } else { $stats += $null }
        }
    } else {
        $stats = @($null)
    }
    $toolStatCache[$Id] = $stats
    return ,$stats
}

function Get-MatPool {
    param([string]$StatType, [int]$Min, [int]$Max)
    $out = @()
    if ([string]::IsNullOrWhiteSpace($StatType)) {
        # slot with no stat constraint -> anything in the tier range
        foreach ($m in $matTier.Keys) { if ($matTier[$m] -ge $Min -and $matTier[$m] -le $Max) { $out += $m } }
    } else {
        if (-not $statMats.ContainsKey($StatType)) { throw ("no material declares stat $StatType") }
        foreach ($m in $statMats[$StatType]) {
            if (-not $matTier.ContainsKey($m)) { continue }
            if ($matTier[$m] -ge $Min -and $matTier[$m] -le $Max) { $out += $m }
        }
    }
    return @($out | Sort-Object -Unique)
}

function New-Materials {
    param([string]$ToolId, [int]$Min, [int]$Max)
    $stats = Get-ToolStats $ToolId
    $mats = @()
    foreach ($st in $stats) {
        # Tier ranges are narrow on purpose (armour is meant to be tier 0..1), but a
        # few slots have nothing down there (tconstruct:slime only exists higher up).
        # Fall back: widen the tier range, then drop the stat constraint.
        $pool = @(Get-MatPool $st $Min $Max)
        if ($ToolId -eq 'tconstruct:plate_shield' -and $st -eq 'tconstruct:shield_core') { $pool = @($pool | Where-Object { $_ -ne 'tconstruct:chorus' }) }
        if ($pool.Count -eq 0) { $pool = @(Get-MatPool $st 0 5); if ($ToolId -eq 'tconstruct:plate_shield' -and $st -eq 'tconstruct:shield_core') { $pool = @($pool | Where-Object { $_ -ne 'tconstruct:chorus' }) } }
        if ($pool.Count -eq 0) { $pool = @(Get-MatPool $null $Min $Max) }
        if ($pool.Count -eq 0) { throw ("no usable material for {0} slot stat '{1}'" -f $ToolId, $st) }
        $mats += $pool[(Get-Random -Minimum 0 -Maximum $pool.Count)]
    }
    return ,$mats
}

function Write-Utf8 { param([string]$Path, [string]$Body)
    [System.IO.File]::WriteAllText($Path, $Body, (New-Object System.Text.UTF8Encoding($false)))
}

$UI = Get-Content (Join-Path $PSScriptRoot 'starter-text.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$lang = Get-Content (Join-Path $tcSource 'assets\tconstruct\lang\zh_cn.json') -Raw -Encoding UTF8 | ConvertFrom-Json
function Text { param([string]$Key, [object[]]$FmtArgs) $tpl = $UI.$Key; if ($null -eq $FmtArgs -or $FmtArgs.Count -eq 0) { return $tpl }; return ($tpl -f $FmtArgs) }
function Lang { param([string]$Key, [string]$Fallback) $v = $lang.$Key; if ([string]::IsNullOrWhiteSpace($v)) { return $Fallback } return $v }
function ItemName { param([string]$Id) $n = ($Id -replace '^tconstruct:', ''); return (Lang ('item.tconstruct.' + $n) $n) }
function MatName  { param([string]$Id) $n = ($Id -replace '^tconstruct:', ''); return (Lang ('material.tconstruct.' + $n) $n) }
function MatNames { param([string[]]$Ids) return (($Ids | ForEach-Object { MatName $_ }) -join '/') }

# ---------------------------------------------------------------------------
# roll the loadouts
# ---------------------------------------------------------------------------
# v0.6.26: every bow the datapack hands a player carries the "self-contained
# quiver" ability (tconstruct:REMOVED_quiver), as the design doc requires.
# bulk_quiver has check_standard_arrows:true, so arrows in the player's own
# inventory are consumed first -- which is why run/give_kit also hands out arrows.
# v0.7.2: renamed from Quiver-Nbt. Two extras now live here:
#   * bows/crossbows -> bulk_quiver I   (v0.6.26)
#   * javelins       -> returning (level 1 = ability form; v0.7.15, level 3 was dropped by TiC
#                       because it needs 1 ability + 2 upgrade slots -- see gen-gear.ps1)
# Every place that builds this NBT MUST use this helper, including the undo/clear
# functions -- a mismatch there means the clear silently misses the item.
function Mod-Nbt { param([string]$ItemId)
    if ($ItemId -match 'longbow|crossbow|shortbow|ballista') {
        return ','
    }
    if ($ItemId -match 'javelin') {
        return ',tic_modifiers:[{name:"tconstruct:returning",level:1}]'
    }
    return ''
}

$loadouts = @()
for ($k = 1; $k -le $DRAFT_COUNT; $k++) {
    $armor = @()   # ordered: slot-major, so index = slot*3 + option index
    foreach ($slot in $ARMOR_SLOTS) {
        # v0.6.22 reverted in v0.6.23: the three options are rolled INDEPENDENTLY out
        # of the set pool, so the same set may come up twice in one slot. That is the
        # intended design (three options != one of each set), and the player explicitly
        # confirmed repeats are fine. What was NOT fine was everybody sharing one
        # loadout -- that is fixed by the per-player @s tspire_draft_l below.
        for ($opt = 0; $opt -lt 3; $opt++) {
            $set = $ARMOR_SETS[(Get-Random -Minimum 0 -Maximum $ARMOR_SETS.Count)]
            $defName = $set.key + '_' + $slot.key
            if (-not (Test-Path (Join-Path $tcSource ("data\tconstruct\tinkering\tool_definitions\{0}.json" -f $defName)))) {
                throw ("no tool definition for armour piece: {0}" -f $defName)
            }
            # A tool-definition file name is NOT always the registered item id
            # (slime_chestplate -> slimy_chestplate). An unknown item id makes the
            # whole function fail to load at runtime, so refuse to emit one.
            $itemName = $defName
            if ($ARMOR_ID_OVERRIDE.ContainsKey($defName)) { $itemName = $ARMOR_ID_OVERRIDE[$defName] }
            $id = 'tconstruct:' + $itemName
            if ($null -eq $lang.('item.tconstruct.' + $itemName)) { throw ("item does not exist in lang: {0} (definition {1})" -f $id, $defName) }
            # NOTE: pass the DEFINITION name, not the item id -- the two differ for
            # slimy_chestplate, and the tool definition file is keyed by definition.
            # v0.6.28: travelers / slime may use tier-2 materials (see the override table)
            $tierMin = $ARMOR_TIERS.min
            $tierMax = $ARMOR_TIERS.max
            if ($ARMOR_TIER_OVERRIDE.ContainsKey($set.key)) {
                $tierMin = $ARMOR_TIER_OVERRIDE[$set.key].min
                $tierMax = $ARMOR_TIER_OVERRIDE[$set.key].max
            }
            $mats = New-Materials $defName $tierMin $tierMax
            $armor += [ordered]@{ id = $id; set = $set.key; slot = $slot.key; mats = $mats }
        }
    }

    # five distinct weapons, at most one shield
    $picked = @()
    $usedShield = $false
    # fresh copies each loadout: mutating $WEAPON_POOL in place would leave the
    # "taken" flags set for the next draft and exhaust the pool.
    $pool = @($WEAPON_POOL | ForEach-Object {
        [ordered]@{ id = $_.id; slots = $_.slots; shield = $_.shield; taken = $false }
    })
    while ($picked.Count -lt 5) {
        $cand = @($pool | Where-Object { -not $_.taken })
        if ($cand.Count -eq 0) { throw "weapon pool exhausted" }
        $c = $cand[(Get-Random -Minimum 0 -Maximum $cand.Count)]
        if ($c.shield -and $usedShield) { $c.taken = $true; continue }
        if ($c.shield) { $usedShield = $true }
        $c.taken = $true
        $wmax = $WEAPON_TIERS.max
  # v0.7.51: ONLY the scythe may roll tier-2 materials at the draft stage
  if ($c.id -eq 'tconstruct:scythe') { $wmax = 2 }
  $mats = New-Materials $c.id $WEAPON_TIERS.min $wmax
        $picked += [ordered]@{ id = $c.id; mats = $mats }
    }
    $loadouts += [ordered]@{ k = $k; armor = $armor; weapons = $picked }
    Write-Host ("loadout {0}: armour 12, weapons {1}" -f $k, (($picked | ForEach-Object { $_.id }) -join '/'))
}

# ---------------------------------------------------------------------------
# emit
# ---------------------------------------------------------------------------
$menuColor = @{ plate = 'aqua'; travelers = 'green'; slime = 'light_purple' }
$menuLabel = @{ plate = $UI.setLabel.plate; travelers = $UI.setLabel.travelers; slime = $UI.setLabel.slime }

foreach ($L in $loadouts) {
    $k = $L.k

    # --- build the starter chest (17 items) + show the armour menu ---------
    $b = New-Object System.Text.StringBuilder
    [void]$b.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
    [void]$b.AppendLine("# Draft loadout $k : 12 armour candidates + 5 weapons.")
    [void]$b.AppendLine("# The chest is Lock-ed; click handlers COPY out of it, so several players can")
    [void]$b.AppendLine("# each take their own four pieces.")
    [void]$b.AppendLine("#")
    [void]$b.AppendLine("# v0.6.23: FILL ONLY. Each player has their OWN draft loadout (@s tspire_draft_l),")
    [void]$b.AppendLine("# so the shared chest is re-stocked from the CLICKING player's own loadout right")
    [void]$b.AppendLine("# before every take (starter/own_fill). That is what makes two players see -- and")
    [void]$b.AppendLine("# get -- two different sets of options instead of one shared list.")
    [void]$b.AppendLine("")
    [void]$b.AppendLine('execute in tspire:tower run kill @e[tag=tspire_starter]')
    [void]$b.AppendLine('summon minecraft:marker ~ ~ ~ {Tags:["tspire_starter"]}')
    [void]$b.AppendLine('execute at @e[tag=tspire_starter] run setblock ~ ~ ~ minecraft:chest{Lock:"tspire_sealed"}')
# v0.7.17: a Returning crystal in the starter chest. Direct NBT injection of "returning" is
#   DROPPED by TiC (a creative-applied one survives, an injected one does not), so hand the
#   player the crystal and let TiC apply it at the Tinker Station -- that path always works.
[void]$b.AppendLine('execute at @e[tag=tspire_starter] run item replace block ~ ~ ~ container.17 with tconstruct:modifier_crystal{modifier:"tconstruct:returning"}')
    $idx = 0
    foreach ($a in $L.armor) {
        $nbt = '{tic_materials:[' + (($a.mats | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']}'
        [void]$b.AppendLine(("execute at @e[tag=tspire_starter] run item replace block ~ ~ ~ container.{0} with {1}{2}" -f $idx, $a.id, $nbt))
        $idx++
    }
    foreach ($w in $L.weapons) {
        $nbt = '{tic_materials:[' + (($w.mats | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']' + (Mod-Nbt $w.id) + '}'
        $count = if ($w.id -eq 'tconstruct:dagger') { 2 } else { 1 }
        [void]$b.AppendLine(("execute at @e[tag=tspire_starter] run item replace block ~ ~ ~ container.{0} with {1}{2} {3}" -f $idx, $w.id, $nbt, $count))
        $idx++
    }
    Write-Utf8 (Join-Path $starterDir ("l{0}_fill.mcfunction" -f $k)) $b.ToString()

    # --- armour menu: 12 entries, one per (slot, set) ----------------------
    $m = New-Object System.Text.StringBuilder
    [void]$m.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
    [void]$m.AppendLine(("# draft {0} / ARMOUR : 4 slots x 3 sets, pick one per slot" -f $k))
    [void]$m.AppendLine("")
    [void]$m.AppendLine('tellraw @s [{"text":"' + (Text 'armorHeader') + '","color":"gold","bold":true}]')
    [void]$m.AppendLine('tellraw @s [{"text":"' + (Text 'armorSub') + '","color":"gray"}]')
    $s = 0
    foreach ($slot in $ARMOR_SLOTS) {
        $slotLabel = $UI.slotLabel[$s]
        [void]$m.AppendLine('tellraw @s [{"text":"' + (Text 'slotHeader' @($slotLabel)) + '","color":"yellow"}]')
        $t = 0
        foreach ($set in $ARMOR_SETS) {
            $a = $L.armor[$s * 3 + $t]
            # the option's OWN set, not the loop variable -- options are rolled randomly
            $setKey = $a.set
            $line  = Text 'armorLine' @($slotLabel, $menuLabel[$setKey], (ItemName $a.id), (MatNames $a.mats))
            $hover = Text 'armorHover' @((ItemName $a.id), (MatNames $a.mats))
            [void]$m.AppendLine('execute if score @s tspire_arm' + $s + ' matches 0 run tellraw @s [{"text":"' + $line + '","color":"' + $menuColor[$setKey] + '","clickEvent":{"action":"run_command","value":"/function tspire:run/apick_' + $s + '_' + $t + '"},"hoverEvent":{"action":"show_text","contents":"' + $hover + '"}}]')
            [void]$m.AppendLine('execute if score @s tspire_arm' + $s + ' matches 1 run tellraw @s [{"text":"' + (Text 'armorPicked' @((ItemName $a.id))) + '","color":"dark_gray"}]')
            $t++
        }
        $s++
    }
    [void]$m.AppendLine('tellraw @s [{"text":"' + (Text 'gold') + '","color":"gray"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]')
    [void]$m.AppendLine('tellraw @s [{"text":"' + (Text 'rule') + '","color":"gold","bold":true}]')
    Write-Utf8 (Join-Path $starterDir ("l{0}_armor_menu.mcfunction" -f $k)) $m.ToString()

    # --- weapon menu: 5 entries, pick exactly 2 ----------------------------
    $w = New-Object System.Text.StringBuilder
    [void]$w.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
    [void]$w.AppendLine(("# draft {0} / WEAPON : five weapons, pick exactly two" -f $k))
    [void]$w.AppendLine("")
    [void]$w.AppendLine('tellraw @s [{"text":"' + (Text 'weaponHeader') + '","color":"gold","bold":true}]')
    $i = 0
    foreach ($wp in $L.weapons) {
        $line  = Text 'weaponLine' @(($i + 1), (ItemName $wp.id), (MatNames $wp.mats))
        $hover = Text 'weaponHover' @((ItemName $wp.id), (MatNames $wp.mats))
        [void]$w.AppendLine('execute if score @s tspire_w' + $i + ' matches 0 run tellraw @s [{"text":"' + $line + '","color":"aqua","clickEvent":{"action":"run_command","value":"/function tspire:run/wpick_' + $i + '"},"hoverEvent":{"action":"show_text","contents":"' + $hover + '"}}]')
        [void]$w.AppendLine('execute if score @s tspire_w' + $i + ' matches 1 run tellraw @s [{"text":"' + (Text 'weaponPicked' @($line)) + '","color":"green","clickEvent":{"action":"run_command","value":"/function tspire:run/wpick_' + $i + '"},"hoverEvent":{"action":"show_text","contents":"' + (Text 'weaponPickedHover') + '"}}]')
        $i++
    }
    [void]$w.AppendLine(('tellraw @s [{"text":"' + (Text 'weaponCount') + '","color":"gray"},{"score":{"name":"@s","objective":"tspire_wcount"},"color":"yellow"},{"text":"' + (Text 'weaponCountTail') + '","color":"gray"},{"text":"  ' + (Text 'reset') + '","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:run/reset_weapons"},"hoverEvent":{"action":"show_text","contents":"' + (Text 'resetHover') + '"}}]'))
    [void]$w.AppendLine('execute if score @s tspire_wcount matches 2 run tellraw @s [{"text":"' + (Text 'confirm') + '","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/function tspire:run/confirm_weapons"},"hoverEvent":{"action":"show_text","contents":"' + (Text 'confirmHover') + '"}}]')
    [void]$w.AppendLine('execute unless score @s tspire_wcount matches 2 run tellraw @s [{"text":"' + (Text 'needTwo') + '","color":"dark_gray"}]')
    [void]$w.AppendLine('tellraw @s [{"text":"' + (Text 'ruleWide') + '","color":"gold","bold":true}]')
    Write-Utf8 (Join-Path $starterDir ("l{0}_weapon_menu.mcfunction" -f $k)) $w.ToString()
}

# --- per-player draft: roll + own_* dispatchers ----------------------------
# v0.6.23: the draft loadout is stored ON THE PLAYER (@s tspire_draft_l), so two
# players see (and get) two DIFFERENT sets of options. There is no global
# #LOADOUT / starter/pick any more -- both were removed.
$r = New-Object System.Text.StringBuilder
[void]$r.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
[void]$r.AppendLine("# Roll THIS player's own draft loadout (1..$DRAFT_COUNT) into @s tspire_draft_l.")
[void]$r.AppendLine("# Rolled per player so party members get different option sets.")
[void]$r.AppendLine("")
[void]$r.AppendLine("scoreboard players set @s tspire_draft_l 0")
for ($k = 1; $k -le $DRAFT_COUNT; $k++) {
    $d = $DRAFT_COUNT - $k + 1
    [void]$r.AppendLine(("execute if score @s tspire_draft_l matches 0 if predicate tspire:roll/d{0} run scoreboard players set @s tspire_draft_l {1}" -f $d, $k))
}
[void]$r.AppendLine("execute if score @s tspire_draft_l matches 0 run scoreboard players set @s tspire_draft_l 1")
Write-Utf8 (Join-Path $starterDir 'roll.mcfunction') $r.ToString()

# --- starter/flush_chat: refresh the chat before every draft menu (v0.7.11) --------------
#   MUST be produced here: line 38 wipes every .mcfunction in the starter directory before
#   regenerating, and own_armor_menu / own_weapon_menu CALL this function -- a missing file
#   makes both of them fail to LOAD, which leaves the draft room stuck with no menus.
#   The text lives in tools/starter-flush.txt because this script must stay pure ASCII
#   (PS 5.1 reads a BOM-less .ps1 as ANSI, and Chinese inside it breaks the parser).
$fcSrc = Join-Path $PSScriptRoot 'starter-flush.txt'
if (-not (Test-Path $fcSrc)) { throw 'missing tools/starter-flush.txt' }
Copy-Item $fcSrc (Join-Path $starterDir 'flush_chat.mcfunction') -Force

$of = New-Object System.Text.StringBuilder
[void]$of.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
[void]$of.AppendLine("# Stock the shared chest from the EXECUTING player's OWN draft loadout.")
[void]$of.AppendLine("# The caller MUST position this (at @e[tag=tspire_starter] or at the prep spot).")
[void]$of.AppendLine("")
for ($k = 1; $k -le $DRAFT_COUNT; $k++) {
    [void]$of.AppendLine(("execute if score @s tspire_draft_l matches {0} run function tspire:starter/l{0}_fill" -f $k))
}
Write-Utf8 (Join-Path $starterDir 'own_fill.mcfunction') $of.ToString()

$oa = New-Object System.Text.StringBuilder
[void]$oa.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
[void]$oa.AppendLine("# Show the EXECUTING player their OWN armour menu.")
[void]$oa.AppendLine("")
# v0.7.10 (player request): refresh the chat first, so the previous menu's buttons are
#   scrolled out of view instead of piling up behind the new one.
[void]$oa.AppendLine("function tspire:starter/flush_chat")
for ($k = 1; $k -le $DRAFT_COUNT; $k++) {
    [void]$oa.AppendLine(("execute if score @s tspire_draft_l matches {0} run function tspire:starter/l{0}_armor_menu" -f $k))
}
Write-Utf8 (Join-Path $starterDir 'own_armor_menu.mcfunction') $oa.ToString()

$ow = New-Object System.Text.StringBuilder
[void]$ow.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
[void]$ow.AppendLine("# Show the EXECUTING player their OWN weapon menu.")
[void]$ow.AppendLine("")
# v0.7.10 (player request): refresh the chat first (see own_armor_menu).
[void]$ow.AppendLine("function tspire:starter/flush_chat")
for ($k = 1; $k -le $DRAFT_COUNT; $k++) {
    [void]$ow.AppendLine(("execute if score @s tspire_draft_l matches {0} run function tspire:starter/l{0}_weapon_menu" -f $k))
}
Write-Utf8 (Join-Path $starterDir 'own_weapon_menu.mcfunction') $ow.ToString()
Write-Host "  roll / own_fill / own_armor_menu / own_weapon_menu (per-player draft)"

# ---------------------------------------------------------------------------
# runtime pick functions
#   run/take_<idx>     copy chest slot <idx> into the first free hotbar slot
#   run/apick_<S>_<T>  armour click handler (slot S, set T)
#   run/wpick_<i>      weapon click handler (i = 0..4)
#   starter/l<k>_clear_weapons   undo the two picked weapons (needs the exact NBT,
#                                hence one per draft)
# ---------------------------------------------------------------------------
$ARMOR_SLOT_COUNT = $ARMOR_SLOTS.Count
$ITEM_COUNT       = $ARMOR_SLOT_COUNT * $ARMOR_SETS.Count + 5

for ($idx = 0; $idx -lt $ITEM_COUNT; $idx++) {
    $d = New-Object System.Text.StringBuilder
    [void]$d.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
    [void]$d.AppendLine(("# Copy draft chest slot {0} into the first free hotbar slot." -f $idx))
    [void]$d.AppendLine("# Runs AT the tspire_starter marker, AS the picking player. #OK = 1 on success.")
    [void]$d.AppendLine("# The chest is Lock-ed, so the item is COPIED (several players can each take one).")
    [void]$d.AppendLine("")
    [void]$d.AppendLine("scoreboard players set #OK tspire_timer 0")
    for ($h = 0; $h -lt 9; $h++) {
        [void]$d.AppendLine(("execute if score #OK tspire_timer matches 0 unless data entity @s Inventory[{{Slot:{0}b}}] store success score #OK tspire_timer run item replace entity @s hotbar.{0} from block ~ ~ ~ container.{1}" -f $h, $idx))
    }
    Write-Utf8 (Join-Path $runDir ("take_{0}.mcfunction" -f $idx)) $d.ToString()
}

for ($s = 0; $s -lt $ARMOR_SLOT_COUNT; $s++) {
    for ($t = 0; $t -lt $ARMOR_SETS.Count; $t++) {
        $idx = $s * $ARMOR_SETS.Count + $t
        $a = New-Object System.Text.StringBuilder
        [void]$a.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
        [void]$a.AppendLine(("# Armour pick: slot {0}, set {1} (chest slot {2})." -f $s, $ARMOR_SETS[$t].key, $idx))
        [void]$a.AppendLine("")
        # v0.6.22: remember whether the slot was ALREADY picked BEFORE this click.
        # The old last line fired on `arm<S> == 1`, i.e. both after a fresh pick and
        # when the player clicked an already-picked option -- so a duplicate click
        # printed "already picked" and THEN re-sent the entire armour menu, which
        # reads as "two copies of the equipment list".
        [void]$a.AppendLine("scoreboard players set #DUP tspire_timer 0")
        [void]$a.AppendLine(('execute if score @s tspire_arm' + $s + ' matches 1 run scoreboard players set #DUP tspire_timer 1'))
        [void]$a.AppendLine(('execute if score @s tspire_arm' + $s + ' matches 1 run tellraw @s [{"text":"' + (Text 'alreadyPicked') + '","color":"red"}]'))
        # v0.6.23: re-stock the shared chest from THIS player's own draft loadout
        # right before copying, so the copy always yields the option they saw.
        [void]$a.AppendLine(("execute if score @s tspire_arm{0} matches 0 at @e[tag=tspire_starter,limit=1] run function tspire:starter/own_fill" -f $s))
        [void]$a.AppendLine(("execute if score @s tspire_arm{0} matches 0 at @e[tag=tspire_starter,limit=1] run function tspire:run/take_{1}" -f $s, $idx))
        [void]$a.AppendLine(("execute if score @s tspire_arm{0} matches 0 if score #OK tspire_timer matches 1 run scoreboard players set @s tspire_arm{0} 1" -f $s))
        [void]$a.AppendLine(('execute if score @s tspire_arm' + $s + ' matches 0 if score #OK tspire_timer matches 0 run tellraw @s [{"text":"' + (Text 'bagFull') + '","color":"red"}]'))
        [void]$a.AppendLine("execute if score #DUP tspire_timer matches 0 run function tspire:start/after_armor_pick")
        Write-Utf8 (Join-Path $runDir ("apick_{0}_{1}.mcfunction" -f $s, $t)) $a.ToString()
    }
}

for ($i = 0; $i -lt 5; $i++) {
    $idx = $ARMOR_SLOT_COUNT * $ARMOR_SETS.Count + $i
    $w = New-Object System.Text.StringBuilder
    [void]$w.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
    [void]$w.AppendLine(("# Weapon pick {0} (chest slot {1}). Exactly two may be taken." -f ($i + 1), $idx))
    [void]$w.AppendLine("")
    [void]$w.AppendLine("scoreboard players set #DUP tspire_timer 0")
    [void]$w.AppendLine('execute if score @s tspire_w' + $i + ' matches 1 run scoreboard players set #DUP tspire_timer 1')
    [void]$w.AppendLine('execute if score @s tspire_w' + $i + ' matches 1 run tellraw @s [{"text":"' + (Text 'weaponAlready') + '","color":"red"}]')
    [void]$w.AppendLine('execute if score @s tspire_w' + $i + ' matches 0 if score @s tspire_wcount matches 2 run tellraw @s [{"text":"' + (Text 'weaponFull') + '","color":"red"}]')
    # v0.6.23: re-stock the chest from THIS player's own draft before copying
    [void]$w.AppendLine(("execute if score @s tspire_w{0} matches 0 if score @s tspire_wcount matches 0..1 at @e[tag=tspire_starter,limit=1] run function tspire:starter/own_fill" -f $i))
    [void]$w.AppendLine(("execute if score @s tspire_w{0} matches 0 if score @s tspire_wcount matches 0..1 at @e[tag=tspire_starter,limit=1] run function tspire:run/take_{1}" -f $i, $idx))
    [void]$w.AppendLine(("execute if score @s tspire_w{0} matches 0 if score @s tspire_wcount matches 0..1 if score #OK tspire_timer matches 1 run scoreboard players set @s tspire_w{0} 1" -f $i))
    [void]$w.AppendLine(('execute if score @s tspire_w' + $i + ' matches 0 if score @s tspire_wcount matches 0..1 if score #OK tspire_timer matches 0 run tellraw @s [{"text":"' + (Text 'bagFull') + '","color":"red"}]'))
    # v0.6.22: only re-render on a FRESH pick (see the apick comment above).
    [void]$w.AppendLine("execute if score #DUP tspire_timer matches 0 run function tspire:start/open_weapon_menu")
    Write-Utf8 (Join-Path $runDir ("wpick_{0}.mcfunction" -f $i)) $w.ToString()
}

foreach ($L in $loadouts) {
    $k = $L.k
    $c = New-Object System.Text.StringBuilder
    [void]$c.AppendLine("# AUTO-GENERATED by tools/gen-starter.ps1 -- do not edit by hand.")
    [void]$c.AppendLine(("# Undo the picked weapons of draft {0} (needs the exact item NBT)." -f $k))
    [void]$c.AppendLine("")
    foreach ($wp in $L.weapons) {
        # v0.7.10 (player report: "re-picking does not clear the tools already in the bag"):
        #   This used to be `clear @s <id>{exact NBT} 1`. Item NBT is NOT stable once the stack
        #   lives in the inventory -- TiC adds/rewrites keys (tic_stats, damage, ...) as soon as
        #   the tool is used or re-serialised, so the exact-NBT match silently failed and the
        #   picked weapon stayed in the bag.
        #   During the draft the only weapons a player can hold are these five, so clearing by
        #   ITEM ID alone is both safe and reliable.
        [void]$c.AppendLine(("clear @s {0}" -f $wp.id))
    }
    for ($i = 0; $i -lt 5; $i++) { [void]$c.AppendLine(("scoreboard players set @s tspire_w{0} 0" -f $i)) }
    [void]$c.AppendLine("function tspire:start/open_weapon_menu")
    Write-Utf8 (Join-Path $starterDir ("l{0}_clear_weapons.mcfunction" -f $k)) $c.ToString()
}

Write-Host ("done: {0} drafts, {1} take + 12 armour + 5 weapon pickers, {0} clear functions" -f $DRAFT_COUNT, $ITEM_COUNT)
