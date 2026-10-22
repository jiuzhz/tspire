# ============================================================
# 均匀掷 1..6，结果写进 #ROLL（tspire_timer）
# ============================================================
# 与 util/roll_d5 同样的谓词链写法：每档条件概率都是 1/6。

scoreboard players set #ROLL tspire_timer 0
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d6 run scoreboard players set #ROLL tspire_timer 6
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #ROLL tspire_timer 5
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #ROLL tspire_timer 4
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #ROLL tspire_timer 3
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #ROLL tspire_timer 2
execute if score #ROLL tspire_timer matches 0 run scoreboard players set #ROLL tspire_timer 1
