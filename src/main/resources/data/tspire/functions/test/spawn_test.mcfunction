# ============================================================
# 手动出怪 + 诊断（v0.7.66）
#   在"没出怪"的房间里执行：/function tspire:test/spawn_test
#   它会：① 以当前节点为原点手动跑一次出怪；② 打印结果数量与上限。
#
#   判读：
#     · 出了怪  → 出怪链本身正常，问题在 run/battle_start 调用它时的【位置/维度】
#     · 还是没怪 → summon 本身失败（位置落在虚空/墙里，或区块没加载）
# ============================================================

tellraw @s [{"text":"===== 手动出怪测试 =====","color":"gold","bold":true}]
tellraw @s [{"text":"当前执行位置 = ","color":"gray"},{"nbt":"Pos","entity":"@s","color":"aqua"}]
tellraw @s [{"text":"当前节点坐标  = ","color":"gray"},{"nbt":"Pos","entity":"@e[tag=tspire_node_current,limit=1]","color":"aqua"}]

# ① 以节点为原点手动出怪（和 battle_start 第 36 行同款写法）
execute at @e[tag=tspire_node_current,limit=1] run function tspire:mobs/spawn_batch

# ② 统计结果
scoreboard players set #ST_N tspire_timer 0
execute as @e[tag=tspire_mob] run scoreboard players add #ST_N tspire_timer 1
tellraw @s [{"text":"手动出怪后，场上 tspire_mob 数量 = ","color":"yellow"},{"score":{"name":"#ST_N","objective":"tspire_timer"},"color":"yellow"},{"text":"（0 = summon 本身没成功）","color":"dark_gray"}]

# ③ 最近的怪在哪（看是不是落到远处/地下）
tellraw @s [{"text":"最近一只怪的坐标 = ","color":"gray"},{"nbt":"Pos","entity":"@e[tag=tspire_mob,limit=1,sort=nearest]","color":"white"}]

function tspire:mobs/cap
tellraw @s [{"text":"#MOB_CAP = ","color":"gray"},{"score":{"name":"#MOB_CAP","objective":"tspire_timer"},"color":"aqua"},{"text":"   #MOB_COUNT = ","color":"gray"},{"score":{"name":"#MOB_COUNT","objective":"tspire_timer"},"color":"aqua"}]
tellraw @s [{"text":"判读：出怪了→问题在 battle_start 的调用位置；没出怪→summon 落点/区块问题。","color":"gray"}]