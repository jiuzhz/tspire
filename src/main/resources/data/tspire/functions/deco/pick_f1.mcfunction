# ============================================================
# 一层战斗房装饰 · 随机挑选（v0.7.20）
# ============================================================
# 执行前提：**at 房间中心标记**（= 地板行走层）。下面调用的 deco/f1_* 全是 `~` 相对坐标，
#   所以只能在锚点上跑。锚点由 deco/apply_f1 负责解析。
#
# 随机怎么掷：**先把骰子掷一次、写进 #DECO，再分派** —— 随机谓词每被 `if` 调用一次就会重掷，
#   所以绝不能"挑一种"和"报第几种"各掷一次（否则报的和建的对不上，本项目的宝箱就这么错过一次）。
#   概率：1/5、1/5、1/5、1/5、1/5
#     d5 → d4 → d3 → d2 连环，四道都没中就是第 5 种（1/5）。
# ============================================================
scoreboard players set #DECO tspire_timer 0
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #DECO tspire_timer 1
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #DECO tspire_timer 2
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #DECO tspire_timer 3
execute if score #DECO tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #DECO tspire_timer 4
execute if score #DECO tspire_timer matches 0 run scoreboard players set #DECO tspire_timer 5

# 分派（每个 f1_N 都是"锚点相对"的整间装饰）
execute if score #DECO tspire_timer matches 1 run function tspire:deco/f1_1
execute if score #DECO tspire_timer matches 2 run function tspire:deco/f1_2
execute if score #DECO tspire_timer matches 3 run function tspire:deco/f1_3
execute if score #DECO tspire_timer matches 4 run function tspire:deco/f1_4
execute if score #DECO tspire_timer matches 5 run function tspire:deco/f1_5
