# ============================================================
# 均匀掷 1..5，结果写进 #ROLL（tspire_timer）
# ============================================================
# 用项目统一的 tspire:roll/dN 谓词链：d5 命中即 5，否则降一档重掷，
# 最后一档落到 1 —— 每一档的条件概率都是 1/5，所以 1..5 等概率。

scoreboard players set #ROLL tspire_timer 0
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #ROLL tspire_timer 5
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #ROLL tspire_timer 4
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #ROLL tspire_timer 3
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #ROLL tspire_timer 2
execute if score #ROLL tspire_timer matches 0 run scoreboard players set #ROLL tspire_timer 1
