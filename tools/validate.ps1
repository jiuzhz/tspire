# ===========================================================================
# tinkers-spire offline validator
# ===========================================================================
# Catches, WITHOUT launching Minecraft, the classes of bug that actually bit us:
#   - a function / loot table / predicate / item modifier / tag that does not exist
#     (Minecraft just logs "Unknown function" and the whole chain silently stops)
#   - a wrong registry id (double namespace, tconstruct:randomized, ...)
#   - a bossbar colour that does not exist (kills the WHOLE load function)
#   - snake_case click_event / hover_event (silently ignored in 1.20.1)
#   - two spaces between command arguments (Brigadier Vec3Argument -> function
#     fails to load, and the error points at the wrong line)
#   - `matches` given a score holder instead of a literal
#   - a store target objective that was never created
#   - non-ASCII inside a .ps1 (PS 5.1 reads BOM-less .ps1 as ANSI)
#
# Usage:  powershell -ExecutionPolicy Bypass -File tools\validate.ps1
# Exit code: 0 = clean, 1 = at least one FAIL.
#
# NOTE: keep this file pure ASCII (PS 5.1 reads BOM-less .ps1 as ANSI).

$ErrorActionPreference = 'Stop'

$root     = Split-Path -Parent $PSScriptRoot
$res      = Join-Path $root 'src\main\resources'
$data     = Join-Path $res 'data'
$fnRoot   = Join-Path $data 'tspire\functions'
$tcSource = (Get-Content (Join-Path $PSScriptRoot 'tc-source.txt') -Raw -Encoding UTF8).Trim()

$script:fails = 0
$script:warns = 0

function Fail { param([string]$M) Write-Host ("FAIL  " + $M) -ForegroundColor Red;    $script:fails++ }
function Warn { param([string]$M) Write-Host ("WARN  " + $M) -ForegroundColor Yellow; $script:warns++ }
function Good { param([string]$M) Write-Host ("ok    " + $M) -ForegroundColor DarkGray }

Write-Host "== tinkers-spire validate ==" -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# load every mcfunction once
# ---------------------------------------------------------------------------
$lines = New-Object System.Collections.Generic.List[object]
$fnFiles = Get-ChildItem $fnRoot -Recurse -File -Filter *.mcfunction | Sort-Object FullName
foreach ($f in $fnFiles) {
    $rel = $f.FullName.Substring($fnRoot.Length + 1) -replace '\\', '/'
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191) {
        Fail ("UTF-8 BOM in {0} (Minecraft cannot parse its first command)" -f $rel)
    }
    $n = 0
    foreach ($l in [System.IO.File]::ReadAllLines($f.FullName, [System.Text.Encoding]::UTF8)) {
        $n++
        $lines.Add([pscustomobject]@{ Rel = $rel; No = $n; Text = $l })
    }
}
Good ("loaded {0} functions, {1} lines" -f $fnFiles.Count, $lines.Count)

function Where-Line { param([string]$Rel, [int]$No) return ("{0}:{1}" -f $Rel, $No) }

# ---------------------------------------------------------------------------
# 1. .ps1 must stay pure ASCII
# ---------------------------------------------------------------------------
$badPs1 = 0
foreach ($p in Get-ChildItem $PSScriptRoot -File -Filter *.ps1) {
    $bad = 0
    foreach ($l in [System.IO.File]::ReadAllLines($p.FullName, [System.Text.Encoding]::UTF8)) {
        if ($l -match '[^\x00-\x7F]') { $bad++ }
    }
    if ($bad -gt 0) { Fail ("non-ASCII in {0} ({1} lines) -- PS 5.1 reads BOM-less .ps1 as ANSI" -f $p.Name, $bad); $badPs1++ }
}
if ($badPs1 -eq 0) { Good "ps1 files are ASCII-only" }

# ---------------------------------------------------------------------------
# 2. every JSON parses
# ---------------------------------------------------------------------------
$jsonCount = 0
foreach ($j in Get-ChildItem $data -Recurse -File -Filter *.json) {
    $jsonCount++
    try { [void](Get-Content $j.FullName -Raw -Encoding UTF8 | ConvertFrom-Json) }
    catch { Fail ("bad JSON: {0} -- {1}" -f $j.FullName.Replace($data, ''), $_.Exception.Message) }
}
Good ("{0} JSON files parse" -f $jsonCount)

# ---------------------------------------------------------------------------
# registry of things that exist
# ---------------------------------------------------------------------------
function Test-DataFile { param([string]$Ns, [string]$Kind, [string]$Path)
    # functions use the .mcfunction extension, every other registry is .json
    $ext = '.json'
    if ($Kind -eq 'functions') { $ext = '.mcfunction' }
    $rel = ("{0}\{1}\{2}{3}" -f $Ns, $Kind, ($Path -replace '/', '\'), $ext)
    return (Test-Path (Join-Path $data $rel))
}
$funcTags = @{}
Get-ChildItem (Join-Path $data 'minecraft\tags\functions') -File -ErrorAction SilentlyContinue | ForEach-Object { $funcTags['minecraft:' + $_.BaseName] = $true }
Get-ChildItem (Join-Path $data 'tspire\tags\functions') -File -ErrorAction SilentlyContinue | ForEach-Object { $funcTags['tspire:' + $_.BaseName] = $true }

# block / item ids available from the unpacked Tinkers jar
$tcBlocks = @{}
$tcItems  = @{}
foreach ($d in 'blockstates', 'models\item') {
    $p = Join-Path $tcSource ("assets\tconstruct\{0}" -f $d)
    if (Test-Path $p) {
        Get-ChildItem $p -File -Filter *.json | ForEach-Object {
            $id = 'tconstruct:' + $_.BaseName
            if ($d -eq 'blockstates') { $tcBlocks[$id] = $true } else { $tcItems[$id] = $true }
        }
    }
}
Good ("tconstruct registry: {0} blocks, {1} items" -f $tcBlocks.Count, $tcItems.Count)

# ---------------------------------------------------------------------------
# 2.5 ITEM IDS  (the slime_chestplate bug)
# ---------------------------------------------------------------------------
# A tool *definition* file name is NOT always the registered item id:
#   data/.../tool_definitions/slime_chestplate.json  ->  item tconstruct:slimy_chestplate
# Emitting the wrong id makes the WHOLE function fail to parse at load time
# ("Whilst parsing command on line N: Unknown item") and the feature silently
# never works. So build the real item set from the language file (which lists
# every registered item) plus the block ids, and check every item argument.
$tcItemIds = @{}
$langFile = Join-Path $tcSource 'assets\tconstruct\lang\zh_cn.json'
if (Test-Path $langFile) {
    $lj = Get-Content $langFile -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($p in $lj.PSObject.Properties) {
        if ($p.Name -like 'item.tconstruct.*') {
            $n = $p.Name.Substring('item.tconstruct.'.Length)
            if ($n -notmatch '\.') { $tcItemIds['tconstruct:' + $n] = $true }
        }
    }
}
foreach ($b in $tcBlocks.Keys) { $tcItemIds[$b] = $true }
Good ("tconstruct item ids known: {0}" -f $tcItemIds.Count)

$bossbarColors = @('pink', 'blue', 'red', 'green', 'yellow', 'purple', 'white')
$bossbarStyles = @('progress', 'notched_6', 'notched_10', 'notched_12', 'notched_20')


# Tinkers effect ids (effect.tconstruct.* keys in the Tinkers lang file). Used to
# check `effect give ... tconstruct:<id>` -- a typo there also kills the whole
# function at load time.
$tcEffectIds = @()
if (Test-Path $langFile) {
    try {
        $langJson = Get-Content $langFile -Raw -Encoding UTF8 | ConvertFrom-Json
        $tcEffectIds = @($langJson.PSObject.Properties | Where-Object { $_.Name -like 'effect.tconstruct.*' } | ForEach-Object { $_.Name -replace '^effect\.tconstruct\.', '' })
    } catch { }
}

# 1.20.1 status effects. Used by the effect-vs-particle rule below: "witch" is a
# particle and "poison" is an effect, and mixing them up makes a command
# unresolvable, which silently kills the whole function at load time.
$effectIds = @(
    'absorption', 'bad_omen', 'blindness', 'conduit_power', 'darkness', 'dolphins_grace',
    'fire_resistance', 'glowing', 'haste', 'health_boost', 'hero_of_the_village', 'hunger',
    'instant_damage', 'instant_health', 'invisibility', 'jump_boost', 'levitation', 'luck',
    'mining_fatigue', 'nausea', 'night_vision', 'poison', 'regeneration', 'resistance',
    'saturation', 'slow_falling', 'slowness', 'speed', 'strength', 'unluck',
    'water_breathing', 'weakness', 'wither'
)

# objectives declared anywhere
$declaredObjectives = @{}
foreach ($l in $lines) {
    if ($l.Text -match '^\s*scoreboard\s+objectives\s+add\s+(\S+)') { $declaredObjectives[$Matches[1]] = $true }
}
Good ("declared objectives: {0}" -f (($declaredObjectives.Keys | Sort-Object) -join ', '))

# ---------------------------------------------------------------------------
# 2.9 RAW FILE SHAPE  (v0.7.1)
# ---------------------------------------------------------------------------
# The five functions that failed to load after the v0.7.1 deploy were file-shape
# problems, not vocabulary problems -- and ReadAllLines() hides one of them,
# because .NET splits a bare CR as well. So look at the raw bytes:
#   * a bare CR inside a line (a PowerShell backtick ate an "r") splits one
#     comment into two lines; the tail is parsed as a command and the whole
#     function fails with "Unknown or incomplete command".
#   * a leftover  -join "  is a PowerShell string-join artefact written straight
#     into an .mcfunction (mystery/pharm_1..3).
$rawCr = 0; $rawJoin = 0
foreach ($f in $fnFiles) {
    $raw = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $rel = $f.FullName.Substring($fnRoot.Length + 1).Replace("\", "/")
    if ($raw -match "\r(?!\n)") {
        $mm = [regex]::Match($raw, "\r(?!\n)")
        $ln = ($raw.Substring(0, $mm.Index) -split "\n").Count
        $rawCr++
        Fail ("$rel`:$ln bare CR inside a line (not CRLF) -- the game sees an extra line, function fails to load")
    }
    if ($raw.Contains('-join "')) {
        $rawJoin++
        Fail ("$rel contains a PowerShell leftover: -join")
    }
}
if ($rawCr -eq 0 -and $rawJoin -eq 0) { Good "no bare CR and no -join leftovers in any function" }

# ---------------------------------------------------------------------------
# 2.9b VANILLA REGISTRY IDS  (v0.7.10)
# ---------------------------------------------------------------------------
# Two real bugs shipped because nothing checked *vanilla* ids:
#   mystery/turtle_save : give @s minecraft:turtle_scute   (the id is minecraft:scute)
#   mystery/props       : fill ... air replace minecraft:armor_stand
#                         setblock ... minecraft:armor_stand  (armor_stand is an ENTITY)
# Both are PARSE errors, so the game logs "Failed to load function" and the WHOLE
# function dies -- the turtle option was unclickable and every mystery prop was
# missing, with no other symptom. The id sets come from the vanilla asset jar:
# run tools\dump-vanilla-ids.ps1 once to write _ref\assets\minecraft\lang\en_us.json.
$mcItems = @{}; $mcBlocks = @{}; $mcEntities = @{}
$mcLang = Join-Path $root '_ref\assets\minecraft\lang\en_us.json'
if (Test-Path $mcLang) {
    $mj = Get-Content $mcLang -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($p in $mj.PSObject.Properties) {
        $n = $p.Name
        if ($n -like 'item.minecraft.*') {
            $k = $n.Substring(15); if ($k -notmatch '\.') { $mcItems['minecraft:' + $k] = $true }
        } elseif ($n -like 'block.minecraft.*') {
            $k = $n.Substring(16); if ($k -notmatch '\.') { $mcBlocks['minecraft:' + $k] = $true }
        } elseif ($n -like 'entity.minecraft.*') {
            $k = $n.Substring(17); if ($k -notmatch '\.') { $mcEntities['minecraft:' + $k] = $true }
        }
    }
}
if ($mcItems.Count -eq 0) {
    Warn "vanilla id list missing -- run tools\dump-vanilla-ids.ps1 (rule 2.9b skipped)"
} else {
    Good ("vanilla registry: {0} items, {1} blocks, {2} entities" -f $mcItems.Count, $mcBlocks.Count, $mcEntities.Count)
    # blocks that exist but have no language key (or are covered by another id)
    $blockOk = @('minecraft:air', 'minecraft:cave_air', 'minecraft:void_air', 'minecraft:water',
                 'minecraft:lava', 'minecraft:fire', 'minecraft:soul_fire', 'minecraft:moving_piston',
                 'minecraft:piston_head', 'minecraft:nether_portal', 'minecraft:end_portal',
                 'minecraft:end_gateway', 'minecraft:bubble_column', 'minecraft:frosted_ice',
                 'minecraft:spawner', 'minecraft:trial_spawner', 'minecraft:vault')
    $badVanilla = 0
    foreach ($l in $lines) {
        $t = $l.Text
        if ($t -match '^\s*#') { continue }
        if ($t -match '\btellraw\b|\btitle\b|\bbossbar\b') { continue }
        $where = Where-Line $l.Rel $l.No
        # --- items: give / clear / item replace ... with -----------------------
        # "effect give @s minecraft:speed" also contains "give" -- effects are not
        # items, so skip both forms (effect give / effect clear) -- minecraft:<effect> is legal there.
        $isEffectGive = ($t -match '\beffect\s+(?:give|clear)\b')
        foreach ($m in [regex]::Matches($t, '\b(?:give|clear)\s+(?:@\S+\s+)?(minecraft:[a-z_0-9]+)')) {
            if ($isEffectGive) { continue }
            $id = $m.Groups[1].Value
            if (-not $mcItems.ContainsKey($id) -and -not $mcBlocks.ContainsKey($id)) { Fail ("$where unknown ITEM id '$id' -- function will not load"); $badVanilla++ }
        }
        foreach ($m in [regex]::Matches($t, '\bwith\s+(minecraft:[a-z_0-9]+)')) {
            $id = $m.Groups[1].Value
            if (-not $mcItems.ContainsKey($id) -and -not $mcBlocks.ContainsKey($id)) { Fail ("$where unknown ITEM id '$id' (item replace ... with) -- function will not load"); $badVanilla++ }
        }
        # --- blocks: setblock / fill ------------------------------------------
        foreach ($m in [regex]::Matches($t, '\bsetblock\s+\S+\s+\S+\s+\S+\s+(minecraft:[a-z_0-9]+)')) {
            $id = $m.Groups[1].Value
            if (-not $mcBlocks.ContainsKey($id) -and $blockOk -notcontains $id) { Fail ("$where unknown BLOCK id '$id' (setblock) -- function will not load"); $badVanilla++ }
        }
        foreach ($m in [regex]::Matches($t, '\bfill\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(minecraft:[a-z_0-9]+)')) {
            $id = $m.Groups[1].Value
            if (-not $mcBlocks.ContainsKey($id) -and $blockOk -notcontains $id) { Fail ("$where unknown BLOCK id '$id' (fill) -- function will not load"); $badVanilla++ }
        }
        if ($t -match '\bfill\s') {
            foreach ($m in [regex]::Matches($t, '\breplace\s+(minecraft:[a-z_0-9]+)')) {
                $id = $m.Groups[1].Value
                if (-not $mcBlocks.ContainsKey($id) -and $blockOk -notcontains $id) { Fail ("$where unknown BLOCK id '$id' (fill ... replace) -- function will not load"); $badVanilla++ }
            }
        }
        # --- entities: summon / type= -----------------------------------------
        foreach ($m in [regex]::Matches($t, '\bsummon\s+(minecraft:[a-z_0-9]+)')) {
            $id = $m.Groups[1].Value
            if (-not $mcEntities.ContainsKey($id)) { Fail ("$where unknown ENTITY id '$id' (summon) -- function will not load"); $badVanilla++ }
        }
        foreach ($m in [regex]::Matches($t, '\btype=(minecraft:[a-z_0-9]+)')) {
            $id = $m.Groups[1].Value
            if (-not $mcEntities.ContainsKey($id)) { Fail ("$where unknown ENTITY id '$id' (selector type=)"); $badVanilla++ }
        }
    }
    if ($badVanilla -eq 0) { Good "vanilla item / block / entity ids all resolve" }
}

# ---------------------------------------------------------------------------
# 2.9c BOSS PERCENTAGE GATES  (v0.7.10)
# ---------------------------------------------------------------------------
# boss/spawn/* computes the HP gates with scoreboard arithmetic:
#     #TH_75 = #MAXHP ; #TH_75 *= #C3 ; #TH_75 /= #C2
# which silently evaluated to 150% -- so "HP <= 75%" was ALWAYS true (the recast
# king's golden bulwark fired from full health). Nothing noticed for many versions.
# This rule re-evaluates each #TH_* chain from the file's own constants and FAILs
# when the result is not in (0%, 100%].
$thChains = 0; $thBad = 0
$reThSet = '^scoreboard players set (#C\d+) tspire_timer (-?\d+)$'
$reThStart = '^scoreboard players operation (#TH_\w+) tspire_timer = #MAXHP tspire_timer$'
foreach ($f in $fnFiles) {
    $rel = $f.FullName.Substring($fnRoot.Length + 1).Replace("\", "/")
    if ($rel -notlike 'boss/spawn/*') { continue }
    $const = @{}
    $fileLines = [System.IO.File]::ReadAllLines($f.FullName, [System.Text.Encoding]::UTF8)
    foreach ($line in $fileLines) {
        $t = $line.Trim()
        if ($t -match $reThSet) { $const[$Matches[1]] = [double]$Matches[2] }
    }
    $cur = $null; $val = 0.0; $ln = 0; $i = 0
    foreach ($line in $fileLines) {
        $i++
        $t = $line.Trim()
        if ($t -match $reThStart) {
            # a new chain starts here -- validate the previous one first
            if ($null -ne $cur) {
                $thChains++
                if ($val -gt 1.0 -or $val -le 0) {
                    Fail ("$rel line $ln : $cur is " + [math]::Round($val * 100, 1) + "% of max HP (must be 0-100%) -- that gate never or always fires")
                    $thBad++
                }
            }
            $cur = $Matches[1]; $val = 1.0; $ln = $i; continue
        }
        if ($null -ne $cur) {
            $reOp = '^scoreboard players operation ' + [regex]::Escape($cur) + ' tspire_timer ([*/]=) (#C\d+) tspire_timer$'
            if ($t -match $reOp) {
                $op = $Matches[1]; $c = $Matches[2]
                if ($const.ContainsKey($c)) {
                    if ($op -eq '*=') { $val = $val * $const[$c] }
                    elseif ($const[$c] -ne 0) { $val = $val / $const[$c] }
                    else { $val = 999 }
                }
                continue
            }
            $thChains++
            if ($val -gt 1.0 -or $val -le 0) {
                Fail ("$rel line $ln : $cur is " + [math]::Round($val * 100, 1) + "% of max HP (must be 0-100%) -- that gate never or always fires")
                $thBad++
            }
            $cur = $null
        }
    }
    if ($null -ne $cur) {
        $thChains++
        if ($val -gt 1.0 -or $val -le 0) {
            Fail ("$rel line $ln : $cur is " + [math]::Round($val * 100, 1) + "% of max HP (must be 0-100%)")
            $thBad++
        }
    }
}
if ($thChains -eq 0) { Warn "no boss percentage chains found -- rule 2.9c checked nothing" }
elseif ($thBad -eq 0) { Good ("boss percentage gates all within 0-100% ({0} chains)" -f $thChains) }

# ---------------------------------------------------------------------------
# 2.9d SYNTAX NEWER THAN 1.20.1  (v0.7.14)
# ---------------------------------------------------------------------------
# `execute if items` was added in 1.20.5. The pack is 1.20.1, so a single such line makes the
# WHOLE function fail to load -- and when that function is tick/second, the run stops dead
# (the startup state machine lives there: the player got stuck at "preparing the draft room").
# Check the modern-only syntax we could plausibly reach for.
$newSyntax = @(
    @{ p = '\bif items\b'          ; why = 'added in 1.20.5' },
    @{ p = '\bexecute if function\b'; why = 'added in 1.20.2' },
    @{ p = '^\s*return\b'          ; why = 'added in 1.20.2' },
    @{ p = '\bsetblock\b[^{]*\s\{' ; why = '/setblock NBT must be GLUED to the block (<block>{nbt}); the space-separated form is 1.20.5+, and writing it makes the whole function fail to load' }
)
$newHits = 0
foreach ($l in $lines) {
    $t = $l.Text
    if ($t -match '^\s*#') { continue }
    foreach ($n in $newSyntax) {
        if ($t -match $n.p) {
            Fail ((Where-Line $l.Rel $l.No) + ' uses syntax that does not exist in 1.20.1 (' + $n.why + ') -- the whole function will fail to load')
            $newHits++
        }
    }
}
if ($newHits -eq 0) { Good "no post-1.20.1 command syntax" }

# ---------------------------------------------------------------------------
# 2.9e OBJECTIVES MUST BE DECLARED  (v0.7.14)
# ---------------------------------------------------------------------------
# Minecraft resolves objective names at PARSE time: referencing an objective that was never
# created with `scoreboard objectives add` makes the whole function fail to load with
# "Unknown scoreboard objective". That is exactly how tspire_offer_f broke the three
# three-choose-one handlers (clicking a candidate silently did nothing).
$objRefs = 0; $objBad = 0
foreach ($l in $lines) {
    $t = $l.Text
    if ($t -match '^\s*#') { continue }
    if ($t -match 'scoreboard\s+objectives\s+add') { continue }
    $cands = @()
    foreach ($m in [regex]::Matches($t, '(?:if|unless)\s+score\s+\S+\s+(\S+)')) { $cands += $m.Groups[1].Value }
    foreach ($m in [regex]::Matches($t, 'scoreboard\s+players\s+(?:set|add|remove|reset|enable|get|operation)\s+\S+\s+(\S+)')) { $cands += $m.Groups[1].Value }
    foreach ($m in [regex]::Matches($t, 'store\s+(?:result|success)\s+score\s+\S+\s+(\S+)')) { $cands += $m.Groups[1].Value }
    foreach ($o in $cands) {
        if ($o -notmatch '^[A-Za-z_]') { continue }
        $objRefs++
        if (-not $declaredObjectives.ContainsKey($o)) {
            Fail ((Where-Line $l.Rel $l.No) + " references undeclared objective '" + $o + "' -- the whole function will fail to load")
            $objBad++
        }
    }
}
if ($objBad -eq 0) { Good ("scoreboard objectives all declared ({0} references)" -f $objRefs) }

# ---------------------------------------------------------------------------
# 2.9f SCOREBOARD OPERATION ARITY  (v0.7.15)
# ---------------------------------------------------------------------------
# `scoreboard players operation <targets> <objective> <op> <source> <objective>` takes the
# target's objective ONCE and then immediately an operator. Writing the objective twice
#      scoreboard players operation @s tspire_offer_f tspire_timer = #REW_F tspire_timer
# makes the command unparsable, so the whole function fails to load -- the reward buttons then
# answered "unknown command" in chat. Check the shape of every operation command.
$opBad = 0
foreach ($l in $lines) {
    $t = $l.Text
    if ($t -match '^\s*#') { continue }
    if ($t -notmatch 'scoreboard\s+players\s+operation\s') { continue }
    # strip the run/execute prefix, look at the tail of the line
    $tail = $t
    $idx = $tail.LastIndexOf('scoreboard players operation ')
    if ($idx -lt 0) { continue }
    $tail = $tail.Substring($idx)
    if ($tail -notmatch '^scoreboard players operation (\S+) (\S+) (=|\+=|-=|\*=|/=|%=|><|<|>) (\S+) (\S+)(\s|$)') {
        Fail ((Where-Line $l.Rel $l.No) + ' malformed scoreboard operation (want: operation <target> <obj> <op> <source> <obj>)')
        $opBad++
    }
}
if ($opBad -eq 0) { Good "scoreboard operation commands are well formed" }

# ---------------------------------------------------------------------------
# 3. per-line command checks
# ---------------------------------------------------------------------------
$refFunc = 0; $refLoot = 0; $refPred = 0; $refMod = 0; $refTag = 0
$usedFuncs = @{}
$thisFileAsFunc = @{}

foreach ($l in $lines) {
    $t = $l.Text
    if ($t -match '^\s*#') { continue }
    $where = Where-Line $l.Rel $l.No

    $thisFileAsFunc['tspire:' + ($l.Rel -replace '\.mcfunction$', '')] = $true

    # --- double namespace ------------------------------------------------
    if ($t -match '\bminecraft:tconstruct:') { Fail ("$where double namespace: minecraft:tconstruct:") }
    if ($t -match '\bminecraft:tspire:')     { Fail ("$where double namespace: minecraft:tspire:") }

    # --- snake_case event fields ----------------------------------------
    if ($t -match 'click_event|hover_event') { Fail ("$where snake_case click_event/hover_event is ignored in 1.20.1") }

    # --- bossbar ---------------------------------------------------------
    if ($t -match 'bossbar\s+set\s+\S+\s+color\s+(\S+)') {
        if ($bossbarColors -notcontains $Matches[1]) { Fail ("$where illegal bossbar color '$($Matches[1])' -- kills the whole load function") }
    }
    if ($t -match 'bossbar\s+set\s+\S+\s+style\s+(\S+)') {
        if ($bossbarStyles -notcontains $Matches[1]) { Fail ("$where illegal bossbar style '$($Matches[1])'") }
    }

    # --- matches must use a literal, never a score holder ----------------
    if ($t -match 'matches\s+#[A-Za-z_]') { Fail ("$where 'matches' given a score holder; it only takes literals") }

    # --- matches: no comma lists -----------------------------------------
    # 1.20.1 takes exactly ONE value or a single range. A comma list such as
    # "matches 1,6,11" parses the 1 and then chokes, killing the whole function
    # at load time (this actually happened in boss/quencher_zone_burn).
    if ($t -match 'matches\s+-?\d+\s*,') { Fail ("$where 'matches' comma list is invalid in 1.20.1 -- write one command per value") }

    # --- particle: the count argument must be a whole number --------------
    # particle <id> [extra args...] <x y z> <dx dy dz> <speed> <count> [mode]
    # speed may be a float but count MUST be an int, and writing them the other
    # way round (count first) makes the WHOLE function fail to load with
    # "Invalid integer data". This bit 23 lines across the v0.6.35+ boss work.
    # v0.6.61 (todo #9): particles that take EXTRA arguments are checked too, by
    # skipping exactly as many leading tokens as that particle type needs. Only
    # `vibration` stays exempt (its destination is either a block position or an
    # entity selector, so its token count is not fixed).
    $paramArgCount = @{
        'dust' = 4; 'dust_color_transition' = 7; 'block' = 1; 'block_marker' = 1
        'falling_dust' = 1; 'item' = 1; 'sculk_charge' = 1; 'shriek' = 1
    }
    if ($t -match '\bparticle\s+([a-z0-9_:]+)\s+(.*)$') {
        $partId = $Matches[1] -replace '^minecraft:', ''
        $tok    = ($Matches[2].Trim() -split '\s+')
        $skip   = 0
        if ($paramArgCount.ContainsKey($partId)) { $skip = $paramArgCount[$partId] }
        $idx    = $skip + 7     # 3 position + 3 delta + 1 speed come before the count
        if ($tok.Count -gt $idx -and $partId -ne 'vibration') {
            $partCount = $tok[$idx]
            if ($partCount -notmatch '^-?\d+$') {
                Fail ("$where particle count '$partCount' is not a whole number -- kills the whole function at load")
            }
        }
    }

    # --- tconstruct effect ids must be real --------------------------------
    # v0.6.50: the duelist now uses Tinkers effects (tconstruct:bleeding / piercing).
    # A typo silently kills the function at load, so validate them against the lang keys.
    if ($t -match '\beffect\s+give\s+\S+\s+tconstruct:([a-z_]+)') {
        if ($tcEffectIds -notcontains $Matches[1]) {
            Fail ("$where unknown tconstruct effect '$($Matches[1])' -- not in the Tinkers lang")
        }
    }

    # --- particle ids that are NOT valid in 1.20.1 ------------------------
    # "minecraft:poison" does not exist (the poison-looking one is witch).
    if ($t -match '\bparticle\s+minecraft:poison\b') { Fail ("$where minecraft:poison is not a 1.20.1 particle -- use minecraft:witch") }

    # --- /damage takes exactly ONE entity --------------------------------
    # v0.6.46: `damage @a[...]` fails to load with "only one entity allowed" and the
    # whole function then silently never runs (this killed the burn damage and the
    # reflect / pressure hits). Correct form: `as @a[...] run damage @s ...`
    # `@p` / `@r` / `@s` always resolve to a single entity, so only @a / @e are checked.
    if ($t -match '\bdamage\s+@[ae]\[(?![^\]]*limit=1)') {
        Fail ("$where /damage takes exactly one entity -- use 'as @a[...] run damage @s' instead")
    }

    # --- /attribute is banned until a form is verified in game ------------
    # v0.6.38 / v0.6.42 used `attribute ... modifier add <uuid> <name> <value> multiply_total`
    # and 1.20.1 rejected the operation argument AT LOAD TIME, silently disabling
    # the duelist and molten-lord mechanics. Use effects instead.
    if (($t -match '^\s*attribute\s' -or $t -match '\brun attribute\s') -and $t -notmatch '\brun attribute\s+\S+\s+minecraft:generic\.(attack_damage|armor|armor_toughness)\s+get\s+100\s*$') {
        Fail ("$where /attribute is banned: the 1.20.1 operation name was rejected twice at load time")
    }

    # --- NBT tag paths are case sensitive --------------------------------
    # v0.6.47: `Item.count` / `SelectedItem.count` are not tags (they are `Count`).
    # `execute store result ... run data get entity @s Item.count` fails, leaves the score
    # untouched, and if that score is then used as a multiplier the result is silently 0.
    if ($t -cmatch '\bItem\.count\b|\bSelectedItem\.count\b') {
        Fail ("$where NBT tag is case sensitive -- use Count (capital C), not count")
    }

    # --- effect vs particle confusion -------------------------------------
    # v0.6.45: a blind "poison -> witch" replace hit an `effect give` line too.
    # "witch" is a PARTICLE and "poison" is an EFFECT, and getting it wrong makes
    # the command unresolvable -> the whole function silently fails to load.
    # Rule A: `effect give ... minecraft:<id>` must name a real status effect.
    if ($t -match '\beffect\s+give\s+\S+\s+minecraft:([a-z_]+)') {
        $effId = $Matches[1]
        if ($effectIds -notcontains $effId) {
            Fail ("$where 'minecraft:$effId' is not a 1.20.1 status effect (is it a particle?) -- kills the whole function at load")
        }
    }
    # Rule B: `particle minecraft:<id>` must not name a status effect.
    if ($t -match '\bparticle\s+minecraft:([a-z_]+)') {
        $ptId = $Matches[1]
        if ($effectIds -contains $ptId) {
            Fail ("$where 'minecraft:$ptId' is a status effect, not a particle -- kills the whole function at load")
        }
    }

    # --- trailing "# comment" after a JSON component (v0.7.1) -------------
    # `scoreboard objectives add X dummy {"text":".."} # note` is NOT valid:
    # a # starts a comment only as the first character of a line, so the tail
    # reaches the parser and kills the whole function -- that is how tspire:load
    # failed and took every objective declaration down with it.
    # Strings are stripped first, so fake players (#SCORE) are not false hits.
    $bareHash = [regex]::Replace($t, '"(?:[^"\\]|\\.)*"', '""')
    if ($bareHash -match '\s#\s') {
        Fail ("$where trailing '#' comment on a command line -- not allowed in mcfunction, kills the whole function at load")
    }

    # --- fill needs 6 coordinates (v0.7.1) --------------------------------
    # `fill x1 y1 z1 x2 y2 block` fails at load with "Expected integer"
    # (test/boss_arena_build had this and never built its floor).
    if ($t -match '^\s*fill\s+(.+)$') {
        $ftok = ($Matches[1].Trim() -split '\s+')
        if ($ftok.Count -lt 7) {
            Fail ("$where fill has $($ftok.Count) tokens, needs 7 (6 coordinates + block) -- kills the whole function at load")
        }
    }

    # --- function calls ---------------------------------------------------
    foreach ($m in [regex]::Matches($t, '\bfunction\s+([a-z0-9_]+:[a-z0-9_/.#]+)')) {
        $target = $m.Groups[1].Value
        if ($target.StartsWith('#')) {
            $refTag++
            if (-not $funcTags.ContainsKey($target.Substring(1))) { Fail ("$where missing function tag $target") }
            continue
        }
        $refFunc++
        $usedFuncs[$target] = $true
        if (-not (Test-DataFile ($target -split ':')[0] 'functions' ($target -split ':', 2)[1])) {
            Fail ("$where missing function $target")
        }
    }

    # --- loot table references -------------------------------------------
    foreach ($m in [regex]::Matches($t, '\bloot\s+([a-z0-9_]+:[a-z0-9_/]+)')) {
        $refLoot++
        $ns = ($m.Groups[1].Value -split ':')[0]
        if (-not (Test-DataFile $ns 'loot_tables' ($m.Groups[1].Value -split ':', 2)[1])) {
            Fail ("$where missing loot table $($m.Groups[1].Value)")
        }
    }

    # --- predicate references --------------------------------------------
    foreach ($m in [regex]::Matches($t, '\bif\s+predicate\s+([a-z0-9_]+:[a-z0-9_/]+)')) {
        $refPred++
        $ns = ($m.Groups[1].Value -split ':')[0]
        if (-not (Test-DataFile $ns 'predicates' ($m.Groups[1].Value -split ':', 2)[1])) {
            Fail ("$where missing predicate $($m.Groups[1].Value)")
        }
    }

    # --- item modifier references ----------------------------------------
    # command form: item modify <targets> <slot> <modifier>
    foreach ($m in [regex]::Matches($t, '\bitem\s+modify\s+\S+\s+\S+\s+\S+\s+([a-z0-9_]+:[a-z0-9_/]+)')) {
        $refMod++
        $ns = ($m.Groups[1].Value -split ':')[0]
        if (-not (Test-DataFile $ns 'item_modifiers' ($m.Groups[1].Value -split ':', 2)[1])) {
            Fail ("$where missing item modifier $($m.Groups[1].Value)")
        }
    }

    # --- store target objective must exist --------------------------------
    foreach ($m in [regex]::Matches($t, 'store\s+(?:result|success)\s+score\s+\S+\s+([A-Za-z0-9_]+)')) {
        if (-not $declaredObjectives.ContainsKey($m.Groups[1].Value)) {
            Fail ("$where store target objective '$($m.Groups[1].Value)' was never created")
        }
    }

    # --- item ids in give / item replace ... with / clear ------------------
    foreach ($m in [regex]::Matches($t, '(?<!effect )\bgive\s+\S+\s+([a-z0-9_]+:[a-z0-9_/]+)')) {
        $id = $m.Groups[1].Value
        if ($id -like 'tconstruct:*' -and -not $tcItemIds.ContainsKey($id)) { Fail ("$where unknown tconstruct item '$id' -> the whole function fails to load") }
    }
    foreach ($m in [regex]::Matches($t, '\bwith\s+([a-z0-9_]+:[a-z0-9_/]+)')) {
        $id = $m.Groups[1].Value
        if ($id -like 'tconstruct:*' -and -not $tcItemIds.ContainsKey($id)) { Fail ("$where unknown tconstruct item '$id' -> the whole function fails to load") }
    }
    foreach ($m in [regex]::Matches($t, '\bclear\s+\S+\s+([a-z0-9_]+:[a-z0-9_/]+)')) {
        $id = $m.Groups[1].Value
        if ($id -like 'tconstruct:*' -and -not $tcItemIds.ContainsKey($id)) { Fail ("$where unknown tconstruct item '$id' in clear") }
    }

    # --- block ids from Tinkers (setblock / fill) -------------------------
    if ($t -match '^\s*(setblock|fill)\s') {
        $toks = ($t -split '\s+') | Where-Object { $_ -ne '' }
        $i = 1
        # skip x y z (and for fill, the second corner)
        while ($i -lt $toks.Count -and $toks[$i] -match '^[~^]?-?[\d.]*$') { $i++ }
        if ($toks[0] -eq 'fill') { while ($i -lt $toks.Count -and $toks[$i] -match '^[~^]?-?[\d.]*$') { $i++ } }
        if ($i -lt $toks.Count) {
            $blk = ($toks[$i] -split '\[')[0]
            if ($blk -like 'tconstruct:*' -and -not $tcBlocks.ContainsKey($blk)) {
                Warn ("$where unknown tconstruct block '$blk'")
            }
        }
    }
}
Good ("references checked: {0} function, {1} tag, {2} loot, {3} predicate, {4} modifier" -f $refFunc, $refTag, $refLoot, $refPred, $refMod)

# ---------------------------------------------------------------------------
# 4. double spaces in the command-argument area
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# 4.5 tower-only entities must be addressed with `execute in tspire:tower`
# ---------------------------------------------------------------------------
# Node markers, shop chests, starter chests and the offer chest only ever exist
# in tspire:tower. A bare `kill @e[tag=tspire_node]` runs in whatever dimension
# the caller happens to be in -- from tick/second that is the OVERWORLD, so the
# old markers were never removed and the next map's markers stacked on top of
# them (one row ended up with 5..7 rooms). This check makes that visible.
$towerOnly = @('tspire_node', 'tspire_shop', 'tspire_starter', 'tspire_offer', 'tspire_anchor', 'tspire_merchant_npc')
foreach ($l in $lines) {
    $t = $l.Text
    if ($t -match '^\s*#') { continue }
    if ($t -match 'tellraw|hoverEvent|contents') { continue }   # help text, not a command
    $sawNode = $false
    foreach ($tag in $towerOnly) { if ($t -match ("@e\[[^\]]*\b" + $tag + "\b")) { $sawNode = $true } }
    if (-not $sawNode) { continue }
    # `at @e[...]` / `as @e[...]` inherit the dimension from the target, that is fine;
    # what is NOT fine is a bare selector in a destructive command.
    if ($t -match '^\s*(kill|tag)\s') {
        Fail ((Where-Line $l.Rel $l.No) + " tower-only selector without dimension: $t")
    }
}

# ---------------------------------------------------------------------------
# 4.6 SNBT only understands \\" and \\\\ as escapes
# ---------------------------------------------------------------------------
# A bare \n inside a quoted NBT string makes the WHOLE command fail to parse
# ("invalid escape sequence"). That killed every map preset function: no node
# markers, no rooms, and no map book. To get a real newline in a book page you
# must write a JSON text component and double-escape it (\\n).
foreach ($l in $lines) {
    $t = $l.Text
    if ($t -match '^\s*#') { continue }
    $bad = [regex]::Matches($t, '(?<!\\)\\[ntru]')
    if ($bad.Count -gt 0) { Fail ((Where-Line $l.Rel $l.No) + " invalid SNBT escape '" + $bad[0].Value + "' -> the whole function fails to load") }
}

$dbl = 0
foreach ($l in $lines) {
    $t = $l.Text
    if ($t -match '^\s*#') { continue }
    # Blank out quoted spans (tellraw / title JSON) first: runs of spaces inside a
    # JSON string are harmless, only the command-argument area matters.
    $bare = [regex]::Replace($t, '"(?:[^"\\]|\\.)*"', '""')
    if ($bare -match '\S\s{2,}\S') { Fail ((Where-Line $l.Rel $l.No) + " two spaces between arguments -> Brigadier breaks, function fails to load"); $dbl++ }
}
if ($dbl -eq 0) { Good "no double spaces in command arguments" }

# ---------------------------------------------------------------------------
# 4b. `execute if score <t> <obj> <op> <holder>` missing the source OBJECTIVE
# ---------------------------------------------------------------------------
# The full syntax is
#     execute if|unless score <target> <targetObjective> <op> <source> <sourceObjective>
# and BOTH objectives are mandatory. Writing `unless score @s tspire_shop_f = #FLOOR`
# made the WHOLE function fail to load ("Whilst parsing command on line N ... #FLOOR if"),
# which silently disabled the merchant node in v0.6.21. This check exists so the same
# mistake can never ship again.
$scoreBad = 0
foreach ($l in $lines) {
    $t = $l.Text
    if ($t -match '^\s*#') { continue }
    $bare = [regex]::Replace($t, '"(?:[^"\\]|\\.)*"', '""')
    # operator followed by a single token and then if/unless/run/end -> objective missing
    if ($bare -match 'score\s+\S+\s+\S+\s*(<=|>=|=|<|>)\s*\S+\s+(if|unless|run)\b') {
        Fail ((Where-Line $l.Rel $l.No) + " 'score ... <op> <holder>' is missing the source objective -> the whole function fails to load")
        $scoreBad++
    }
}
if ($scoreBad -eq 0) { Good "every 'execute ... score' comparison names both objectives" }

# ---------------------------------------------------------------------------
# 4c. nothing under mobs/ or boss/ may write #FLOOR
# ---------------------------------------------------------------------------
# mobs/groups/* used to emit `scoreboard players set #FLOOR tspire_timer <floor>`,
# and the hand-written boss/spawn/* carried WRONG values (the FLOOR-2 boss set 3,
# the floor-1 bosses set 2). Result: killing the floor-1 boss pushed #FLOOR to 2,
# then run/floor_advance made it 3 and the party was teleported to FLOOR 3.
# #FLOOR may only be changed by run/start_run and run/floor_advance.
$floorBad = 0
foreach ($l in $lines) {
    if ($l.Text -match '^\s*#') { continue }
    if ($l.Rel -notmatch '^(mobs|boss)/') { continue }
    if ($l.Text -match '#FLOOR\s+tspire_timer\s+(set|add|remove|reset|operation)') {
        Fail ((Where-Line $l.Rel $l.No) + " writes #FLOOR -> only run/start_run and run/floor_advance may; corrupting it sends the party to the wrong floor")
        $floorBad++
    }
}
if ($floorBad -eq 0) { Good "mobs/ and boss/ never write #FLOOR" }

# ---------------------------------------------------------------------------
# 4d. execute chaining: bare keyword at line start, or `run <keyword>`
# ---------------------------------------------------------------------------
# v0.6.60: two boss functions ended with a bare `at @s run particle ...` (the
# `execute` was missing) and boss/moltenlord_lava_zone had
# `... matches 20 run as @a[...] run damage` (a `run` in the middle -- `run` must
# be the LAST keyword of the chain). Both are parse errors, so Minecraft prints
# "Failed to load function ..." and the ENTIRE function silently never runs.
# Also: /data merge|modify|get entity takes exactly ONE entity.
$chainBad = 0
foreach ($l in $lines) {
    if ($l.Text -match '^\s*#') { continue }
    $bare = ([regex]::Replace($l.Text, '"(?:[^"\\]|\\.)*"', '""')).Trim()
    if ($bare -match '^(at|as|if|unless|in|positioned|facing|on|align|anchored|rotated|store)\s') {
        Fail ((Where-Line $l.Rel $l.No) + " line starts with '$($Matches[1])' but there is no 'execute' -> the whole function fails to load")
        $chainBad++
    }
    if ($bare -match '\brun\s+(as|at|in|positioned|facing|on|align|anchored|rotated|if|unless|store)\s') {
        Fail ((Where-Line $l.Rel $l.No) + " 'run $($Matches[1])' is not a command -- 'run' must come last -> the whole function fails to load")
        $chainBad++
    }
    if ($bare -match '\bdata\s+(merge|modify|get)\s+entity\s+(@[aepr]\S*)') {
        $sel = $Matches[2]
        if ($sel -notmatch 'limit=1' -and $sel -notmatch '^@[spr]') {
            Fail ((Where-Line $l.Rel $l.No) + " '$sel' can match several entities but '/data ... entity' takes exactly one (add limit=1)")
            $chainBad++
        }
    }
}
if ($chainBad -eq 0) { Good "execute chains and /data entity selectors are well formed" }

# ---------------------------------------------------------------------------
# 4e. particle ids must exist in 1.20.1
# ---------------------------------------------------------------------------
# v0.6.60: boss/recastking_summon used `particle minecraft:gold_block ...`, which
# is not a particle at all ("unknown particle") and killed the whole
# function (so the summon never ran). The id below is the FIRST argument; extra
# arguments (e.g. `particle minecraft:block minecraft:gold_block`) come after it.
# If a legitimate NEW particle is ever flagged, add it to this list.
$particleIds = @(
    'ambient_entity_effect', 'angry_villager', 'ash', 'block', 'block_marker', 'bubble',
    'bubble_column_up', 'bubble_pop', 'campfire_cosy_smoke', 'campfire_signal_smoke', 'cherry_leaves',
    'cloud', 'composter', 'crimson_spore', 'crit', 'damage_indicator', 'dolphin', 'dragon_breath',
    'dripping_dripstone_lava', 'dripping_dripstone_water', 'dripping_honey', 'dripping_lava',
    'dripping_obsidian_tear', 'dripping_water', 'dust', 'dust_color_transition', 'dust_pillar',
    'effect', 'electric_spark', 'enchant', 'enchanted_hit', 'end_rod', 'entity_effect', 'explosion',
    'explosion_emitter', 'falling_dripstone_lava', 'falling_dripstone_water', 'falling_dust',
    'falling_honey', 'falling_lava', 'falling_nectar', 'falling_obsidian_tear',
    'falling_spore_blossom', 'falling_water', 'firework', 'fishing', 'flame', 'flash', 'glow',
    'glow_squid_ink', 'happy_villager', 'heart', 'instant_effect', 'item', 'item_cobweb', 'item_slime',
    'item_snowball', 'landing_honey', 'landing_lava', 'landing_obsidian_tear', 'large_smoke', 'lava',
    'mycelium', 'nautilus', 'note', 'poof', 'portal', 'rain', 'reverse_portal', 'scrape',
    'sculk_charge', 'sculk_charge_pop', 'sculk_dust', 'sculk_soul', 'shriek', 'small_flame', 'smoke',
    'sneeze', 'snowflake', 'sonic_boom', 'soul', 'soul_fire_flame', 'spore_blossom_air', 'splash',
    'spit', 'squid_ink', 'sweep_attack', 'totem_of_undying', 'underwater', 'vibration', 'warped_spore',
    'wax_off', 'wax_on', 'white_ash', 'white_smoke', 'witch'
)
$partBad = 0
foreach ($l in $lines) {
    if ($l.Text -match '^\s*#') { continue }
    $bare = [regex]::Replace($l.Text, '"(?:[^"\\]|\\.)*"', '""')
    foreach ($m in [regex]::Matches($bare, '\bparticle\s+(?:minecraft:)?([a-z_]+)')) {
        if ($particleIds -notcontains $m.Groups[1].Value) {
            Fail ((Where-Line $l.Rel $l.No) + " 'particle $($m.Groups[1].Value)' is not a 1.20.1 particle -> the whole function fails to load")
            $partBad++
        }
    }
}
if ($partBad -eq 0) { Good "every particle id used exists in 1.20.1" }

# ---------------------------------------------------------------------------
# 4f. no hard-coded boss HP gates (scores={tspire_boss_hp=..N})
# ---------------------------------------------------------------------------
# This bit the project TWICE:
#   v0.6.61 #27 -- boss/moltenlord used "..300" / "..425" (values picked for a
#                  1-player 500 HP bar) -> 60%/85% solo but 40%/57% with 3 players.
#   v0.6.62 #31 -- boss/inscriber_bookworm used "..375", which was 50% of the old
#                  750 HP bar; after the 500/600/750 rescale it silently became
#                  75%/62.5%/50%, so the third silverfish spawned far too early.
# Boss HP now scales with the party, so every gate must compare SCORES
# (`#BNOW` vs `#TH_75` / `#TH_HALF` / `#TH_40` / `#TH_25`, or a 0/1 flag score when
# a selector needs it). test/ files are exempt: they are diagnostics.
$hpGateBad = 0
foreach ($l in $lines) {
    if ($l.Text -match '^\s*#') { continue }
    if ($l.Rel -like 'test/*') { continue }
    if ($l.Text -match 'scores=\{[^}]*tspire_boss_hp\s*=\s*[.\-0-9]') {
        Fail ((Where-Line $l.Rel $l.No) + " hard-coded boss HP gate -- boss HP scales with the party, use '#BNOW' vs '#TH_*' (or a 0/1 flag score)")
        $hpGateBad++
    }
}
if ($hpGateBad -eq 0) { Good "no hard-coded boss HP gates (boss HP scales with the party)" }

# ---------------------------------------------------------------------------
# 4g. command shape checks for past generator accidents
# ---------------------------------------------------------------------------
$shapeBad = 0
foreach ($l in $lines) {
    if ($l.Text -match '^\s*(#|$)') { continue }
    $bare = [regex]::Replace($l.Text, '"(?:[^"\\]|\\.)*"', '""')
    if ($l.Text -match 'DisabledSlots:\d+b\b') {
        Fail ((Where-Line $l.Rel $l.No) + " DisabledSlots must be an int; a byte suffix loses the lock bits")
        $shapeBad++
    }
    # A second namespaced id after the entity id is never a summon coordinate.
    if ($bare -match '\bsummon\s+\S+\s+([a-z_]+:[a-z_]+)\b') {
        Fail ((Where-Line $l.Rel $l.No) + " summon has a second entity id where coordinates should be")
        $shapeBad++
    }
    # A bare entity name is also invalid in the coordinate slot.
    if ($bare -match '\bsummon\s+\S+\s+([a-z_]+)\s+(~|\^|-?\d)' -and $Matches[1] -notin @('minecraft','tconstruct')) {
        Fail ((Where-Line $l.Rel $l.No) + " summon has an extra word before coordinates")
        $shapeBad++
    }
    if ($bare -match '\bfill\s+([^\{]+)') {
        $args = $Matches[1].Trim() -split '\s+'
        if ($args.Count -lt 7 -or $args[0..5] -match '^(minecraft:|tconstruct:)' -or $args[6] -notmatch '^(?:[a-z0-9_]+:)?[a-z0-9_]+(\[.*\])?$') {
            Fail ((Where-Line $l.Rel $l.No) + " fill needs six coordinates followed by a block id")
            $shapeBad++
        }
        if ($args.Count -ge 8 -and $args[7] -notin @('replace','keep','destroy','hollow','outline')) {
            Fail ((Where-Line $l.Rel $l.No) + " fill has an invalid mode after the block id")
            $shapeBad++
        }
    }
}
if ($shapeBad -eq 0) { Good "summon and fill command shapes look valid" }

# ---------------------------------------------------------------------------
# 4b. clickable chat actions and service-node routing
# ---------------------------------------------------------------------------
& node (Join-Path $PSScriptRoot 'check-click-triggers.js')
if ($LASTEXITCODE -ne 0) { Fail "clickable chat action audit failed" }

# ---------------------------------------------------------------------------
# 5. orphan functions (generated but never called) -- informational
# ---------------------------------------------------------------------------
$skipPrefix = @('test/', 'load', 'tick', 'config/', 'music/rp_on', 'music/rp_off', 'gui/pick_armor')
$orphans = @()
foreach ($k in $thisFileAsFunc.Keys) {
    $short = $k.Substring('tspire:'.Length)
    if ($usedFuncs.ContainsKey($k)) { continue }
    $skip = $false
    foreach ($p in $skipPrefix) { if ($short -like ($p + '*')) { $skip = $true } }
    if (-not $skip) { $orphans += $short }
}
if ($orphans.Count -gt 0) { Warn ("{0} function(s) never referenced: {1}" -f $orphans.Count, (($orphans | Sort-Object) -join ', ')) }
else { Good "no orphan functions" }

# ---------------------------------------------------------------------------
# summary
# ---------------------------------------------------------------------------
Write-Host ""
if ($script:fails -eq 0) {
    Write-Host ("PASS  {0} warning(s), 0 failures" -f $script:warns) -ForegroundColor Green
    exit 0
} else {
    Write-Host ("FAIL  {0} failure(s), {1} warning(s)" -f $script:fails, $script:warns) -ForegroundColor Red
    exit 1
}

