# Carve row 13 after the map markers are drawn.
execute in tspire:tower as @e[tag=tspire_node,tag=tspire_row13] at @s run function tspire:map/room_shell
execute if score #FLOOR tspire_timer matches 1..2 in tspire:tower as @e[tag=tspire_node,tag=tspire_row13] at @s run function tspire:map/room_entry_lights
scoreboard players set #MAP_STEP tspire_timer 33
scoreboard players set #PICK_WAIT tspire_timer 0
schedule function tspire:map/build_row_14 1t replace
