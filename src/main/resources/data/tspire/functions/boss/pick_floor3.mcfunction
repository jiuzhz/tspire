# 第 3 层 3 选 1（最终 Boss）
scoreboard players set #PICKED tspire_timer 0

execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d3 run function tspire:boss/spawn/inscriber
execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d2 run function tspire:boss/spawn/moltenlord
execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d1 run function tspire:boss/spawn/recastking
