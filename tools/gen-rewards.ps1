# Generate tinkers-spire reward loot tables (design doc 3.3 / 6.3).
#
# KEY CORRECTNESS RULE (this is the "useless part" bug):
#   A material is only usable for a part if the material actually provides that
#   part's STAT TYPE. e.g. string/feather/leather only have binding / bowstring,
#   so tconstruct:small_blade{Material:"tconstruct:string"} is a part nobody can
#   ever craft or use.
#   The stat types are read from the jar:
#       data/tconstruct/tinkering/materials/stats/<material>.json
#           { "stats": { "tconstruct:head": {...}, "tconstruct:handle": {...} } }
#   Each part is then only offered with materials that have the matching stat.
#
# Part -> stat type mapping used here (only mappings that exist in material data):
#   small_blade/broad_blade/small_axe_head/pick_head -> head
#   tool_handle/tough_handle                         -> handle
#   tool_binding/tough_binding                       -> binding
#   bow_limb                                         -> limb
#   bow_grip                                         -> grip
#   bowstring                                        -> bowstring
#   arrow_head                                       -> arrow_head
#   large_plate is EXCLUDED: no material in 3.12 declares a "large_plate" stat
#   (TinkerToolParts has the part, but no stat data backs it), so any large_plate
#   reward would be dead weight.
#
# Also fixed here: nested loot tables use the field "name", NOT "value".
# ("Missing name, expected to find a string" killed battle_random_* entirely.)
#
# NOTE: keep this file pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI).

# ---------------------------------------------------------------------------
# TUNABLE PARAMETERS (edit below, then re-run this script)
#   $floorTiers -- per-floor material tier range for the reward part pool
#   $partDefs   -- which tinkering parts can be rewards + their stat type
#   $mods       -- modifier crystals that can drop, grouped by category
#   $catShare   -- crystal category weights (percent)
#   $ancient    -- the ancient tool pool
#   battle_random_f* entry weights are inline where those tables are emitted
# ---------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'

$root   = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root 'src\main\resources\data\tspire\loot_tables\rewards'

# The unpacked Tinkers' Construct jar lives on a path containing CJK characters.
# This .ps1 must stay pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI), so the
# path is read from tools/tc-source.txt (UTF-8) instead of being a literal here.
$tcSource = (Get-Content (Join-Path $PSScriptRoot 'tc-source.txt') -Raw -Encoding UTF8).Trim()
$statsDir = Join-Path $tcSource 'data\tconstruct\tinkering\materials\stats'

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
Get-ChildItem -File $outDir -Filter *.json -ErrorAction SilentlyContinue | Remove-Item -Force

# ---------------------------------------------------------------------------
# 1) read material -> stat types from the jar
# ---------------------------------------------------------------------------
if (-not (Test-Path $statsDir)) { throw "material stats not found: $statsDir" }

$matStats = @{}
Get-ChildItem $statsDir -File -Filter *.json | ForEach-Object {
    $mat = 'tconstruct:' + $_.BaseName
    $j = Get-Content $_.FullName -Raw | ConvertFrom-Json
    $types = @()
    if ($j.stats) { $types = @($j.stats.PSObject.Properties.Name) }
    $matStats[$mat] = $types
}
Write-Host ("loaded stats for {0} materials" -f $matStats.Count)

# stat type counts, to sanity check the part table
$statCount = @{}
foreach ($m in $matStats.Keys) { foreach ($t in $matStats[$m]) { $statCount[$t] = 1 + $statCount[$t] } }
Write-Host ("distinct stat types: {0}" -f $statCount.Count)

# ---------------------------------------------------------------------------
# 2) material pools DERIVED from Tinkers' own data
#    A material is a compat / integration material iff its definition carries a
#    "condition" field, e.g.
#        "condition": { "type": "forge:or", "values": [
#            { "type": "tconstruct:config", "prop": "force_integration_materials" },
#            { "type": "mantle:tag_filled", "tag": "forge:ingots/ironwood" } ] }
#    i.e. it only exists when another mod supplies that ingot. Design doc 4.1
#    says to drop those, so they are excluded here automatically.
#    Also excluded: "redirect" aliases and hidden materials.
#    Tier comes from the same definition file, so no hand-written tier list.
# ---------------------------------------------------------------------------
$defDir = Join-Path $tcSource 'data\tconstruct\tinkering\materials\definition'
if (-not (Test-Path $defDir)) { throw "material definitions not found: $defDir" }

$tiers = @{ 0 = @(); 1 = @(); 2 = @(); 3 = @(); 4 = @() }
$compat = @(); $alias = @(); $hidden = @()

Get-ChildItem $defDir -File -Filter *.json | ForEach-Object {
    $mat = 'tconstruct:' + $_.BaseName
    $j = Get-Content $_.FullName -Raw | ConvertFrom-Json
    $props = @($j.PSObject.Properties.Name)
    if ($props -contains 'condition') { $compat += $mat; return }
    if ($props -contains 'redirect')  { $alias  += $mat; return }
    if ($j.hidden -eq $true)          { $hidden += $mat; return }
    $t = [int]$j.tier
    if ($tiers.ContainsKey($t)) { $tiers[$t] += $mat }
}

Write-Host ("compat materials excluded ({0}): {1}" -f $compat.Count, (($compat | Sort-Object) -join ', '))
Write-Host ("redirect aliases ({0}), hidden ({1})" -f $alias.Count, $hidden.Count)
foreach ($t in 0..4) { Write-Host ("  tier {0}: {1} materials" -f $t, $tiers[$t].Count) }

$floorTiers = @{ 'f1' = @(0,1,2); 'f2' = @(2,3); 'f3' = @(3,4) }

# ---------------------------------------------------------------------------
# 3) part -> required stat type
# ---------------------------------------------------------------------------
$partDefs = @(
    # v0.7.19 (player report): the shield core was missing from every part list, so it could
    #   neither be sold to the merchant nor used in the artisan fusion. Added here (and to the
    #   identical table in gen-shops.ps1).
    @{ item = 'shield_core';   stat = 'tconstruct:shield_core' }
    @{ item = 'small_blade';   stat = 'tconstruct:head' }
    @{ item = 'broad_blade';   stat = 'tconstruct:head' }
    @{ item = 'small_axe_head';stat = 'tconstruct:head' }

    @{ item = 'pick_head';    stat = 'tconstruct:head' }
    @{ item = 'hammer_head';    stat = 'tconstruct:head' }
    @{ item = 'broad_axe_head';    stat = 'tconstruct:head' }
    @{ item = 'adze_head';    stat = 'tconstruct:head' }
    @{ item = 'large_plate';    stat = 'tconstruct:head' }
    @{ item = 'tool_handle';   stat = 'tconstruct:handle' }
    @{ item = 'tough_handle';  stat = 'tconstruct:handle' }
    @{ item = 'tool_binding';  stat = 'tconstruct:binding' }
    @{ item = 'tough_binding'; stat = 'tconstruct:binding' }
    @{ item = 'bow_limb';      stat = 'tconstruct:limb' }
    @{ item = 'bow_grip';      stat = 'tconstruct:grip' }
    @{ item = 'bowstring';     stat = 'tconstruct:bowstring' }
    # v0.6.43: armour parts. Without these, EVERY armour tool definition produced
    # an empty part list (its parts are helmet_plating / chestplate_plating /
    # leggings_plating / boots_plating, and the travellers sets declare the stat
    # types plating_helmet..plating_boots), so the three-choice offer could never
    # contain an armour part -- the player reported exactly that.
    # All four stat types are supported by 31 materials each.
    @{ item = 'helmet_plating';     stat = 'tconstruct:plating_helmet' }
    @{ item = 'chestplate_plating'; stat = 'tconstruct:plating_chestplate' }
    @{ item = 'leggings_plating';   stat = 'tconstruct:plating_leggings' }
    @{ item = 'boots_plating';      stat = 'tconstruct:plating_boots' }
    @{ item = 'maille';             stat = 'tconstruct:maille' }
)


# ---------------------------------------------------------------------------
# v0.7.11 (player request): never place a material in a slot where TiC would grant
# the enderclearance trait. Verified against TiC 3.12.0.220 data:
#   chorus / enderslime_vine -> trait sits on the ARMOUR stat group
#   enderslime               -> trait sits on the AMMO stat group (declares arrow_head)
# These materials are otherwise unchanged (chorus still grants enderference).
$ENDER_ARMOR_STATS = @(
    'tconstruct:plating_helmet', 'tconstruct:plating_chestplate',
    'tconstruct:plating_leggings', 'tconstruct:plating_boots',
    'tconstruct:plating_shield', 'tconstruct:maille',
    'tconstruct:cuirass', 'tconstruct:laces', 'tconstruct:shell', 'tconstruct:ribcage',
    # v0.7.19 (player report): TiC's armour group also covers the SHIELD CORE slot --
    'tconstruct:shield_core'
)
function Test-EnderClearance {
    param([string]$Material, [string]$StatType)
    $short = $Material -replace '^tconstruct:', ''
    if ($StatType -eq 'tconstruct:arrow_head') { return ($short -eq 'enderslime') }
    if ($ENDER_ARMOR_STATS -contains $StatType) { return ($short -eq 'chorus' -or $short -eq 'enderslime_vine') }
    return $false
}

function Get-FloorMaterials {
    param([string]$Floor, [string]$StatType)
    $out = @()
    foreach ($t in $floorTiers[$Floor]) {
        foreach ($id in $tiers[$t]) {
            if (-not $matStats.ContainsKey($id)) { continue }
            if ($matStats[$id] -notcontains $StatType) { continue }
            if (Test-EnderClearance -Material $id -StatType $StatType) { continue }
            $out += $id
        }
    }
    return @($out | Sort-Object -Unique)
}

function Get-TierMaterials {
    param([int]$Tier, [string]$StatType)
    $out = @()
    foreach ($id in $tiers[$Tier]) {
        if (-not $matStats.ContainsKey($id)) { continue }
        if ($matStats[$id] -notcontains $StatType) { continue }
        if (Test-EnderClearance -Material $id -StatType $StatType) { continue }
        $out += $id
    }
    return @($out | Sort-Object -Unique)
}

function New-LootTable {
    param([string]$Name, $Entries)
    $obj = [ordered]@{ pools = @([ordered]@{ rolls = 1; entries = $Entries }) }
    $json = $obj | ConvertTo-Json -Depth 16
    [System.IO.File]::WriteAllText((Join-Path $outDir "$Name.json"), $json, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  {0}.json  ({1} entries)" -f $Name, $Entries.Count)
}

# ---------------------------------------------------------------------------
# 4) modifier crystals (design doc 6.3: upgrade 50 / ability 30 / defense 15 / slotless 5)
# ---------------------------------------------------------------------------
# v0.7.13 (player report: Draconic never seen): TiC's dragon family is
#   draconic     = Draconic -> slotless/bonus, grants +1 ABILITY slot (recipes: dragon scales / head / skull)
#   dragonborn   = Dragonborn -> DEFENSE (recipe data/tconstruct/recipes/tools/modifiers/defense/dragonborn.json)
#   dragonfall / dragonheart / dragonshot = registry-only in 3.12, no recipes at all -> not pooled.
#   We had dragonborn in 'slotless' and draconic nowhere, so Draconic could never drop from a crystal.
#
# v0.7.12: the three category tables used by the resonance event (mystery/crystal_<cat>) used to be
#   hand-written files that had drifted badly -- crystal_slotless listed only writable and
#   harmonious, so dragonborn (dragonborn, the slotless modifier the player kept not seeing) could
#   NEVER come out of resonance. They are generated below from $mods so they cannot drift again.
$mods = @{
    'upgrade' = @(
        'diamond','netherite','reinforced','tank','smelting','zoom','magnetic',
        'necrotic','fiery','knockback','padded','sweeping_edge','severing','freezing',
        'sharpness','smite','bane_of_sssss','killager','antiaquatic','pierce','swiftstrike',
        'haste','blasting','lightspeed','hydraulic',
        'power','quick_charge','trueshot','scope','punch','impaling','multishot',
        'thorns','respiration','leaping','speedy','step_up','feather_falling','depth_strider','soulspeed'
    )
    'ability' = @(
        'luck','gilded',
        'stripping','spitting','warping','firestarter','tilling','flinging','glowing','bonking','pathing','splashing','springing',
        'spilling','parrying','blocking',
        'silky','exchanging','autosmelt',
        'ballista','returning','grapple','channeling','bulk_quiver',
        'protection','strength','reach','pockets','frost_walker','bouncy','reflecting'
    )
    'defense' = @(
        'projectile_protection','turtle_shell','shulking','fire_protection','blast_protection',
        'melee_protection','magic_protection','knockback_resistance','revitalizing',
        'dragonborn'
    )
    'slotless' = @('writable','harmonious','forecast','recapitated','shiny','draconic')
}
# v0.7.2 (player request): slotless 25 -> 15, the other three scaled up in proportion
# (34 / 22.67 / 28.33 = the old 30/20/25 scaled by 85/75). 0.6.44 had 30/20/25/25.
$catShare = @{ 'upgrade' = 34; 'ability' = 22.67; 'defense' = 28.33; 'slotless' = 15 }

# v0.6.26: drop the mining/excavating modifiers. The tower has no ores, so a crystal
# that only speeds up digging or auto-smelts ore is a wasted reward slot.
# Edit this list if more turn out to be useless in the tower.
#   smelting   auto-smelt ore
#   haste      mining speed
#   blasting   mining speed
#   lightspeed mining speed
#   hydraulic  mining speed
#   silky      silk touch
#   exchanging swap the mined block
#   autosmelt  auto-smelt
# (luck is KEPT: it also gives looting, which still matters for mob drops)
$modExcluded = @('smelting','haste','blasting','lightspeed','hydraulic','silky','exchanging','autosmelt','reinforced','severing','warping','firestarter','luck','bulk_quiver')
foreach ($cat in @('upgrade','ability','defense','slotless')) {
    $mods[$cat] = @($mods[$cat] | Where-Object { $modExcluded -notcontains $_ })
    if ($mods[$cat].Count -eq 0) { throw ("crystal category '$cat' is empty after exclusions") }
}
Write-Host ("  crystal modifiers after exclusion: " + (($mods.Keys | ForEach-Object { "$_=" + $mods[$_].Count }) -join ' '))

$crystalEntries = @()
foreach ($cat in @('upgrade','ability','defense','slotless')) {
    $list = $mods[$cat]
# v0.7.18 BUG FIX (player report: resonance gave one crystal or none; the chest
#   announced a crystal but gave none): a loot entry weight MUST be an integer -- 0.9714
#   was truncated to 0, so every random crystal reward was effectively empty. Now x10000.
    $per = [int][Math]::Round(($catShare[$cat] / $list.Count) * 10000, 0)
    if ($per -lt 1) { throw ('crystal weight for ' + $cat + ' would be < 1') }
    foreach ($m in $list) {
        $crystalEntries += [ordered]@{
            type      = 'minecraft:item'
            name      = 'tconstruct:modifier_crystal'
            weight    = $per
            functions = @([ordered]@{ function = 'minecraft:set_nbt'; tag = ('{modifier:"tconstruct:' + $m + '"}') })
        }
    }
}
New-LootTable -Name 'crystal' -Entries $crystalEntries

# --- v0.7.12: per-category crystal tables used by the resonance event (mystery/crystal_<cat>) ------
#   These used to be hand-written files and had drifted: crystal_slotless listed only writable
#   and harmonious, so dragonborn (the slotless "dragonborn" modifier) could NEVER come out of resonance.
#   Generated here from $mods with the same weight formula as the flat table (catShare / count),
#   so a category pool can never disagree with the flat reward pool again.
$mystDir = Join-Path $root 'src\main\resources\data\tspire\loot_tables\mystery'  # v0.7.12: $root, not $resDir (this script has no $resDir)
New-Item -ItemType Directory -Force -Path $mystDir | Out-Null
foreach ($cat in @('upgrade','ability','defense','slotless')) {
    $list = @($mods[$cat])
    if ($list.Count -eq 0) { throw ('crystal category ' + $cat + ' is empty') }
    # v0.7.18: integer weights, same x10000 scaling as the flat table (see the note there).
    $catW = [int][Math]::Round(($catShare[$cat] / $list.Count) * 10000, 0)
    if ($catW -lt 1) { throw ('category weight for ' + $cat + ' would be < 1') }
    $catEntries = @()
    foreach ($m in $list) {
        $catEntries += [ordered]@{
            type      = 'minecraft:item'
            name      = 'tconstruct:modifier_crystal'
            weight    = $catW
            functions = @([ordered]@{ function = 'minecraft:set_nbt'; tag = ('{modifier:"tconstruct:' + $m + '"}') })
        }
    }
    $catObj = [ordered]@{ pools = @([ordered]@{ rolls = 1; entries = $catEntries }) }
    [System.IO.File]::WriteAllText((Join-Path $mystDir ('crystal_' + $cat + '.json')), ($catObj | ConvertTo-Json -Depth 16), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  mystery/crystal_{0}.json  ({1} entries, weight {2})" -f $cat, $list.Count, $catW)
}

# ---------------------------------------------------------------------------
# 5) material parts per floor (stat-type filtered)
# ---------------------------------------------------------------------------
foreach ($f in @('f1','f2','f3')) {
    $entries = @()
    foreach ($p in $partDefs) {
        $mats = Get-FloorMaterials -Floor $f -StatType $p.stat
        foreach ($m in $mats) {
            $entries += [ordered]@{
                type      = 'minecraft:item'
                name      = ('tconstruct:' + $p.item)
                weight    = 1
                functions = @([ordered]@{ function = 'minecraft:set_nbt'; tag = ('{Material:"' + $m + '"}') })
            }
        }
    }
    New-LootTable -Name ("part_{0}" -f $f) -Entries $entries
}

# ---------------------------------------------------------------------------
# 6) gear wrapper (v0.6.44)
# ---------------------------------------------------------------------------
# The battle reward used to point straight at tspire:mob_gear/weapon_<floor>, i.e.
# WEAPONS ONLY -- the player asked whether the gear pool contains armour, and it did
# not. This wrapper rolls one of the five gear slots instead, so armour now drops.
# weight: weapon 2, each armour slot 1 (so ~33% weapon / ~67% armour).
# NOTE: the old repair_* tables are no longer generated at all (v0.6.43 removed the
# repair reward from the pool; v0.6.44 deletes the tables themselves).
foreach ($f in @('f1','f2','f3')) {
    $gearEntries = @(
        [ordered]@{ type='minecraft:loot_table'; name="tspire:mob_gear/weapon_$f"; weight=2 }
        [ordered]@{ type='minecraft:loot_table'; name="tspire:mob_gear/head_$f";   weight=1 }
        [ordered]@{ type='minecraft:loot_table'; name="tspire:mob_gear/chest_$f";  weight=1 }
        [ordered]@{ type='minecraft:loot_table'; name="tspire:mob_gear/legs_$f";   weight=1 }
        [ordered]@{ type='minecraft:loot_table'; name="tspire:mob_gear/feet_$f";   weight=1 }
    )
    New-LootTable -Name ("gear_{0}" -f $f) -Entries $gearEntries
}
Write-Host "  gear_f1..f3.json  (weapon + head/chest/legs/feet, armour included)"

# ---------------------------------------------------------------------------
# 7) ancient tools / throwing tools
# ---------------------------------------------------------------------------
$ancient = @(
    @{ id='tconstruct:melting_pan'; slots=2 }
    @{ id='tconstruct:war_pick';    slots=3 }
    @{ id='tconstruct:battlesign';  slots=2 }
    @{ id='tconstruct:swasher';     slots=3 }
)
$entries = @()
foreach ($a in $ancient) {
    $mats = @()
    # v0.7.46 (player request): ancient tools must use the SAME material pool as the spire
    #   (i.e. the tier tables built in section 2, which already drop compat materials with a
    #   "condition", redirect aliases and hidden materials) -- PLUS tconstruct:ancient, the
    #   material that only exists for TiC's ancient tools.
    $ancientPool = @()
    foreach ($tier in 0..4) { $ancientPool += $tiers[$tier] }
    $ancientPool += 'tconstruct:ancient'
    for ($i = 0; $i -lt $a.slots; $i++) {
        $mats += [ordered]@{ type = $ancientPool[(Get-Random -Minimum 0 -Maximum $ancientPool.Count)] }
    }
    $matIds = @($mats | ForEach-Object { $_.type })
    $matTag = '{tic_materials:' + (ConvertTo-Json -InputObject $matIds -Compress) + '}'
    $funcs = @([ordered]@{ function='minecraft:set_nbt'; tag=$matTag })
    if ($a.id -eq 'tconstruct:swasher') {
        # Eight equally available fluids are selected when the reward is drawn.
        $swasherFluids = @(
            'minecraft:water', 'minecraft:lava', 'tconstruct:powdered_snow',
            'tconstruct:earth_slime', 'tconstruct:sky_slime', 'tconstruct:ichor',
            'tconstruct:molten_queens_slime', 'tconstruct:molten_netherite'
        )
        for ($j = 0; $j -lt $swasherFluids.Count; $j++) {
            $weight = 1
            $swFuncs = @(
                [ordered]@{ function='minecraft:set_nbt'; tag=$matTag },
                [ordered]@{ function='mantle:set_fluid'; fluid=[ordered]@{ amount=2000; fluid=$swasherFluids[$j] } }
            )
            $entries += [ordered]@{ type='minecraft:item'; name=$a.id; weight=$weight; functions=$swFuncs }
        }
        continue
    }
    $entries += [ordered]@{
        type='minecraft:item'; name=$a.id; weight=8
        functions=$funcs
    }
}
New-LootTable -Name 'ancient' -Entries $entries

New-LootTable -Name 'throwing' -Entries @(
    [ordered]@{ type='minecraft:item'; name='tconstruct:shuriken'; weight=50; functions=@([ordered]@{ function='minecraft:set_count'; count=4 }, [ordered]@{ function='tconstruct:add_tool_data'; materials=@(@{type='tconstruct:random';tier=@{min=0;max=2};material=@{type='mantle:inverted';inverted_type='mantle:tag';tag='tspire:excluded_throwing'}},@{type='tconstruct:random';tier=@{min=0;max=2};material=@{type='mantle:inverted';inverted_type='mantle:tag';tag='tspire:excluded_throwing'}}); damage=0 }) }
    [ordered]@{ type='minecraft:item'; name='tconstruct:throwing_axe'; weight=50; functions=@([ordered]@{ function='minecraft:set_count'; count=4 }, [ordered]@{ function='tconstruct:add_tool_data'; materials=@(@{type='tconstruct:random';tier=@{min=0;max=2};material=@{type='mantle:inverted';inverted_type='mantle:tag';tag='tspire:excluded_throwing'}},@{type='tconstruct:random';tier=@{min=0;max=2};material=@{type='mantle:inverted';inverted_type='mantle:tag';tag='tspire:excluded_throwing'}}); damage=0 }) }
)

# ---------------------------------------------------------------------------
# 7.5) special rewards (v0.6.54)
# ---------------------------------------------------------------------------
# The five existing special rewards remain equal; a fuel tank takes 10%.
# The fuel tank carries lava on floors 1/2 and blazing blood on floor 3.
#     golden apple / splash potion of Instant Health II / potion of Strength /
#     potion of Swiftness / lingering potion of Regeneration.
#   Parts/crystal/gear each lost 0.4 points to pay for it; ancient & throwing untouched.
$specialDefs = @(
    @{ name = 'minecraft:golden_apple';      nbt = $null }
    @{ name = 'minecraft:splash_potion';     nbt = '{Potion:"minecraft:strong_healing"}' }
    @{ name = 'minecraft:potion';            nbt = '{Potion:"minecraft:strength"}' }
    @{ name = 'minecraft:potion';            nbt = '{Potion:"minecraft:swiftness"}' }
    @{ name = 'minecraft:lingering_potion';  nbt = '{Potion:"minecraft:strong_regeneration"}' }
)
foreach ($f in @('f1','f2','f3')) {
    $specialEntries = @()
    foreach ($sd in $specialDefs) {
        $e = [ordered]@{ type = 'minecraft:item'; name = $sd.name; weight = 9 }
        if ($sd.nbt) { $e.functions = @([ordered]@{ function = 'minecraft:set_nbt'; tag = $sd.nbt }) }
        $specialEntries += $e
    }
    $fuel = if ($f -eq 'f3') { 'tconstruct:blazing_blood' } else { 'minecraft:lava' }
    $specialEntries += [ordered]@{
        type='minecraft:item'; name='tconstruct:seared_fuel_tank'; weight=5
        functions=@([ordered]@{ function='minecraft:set_nbt'; tag=('{tank:{FluidName:"' + $fuel + '",Amount:1000}}') })
    }
    New-LootTable -Name ("special_{0}" -f $f) -Entries $specialEntries
    if ($f -eq 'f1') { New-LootTable -Name 'special' -Entries $specialEntries }
}
Write-Host "  special_f1..f3.json  (tank 10%, five existing rewards 18% each)"

# ---------------------------------------------------------------------------
# 8) random reward x2  -- rebalanced in v0.6.26, repair parts dropped in v0.6.43
# ---------------------------------------------------------------------------
# v0.6.43 (player request): the repair-part reward was removed from the battle pool.
# v0.6.44 (player request): crystal -10, parts +4, gear +6; the gear entry now draws
#   from a wrapper table that ALSO includes armour (weapon + head/chest/legs/feet),
#   because the old entry pointed straight at mob_gear/weapon_* (weapons only).
# Weights are written on a 1000 scale so the ratios stay exact as integers:
#   part 294 / crystal 344 / gear 147 / special 203 / ancient 6 / throwing 6 (= 1000)
#   i.e. 29.4% / 34.4% / 14.7% / 20.3% / 0.6% / 0.6% per roll.
# The repair_* loot tables are deleted by this script (nothing uses them any more).
foreach ($f in @('f1','f2','f3')) {
    $entries = @(
        [ordered]@{ type='minecraft:loot_table'; name="tspire:rewards/part_$f";     weight=294 }
        [ordered]@{ type='minecraft:loot_table'; name='tspire:rewards/crystal';     weight=344 }
        [ordered]@{ type='minecraft:loot_table'; name="tspire:rewards/gear_$f";    weight=147 }
        [ordered]@{ type='minecraft:loot_table'; name="tspire:rewards/special_$f";  weight=203 }
        [ordered]@{ type='minecraft:loot_table'; name='tspire:rewards/ancient';     weight=6 }
        [ordered]@{ type='minecraft:loot_table'; name='tspire:rewards/throwing';    weight=6 }
    )
    $obj = [ordered]@{ pools = @([ordered]@{ rolls = 2; entries = $entries }) }
    $json = $obj | ConvertTo-Json -Depth 16
    [System.IO.File]::WriteAllText((Join-Path $outDir ("battle_random_{0}.json" -f $f)), $json, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  battle_random_{0}.json  (6 entries, rolls=2, special 203/1000)" -f $f)
}

Write-Host ("done: {0} reward loot tables" -f (Get-ChildItem -File $outDir -Filter *.json).Count)

# ---------------------------------------------------------------------------
# 6.5) EQUIPMENT-AWARE PART OFFERS -- CONCRETE, VISIBLE CANDIDATES
#      (design doc 3.3, first reward type)
#
# v0.6.22: the three candidates are now PRE-GENERATED CONCRETE ITEMS instead of
# runtime loot-table rolls. Reason (reported in play test): the player could not
# see what the three options were before choosing. A runtime roll cannot be named
# in the chat menu -- the text has to be written long before the roll happens.
#
# For every (tool, floor, variant) we bake ONE concrete triple of parts:
#   slot k = the tool's k-th part (wraps around when the tool has fewer than 3),
#   each slot's material drawn independently from that floor's pool for the
#   part's stat type.
# Then we emit one function per floor which
#   * prints the three clickable candidates WITH real names and materials
#     (when #OFFER_SLOT == 0), and
#   * gives the exact matching item (when #OFFER_SLOT == 1/2/3).
# Each player rolls their own variant (@s tspire_ov), so two players see two
# different triples -- and each triple is derived from THEIR OWN held tool,
# which is what keeps multiplayer correct.
#
# All UI text lives in tools/offer-text.json: this script must stay ASCII-only
# (a non-ASCII byte in a .ps1 breaks parsing, see HANDOFF).
# ---------------------------------------------------------------------------
$lang = Get-Content (Join-Path $tcSource 'assets\tconstruct\lang\zh_cn.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$OT   = Get-Content (Join-Path $PSScriptRoot 'offer-text.json')        -Raw -Encoding UTF8 | ConvertFrom-Json
function Lang { param([string]$Key, [string]$Fallback) if ($lang.$Key) { return $lang.$Key } else { return $Fallback } }
function ItemName { param([string]$Id) $n = ($Id -replace '^tconstruct:', ''); return (Lang ('item.tconstruct.' + $n) $n) }
function MatName { param([string]$Id) $n = ($Id -replace '^tconstruct:', ''); return (Lang ('material.tconstruct.' + $n) $n) }
function JsonStr { param([string]$S) return ($S -replace '\\', '\\' -replace '"', '\"') }

# How many concrete triples per (tool, floor). More = more variety, more lines.
$OFFER_VARIANTS = 4

$toolDefDir = Join-Path $tcSource 'data\tconstruct\tinkering\tool_definitions'
$partByStat = @{}
foreach ($pd in $partDefs) {
    if (-not $partByStat.ContainsKey($pd.stat)) { $partByStat[$pd.stat] = @() }
    $partByStat[$pd.stat] += $pd.item
}
function Get-PartStat { param([string]$Item)
    foreach ($pd in $partDefs) { if ($pd.item -eq $Item) { return $pd.stat } }
    return $null
}

$toolParts   = [ordered]@{}   # tool id -> part item list
Get-ChildItem $toolDefDir -File -Filter *.json | Sort-Object Name | ForEach-Object {
    $j  = Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    $ps = $j.modules | Where-Object { $_.type -eq 'tconstruct:part_stats' }     | Select-Object -First 1
    $ms = $j.modules | Where-Object { $_.type -eq 'tconstruct:material_stats' } | Select-Object -First 1
    $parts = @()
    if ($ps -and @($ps.parts).Count -gt 0) {
        foreach ($e in @($ps.parts)) {
            if ($e -is [string]) {
                $n = $e -replace '^tconstruct:', ''
                if (Get-PartStat $n) { $parts += $n }
            } elseif (@($e.PSObject.Properties.Name) -contains 'item') {
                $n = $e.item -replace '^tconstruct:', ''
                if (Get-PartStat $n) { $parts += $n }
            } elseif (@($e.PSObject.Properties.Name) -contains 'stat') {
                if ($partByStat.ContainsKey($e.stat)) { $parts += $partByStat[$e.stat] }
            }
        }
    } elseif ($ms) {
        foreach ($s in @($ms.stat_types)) {
            $st = $null
            if ($s -is [string]) { $st = $s } elseif ($s -and (@($s.PSObject.Properties.Name) -contains 'stat')) { $st = $s.stat }
            if ($st -and $partByStat.ContainsKey($st)) { $parts += $partByStat[$st] }
        }
    }
    $parts = @($parts | Select-Object -Unique)
    if ($parts.Count -gt 0) { $toolParts['tconstruct:' + $_.BaseName] = $parts }
}
Write-Host ("tools with usable parts: {0}" -f $toolParts.Count)

# Every part item, for the "nothing modifiable in hand" fallback pool.
$allParts = @($partDefs | ForEach-Object { $_.item } | Select-Object -Unique)

# Build one concrete triple for a part list + floor.
function New-OfferPick { param($Parts, [string]$Floor)
    $pick = @()
    for ($slot = 1; $slot -le 3; $slot++) {
        $pi = $Parts[($slot - 1) % $Parts.Count]
        $st = Get-PartStat $pi
        $mats = @(Get-FloorMaterials -Floor $Floor -StatType $st)
        if ($mats.Count -eq 0) { $mats = @('tconstruct:iron') }
        $m  = $mats[(Get-Random -Minimum 0 -Maximum $mats.Count)]
        $pick += [ordered]@{ part = $pi; mat = $m }
    }
    return ,$pick
}

# One tellraw line printing the three clickable candidates (with real names).
function New-OfferMenuLine { param([string]$Cond, [string]$Headline, $Pick, [int]$Slot)
    $c = 'execute ' + $Cond + ' if score #OFFER_SLOT tspire_timer matches 0 run tellraw @s ['
    $c += '{"text":"' + (JsonStr $OT.header) + '","color":"gold"},{"text":"' + (JsonStr $Headline) + '","color":"white"}'
    $pn    = ItemName ('tconstruct:' + $Pick.part)
    $mn    = MatName $Pick.mat
    $label = ($OT.label -f $Slot, $pn, $mn)
    $hover = ($OT.hover -f $pn, $mn)
    $c += ',{"text":"' + (JsonStr $label) + '","color":"aqua"'
    $c += ',"clickEvent":{"action":"run_command","value":"/function tspire:rewards/offer_take_' + ($Slot - 1) + '"}'
    $c += ',"hoverEvent":{"action":"show_text","contents":"' + (JsonStr $hover) + '"}}'
    return ($c + ']')
}

$fnDir = Join-Path $root 'src\main\resources\data\tspire\functions\rewards'
# Kept for historical reference only. The active generator below samples three
# distinct equipment slots and writes the same offer_f* output files.
if ($false) {
foreach ($f in @('f1','f2','f3')) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-rewards.ps1 -- do not edit by hand.")
    [void]$sb.AppendLine("# Three-choose-one part reward -- CONCRETE candidates, printed with their real names.")
    [void]$sb.AppendLine("# Runs AS the player. #OFFER_SLOT 0 = print the menu, 1/2/3 = give that candidate.")
    [void]$sb.AppendLine("# Guarded by @s tspire_ov (which triple this player rolled) and by #SRC.")
    [void]$sb.AppendLine("#")
    [void]$sb.AppendLine("# v0.6.26: the reward is no longer decided by the HELD weapon alone.")
    [void]$sb.AppendLine("# Pass A picks ONE source item in priority order and stores its index in #SRC:")
    [void]$sb.AppendLine("#   1 mainhand  2 OFFHAND  3 chest 102  4 legs 101  5 feet 100  6 head 103")
    [void]$sb.AppendLine("# 0 = no modifiable gear worn or held -> generic material pool fallback.")
    [void]$sb.AppendLine("#")
    [void]$sb.AppendLine("# v0.6.29 IMPORTANT: the MENU pass (OFFER_SLOT 0) also copies #SRC into the")
    [void]$sb.AppendLine("# player's own @s tspire_src. The GIVE pass reads ONLY that stored value, so the")
    [void]$sb.AppendLine("# item handed out is exactly the one the player was shown -- even if they swap")
    [void]$sb.AppendLine("# weapons between opening the menu and clicking (that used to hand out the")
    [void]$sb.AppendLine("# wrong tool's part).")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("# --- Pass A: pick the source item ---------------------------------------")
    [void]$sb.AppendLine("# v0.6.44 player request: a player HOLDING A WEAPON should still be able to")
    [void]$sb.AppendLine("#   roll an armour part, so the strict priority order is replaced by a 50/50 mix:")
    [void]$sb.AppendLine("#   flip one d2 to decide whether this pass looks at the HANDS or the ARMOUR first;")
    [void]$sb.AppendLine("#   if that group has nothing modifiable, it falls through to the other group, and")
    [void]$sb.AppendLine("#   only if BOTH are empty does #SRC stay 0 (generic floor pool).")
    [void]$sb.AppendLine("#   The coin is re-flipped per player because this function runs `as @a`.")
    [void]$sb.AppendLine("scoreboard players set #SRC tspire_timer 0")
    [void]$sb.AppendLine("scoreboard players set #SRC_ARM tspire_timer 0")
    [void]$sb.AppendLine("execute if predicate tspire:roll/d2 run scoreboard players set #SRC_ARM tspire_timer 1")
    [void]$sb.AppendLine("")
    $handSlots  = @(@{ n = 'mainhand'; sel = 'SelectedItem' }, @{ n = 'offhand'; slot = -106 })
    $armorSlots = @(@{ n = 'chest'; slot = 102 }, @{ n = 'legs'; slot = 101 }, @{ n = 'feet'; slot = 100 }, @{ n = 'head'; slot = 103 })
    $srcRounds = @(
        @{ tag = 'round 1 (coin=hands)';   cond = 'if score #SRC_ARM tspire_timer matches 0'; group = $handSlots },
        @{ tag = 'round 1 (coin=armour)';  cond = 'if score #SRC_ARM tspire_timer matches 1'; group = $armorSlots },
        @{ tag = 'round 2 (fallback)';     cond = '';                                        group = $armorSlots },
        @{ tag = 'round 2 (fallback)';     cond = '';                                        group = $handSlots }
    )
    foreach ($rd in $srcRounds) {
        foreach ($srcSlot in $rd.group) {
            [void]$sb.AppendLine(("# -- {0}: priority '{1}' --" -f $rd.tag, $srcSlot.n))
            $toolIdx = 0
            $NO_CAST = @('bowstring','arrow_head','shield_core')
foreach ($tool in $toolParts.Keys) {
                $toolIdx++
                $coin = ''
                if ($rd.cond) { $coin = ' ' + $rd.cond }
                if ($srcSlot.sel) {
                    [void]$sb.AppendLine(("execute if score #SRC tspire_timer matches 0{0} if entity @s[nbt={{{1}:{{id:""{2}""}}}}] run scoreboard players set #SRC tspire_timer {3}" -f $coin, $srcSlot.sel, $tool, $toolIdx))
                } else {
                    [void]$sb.AppendLine(("execute if score #SRC tspire_timer matches 0{0} if entity @s[nbt={{Inventory:[{{Slot:{1}b,id:""{2}""}}]}}] run scoreboard players set #SRC tspire_timer {3}" -f $coin, $srcSlot.slot, $tool, $toolIdx))
                }
            }
        }
    }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("# the MENU pass records the source on the player; the give pass only reads it")
    [void]$sb.AppendLine("execute if score #OFFER_SLOT tspire_timer matches 0 run scoreboard players operation @s tspire_src = #SRC tspire_timer")
    [void]$sb.AppendLine("")

    $blocks = 0
    $toolIdx = 0
    $NO_CAST = @('bowstring','arrow_head','shield_core')
foreach ($tool in $toolParts.Keys) {
        $toolIdx++
        $tn    = ($tool -replace '^tconstruct:', '')
        $tname = ItemName $tool
        $parts = @($toolParts[$tool])
        for ($v = 1; $v -le $OFFER_VARIANTS; $v++) {
            $pick = New-OfferPick -Parts $parts -Floor $f
            $condMenu = 'if score @s tspire_ov matches ' + $v + ' if score #SRC tspire_timer matches ' + $toolIdx
            $condGive = 'if score @s tspire_ov matches ' + $v + ' if score @s tspire_src matches ' + $toolIdx
            [void]$sb.AppendLine(("# ---- {0} / {1} / variant {2} ----" -f $tn, $f, $v))
            [void]$sb.AppendLine((New-OfferMenuLine -Cond $condMenu -Headline ($OT.headlineTool -f $tname) -Pick $pick))
            for ($slot = 1; $slot -le 3; $slot++) {
                $nbt = 'tconstruct:' + $pick[$slot - 1].part + '{Material:"' + $pick[$slot - 1].mat + '"}'
                [void]$sb.AppendLine(('execute ' + $condGive + ' if score #OFFER_SLOT tspire_timer matches ' + $slot + ' run give @s ' + $nbt))
            }
            $blocks++
        }
    }

    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("# --- fallback: no modifiable gear worn or held -> generic floor pool ---")
    for ($v = 1; $v -le $OFFER_VARIANTS; $v++) {
        $pick = New-OfferPick -Parts $allParts -Floor $f
        $condMenu = 'if score @s tspire_ov matches ' + $v + ' if score #SRC tspire_timer matches 0'
        $condGive = 'if score @s tspire_ov matches ' + $v + ' if score @s tspire_src matches 0'
        [void]$sb.AppendLine(("# ---- generic / {0} / variant {1} ----" -f $f, $v))
        [void]$sb.AppendLine((New-OfferMenuLine -Cond $condMenu -Headline $OT.headlineGeneric -Pick $pick))
        for ($slot = 1; $slot -le 3; $slot++) {
            $nbt = 'tconstruct:' + $pick[$slot - 1].part + '{Material:"' + $pick[$slot - 1].mat + '"}'
            [void]$sb.AppendLine(('execute ' + $condGive + ' if score #OFFER_SLOT tspire_timer matches ' + $slot + ' run give @s ' + $nbt))
        }
        $blocks++
    }

    [System.IO.File]::WriteAllText((Join-Path $fnDir ("offer_{0}.mcfunction" -f $f)), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  offer_{0}.mcfunction  ({1} tools + 1 generic = {2} blocks)" -f $f, $toolParts.Count, $blocks)
}
}

# Physical slots: main hand, off hand, chest, legs, feet, head. Each is used
# at most once per offer. A random rotation changes which slots get priority.
$offerSlots = @(
    @{ id = 1; sel = 'SelectedItem' },
    @{ id = 2; slot = -106 },
    @{ id = 3; slot = 102 },
    @{ id = 4; slot = 101 },
    @{ id = 5; slot = 100 },
    @{ id = 6; slot = 103 }
)
foreach ($srcSlot in $offerSlots) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-rewards.ps1")
    $toolIdx = 0
    foreach ($tool in $toolParts.Keys) {
        $toolIdx++
        if ($srcSlot.sel) {
            $check = ('if entity @s[nbt={{{0}:{{id:"{1}"}}}}]' -f $srcSlot.sel, $tool)
        } else {
            $check = ('if entity @s[nbt={{Inventory:[{{Slot:{0}b,id:"{1}"}}]}}]' -f $srcSlot.slot, $tool)
        }
        [void]$sb.AppendLine(('execute if score #SRC tspire_timer matches 0 if score #OFFER_USED{0} tspire_timer matches 0 {1} run scoreboard players set #SRC tspire_timer {2}' -f $srcSlot.id, $check, $toolIdx))
    }
    [void]$sb.AppendLine(('execute if score #SRC tspire_timer matches 1.. run scoreboard players set #OFFER_USED{0} tspire_timer 1' -f $srcSlot.id))
    [System.IO.File]::WriteAllText((Join-Path $fnDir ("offer_source_{0}.mcfunction" -f $srcSlot.id)), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# AUTO-GENERATED by tools/gen-rewards.ps1')
[void]$sb.AppendLine('scoreboard players set #SRC tspire_timer 0')
for ($rot = 1; $rot -le 6; $rot++) {
    for ($offset = 0; $offset -lt 6; $offset++) {
        $slotId = (($rot + $offset - 1) % 6) + 1
        [void]$sb.AppendLine(('execute if score #OFFER_ROT tspire_timer matches {0} if score #SRC tspire_timer matches 0 run function tspire:rewards/offer_source_{1}' -f $rot, $slotId))
    }
}
[System.IO.File]::WriteAllText((Join-Path $fnDir 'offer_source_pick.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# AUTO-GENERATED by tools/gen-rewards.ps1')
[void]$sb.AppendLine('# Reuse an equipped slot only when every eligible slot was already used.')
for ($i = 1; $i -le 6; $i++) { [void]$sb.AppendLine(('scoreboard players set #OFFER_USED{0} tspire_timer 0' -f $i)) }
[void]$sb.AppendLine('function tspire:rewards/offer_source_pick')
[System.IO.File]::WriteAllText((Join-Path $fnDir 'offer_source_pick_reuse.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
foreach ($group in @('hands','armor')) {
    $allowed = if ($group -eq 'hands') { @(1,2) } else { @(3,4,5,6) }
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine('# AUTO-GENERATED by tools/gen-rewards.ps1')
    [void]$sb.AppendLine('scoreboard players set #SRC tspire_timer 0')
    for ($rot = 1; $rot -le 6; $rot++) {
        for ($offset = 0; $offset -lt 6; $offset++) {
            $slotId = (($rot + $offset - 1) % 6) + 1
            if ($allowed -contains $slotId) {
                [void]$sb.AppendLine(('execute if score #OFFER_ROT tspire_timer matches {0} if score #SRC tspire_timer matches 0 run function tspire:rewards/offer_source_{1}' -f $rot, $slotId))
            }
        }
    }
    [System.IO.File]::WriteAllText((Join-Path $fnDir ("offer_source_pick_{0}.mcfunction" -f $group)), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# AUTO-GENERATED by tools/gen-rewards.ps1')
[void]$sb.AppendLine('function tspire:util/roll_d6')
[void]$sb.AppendLine('scoreboard players operation #OFFER_ROT tspire_timer = #ROLL tspire_timer')
[void]$sb.AppendLine('scoreboard players set #OFFER_FIRST_ARM tspire_timer 0')
[void]$sb.AppendLine('execute if predicate tspire:roll/d2 run scoreboard players set #OFFER_FIRST_ARM tspire_timer 1')
for ($i = 1; $i -le 6; $i++) { [void]$sb.AppendLine(('scoreboard players set #OFFER_USED{0} tspire_timer 0' -f $i)) }
for ($i = 1; $i -le 3; $i++) {
    if ($i -eq 1) {
        [void]$sb.AppendLine('execute if score #OFFER_FIRST_ARM tspire_timer matches 0 run function tspire:rewards/offer_source_pick_hands')
        [void]$sb.AppendLine('execute if score #OFFER_FIRST_ARM tspire_timer matches 1 run function tspire:rewards/offer_source_pick_armor')
        [void]$sb.AppendLine('execute if score #SRC tspire_timer matches 0 run function tspire:rewards/offer_source_pick')
    } elseif ($i -eq 2) {
        [void]$sb.AppendLine('execute if score #OFFER_FIRST_ARM tspire_timer matches 0 run function tspire:rewards/offer_source_pick_armor')
        [void]$sb.AppendLine('execute if score #OFFER_FIRST_ARM tspire_timer matches 1 run function tspire:rewards/offer_source_pick_hands')
        [void]$sb.AppendLine('execute if score #SRC tspire_timer matches 0 run function tspire:rewards/offer_source_pick')
    } else {
        [void]$sb.AppendLine('function tspire:rewards/offer_source_pick')
    }
    [void]$sb.AppendLine('execute if score #SRC tspire_timer matches 0 run function tspire:rewards/offer_source_pick_reuse')
    [void]$sb.AppendLine(('scoreboard players operation #SRC{0} tspire_timer = #SRC tspire_timer' -f $i))
}
[void]$sb.AppendLine('scoreboard players set #C64 tspire_timer 64')
[void]$sb.AppendLine('scoreboard players set #C4096 tspire_timer 4096')
[void]$sb.AppendLine('scoreboard players operation @s tspire_src = #SRC1 tspire_timer')
[void]$sb.AppendLine('scoreboard players operation #TMP tspire_timer = #SRC2 tspire_timer')
[void]$sb.AppendLine('scoreboard players operation #TMP tspire_timer *= #C64 tspire_timer')
[void]$sb.AppendLine('scoreboard players operation @s tspire_src += #TMP tspire_timer')
[void]$sb.AppendLine('scoreboard players operation #TMP tspire_timer = #SRC3 tspire_timer')
[void]$sb.AppendLine('scoreboard players operation #TMP tspire_timer *= #C4096 tspire_timer')
[void]$sb.AppendLine('scoreboard players operation @s tspire_src += #TMP tspire_timer')
[System.IO.File]::WriteAllText((Join-Path $fnDir 'offer_sources.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))

foreach ($f in @('f1','f2','f3')) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine('# AUTO-GENERATED by tools/gen-rewards.ps1')
    [void]$sb.AppendLine('# Three candidates come from up to three different equipped items.')
    [void]$sb.AppendLine('# Source ids are packed in the player score tspire_src (base 64).')
    [void]$sb.AppendLine('scoreboard players set #C64 tspire_timer 64')
    [void]$sb.AppendLine('scoreboard players set #C4096 tspire_timer 4096')
    [void]$sb.AppendLine('scoreboard players operation #SRC1 tspire_timer = @s tspire_src')
    [void]$sb.AppendLine('scoreboard players operation #SRC1 tspire_timer %= #C64 tspire_timer')
    [void]$sb.AppendLine('scoreboard players operation #SRC2 tspire_timer = @s tspire_src')
    [void]$sb.AppendLine('scoreboard players operation #SRC2 tspire_timer /= #C64 tspire_timer')
    [void]$sb.AppendLine('scoreboard players operation #SRC2 tspire_timer %= #C64 tspire_timer')
    [void]$sb.AppendLine('scoreboard players operation #SRC3 tspire_timer = @s tspire_src')
    [void]$sb.AppendLine('scoreboard players operation #SRC3 tspire_timer /= #C4096 tspire_timer')
    for ($slot = 1; $slot -le 3; $slot++) {
        $toolIdx = 0
        foreach ($tool in $toolParts.Keys) {
            $toolIdx++
            $tname = ItemName $tool
            $parts = @($toolParts[$tool])
            for ($v = 1; $v -le $OFFER_VARIANTS; $v++) {
                $pick = New-OfferPick -Parts $parts -Floor $f
                $cond = ('if score @s tspire_ov matches {0} if score #SRC{1} tspire_timer matches {2}' -f $v, $slot, $toolIdx)
                [void]$sb.AppendLine((New-OfferMenuLine -Cond $cond -Headline ($OT.headlineTool -f $tname) -Pick $pick[$slot - 1] -Slot $slot))
                $nbt = 'tconstruct:' + $pick[$slot - 1].part + '{Material:"' + $pick[$slot - 1].mat + '"}'
                [void]$sb.AppendLine(('execute {0} if score #OFFER_SLOT tspire_timer matches {1} run give @s {2}' -f $cond, $slot, $nbt))
            }
        }
        for ($v = 1; $v -le $OFFER_VARIANTS; $v++) {
            $pick = New-OfferPick -Parts $allParts -Floor $f
            $cond = ('if score @s tspire_ov matches {0} if score #SRC{1} tspire_timer matches 0' -f $v, $slot)
            [void]$sb.AppendLine((New-OfferMenuLine -Cond $cond -Headline $OT.headlineGeneric -Pick $pick[$slot - 1] -Slot $slot))
            $nbt = 'tconstruct:' + $pick[$slot - 1].part + '{Material:"' + $pick[$slot - 1].mat + '"}'
            [void]$sb.AppendLine(('execute {0} if score #OFFER_SLOT tspire_timer matches {1} run give @s {2}' -f $cond, $slot, $nbt))
        }
    }
    [System.IO.File]::WriteAllText((Join-Path $fnDir ("offer_{0}.mcfunction" -f $f)), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  offer_{0}.mcfunction: three independent equipment sources" -f $f)
}

# ---- variant roller: each player gets their own triple -------------------------
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-rewards.ps1 -- do not edit by hand.")
[void]$sb.AppendLine("# Roll THIS player's own candidate triple index (1..$OFFER_VARIANTS) into @s tspire_ov.")
[void]$sb.AppendLine("# Rolled per player, so party members see different candidates.")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("scoreboard players set @s tspire_ov 0")
$d = $OFFER_VARIANTS
for ($v = $OFFER_VARIANTS; $v -ge 1; $v--) {
    [void]$sb.AppendLine(("execute if score @s tspire_ov matches 0 if predicate tspire:roll/d{0} run scoreboard players set @s tspire_ov {1}" -f $d, $v))
    $d--
}
[void]$sb.AppendLine("execute if score @s tspire_ov matches 0 run scoreboard players set @s tspire_ov 1")
[System.IO.File]::WriteAllText((Join-Path $fnDir 'offer_variant.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "  offer_variant.mcfunction"

# ---------------------------------------------------------------------------
# 6.6) ARTISAN FUSION -- two parts in hand -> one part of the NEXT floor's pool
# ---------------------------------------------------------------------------
# v0.6.35: hold a material part in the main hand and another in the off hand,
# spend 30 gold (once per artisan node) and get the SAME part type back.
# v0.7.10 (player spec, supersedes the v0.7.9 "strictly higher" rule):
#   * the two parts may be DIFFERENT tiers -- fusion is never refused for that;
#   * same tier      -> one tier higher   (two tier 2 -> tier 3)
#   * different tier -> the HIGHER of the two (tier 1 + tier 2 -> tier 2)
#   * tier 4 + tier 4 -> tier 4 (there is nothing above it)
#   So the output tier is: same ? min(higher+1, 4) : higher.
#   Targets are MATERIAL TIERS (tables artisan/fuse/<part>_t1..t4), not floors.
$fuseOut = Join-Path $root 'src/main/resources/data/tspire/loot_tables/artisan/fuse'
New-Item -ItemType Directory -Force -Path $fuseOut | Out-Null
Get-ChildItem -File $fuseOut -Filter *.json -ErrorAction SilentlyContinue | Remove-Item -Force

$fuseFn = Join-Path $root 'src/main/resources/data/tspire/functions/artisan'
$fuseParts = @($partDefs | ForEach-Object { $_.item } | Select-Object -Unique)
foreach ($pi in $fuseParts) {
    $st = Get-PartStat $pi
    foreach ($tf in 1..4) {
        $mats = @(Get-TierMaterials -Tier $tf -StatType $st)
        if ($mats.Count -eq 0) { continue }
        $entries = @()
        foreach ($m in $mats) {
            $entries += [ordered]@{
                type      = 'minecraft:item'
                name      = ('tconstruct:' + $pi)
                weight    = 1
                functions = @([ordered]@{ function = 'minecraft:set_nbt'; tag = ('{Material:"' + $m + '"}') })
            }
        }
        $obj  = [ordered]@{ pools = @([ordered]@{ rolls = 1; entries = $entries }) }
        $json = $obj | ConvertTo-Json -Depth 16
        [System.IO.File]::WriteAllText((Join-Path $fuseOut ("{0}_t{1}.json" -f $pi, $tf)), $json, (New-Object System.Text.UTF8Encoding($false)))
    }
}
Write-Host ("  artisan/fuse: {0} tables" -f ((Get-ChildItem -File $fuseOut -Filter *.json).Count))

# --- reader: #PIDX = main-hand part index, #PIDX2 = off-hand part index (0 = not a part)
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-rewards.ps1 -- do not edit by hand.")
[void]$sb.AppendLine("# Read the MAIN hand into #PIDX and the OFF hand into #PIDX2 (1..N part index, 0 = not a part).")
[void]$sb.AppendLine("# Runs AS the player.")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("scoreboard players set #PIDX tspire_timer 0")
$i = 0
foreach ($pi in $fuseParts) {
    $i++
    [void]$sb.AppendLine(("execute if entity @s[nbt={{SelectedItem:{{id:""tconstruct:{0}""}}}}] run scoreboard players set #PIDX tspire_timer {1}" -f $pi, $i))
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("scoreboard players set #PIDX2 tspire_timer 0")
$i = 0
foreach ($pi in $fuseParts) {
    $i++
    [void]$sb.AppendLine(("execute if entity @s[nbt={{Inventory:[{{Slot:-106b,id:""tconstruct:{0}""}}]}}] run scoreboard players set #PIDX2 tspire_timer {1}" -f $pi, $i))
}
[System.IO.File]::WriteAllText((Join-Path $fuseFn 'fuse_read.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))

# --- v0.7.5 (todo #5): the two parts must be the SAME TIER.
#   The player asked for "two parts of the same tier -> one part of the next tier".
#   Commands cannot compare two strings, so we tag each tier: every material writes its
#   tier into #FUSE_MT (main hand) or #FUSE_OT (off hand) by matching the literal
#   `Material:"tconstruct:<id>"` tag, then a per-tier equality test sets #FUSE_SAME.
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-rewards.ps1 -- do not edit by hand.")
[void]$sb.AppendLine("# #FUSE_SAME = 1 when both held parts have materials of the SAME tier.")
[void]$sb.AppendLine("# v0.7.9: #FUSE_T = target MATERIAL TIER = input tier + 1 (0 = already highest).")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("scoreboard players set #FUSE_MT tspire_timer -1")
[void]$sb.AppendLine("scoreboard players set #FUSE_OT tspire_timer -2")
[void]$sb.AppendLine("scoreboard players set #FUSE_SAME tspire_timer 0")
foreach ($tv in 0..4) {
    foreach ($mt in $tiers[$tv]) {
        [void]$sb.AppendLine(('execute if entity @s[nbt={{SelectedItem:{{tag:{{Material:"{0}"}}}}}}] run scoreboard players set #FUSE_MT tspire_timer {1}' -f $mt, $tv))
        [void]$sb.AppendLine(('execute if entity @s[nbt={{Inventory:[{{Slot:-106b,tag:{{Material:"{0}"}}}}]}}] run scoreboard players set #FUSE_OT tspire_timer {1}' -f $mt, $tv))
    }
}
foreach ($tv in @(0,1,2,3,4)) {
    [void]$sb.AppendLine(("execute if score #FUSE_MT tspire_timer matches {0} if score #FUSE_OT tspire_timer matches {0} run scoreboard players set #FUSE_SAME tspire_timer 1" -f $tv))
}
# v0.7.10: #FUSE_T = the output MATERIAL TIER.
#   #FUSE_HI = max(input tiers); then same tier bumps it by one (capped at 4),
#   while different tiers keep it (no upgrade). Commands cannot compare two
#   scores, so the max is built from per-tier equality tests.
[void]$sb.AppendLine("# #FUSE_HI = max(#FUSE_MT, #FUSE_OT); #FUSE_T = output material tier.")
[void]$sb.AppendLine("scoreboard players set #FUSE_HI tspire_timer -1")
foreach ($tv in 0..4) {
    [void]$sb.AppendLine(("execute if score #FUSE_MT tspire_timer matches {0} run scoreboard players set #FUSE_HI tspire_timer {0}" -f $tv))
}
foreach ($tv in 1..4) {
    [void]$sb.AppendLine(("execute if score #FUSE_OT tspire_timer matches {0} if score #FUSE_HI tspire_timer matches ..{1} run scoreboard players set #FUSE_HI tspire_timer {0}" -f $tv, ($tv - 1)))
}
# same tier -> one higher (tier 4 caps at 4); different tier -> keep the higher one
foreach ($tv in 0..3) {
    [void]$sb.AppendLine(("execute if score #FUSE_SAME tspire_timer matches 1 if score #FUSE_HI tspire_timer matches {0} run scoreboard players set #FUSE_T tspire_timer {1}" -f $tv, ($tv + 1)))
}
[void]$sb.AppendLine("execute if score #FUSE_SAME tspire_timer matches 1 if score #FUSE_HI tspire_timer matches 4 run scoreboard players set #FUSE_T tspire_timer 4")
foreach ($tv in 1..4) {
    [void]$sb.AppendLine(("execute if score #FUSE_SAME tspire_timer matches 0 if score #FUSE_HI tspire_timer matches {0} run scoreboard players set #FUSE_T tspire_timer {0}" -f $tv))
}
# LOUD failure instead of shipping an empty table (an empty one would make EVERY fusion fail).
$tierLines = 0
foreach ($tv in 0..4) { $tierLines += @($tiers[$tv]).Count }
if ($tierLines -eq 0) { throw "fuse_tier: no materials in `$tiers -- refusing to write an empty tier table" }
Write-Host ("  artisan/fuse_tier.mcfunction  ({0} materials)" -f $tierLines)
[System.IO.File]::WriteAllText((Join-Path $fuseFn 'fuse_tier.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))

# --- availability: does this part have a pool on the target floor?
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-rewards.ps1 -- do not edit by hand.")
[void]$sb.AppendLine("# #FUSE_OK = 1 when #PIDX (part) has materials at #FUSE_T (target material tier).")
[void]$sb.AppendLine("")
$i = 0
foreach ($pi in $fuseParts) {
    $i++
    [void]$sb.AppendLine(("execute if score #PIDX tspire_timer matches {0} run scoreboard players set #FUSE_OK tspire_timer 0" -f $i))
    foreach ($tf in 1..4) {
        $mats = @(Get-TierMaterials -Tier $tf -StatType (Get-PartStat $pi))
        if ($mats.Count -eq 0) { continue }
        [void]$sb.AppendLine(("execute if score #PIDX tspire_timer matches {0} if score #FUSE_T tspire_timer matches {1} run scoreboard players set #FUSE_OK tspire_timer 1" -f $i, $tf))
    }
}
[System.IO.File]::WriteAllText((Join-Path $fuseFn 'fuse_check.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))

# --- giver
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-rewards.ps1 -- do not edit by hand.")
[void]$sb.AppendLine("# Give the fused part: #PIDX chooses the part type, #FUSE_T the target material tier.")
[void]$sb.AppendLine("")
$i = 0
foreach ($pi in $fuseParts) {
    $i++
    foreach ($tf in 1..4) {
        $mats = @(Get-TierMaterials -Tier $tf -StatType (Get-PartStat $pi))
        if ($mats.Count -eq 0) { continue }
        [void]$sb.AppendLine(("execute if score #PIDX tspire_timer matches {0} if score #FUSE_T tspire_timer matches {1} run loot give @s loot tspire:artisan/fuse/{2}_t{3}" -f $i, $tf, $pi, $tf))
    }
}
[System.IO.File]::WriteAllText((Join-Path $fuseFn 'fuse_give.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "  artisan/fuse_read + fuse_check + fuse_give"


# ---------------------------------------------------------------------------
# 9) artisan/put_cast -- put a gold cast in the Part Builder
# ---------------------------------------------------------------------------
# The Part Builder is an ISingleStackContainer: exactly ONE slot, holding the
# pattern / cast that decides which part shape gets made. Gold casts are
# reusable (tag tconstruct:patterns/reusable) and need no NBT, so we drop in
# the cast matching whatever tool the player is holding.
# map/enter_artisan only calls this when the slot is still empty.
$castDir = Join-Path $root 'src\main\resources\data\tspire\functions\artisan'
New-Item -ItemType Directory -Force -Path $castDir | Out-Null
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-rewards.ps1 -- do not edit by hand.")
[void]$sb.AppendLine("# Runs AT the Part Builder. Puts a gold cast for the held tool's main part")
[void]$sb.AppendLine("# into its single slot. Gold casts are reusable, so this never wears out.")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("# default: a sword blade cast")
[void]$sb.AppendLine("item replace block ~ ~ ~ container.0 with tconstruct:small_blade_cast")
$NO_CAST = @('bowstring','arrow_head','shield_core')
foreach ($tool in $toolParts.Keys) {
    $part = $toolParts[$tool][0]
    # v0.7.19: some parts have NO cast item in TiC (bowstring / arrow_head / shield_core).
    #   Emitting e.g. tconstruct:shield_core_cast made the WHOLE put_cast function fail to
    #   load ("unknown item id"), which broke the artisan part builder.
    if ($NO_CAST -contains $part) { continue }
    [void]$sb.AppendLine(("execute if entity @s[nbt={{SelectedItem:{{id:""{0}""}}}}] run item replace block ~ ~ ~ container.0 with tconstruct:{1}_cast" -f $tool, $part))
}
[System.IO.File]::WriteAllText((Join-Path $castDir 'put_cast.mcfunction'), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host ("  artisan/put_cast.mcfunction  ({0} tools)" -f $toolParts.Count)
