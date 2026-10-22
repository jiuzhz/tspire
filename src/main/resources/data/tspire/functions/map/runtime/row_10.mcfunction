# Draw and place row 10 of 15.
scoreboard players set #MAP_WIDTH tspire_timer 2
execute if predicate tspire:roll/d3 run scoreboard players set #MAP_WIDTH tspire_timer 3
execute if score #MAP_WIDTH tspire_timer matches 2 if predicate tspire:roll/d2 run scoreboard players set #MAP_WIDTH tspire_timer 4
execute if score #MAP_WIDTH tspire_timer matches 3.. run scoreboard players add #MAP_WIDE tspire_timer 1
scoreboard players operation #MAP_N tspire_timer += #MAP_WIDTH tspire_timer
execute if score #FLOOR tspire_timer matches 1 if score #MAP_WIDTH tspire_timer matches 2 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~ ~ run function tspire:map/runtime/place_f1_r10_w2
execute if score #FLOOR tspire_timer matches 1 if score #MAP_WIDTH tspire_timer matches 3 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~ ~ run function tspire:map/runtime/place_f1_r10_w3
execute if score #FLOOR tspire_timer matches 1 if score #MAP_WIDTH tspire_timer matches 4 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~ ~ run function tspire:map/runtime/place_f1_r10_w4
execute if score #FLOOR tspire_timer matches 2 if score #MAP_WIDTH tspire_timer matches 2 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~32 ~ run function tspire:map/runtime/place_f2_r10_w2
execute if score #FLOOR tspire_timer matches 2 if score #MAP_WIDTH tspire_timer matches 3 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~32 ~ run function tspire:map/runtime/place_f2_r10_w3
execute if score #FLOOR tspire_timer matches 2 if score #MAP_WIDTH tspire_timer matches 4 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~32 ~ run function tspire:map/runtime/place_f2_r10_w4
execute if score #FLOOR tspire_timer matches 3 if score #MAP_WIDTH tspire_timer matches 2 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~64 ~ run function tspire:map/runtime/place_f3_r10_w2
execute if score #FLOOR tspire_timer matches 3 if score #MAP_WIDTH tspire_timer matches 3 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~64 ~ run function tspire:map/runtime/place_f3_r10_w3
execute if score #FLOOR tspire_timer matches 3 if score #MAP_WIDTH tspire_timer matches 4 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~64 ~ run function tspire:map/runtime/place_f3_r10_w4
scoreboard players set #MAP_STEP tspire_timer 10
scoreboard players set #PICK_WAIT tspire_timer 0
schedule function tspire:map/runtime/row_11 1t replace
