# 第 2 层 3 选 1
scoreboard players set #PICKED tspire_timer 0

execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d3 run function tspire:boss/spawn/duelist
execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d2 run function tspire:boss/spawn/skullcrusher
execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d1 run function tspire:boss/spawn/shadowweaver
