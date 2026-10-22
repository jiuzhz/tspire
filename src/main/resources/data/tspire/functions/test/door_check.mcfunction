# ============================================================
# 节点封门自检（用法：走进某个房间后执行 /function tspire:test/door_check）
# ============================================================
# 【v0.6.29】为了定位"同一行其他房间没封口 / 出现不该存在的门"，这里把
#   **你周围 40 格内每个节点**的：坐标、tag 状态、南门/北门的实际方块 打出来。
#
# 读法：
#   tag  avail   = 本行还没选的可选节点 → 门应该是「空气」
#   tag  current = 当前所在节点         → 门应该是「空气」
#   tag  locked  = 本行被放弃的节点     → 门应该是「封条石」
#   tag  done    = 已经通过的节点       → 门应该是「封条石」（除非还挂着 current）
#   门  空气 / 封条石 / 屏障 —— 和上面预期对不上就是 bug
# ============================================================

tag @s add tspire_door_probe
tellraw @s [{"text":"========== 节点封门自检 ==========","color":"gold","bold":true}]
tellraw @s [{"text":"你周围 40 格内的节点（坐标 / tag / 南北门方块）：","color":"gray"}]

execute as @e[tag=tspire_node] at @s if entity @e[tag=tspire_door_probe,distance=..40] run function tspire:test/door_node

tellraw @s [{"text":"==================================","color":"gold","bold":true}]
tag @s remove tspire_door_probe
