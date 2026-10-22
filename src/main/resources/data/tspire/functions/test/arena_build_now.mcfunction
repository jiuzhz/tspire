# 第 1 拍：真正建层。执行者/位置无关（build_floor 自己锚在 (0,64,0)）。
function tspire:test/boss_arena_build

# 先清掉**所有**旧的 tspire_test_node（尤其是旧版测试场留下的那个，否则 limit=1 会挑错）
execute in tspire:tower run kill @e[tag=tspire_test_node]

# 真实 BOSS 节点 -> 当前节点
execute in tspire:tower run tag @e[tag=tspire_node,tag=tspire_type_boss] add tspire_test_node
execute in tspire:tower run tag @e[tag=tspire_node,tag=tspire_type_boss] add tspire_node_current
execute in tspire:tower run tag @e[tag=tspire_node,tag=tspire_type_boss] add tspire_node_avail

# 全队进房间（BOSS 节点 z=-390，房间内部 z -404..-376）
execute if score #FLOOR tspire_timer matches ..1 in tspire:tower run tp @a[team=tspire_party] 0 64 -374
execute if score #FLOOR tspire_timer matches 2 in tspire:tower run tp @a[team=tspire_party] 0 96 -374
execute if score #FLOOR tspire_timer matches 3.. in tspire:tower run tp @a[team=tspire_party] 0 128 -374
execute in tspire:tower as @a[team=tspire_party] at @s run spawnpoint @s ~ ~ ~
function tspire:run/battle_start

# 自检：如果这一拍之后还是没有真实节点，说明区块仍没加载 —— 报告出来而不是静默跑偏
execute unless entity @e[tag=tspire_test_node] run tellraw @a[team=tspire_party] [{"text":"[测试] ","color":"gold"},{"text":"警告：没有找到真实 BOSS 节点，场地可能没建起来。请再点一次，或跑 /function tspire:test/boss_arena_check","color":"red"}]
scoreboard players set #ARENA tspire_timer 2
