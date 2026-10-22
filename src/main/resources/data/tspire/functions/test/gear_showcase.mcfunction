# ============================================================
# 出怪链路演示：一次生成两个编队，检查装备是否真的挂上
# 用法：找一块空地，/function tspire:test/gear_showcase
# ============================================================
# 期望看到：
#   - 近处 5 只（3 僵尸 + 2 骷髅）：每个可装备单位都拿匠魂武器、穿匠魂盔甲
#   - 前方 8 格 5 只（2 卫道士 + 3 僵尸）：同上
#   - 武器与盔甲的材料【每次都不一样】（tier 0 池内随机）
#   - 骷髅应拿远程武器（长弓/弩），卫道士拿近战
#
# 若想确认 NBT，对任意一只执行：
#   /data get entity @e[tag=tspire_mob,limit=1,sort=nearest] HandItems
#   /data get entity @e[tag=tspire_mob,limit=1,sort=nearest] ArmorItems
# ============================================================

kill @e[tag=tspire_mob]
scoreboard players set #FLOOR tspire_timer 1

tellraw @s [{"text":"[出怪演示] ","color":"gold"},{"text":"生成第 1 层简单编队 1-E1","color":"white"}]
function tspire:mobs/groups/floor1_easy/e1

tellraw @s [{"text":"[出怪演示] ","color":"gold"},{"text":"前方 8 格生成困难编队 1-H2","color":"white"}]
execute positioned ~8 ~ ~ run function tspire:mobs/groups/floor1_hard/h2

tellraw @s [{"text":"检查点：","color":"yellow"},{"text":"每只怪手上都应有匠魂武器，身上有匠魂盔甲，且材料各不相同。","color":"gray"}]
tellraw @s [{"text":"清理：","color":"gray"},{"text":"/kill @e[tag=tspire_mob]","color":"gray"}]
