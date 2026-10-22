# 给本层所有节点挖出房间（设计文档 §3.5.3）
# ============================================================
# 由 map/build_floor 在地图抽完之后调用一次。
# 岩体已经填实，这里只负责"挖"，挖完刷新门的状态。
# ============================================================

# Boss 房
execute as @e[tag=tspire_node,tag=tspire_type_boss] at @s run function tspire:map/room_boss

# 其余节点
execute as @e[tag=tspire_node,tag=!tspire_type_boss] at @s run function tspire:map/room_shell

# The final row's north doorway and boss south doorway are five blocks wide.
execute as @e[tag=tspire_node,tag=tspire_row15] at @s run fill ~-2 ~ ~-8 ~2 ~2 ~-9 minecraft:air

# 第 1 行开着，其余堵住
function tspire:map/refresh_doors
