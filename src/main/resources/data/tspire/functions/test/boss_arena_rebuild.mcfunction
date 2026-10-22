# ============================================================
# Boss 单挑 · 只重建场地（不生成 Boss）—— v0.7.2：真实 BOSS 房
# ============================================================
# 由 test/boss_arena_check 的按钮或手动调用。与 boss_arena_setup 的区别：
#   不重设 #PARTY_SIZE、不清小怪残留表、**不调用 run/battle_start**（不自动开战）。
# 需要 #FLOOR 已经是对的（boss_pick_<id> 会设好；手动调用前请自己设）。
# ============================================================

function tspire:run/enter_tower
execute in tspire:tower run kill @e[tag=tspire_boss]
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_kb_rot]
execute in tspire:tower run kill @e[tag=tspire_arrow]

# forceload + 建层（boss_arena_build = forceload + map/build_floor）
function tspire:test/boss_arena_build

# 真实 BOSS 节点 -> 当前节点（重建会杀掉旧的 node marker，所以标签要重新打）
execute in tspire:tower run tag @e[tag=tspire_node,tag=tspire_type_boss] add tspire_test_node
execute in tspire:tower run tag @e[tag=tspire_node,tag=tspire_type_boss] add tspire_node_current
execute in tspire:tower run tag @e[tag=tspire_node,tag=tspire_type_boss] add tspire_node_avail

execute if score #FLOOR tspire_timer matches ..1 in tspire:tower run tp @a[team=tspire_party] 0 64 -374
execute if score #FLOOR tspire_timer matches 2 in tspire:tower run tp @a[team=tspire_party] 0 96 -374
execute if score #FLOOR tspire_timer matches 3.. in tspire:tower run tp @a[team=tspire_party] 0 128 -374
execute in tspire:tower run gamemode adventure @a[team=tspire_party]
execute in tspire:tower as @a[team=tspire_party] at @s run spawnpoint @s ~ ~ ~

tellraw @a[team=tspire_party] [{"text":"[BOSS 房] ","color":"gold"},{"text":"真实楼层与 BOSS 房已重建，全队已就位。","color":"green"}]
