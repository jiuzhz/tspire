# ============================================================
# 三层战斗房装饰 · 随机挑选（v0.7.21）
# ============================================================
# 执行前提：**at 房间中心标记**（= 地板行走层）—— deco/f3_* 全是 `~` 相对坐标。
# 同 pick_f1 / pick_f2：先掷一次写进 #DECO 再分派，各 1/5。
# ============================================================
scoreboard players set #DECO tspire_timer 0
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #DECO tspire_timer 1
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #DECO tspire_timer 2
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #DECO tspire_timer 3
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #DECO tspire_timer 4
execute if score #DECO tspire_timer matches 0 run scoreboard players set #DECO tspire_timer 5

execute if score #DECO tspire_timer matches 1 run function tspire:deco/f3_1
execute if score #DECO tspire_timer matches 2 run function tspire:deco/f3_2
execute if score #DECO tspire_timer matches 3 run function tspire:deco/f3_3
execute if score #DECO tspire_timer matches 4 run function tspire:deco/f3_4
execute if score #DECO tspire_timer matches 5 run function tspire:deco/f3_5
