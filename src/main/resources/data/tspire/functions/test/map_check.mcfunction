# ============================================================
# 地图自检（用法：/function tspire:test/map_check）
# ============================================================
# 直接数出塔里**每一行到底有几个节点 marker**，以及被消费/可进入的分布。
# "一行出现 5 个房间"这种问题，用这个一眼就能定性：
#   - 如果这里报的行宽是 5+，那就是 marker 叠了（清理没干净）
#   - 如果这里报的最大值 ≤4，那看到的多半是"相邻两行的房间一起进了视野"
#
# 计数用 `execute store result ... if entity` 的**条件形式**（不带 run），
# 不会往聊天栏刷 "Test passed"。

tellraw @s [{"text":"========== 地图自检 ==========","color":"gold","bold":true}]

# 总节点数
scoreboard players set #N_DONE tspire_timer 0
execute in tspire:tower store result score #N_DONE tspire_timer if entity @e[tag=tspire_node]
tellraw @s [{"text":"节点 marker 总数：","color":"gray"},{"score":{"name":"#N_DONE","objective":"tspire_timer"},"color":"yellow"},{"text":"（11 行 × 2~4 + 1 Boss，正常 23~45）","color":"dark_gray"}]

# 逐行计数
scoreboard players set #N_ROW1 tspire_timer 0
scoreboard players set #N_ROW2 tspire_timer 0
scoreboard players set #N_ROW3 tspire_timer 0
scoreboard players set #N_ROW4 tspire_timer 0
scoreboard players set #N_ROW5 tspire_timer 0
scoreboard players set #N_ROW6 tspire_timer 0
scoreboard players set #N_ROW7 tspire_timer 0
scoreboard players set #N_ROW8 tspire_timer 0
scoreboard players set #N_ROW9 tspire_timer 0
scoreboard players set #N_ROW10 tspire_timer 0
scoreboard players set #N_ROW11 tspire_timer 0
scoreboard players set #N_ROW12 tspire_timer 0
execute in tspire:tower store result score #N_ROW1 tspire_timer if entity @e[tag=tspire_row1]
execute in tspire:tower store result score #N_ROW2 tspire_timer if entity @e[tag=tspire_row2]
execute in tspire:tower store result score #N_ROW3 tspire_timer if entity @e[tag=tspire_row3]
execute in tspire:tower store result score #N_ROW4 tspire_timer if entity @e[tag=tspire_row4]
execute in tspire:tower store result score #N_ROW5 tspire_timer if entity @e[tag=tspire_row5]
execute in tspire:tower store result score #N_ROW6 tspire_timer if entity @e[tag=tspire_row6]
execute in tspire:tower store result score #N_ROW7 tspire_timer if entity @e[tag=tspire_row7]
execute in tspire:tower store result score #N_ROW8 tspire_timer if entity @e[tag=tspire_row8]
execute in tspire:tower store result score #N_ROW9 tspire_timer if entity @e[tag=tspire_row9]
execute in tspire:tower store result score #N_ROW10 tspire_timer if entity @e[tag=tspire_row10]
execute in tspire:tower store result score #N_ROW11 tspire_timer if entity @e[tag=tspire_row11]
execute in tspire:tower store result score #N_ROW12 tspire_timer if entity @e[tag=tspire_row12]

tellraw @s [{"text":"每行节点数（第 12 行是 Boss，正常为 1）：","color":"gray"}]
execute in tspire:tower unless entity @e[tag=tspire_node] run tellraw @s [{"text":"  塔里一个节点都没有 —— 说明地图预设函数没跑或加载失败","color":"red"}]
tellraw @s [{"text":"  行 1：","color":"gray"},{"score":{"name":"#N_ROW1","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 2：","color":"gray"},{"score":{"name":"#N_ROW2","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 3：","color":"gray"},{"score":{"name":"#N_ROW3","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 4：","color":"gray"},{"score":{"name":"#N_ROW4","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"  行 5：","color":"gray"},{"score":{"name":"#N_ROW5","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 6：","color":"gray"},{"score":{"name":"#N_ROW6","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 7：","color":"gray"},{"score":{"name":"#N_ROW7","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 8：","color":"gray"},{"score":{"name":"#N_ROW8","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"  行 9：","color":"gray"},{"score":{"name":"#N_ROW9","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 10：","color":"gray"},{"score":{"name":"#N_ROW10","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 11：","color":"gray"},{"score":{"name":"#N_ROW11","objective":"tspire_timer"},"color":"yellow"},{"text":"　行 12：","color":"gray"},{"score":{"name":"#N_ROW12","objective":"tspire_timer"},"color":"yellow"}]

# 状态分布
scoreboard players set #N_AVAIL tspire_timer 0
scoreboard players set #N_LOCK tspire_timer 0
scoreboard players set #N_DONE2 tspire_timer 0
scoreboard players set #N_SPENT tspire_timer 0
scoreboard players set #N_REUSE tspire_timer 0
execute in tspire:tower store result score #N_AVAIL tspire_timer if entity @e[tag=tspire_node_avail]
execute in tspire:tower store result score #N_LOCK tspire_timer if entity @e[tag=tspire_node_locked]
execute in tspire:tower store result score #N_DONE2 tspire_timer if entity @e[tag=tspire_node_done]
execute in tspire:tower store result score #N_SPENT tspire_timer if entity @e[tag=tspire_node_spent]
execute in tspire:tower store result score #N_REUSE tspire_timer if entity @e[tag=tspire_node_reusable]
tellraw @s [{"text":"状态：","color":"gray"},{"text":"可进入 ","color":"green"},{"score":{"name":"#N_AVAIL","objective":"tspire_timer"},"color":"green"},{"text":"　锁定 ","color":"red"},{"score":{"name":"#N_LOCK","objective":"tspire_timer"},"color":"red"},{"text":"　已通过 ","color":"gray"},{"score":{"name":"#N_DONE2","objective":"tspire_timer"},"color":"gray"},{"text":"　已消费 ","color":"dark_gray"},{"score":{"name":"#N_SPENT","objective":"tspire_timer"},"color":"dark_gray"},{"text":"　可复用 ","color":"aqua"},{"score":{"name":"#N_REUSE","objective":"tspire_timer"},"color":"aqua"}]
# 调试/demo 残留（这些会污染上面的行计数）
scoreboard players set #N_DEMO tspire_timer 0
execute in tspire:tower store result score #N_DEMO tspire_timer if entity @e[tag=tspire_demo_node]
execute if score #N_DEMO tspire_timer matches 1.. run tellraw @s [{"text":"⚠ 塔里有 ","color":"red"},{"score":{"name":"#N_DEMO","objective":"tspire_timer"},"color":"red"},{"text":" 个调试用节点混在行计数里！用 /kill @e[tag=tspire_demo_node] 清掉。","color":"red"}]
tellraw @s [{"text":"==================================","color":"gold","bold":true}]
