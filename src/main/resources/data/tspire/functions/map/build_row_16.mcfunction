# Carve row 16 after the map markers are drawn.
execute in tspire:tower as @e[tag=tspire_node,tag=tspire_type_boss] at @s run function tspire:map/room_boss
scoreboard players set #MAP_STEP tspire_timer 36
scoreboard players set #PICK_WAIT tspire_timer 0
execute in tspire:tower run function tspire:map/refresh_doors
execute unless score #PICK_STAGE tspire_timer matches 9 if score #FLOOR tspire_timer matches 2..3 run function tspire:run/next_floor_finish
execute if score #PICK_STAGE tspire_timer matches 9 run scoreboard players set #PICK_STAGE tspire_timer 2
