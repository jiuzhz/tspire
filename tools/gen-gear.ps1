# Generate tinkers-spire gear loot tables and equip functions.
#
# Emits one loot table per (slot, floor). Parts are rolled with
# tconstruct:add_tool_data + {"type":"tconstruct:random","tier":{min,max}}.
#
# Why a RANGE and not a single tier:
#   A single tier is often too narrow to be visible. Tier 0 only holds
#   feather/leather/string/wood, and among those only WOOD can be a tool head,
#   so every tier-0 tool comes out wooden. Ranges follow the design doc's
#   per-floor material pools (section 4.2):
#       floor 1 -> tier 0..2
#       floor 2 -> tier 2..3
#       floor 3 -> tier 3..4
#   Range form is proven by Tinkers' own plate_shield.json, which uses
#   "tier": { "max": 2, "min": 1 }.
#
# IMPORTANT: "slots" must match the tool definition exactly. Extra materials
# beyond the tool's slot count are SILENTLY SKIPPED. Slot counts come from
# docs/PARTS.md (extracted from tool_definitions/*.json).
#
# NOTE: keep this file pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI).

# ---------------------------------------------------------------------------
# TUNABLE PARAMETERS (edit the arrays below, then re-run this script)
#   $floors  -- which floors exist and the material tier range of each
#   $weapons -- tinker weapons mobs may spawn with, plus their slot counts
#   $armor   -- armor pieces and their slot counts
#   $mcSlots -- tinker part slot -> minecraft equipment slot
# ---------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$resDir = Join-Path $root 'src\main\resources'
$outDir = Join-Path $resDir 'data\tspire\loot_tables\mob_gear'
$fnDir  = Join-Path $resDir 'data\tspire\functions\mobs'

# --- per-floor material tier range (design doc section 4.2) ---
#   min/max = ARMOUR material range; wmin/wmax = WEAPON material range.
#   v0.7.21 (player request): "lower every mob's WEAPON material pool by one tier, not the
#   armour" -> the weapon range is one tier below the armour range on every floor.
#   NOTE: this only changes what a mob CARRIES (looks / potential drops). The probe proved
#   the held tool adds no attack damage to a mob (see doc 7.10), so this is NOT a damage nerf.
$floors = @(
    @{ id = 'f1'; min = 0; max = 2; wmin = 0; wmax = 1; label = 'floor 1 (armour 0-2, weapon 0-1)' },
    @{ id = 'f2'; min = 2; max = 3; wmin = 1; wmax = 2; label = 'floor 2 (armour 2-3, weapon 1-2)' },
    @{ id = 'f3'; min = 3; max = 4; wmin = 2; wmax = 3; label = 'floor 3 (armour 3-4, weapon 2-3)' }
)

# --- mainhand weapons (id, slot count, weight) ---
$weapons = @(
    @{ id = 'tconstruct:sword';        slots = 3; w = 20 },
    @{ id = 'tconstruct:dagger';       slots = 2; w = 15 },
    @{ id = 'tconstruct:cleaver';      slots = 4; w = 10 },
    @{ id = 'tconstruct:scythe';       slots = 4; w = 10 },
    @{ id = 'tconstruct:broad_axe';    slots = 4; w = 10 },
    @{ id = 'tconstruct:crossbow';     slots = 3; w = 10 },
    @{ id = 'tconstruct:longbow';      slots = 4; w = 10 },
    @{ id = 'tconstruct:javelin';      slots = 4; w = 8 },
    # v0.7.21: the shield is an ARMOUR-group tool, so it must use the armour material
    #   exclusion list (tspire:excluded_armor) -- otherwise it can roll tconstruct:chorus /
    #   enderslime_vine, which is the "chorus shield still on mobs" the player reported.
    @{ id = 'tconstruct:plate_shield'; slots = 2; w = 7; mat = 'tspire:excluded_armor' }
)

$armor = [ordered]@{
    head  = @(
        @{ id = 'tconstruct:plate_helmet';         slots = 2; w = 50 },
        @{ id = 'tconstruct:travelers_helmet';     slots = 2; w = 50 }
    )
    chest = @(
        @{ id = 'tconstruct:plate_chestplate';     slots = 2; w = 50 },
        @{ id = 'tconstruct:travelers_chestplate'; slots = 2; w = 50 }
    )
    legs  = @(
        @{ id = 'tconstruct:plate_leggings';       slots = 2; w = 50 },
        @{ id = 'tconstruct:travelers_leggings';   slots = 2; w = 50 }
    )
    feet  = @(
        @{ id = 'tconstruct:plate_boots';          slots = 2; w = 50 },
        @{ id = 'tconstruct:travelers_boots';      slots = 2; w = 50 }
    )
}

$mcSlots = [ordered]@{
    'weapon.mainhand' = 'weapon'
    'armor.head'      = 'head'
    'armor.chest'     = 'chest'
    'armor.legs'      = 'legs'
    'armor.feet'      = 'feet'
}

# v0.7.15: every JAVELIN handed to a player gets Returning (level 1 = the ABILITY form).
#   It used to be level 3, but a level-3 returning needs 1 ability slot AND 2 upgrade slots;
#   a javelin cannot pay that, so TiC silently DROPPED the modifier -- player saves showed
#   javelins with only their material traits and no returning at all. Level 1 needs just the
#   single ability slot every javelin has, so it actually sticks.
# v0.7.5: every JAVELIN handed to a player gets Returning (tconstruct:returning,
#   a multilevel ability: level 1 = ability slot, 2-4 = upgrade slots).
#   The starter already did this (tools/gen-starter.ps1 Mod-Nbt), but the reward /
#   chest path uses THESE tables (mob_gear/weapon_f*), so a javelin from a battle
#   reward came back without the modifier -- the player reported exactly that.
function Get-ModNbt { param([string]$ItemId)
    if ($ItemId -match 'javelin') { return ',tic_modifiers:[{name:"tconstruct:returning",level:1}]' }
    if ($ItemId -match 'longbow|crossbow|shortbow|ballista') { return ',' }
    return ''
}

function New-Entry {
    param([string]$ItemId, [int]$Slots, [int]$Weight, [int]$Min, [int]$Max, [string]$MatTag, [int]$Count = 1)
    # v0.7.11: armour slots must also exclude the two materials that grant TiC's
    #   enderclearance trait on armour-group stats: chorus and enderslime_vine.
    if (-not $MatTag) { $MatTag = 'tspire:compat_excluded' }
    $mats = @()
    for ($i = 0; $i -lt $Slots; $i++) {
        # "material" excludes the compat / integration materials tagged in
        # tspire:compat_excluded. Syntax copied from Tinkers' own
        # data/tconstruct/mantle/loot_injectors/spawn_bonus_chest.json:
        #   {"type":"mantle:inverted","inverted_type":"mantle:tag","tag":"..."}
        # (tconstruct:and / tconstruct:tag / tconstruct:invert are NOT valid
        #  MaterialPredicate loaders -- only the mantle:* wrappers are.)
        $mats += [ordered]@{
            type = 'tconstruct:random'
            tier = [ordered]@{ min = $Min; max = $Max }
            material = [ordered]@{
                type          = 'mantle:inverted'
                inverted_type = 'mantle:tag'
                tag           = $MatTag
            }
        }
    }
    # v0.6.26: bows/crossbows handed to a PLAYER (mob_gear/weapon_* is also used as a
    # battle/chest reward) must carry the "self-contained quiver" ability, as the
    # design doc requires. Added as a second item function so the tool data stays
    # untouched. run/give_kit also hands out arrows, which bulk_quiver uses first.
    $funcs = @(
        [ordered]@{
            function  = 'tconstruct:add_tool_data'
            materials = $mats
            damage    = 0
        }
    )
    if ($Count -gt 1) { $funcs += [ordered]@{ function = 'minecraft:set_count'; count = $Count } }
    if ($ItemId -match 'longbow|crossbow|shortbow|ballista') {
        $funcs += [ordered]@{
            function = 'minecraft:set_nbt'
            tag      = '{}'
        }
    }
    # v0.7.5: a JAVELIN handed to a player gets Returning III (tconstruct:returning is a
    #   multilevel ability: level 1 costs an ability slot, levels 2-4 cost upgrade slots).
    #   The starter already added it (gen-starter.ps1 Mod-Nbt), but rewards / chests use
    #   THESE tables -- so a javelin from a reward came back without the modifier.
    if ($ItemId -match 'javelin') {
        $funcs += [ordered]@{
            function = 'minecraft:set_nbt'
            tag      = '{tic_modifiers:[{name:"tconstruct:returning",level:1}]}'
        }
    }
    return [ordered]@{
        type      = 'minecraft:item'
        name      = $ItemId
        weight    = $Weight
        functions = $funcs
    }
}

function Write-Table {
    param([string]$Name, $Entries)
    $obj = [ordered]@{
        pools = @([ordered]@{ rolls = 1; entries = $Entries })
    }
    $json = $obj | ConvertTo-Json -Depth 14
    $path = Join-Path $outDir "$Name.json"
    [System.IO.File]::WriteAllText($path, $json, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  {0}.json  ({1} entries)" -f $Name, $Entries.Count)
}

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
New-Item -ItemType Directory -Force -Path $fnDir  | Out-Null
Write-Host "generating gear loot tables -> $outDir"

foreach ($f in $floors) {
    $entries = @()
    foreach ($wp in $weapons) { $entries += (New-Entry -ItemId $wp.id -Slots $wp.slots -Weight $wp.w -Min $f.min -Max $f.max -MatTag $wp.mat -Count $(if ($wp.id -eq 'tconstruct:dagger') { 2 } else { 1 })) }
    Write-Table -Name ("weapon_{0}" -f $f.id) -Entries $entries

    # v0.7.7 (player request): MOBS no longer carry the cleaver or the broad axe.
    #   weapon_<f> stays as-is because the battle-reward pool reuses it (players can
    #   still get those two), so mobs get their own filtered table instead.
    $mobEntries = @()
    foreach ($wp in $weapons) {
        if ($wp.id -match 'cleaver|broad_axe') { continue }
        $mobEntries += (New-Entry -ItemId $wp.id -Slots $wp.slots -Weight $wp.w -Min $f.wmin -Max $f.wmax -MatTag $wp.mat)
    }
    if ($mobEntries.Count -eq 0) { throw 'mob weapon table would be empty' }
    Write-Table -Name ("mob_weapon_{0}" -f $f.id) -Entries $mobEntries
}
foreach ($slot in $armor.Keys) {
    foreach ($f in $floors) {
        $entries = @()
        foreach ($a in $armor[$slot]) { $entries += (New-Entry -ItemId $a.id -Slots $a.slots -Weight $a.w -Min $f.min -Max $f.max -MatTag 'tspire:excluded_armor') }
        Write-Table -Name ("{0}_{1}" -f $slot, $f.id) -Entries $entries
    }
}

# Boss-only armour tables. Regular mobs keep the plate/travelers mix above.
# The molten lord's assigned chestplate is preserved by the equip function below.
foreach ($f in $floors) {
    $bossMin = if ($f.id -eq 'f3') { 3 } else { $f.min }
    $bossMax = if ($f.id -eq 'f3') { 3 } else { $f.max }
    foreach ($slot in $armor.Keys) {
        $plate = @($armor[$slot] | Where-Object { $_.id -like 'tconstruct:plate_*' })
        if ($plate.Count -ne 1) { throw ("expected one plate armour item for " + $slot) }
        $entries = @(New-Entry -ItemId $plate[0].id -Slots $plate[0].slots -Weight 1 -Min $bossMin -Max $bossMax -MatTag 'tspire:excluded_armor')
        Write-Table -Name ("boss_{0}_{1}" -f $slot, $f.id) -Entries $entries
    }
}

# ---------------------------------------------------------------------------
# v0.7.22 (player request): the EASY pools get weaker gear than the hard pools.
#   floor 1 easy: NO weapon at all (armour only)      -> mobs/equip_f1_easy
#   floor 2 easy: weapon one tier LOWER than hard     -> mobs/equip_f2_easy
#   floor 3 easy: weapon one tier LOWER than hard     -> mobs/equip_f3_easy
#   hard pools + everything else: unchanged           -> mobs/equip
# Armour is NOT changed (player: weapons only, not equipment).
# Why separate files instead of a flag: the equip pass runs on @e[tag=tspire_mob_new],
# one global score cannot say "this mob came from the easy pool".
# ---------------------------------------------------------------------------
$easyWeaponRange = @{
    f1 = $null            # no weapon at all
    f2 = @{ min = 0; max = 1 }
    f3 = @{ min = 1; max = 2 }
}
foreach ($f in $floors) {
    $er = $easyWeaponRange[$f.id]
    if ($er) {
        $eEntries = @()
        foreach ($wp in $weapons) {
            if ($wp.id -match 'cleaver|broad_axe') { continue }
            $eEntries += (New-Entry -ItemId $wp.id -Slots $wp.slots -Weight $wp.w -Min $er.min -Max $er.max -MatTag $wp.mat)
        }
        if ($eEntries.Count -eq 0) { throw ('easy weapon table would be empty: ' + $f.id) }
        Write-Table -Name ("mob_weapon_{0}_easy" -f $f.id) -Entries $eEntries
    }

    $sbe = New-Object System.Text.StringBuilder
    [void]$sbe.AppendLine("# AUTO-GENERATED by tools/gen-gear.ps1 -- do not edit by hand.")
    if (-not $er) {
        [void]$sbe.AppendLine("# EASY-pool gear for floor $($f.id): NO WEAPON (player request v0.7.22), armour only.")
        [void]$sbe.AppendLine("# Spawned mobs come empty-handed, so these mobs deal only their vanilla base damage.")
    } else {
        [void]$sbe.AppendLine(("# EASY-pool gear for floor {0}: weapon tier {1}..{2} (one tier below the hard pool), same armour." -f $f.id, $er.min, $er.max))
    }
    [void]$sbe.AppendLine("")
    foreach ($mcSlot in $mcSlots.Keys) {
        if ($mcSlot -eq 'weapon.mainhand') {
            if ($er) {
                [void]$sbe.AppendLine("execute as @e[tag=tspire_mob_new,tag=tspire_gear,type=minecraft:pillager] run item replace entity @s weapon.mainhand with minecraft:crossbow")
                [void]$sbe.AppendLine(("execute as @e[tag=tspire_mob_new,tag=tspire_gear,type=!minecraft:pillager] run loot replace entity @s weapon.mainhand loot tspire:mob_gear/mob_weapon_{0}_easy" -f $f.id))
            }
            # floor 1 easy: no weapon line at all
        } else {
            [void]$sbe.AppendLine(("execute as @e[tag=tspire_mob_new,tag=tspire_gear] run loot replace entity @s {0} loot tspire:mob_gear/{1}_{2}" -f $mcSlot, $mcSlots[$mcSlot], $f.id))
        }
    }
    [System.IO.File]::WriteAllText((Join-Path $fnDir ("equip_{0}_easy.mcfunction" -f $f.id)), $sbe.ToString(), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  equip_{0}_easy.mcfunction" -f $f.id)
}

# --- equip functions: 1.20.1 has no macros, so branch on #FLOOR ---
foreach ($f in $floors) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-gear.ps1 -- do not edit by hand.")
    [void]$sb.AppendLine("# Equip every mob tagged tspire_mob_new using $($f.label).")
    [void]$sb.AppendLine("")
    foreach ($mcSlot in $mcSlots.Keys) {
        if ($mcSlot -eq 'weapon.mainhand') {
            # v0.6.49: pillagers must keep a PLAIN VANILLA CROSSBOW.
            #   A summoned pillager has no equipment at all (equipment is only rolled on
            #   natural spawn), so we must hand it one -- and it must NOT get a Tinkers
            #   weapon, which is what mob_gear/weapon_* would give it.
            #   NOTE: this branch used to exist only in the generated file; running this
            #   generator wiped it (same accident class as merchant/sell in v0.6.47).
            [void]$sb.AppendLine("execute as @e[tag=tspire_mob_new,tag=tspire_gear,type=minecraft:pillager] run item replace entity @s weapon.mainhand with minecraft:crossbow")
            [void]$sb.AppendLine(("execute as @e[tag=tspire_mob_new,tag=tspire_gear,type=!minecraft:pillager] run loot replace entity @s weapon.mainhand loot tspire:mob_gear/mob_weapon_{0}" -f $f.id))
        } else {
            [void]$sb.AppendLine(("execute as @e[tag=tspire_mob_new,tag=tspire_gear] run loot replace entity @s {0} loot tspire:mob_gear/{1}_{2}" -f $mcSlot, $mcSlots[$mcSlot], $f.id))
        }
    }
    [System.IO.File]::WriteAllText((Join-Path $fnDir ("equip_{0}.mcfunction" -f $f.id)), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  equip_{0}.mcfunction" -f $f.id)
}

$sb2 = New-Object System.Text.StringBuilder
[void]$sb2.AppendLine("# AUTO-GENERATED by tools/gen-gear.ps1 -- do not edit by hand.")
[void]$sb2.AppendLine("# Equip every mob tagged tspire_mob_new, using the floor in #FLOOR (1..3).")
[void]$sb2.AppendLine("# 1.20.1 has no macros, hence the branch chain.")
[void]$sb2.AppendLine("")
for ($i = 0; $i -lt $floors.Count; $i++) {
    [void]$sb2.AppendLine(("execute if score #FLOOR tspire_timer matches {0} run function tspire:mobs/equip_{1}" -f ($i + 1), $floors[$i].id))
}
[System.IO.File]::WriteAllText((Join-Path $fnDir 'equip.mcfunction'), $sb2.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "  equip.mcfunction"

# ---------------------------------------------------------------------------
# v0.7.20 (player request): the three FLOOR-3 BOSSES draw their weapon + armour
#   from the TIER-3 material pool ONLY.
#   The floor's own range is 3..4 and it also feeds NORMAL floor-3 mobs -- those
#   stay unchanged; only bosses get this separate set:
#     mob_gear/boss_weapon_f3 + boss_{head,chest,legs,feet}_f3
#   consumed by mobs/equip_boss_f3.mcfunction, which boss/spawn/{inscriber,
#   moltenlord,recastking} call INSTEAD of mobs/equip.
# ---------------------------------------------------------------------------
$bossTier = @{ id = 'f3boss'; min = 3; max = 3; label = 'floor 3 bosses (tier 3 only)' }

$bossWeaponEntries = @()
foreach ($wp in $weapons) {
    if ($wp.id -match 'cleaver|broad_axe') { continue }   # same filter as mobs (v0.7.7)
    $bossWeaponEntries += (New-Entry -ItemId $wp.id -Slots $wp.slots -Weight $wp.w -Min $bossTier.min -Max $bossTier.max -MatTag $wp.mat)
}
if ($bossWeaponEntries.Count -eq 0) { throw 'boss weapon table would be empty' }
Write-Table -Name 'boss_weapon_f3' -Entries $bossWeaponEntries

# boss_{head,chest,legs,feet}_f3 were generated above as plate-only tables.

$sbBoss = New-Object System.Text.StringBuilder
[void]$sbBoss.AppendLine("# AUTO-GENERATED by tools/gen-gear.ps1 -- do not edit by hand.")
[void]$sbBoss.AppendLine("# Floor-3 BOSS gear: TIER 3 material pool only (v0.7.20, player request).")
[void]$sbBoss.AppendLine("# Called by boss/spawn/{inscriber,moltenlord,recastking} INSTEAD of mobs/equip.")
[void]$sbBoss.AppendLine("")
foreach ($mcSlot in $mcSlots.Keys) {
    if ($mcSlot -eq 'weapon.mainhand') {
        # pillagers keep a PLAIN VANILLA CROSSBOW (same reason as equip_f*)
        [void]$sbBoss.AppendLine("execute as @e[tag=tspire_mob_new,tag=tspire_gear,type=minecraft:pillager] run item replace entity @s weapon.mainhand with minecraft:crossbow")
        [void]$sbBoss.AppendLine("execute as @e[tag=tspire_mob_new,tag=tspire_gear,type=!minecraft:pillager] run loot replace entity @s weapon.mainhand loot tspire:mob_gear/boss_weapon_f3")
    } else {
        [void]$sbBoss.AppendLine(("execute as @e[tag=tspire_mob_new,tag=tspire_gear] run loot replace entity @s {0} loot tspire:mob_gear/boss_{1}_f3" -f $mcSlot, $mcSlots[$mcSlot]))
    }
}
[void]$sbBoss.AppendLine('execute as @e[tag=tspire_boss_moltenlord] run loot replace entity @s armor.chest loot tspire:mob_gear/boss_chest_moltenlord')
[System.IO.File]::WriteAllText((Join-Path $fnDir 'equip_boss_f3.mcfunction'), $sbBoss.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "  equip_boss_f3.mcfunction"

$sbBossArmor = New-Object System.Text.StringBuilder
[void]$sbBossArmor.AppendLine('# AUTO-GENERATED by tools/gen-gear.ps1')
[void]$sbBossArmor.AppendLine('# Called at the current boss node after boss/spawn/pick_floor*.')
foreach ($f in $floors) {
    $floorNum = [int]($f.id.Substring(1))
    foreach ($slot in @('head','chest','legs','feet')) {
        $selector = if ($slot -eq 'chest') { '@e[tag=tspire_boss,tag=!tspire_boss_moltenlord,distance=..20]' } else { '@e[tag=tspire_boss,distance=..20]' }
        [void]$sbBossArmor.AppendLine(('execute if score #FLOOR tspire_timer matches {0} as {1} run loot replace entity @s armor.{2} loot tspire:mob_gear/boss_{2}_{3}' -f $floorNum, $selector, $slot, $f.id))
    }
}
[System.IO.File]::WriteAllText((Join-Path $fnDir 'equip_boss_armor.mcfunction'), $sbBossArmor.ToString(), (New-Object System.Text.UTF8Encoding($false)))

# ---------------------------------------------------------------------------
# starter weapons (the run-start 3-way choice, design doc 13.10 phase 2/3)
#   One single-entry table per archetype: the TYPE is fixed (so the chat menu
#   can honestly describe it) while the MATERIALS are rolled from the floor-1
#   pool (tier 0..2).
# ---------------------------------------------------------------------------
$starterDir = Join-Path $resDir 'data\tspire\loot_tables\starter'
New-Item -ItemType Directory -Force -Path $starterDir | Out-Null
Get-ChildItem -File $starterDir -Filter *.json -ErrorAction SilentlyContinue | Remove-Item -Force

$starters = @(
    @{ file = 'sword';    id = 'tconstruct:sword';    slots = 3 },
    @{ file = 'dagger';   id = 'tconstruct:dagger';   slots = 2 },
    @{ file = 'crossbow'; id = 'tconstruct:crossbow'; slots = 3 }
)
foreach ($st in $starters) {
    $entry = New-Entry -ItemId $st.id -Slots $st.slots -Weight 1 -Min 0 -Max 2 -Count $(if ($st.id -eq 'tconstruct:dagger') { 2 } else { 1 })
    $obj = [ordered]@{ pools = @([ordered]@{ rolls = 1; entries = @($entry) }) }
    $json = $obj | ConvertTo-Json -Depth 14
    [System.IO.File]::WriteAllText((Join-Path $starterDir ("{0}.json" -f $st.file)), $json, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  starter/{0}.json  ({1}, {2} slots)" -f $st.file, $st.id, $st.slots)
}

# clean up the old tier-keyed tables so they do not linger
Get-ChildItem -File $outDir -Filter '*_t?.json' -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Host ("  removed stale {0}" -f $_.Name)
}
Get-ChildItem -File $fnDir -Filter 'equip_t?.mcfunction' -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Host ("  removed stale {0}" -f $_.Name)
}

$n = (Get-ChildItem -File $outDir -Filter *.json).Count
Write-Host ("done: {0} loot tables" -f $n)
