# ============================================================
# 二层战斗房装饰 · 随机挑选（v0.7.21）
# ============================================================
# 执行前提：**at 房间中心标记**（= 地板行走层）—— deco/f2_* 全是 `~` 相对坐标。
# 随机：先掷一次写进 #DECO 再分派（随机谓词每被 `if` 调用一次就重掷，绝不能掷两次）。
#   概率各 1/5：d5 → d4 → d3 → d2 连环 + 兜底第 5 种。
# ============================================================
scoreboard players set #DECO tspire_timer 0
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #DECO tspire_timer 1
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #DECO tspire_timer 2
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #DECO tspire_timer 3
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #DECO tspire_timer 4
execute if score #DECO tspire_timer matches 0 run scoreboard players set #DECO tspire_timer 5

execute if score #DECO tspire_timer matches 1 run function tspire:deco/f2_1
execute if score #DECO tspire_timer matches 2 run function tspire:deco/f2_2
execute if score #DECO tspire_timer matches 3 run function tspire:deco/f2_3
execute if score #DECO tspire_timer matches 4 run function tspire:deco/f2_4
execute if score #DECO tspire_timer matches 5 run function tspire:deco/f2_5
