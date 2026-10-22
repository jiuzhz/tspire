# Uniform roll 1..18
scoreboard players set #ROLL tspire_timer 0
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d18 run scoreboard players set #ROLL tspire_timer 18
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d17 run scoreboard players set #ROLL tspire_timer 17
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d16 run scoreboard players set #ROLL tspire_timer 16
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d15 run scoreboard players set #ROLL tspire_timer 15
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d14 run scoreboard players set #ROLL tspire_timer 14
execute if score #ROLL tspire_timer matches 0 if predicate tspire:roll/d13 run scoreboard players set #ROLL tspire_timer 13
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
