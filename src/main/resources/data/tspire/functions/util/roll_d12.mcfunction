# ============================================================
# 均匀掷 1..12，结果写进 #ROLL（tspire_timer）
# ============================================================
# 与 util/roll_d5..d10 同样的谓词链写法：每档条件概率都是 1/12。

scoreboard players set #ROLL tspire_timer 0
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d12 run scoreboard players set #ROLL tspire_timer 12
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d11 run scoreboard players set #ROLL tspire_timer 11
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d10 run scoreboard players set #ROLL tspire_timer 10
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d9 run scoreboard players set #ROLL tspire_timer 9
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d8 run scoreboard players set #ROLL tspire_timer 8
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d7 run scoreboard players set #ROLL tspire_timer 7
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d6 run scoreboard players set #ROLL tspire_timer 6
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #ROLL tspire_timer 5
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #ROLL tspire_timer 4
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #ROLL tspire_timer 3
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #ROLL tspire_timer 2
execute if score #ROLL tspire_timer matches 0 run scoreboard players set #ROLL tspire_timer 1
