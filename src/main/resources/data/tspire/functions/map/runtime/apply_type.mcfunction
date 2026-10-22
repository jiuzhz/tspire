execute if score #MAP_TYPE tspire_timer matches 1 run tag @s add tspire_type_mystery
execute if score #MAP_TYPE tspire_timer matches 1 run setblock ~ ~-1 ~ minecraft:cyan_concrete
execute if score #MAP_TYPE tspire_timer matches 2 run tag @s add tspire_type_elite
execute if score #MAP_TYPE tspire_timer matches 2 run setblock ~ ~-1 ~ minecraft:purple_concrete
execute if score #MAP_TYPE tspire_timer matches 3 run tag @s add tspire_type_chest
execute if score #MAP_TYPE tspire_timer matches 3 run setblock ~ ~-1 ~ minecraft:yellow_concrete
execute if score #MAP_TYPE tspire_timer matches 4 run tag @s add tspire_type_merchant
execute if score #MAP_TYPE tspire_timer matches 4 run setblock ~ ~-1 ~ minecraft:emerald_block
execute if score #MAP_TYPE tspire_timer matches 5 run tag @s add tspire_type_artisan
execute if score #MAP_TYPE tspire_timer matches 5 run setblock ~ ~-1 ~ minecraft:orange_concrete
execute if score #MAP_TYPE tspire_timer matches 6 run tag @s add tspire_type_combat
execute if score #MAP_TYPE tspire_timer matches 6 run setblock ~ ~-1 ~ minecraft:red_concrete
tag @s remove tspire_type_pending
