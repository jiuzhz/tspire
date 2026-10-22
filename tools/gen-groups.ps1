# Generate tinkers-spire encounter groups, roll predicates and pick functions.
#
# Group composition comes from the design doc section 7.4 (38 groups):
#   floor1: easy e1-e3, hard h1-h9
#   floor2: easy e1-e3, hard h1-h10
#   floor3: easy e1-e3, hard h1-h10
#
# Mobs that can render/hold equipment get tag tspire_gear; armless mobs
# (spider, creeper, blaze, ...) do not, so the equip pass skips them.
# Witch is deliberately NOT geared -- she keeps her potion.
#
# Random selection: 1.20.1 has no /random, so we use a chain of
# minecraft:random_chance predicates plus a #PICKED guard. For a pool of N,
# step i uses chance 1/(N-i), which yields a uniform pick.
#
# NOTE: keep this file pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI).
# NOTE: command arguments must use SINGLE spaces only -- Brigadier's Vec3
#       parser consumes exactly one space per coordinate separator.

# v0.6.46 (player request): the mob pools no longer use evokers or vexes --
#   evoker -> vindicator, vex -> pillager. Vexes/evokers brought summoning AI that
#   misbehaved with Tinkers gear; vindicators and pillagers are plain melee/ranged.
# ---------------------------------------------------------------------------
# TUNABLE PARAMETERS (edit below, then re-run this script)
#   $groups  -- the encounter groups: floor -> easy/hard -> spawn list
#   $armless -- mobs that cannot render equipment (equip pass skips them)
# ---------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'

$root   = Split-Path -Parent $PSScriptRoot
$resDir = Join-Path $root 'src\main\resources'
$fnRoot = Join-Path $resDir 'data\tspire\functions\mobs'
$predDir = Join-Path $resDir 'data\tspire\predicates\roll'

# mobs that cannot hold or render equipment
$armless = @(
    'minecraft:spider', 'minecraft:cave_spider', 'minecraft:creeper', 'minecraft:slime',
    'minecraft:magma_cube', 'minecraft:blaze', 'minecraft:ghast', 'minecraft:enderman',
    'minecraft:silverfish', 'minecraft:endermite', 'minecraft:phantom', 'minecraft:shulker',
    'minecraft:guardian', 'minecraft:elder_guardian', 'minecraft:ravager',
    'minecraft:hoglin', 'minecraft:zoglin', 'minecraft:witch'
)

# ---------------------------------------------------------------------------
# group definitions: floor -> pool -> list of groups -> list of [mob, count]
# ---------------------------------------------------------------------------
$groups = [ordered]@{
    '1' = [ordered]@{
        'easy' = @(
            @(@('minecraft:zombie', 3), @('minecraft:skeleton', 2)),
            @(@('minecraft:drowned', 3), @('minecraft:husk', 2)),
            @(@('minecraft:zombie_villager', 3), @('minecraft:spider', 2))
        )
        'hard' = @(
            @(@('minecraft:zombie', 4), @('minecraft:skeleton', 2)),
            @(@('minecraft:vindicator', 2), @('minecraft:zombie', 3)),
            @(@('minecraft:pillager', 3), @('minecraft:skeleton', 2)),
            @(@('minecraft:husk', 3), @('minecraft:cave_spider', 3)),
            @(@('minecraft:zombie', 3), @('minecraft:creeper', 2), @('minecraft:spider', 2)),
            @(@('minecraft:drowned', 3), @('minecraft:skeleton', 3)),
            @(@('minecraft:zombie_villager', 4), @('minecraft:vindicator', 1)),
            @(@('minecraft:skeleton', 4), @('minecraft:spider', 3)),
            @(@('minecraft:zombie', 5), @('minecraft:zombie_villager', 2), @('minecraft:creeper', 1))
        )
    }
    '2' = [ordered]@{
        'easy' = @(
            @(@('minecraft:zombie', 3), @('minecraft:skeleton', 2)),
            @(@('minecraft:drowned', 3), @('minecraft:stray', 2)),
            @(@('minecraft:zombie_villager', 3), @('minecraft:magma_cube', 2))
        )
        'hard' = @(
            @(@('minecraft:vindicator', 2), @('minecraft:pillager', 2), @('minecraft:zombie', 2)),
            @(@('minecraft:vindicator', 1), @('minecraft:pillager', 4), @('minecraft:zombie', 2)),
            @(@('minecraft:skeleton', 4), @('minecraft:stray', 2)),
            @(@('minecraft:zombified_piglin', 4), @('minecraft:blaze', 2)),
            @(@('minecraft:pillager', 4), @('minecraft:witch', 1), @('minecraft:zombie', 1)),
            @(@('minecraft:zombie', 4), @('minecraft:magma_cube', 3)),
            @(@('minecraft:cave_spider', 4), @('minecraft:spider', 3)),
            @(@('minecraft:vindicator', 3), @('minecraft:skeleton', 3)),
            @(@('minecraft:drowned', 4), @('minecraft:zombie_villager', 3)),
            @(@('minecraft:zombified_piglin', 3), @('minecraft:vindicator', 1), @('minecraft:pillager', 3))
        )
    }
    '3' = [ordered]@{
        'easy' = @(
            @(@('minecraft:zombified_piglin', 3), @('minecraft:skeleton', 2)),
            @(@('minecraft:piglin', 3), @('minecraft:zombified_piglin', 2)),
            @(@('minecraft:wither_skeleton', 3), @('minecraft:zombie', 2))
        )
        'hard' = @(
            @(@('minecraft:vindicator', 3), @('minecraft:pillager', 3)),
            @(@('minecraft:vindicator', 3), @('minecraft:pillager', 8)),
            @(@('minecraft:zombified_piglin', 4), @('minecraft:piglin', 2)),
            @(@('minecraft:wither_skeleton', 4), @('minecraft:blaze', 3)),
            @(@('minecraft:ravager', 2), @('minecraft:pillager', 4)),
            @(@('minecraft:elder_guardian', 2), @('minecraft:guardian', 4)),
            @(@('minecraft:zombified_piglin', 5), @('minecraft:skeleton', 3)),
            @(@('minecraft:piglin', 4), @('minecraft:phantom', 3)),
            @(@('minecraft:zombie', 4), @('minecraft:vindicator', 3)),
            @(@('minecraft:wither_skeleton', 4), @('minecraft:vindicator', 4), @('minecraft:pillager', 3))
        )
    }
}

function Get-Pos {
    param([int]$Index)
    # v0.6.28: the formation is now laid out relative to the ROOM CENTRE (see
    # run/battle_start, which anchors spawn_batch on the current node marker instead
    # of the player), 5 columns wide and stacking northwards.
    # The player walks in through the SOUTH door, so everything at negative z is in
    # front of them and, more importantly, several blocks away from the doorway --
    # they used to be hit the instant the trigger fired because the old origin was
    # the player's own position.
    $x = (($Index % 5) - 2) * 3
    $z = -3 - [Math]::Floor($Index / 5) * 2
    return @($x, $z)
}

# ---------------------------------------------------------------------------
# 1) group functions
# ---------------------------------------------------------------------------
$count = 0
foreach ($floor in $groups.Keys) {
    foreach ($pool in $groups[$floor].Keys) {
        $list = $groups[$floor][$pool]
        for ($k = 0; $k -lt $list.Count; $k++) {
            $tag = if ($pool -eq 'easy') { 'e' } else { 'h' }
            $name = "$tag$($k + 1)"
            $dir = Join-Path $fnRoot ("groups\floor{0}_{1}" -f $floor, $pool)
            New-Item -ItemType Directory -Force -Path $dir | Out-Null

            $sum = ($list[$k] | ForEach-Object { "$($_[0].Replace('minecraft:','')) x$($_[1])" }) -join ' + '
            $sb = New-Object System.Text.StringBuilder
            [void]$sb.AppendLine("# $floor-$($tag.ToUpper())$($k + 1) | floor $floor $pool | $sum")
            [void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-groups.ps1 -- do not edit by hand.")
            [void]$sb.AppendLine("")

            $idx = 0
            foreach ($entry in $list[$k]) {
                $mob = $entry[0]
                $n = [int]$entry[1]
                $tags = 'tspire_mob","tspire_mob_new'
                if ($armless -notcontains $mob) { $tags = $tags + '","tspire_gear' }
                # v0.7.22 (player request): tag the EASY pools so later passes can tell them apart
                #   (see tick/second: `tspire_noweapon` mobs get their main hand cleared every second,
                #    and mobs/equip_f*_easy is what hands out their weaker gear).
                if ($pool -eq 'easy') {
                    $tags = $tags + '","tspire_pool_easy'
                    if ($floor -eq 1) { $tags = $tags + '","tspire_noweapon' }
                }
                for ($c = 0; $c -lt $n; $c++) {
                    $p = Get-Pos -Index $idx
                    $sizeNbt = if ($mob -eq 'minecraft:magma_cube') { ',Size:2' } else { '' }
                    [void]$sb.AppendLine(("summon {0} ~{1} ~ ~{2} {{Tags:[`"{3}`"],PersistenceRequired:1b{4}}}" -f $mob, $p[0], $p[1], $tags, $sizeNbt))
                    $idx++
                }
            }
            [void]$sb.AppendLine("")

            # ------------------------------------------------------------------
            # v0.7.23 (player request) party-size mob scaling
            #   1 player -> -40%, 2 players -> -20%, 3+ -> unchanged.
            #   * total is FLOORED: target = max(#species, floor(total * factor))
            #   * handed out proportionally (largest-remainder), every species keeps >= 1
            #   * implementation: spawn the full group, then kill the surplus per TYPE at
            #     random -- only mobs still tagged tspire_mob_new (i.e. this batch) are hit,
            #     so mobs already in the room are never touched
            #   * #PARTY_SIZE is computed by mobs/cap at the top of mobs/spawn_batch
            #     (counts party members incl. the dead-awaiting-revive, same basis as the
            #     boss HP scaling)
            # NOTE: this file must stay pure ASCII -- PS 5.1 reads BOM-less .ps1 as ANSI,
            #       and CJK comments here break the parser (v0.7.22 lesson, 3rd time).
            # ------------------------------------------------------------------
            $byType = [ordered]@{}
            foreach ($entry in $list[$k]) {
                $mob = $entry[0]
                if ($byType.Contains($mob)) { $byType[$mob] += [int]$entry[1] } else { $byType[$mob] = [int]$entry[1] }
            }
            $total = 0; foreach ($v in $byType.Values) { $total += $v }
            $nspec = $byType.Count
            $cullLines = @()
            foreach ($players in 1, 2) {
                $factor = if ($players -eq 1) { 0.6 } else { 0.8 }
                $target = [Math]::Max($nspec, [Math]::Floor($total * $factor))
                $keep = [ordered]@{}; $extra = [ordered]@{}
                foreach ($m in $byType.Keys) {
                    $keep[$m] = [Math]::Max(1, [Math]::Floor($byType[$m] * $factor))
                    $extra[$m] = 0
                }
                $assigned = 0; foreach ($v in $keep.Values) { $assigned += $v }
                while ($assigned -lt $target) {
                    $best = $null; $bestRem = -1e9
                    foreach ($m in $byType.Keys) {
                        $rem = ($byType[$m] * $factor) - [Math]::Floor($byType[$m] * $factor) - $extra[$m]
                        if ($rem -gt $bestRem) { $bestRem = $rem; $best = $m }
                    }
                    $extra[$best]++; $keep[$best]++; $assigned++
                }
                foreach ($m in $byType.Keys) {
                    $surplus = $byType[$m] - $keep[$m]
                    if ($surplus -gt 0) {
                        $cullLines += ("execute if score #PARTY_SIZE tspire_timer matches {0} run kill @e[type={1},tag=tspire_mob_new,sort=random,limit={2}]" -f $players, $m, $surplus)
                    }
                }
            }
            if ($cullLines.Count) {
                $keep1 = [Math]::Max($nspec, [Math]::Floor($total * 0.6))
                $keep2 = [Math]::Max($nspec, [Math]::Floor($total * 0.8))
                [void]$sb.AppendLine("# --- v0.7.23 party-size scaling: 1 player keeps $keep1 / $keep2 for 2 players, out of $total ($nspec species) ---")
                foreach ($l in $cullLines) { [void]$sb.AppendLine($l) }
                [void]$sb.AppendLine("")
            }

            # v0.6.25: DO NOT write #FLOOR here. It used to emit
            #   scoreboard players set #FLOOR tspire_timer <floor>
            # which is at best redundant (roll_group already branched on #FLOOR)
            # and at worst a landmine: the hand-written boss/spawn/* files carried
            # WRONG values (the floor-2 boss set #FLOOR=3), so after killing a
            # floor-1 boss the floor counter was already 2 and floor_advance
            # pushed it to 3 -- the player was teleported to floor 3.
            # #FLOOR must only ever be changed by run/start_run and run/floor_advance.
            # v0.7.22 (player request): the EASY pools use their own gear pass --
            #   floor 1 easy -> no weapon at all; floor 2/3 easy -> weapon one tier lower.
            #   Hard pools (and everything else) keep calling mobs/equip.
            if ($pool -eq 'easy') {
                [void]$sb.AppendLine("function tspire:mobs/equip_f$($floor)_easy")
            } else {
                [void]$sb.AppendLine("function tspire:mobs/equip")
            }
            [void]$sb.AppendLine("tag @e[tag=tspire_mob_new] remove tspire_mob_new")

            $file = Join-Path $dir "$name.mcfunction"
            [System.IO.File]::WriteAllText($file, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
            $count++
        }
    }
}
Write-Host ("generated {0} group functions" -f $count)

# ---------------------------------------------------------------------------
# 2) roll predicates: d1 .. d20 with chance 1/n
#    (d20 is used by the merchant's 5% ancient-tool shelf)
# ---------------------------------------------------------------------------
New-Item -ItemType Directory -Force -Path $predDir | Out-Null
for ($n = 1; $n -le 20; $n++) {
    $chance = 1.0 / $n
    $obj = [ordered]@{
        condition = 'minecraft:random_chance'
        chance    = [Math]::Round($chance, 6)
    }
    $json = $obj | ConvertTo-Json
    [System.IO.File]::WriteAllText((Join-Path $predDir "d$n.json"), $json, (New-Object System.Text.UTF8Encoding($false)))
}
Write-Host "generated 20 roll predicates (tspire:roll/d1 .. d20)"

# ---------------------------------------------------------------------------
# 3) pick functions: one per (floor, pool)
# ---------------------------------------------------------------------------
$pickDir = Join-Path $fnRoot 'pick'
New-Item -ItemType Directory -Force -Path $pickDir | Out-Null

foreach ($floor in $groups.Keys) {
    foreach ($pool in $groups[$floor].Keys) {
        $list = $groups[$floor][$pool]
        $n = $list.Count
        $tag = if ($pool -eq 'easy') { 'e' } else { 'h' }
        $sb = New-Object System.Text.StringBuilder
        [void]$sb.AppendLine("# AUTO-GENERATED by tools/gen-groups.ps1 -- do not edit by hand.")
        [void]$sb.AppendLine("# Uniformly pick one of $n groups from floor $floor $pool.")
        [void]$sb.AppendLine("# Chain of random_chance predicates; the #PICKED guard stops after one hit.")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("scoreboard players set #PICKED tspire_timer 0")
        for ($k = 0; $k -lt $n; $k++) {
            $d = $n - $k
            [void]$sb.AppendLine(("execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d{0} run function tspire:mobs/pick/{1}_{2}_{3}" -f $d, $floor, $pool, $tag + ($k + 1)))
        }
        [System.IO.File]::WriteAllText((Join-Path $pickDir ("{0}_{1}.mcfunction" -f $floor, $pool)), $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))

        # per-group stubs that actually spawn and mark as picked
        for ($k = 0; $k -lt $n; $k++) {
            $gname = $tag + ($k + 1)
            $sb2 = New-Object System.Text.StringBuilder
            [void]$sb2.AppendLine("# AUTO-GENERATED by tools/gen-groups.ps1 -- do not edit by hand.")
            [void]$sb2.AppendLine(("function tspire:mobs/groups/floor{0}_{1}/{2}" -f $floor, $pool, $gname))
            [void]$sb2.AppendLine(("scoreboard players set #LAST_GRP tspire_timer {0}" -f ($k + 1)))
            [void]$sb2.AppendLine(("scoreboard players set #LAST_POOL tspire_timer {0}" -f $(if ($pool -eq 'easy') { 0 } else { 1 })))
            [void]$sb2.AppendLine(("scoreboard players set #LAST_TAG tspire_timer {0}" -f $floor))
            [void]$sb2.AppendLine("scoreboard players set #PICKED tspire_timer 1")
            [System.IO.File]::WriteAllText((Join-Path $pickDir ("{0}_{1}_{2}.mcfunction" -f $floor, $pool, $gname)), $sb2.ToString(), (New-Object System.Text.UTF8Encoding($false)))
        }
    }
}
Write-Host "generated pick functions"

# ---------------------------------------------------------------------------
# 4) roll_group entry point
#    #FLOOR 1..3, #BATTLE 1-based, #ELITE 0/1
#    Pool rule (design doc 7.4): battles 1-2 -> easy, battle 3+ -> hard, elite -> hard
# ---------------------------------------------------------------------------
$sb3 = New-Object System.Text.StringBuilder
[void]$sb3.AppendLine("# AUTO-GENERATED by tools/gen-groups.ps1 -- do not edit by hand.")
[void]$sb3.AppendLine("# Pick and spawn one encounter group.")
[void]$sb3.AppendLine("#   in: #FLOOR (1..3), #BATTLE (1-based this floor), #ELITE (0/1)")
[void]$sb3.AppendLine("#   pool rule (design doc 7.4): battle 1-2 -> easy, battle 3+ -> hard, elite -> hard")
[void]$sb3.AppendLine("")
[void]$sb3.AppendLine("scoreboard players set #POOL tspire_timer 0")
[void]$sb3.AppendLine("execute if score #ELITE tspire_timer matches 1 run scoreboard players set #POOL tspire_timer 1")
[void]$sb3.AppendLine("execute if score #BATTLE tspire_timer matches 3.. run scoreboard players set #POOL tspire_timer 1")
[void]$sb3.AppendLine("")
foreach ($floor in $groups.Keys) {
    [void]$sb3.AppendLine(("execute if score #FLOOR tspire_timer matches {0} if score #POOL tspire_timer matches 0 run function tspire:mobs/pick/{0}_easy" -f $floor))
    [void]$sb3.AppendLine(("execute if score #FLOOR tspire_timer matches {0} if score #POOL tspire_timer matches 1 run function tspire:mobs/pick/{0}_hard" -f $floor))
}
[System.IO.File]::WriteAllText((Join-Path $fnRoot 'roll_group.mcfunction'), $sb3.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "generated roll_group.mcfunction"
