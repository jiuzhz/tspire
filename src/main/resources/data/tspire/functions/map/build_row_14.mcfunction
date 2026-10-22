# Carve row 14 after the map markers are drawn.
execute in tspire:tower as @e[tag=tspire_node,tag=tspire_row14] at @s run function tspire:map/room_shell
execute if score #FLOOR tspire_timer matches 1..2 in tspire:tower as @e[tag=tspire_node,tag=tspire_row14] at @s run function tspire:map/room_entry_lights
scoreboard players set #MAP_STEP tspire_timer 34
scoreboard players set #PICK_WAIT tspire_timer 0
schedule function tspire:map/build_row_15 1t replace
