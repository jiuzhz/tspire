scoreboard players set #MAP_TYPE tspire_timer 0
execute if score #MAP_TYPE tspire_timer matches 0 if score #MAP_MYST tspire_timer matches 1.. run scoreboard players set #MAP_TYPE tspire_timer 1
execute if score #MAP_TYPE tspire_timer matches 0 if score #MAP_ELITE tspire_timer matches 1.. run scoreboard players set #MAP_TYPE tspire_timer 2
execute if score #MAP_TYPE tspire_timer matches 0 if score #MAP_CHEST tspire_timer matches 1.. run scoreboard players set #MAP_TYPE tspire_timer 3
execute if score #MAP_TYPE tspire_timer matches 0 if score #MAP_MERCH tspire_timer matches 1.. run scoreboard players set #MAP_TYPE tspire_timer 4
execute if score #MAP_TYPE tspire_timer matches 0 if score #MAP_ART tspire_timer matches 1.. run scoreboard players set #MAP_TYPE tspire_timer 5
execute if score #MAP_TYPE tspire_timer matches 0 if score #MAP_COMB tspire_timer matches 1.. run scoreboard players set #MAP_TYPE tspire_timer 6
execute as @e[tag=tspire_type_pending,sort=random,limit=1] at @s run function tspire:map/runtime/apply_type
execute if score #MAP_TYPE tspire_timer matches 1 run scoreboard players remove #MAP_MYST tspire_timer 1
execute if score #MAP_TYPE tspire_timer matches 2 run scoreboard players remove #MAP_ELITE tspire_timer 1
execute if score #MAP_TYPE tspire_timer matches 3 run scoreboard players remove #MAP_CHEST tspire_timer 1
execute if score #MAP_TYPE tspire_timer matches 4 run scoreboard players remove #MAP_MERCH tspire_timer 1
execute if score #MAP_TYPE tspire_timer matches 5 run scoreboard players remove #MAP_ART tspire_timer 1
execute if score #MAP_TYPE tspire_timer matches 6 run scoreboard players remove #MAP_COMB tspire_timer 1
