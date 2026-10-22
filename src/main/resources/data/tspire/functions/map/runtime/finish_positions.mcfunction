# Place the boss, then calculate exact category quotas from the drawn node count.
execute if score #FLOOR tspire_timer matches 1 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~ ~ run function tspire:map/runtime/place_boss
execute if score #FLOOR tspire_timer matches 2 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~32 ~ run function tspire:map/runtime/place_boss
execute if score #FLOOR tspire_timer matches 3 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~64 ~ run function tspire:map/runtime/place_boss
scoreboard players set #MAP_C100 tspire_timer 100
scoreboard players set #MAP_P23 tspire_timer 23
scoreboard players set #MAP_P7 tspire_timer 7
scoreboard players set #MAP_P8 tspire_timer 8
scoreboard players set #MAP_P20 tspire_timer 20
scoreboard players operation #MAP_MYST tspire_timer = #MAP_N tspire_timer
scoreboard players operation #MAP_MYST tspire_timer *= #MAP_P23 tspire_timer
scoreboard players operation #MAP_MYST tspire_timer /= #MAP_C100 tspire_timer
scoreboard players operation #MAP_ELITE tspire_timer = #MAP_N tspire_timer
scoreboard players operation #MAP_ELITE tspire_timer *= #MAP_P7 tspire_timer
scoreboard players operation #MAP_ELITE tspire_timer /= #MAP_C100 tspire_timer
scoreboard players operation #MAP_CHEST tspire_timer = #MAP_N tspire_timer
scoreboard players operation #MAP_CHEST tspire_timer *= #MAP_P8 tspire_timer
scoreboard players operation #MAP_CHEST tspire_timer /= #MAP_C100 tspire_timer
scoreboard players operation #MAP_ART tspire_timer = #MAP_N tspire_timer
scoreboard players operation #MAP_ART tspire_timer *= #MAP_P20 tspire_timer
scoreboard players operation #MAP_ART tspire_timer /= #MAP_C100 tspire_timer
scoreboard players set #MAP_MERCH tspire_timer 1
execute if predicate tspire:roll/d2 run scoreboard players set #MAP_MERCH tspire_timer 2
scoreboard players operation #MAP_COMB tspire_timer = #MAP_N tspire_timer
scoreboard players operation #MAP_COMB tspire_timer -= #MAP_MYST tspire_timer
scoreboard players operation #MAP_COMB tspire_timer -= #MAP_ELITE tspire_timer
scoreboard players operation #MAP_COMB tspire_timer -= #MAP_CHEST tspire_timer
scoreboard players operation #MAP_COMB tspire_timer -= #MAP_ART tspire_timer
scoreboard players operation #MAP_COMB tspire_timer -= #MAP_MERCH tspire_timer
scoreboard players operation #MAP_COMB tspire_timer -= #MAP_FIRST_WIDTH tspire_timer
execute if score #FLOOR tspire_timer matches 2..3 run scoreboard players operation #MAP_ART tspire_timer -= #MAP_LAST_WIDTH tspire_timer
scoreboard players set #MAP_STEP tspire_timer 16
scoreboard players set #PICK_WAIT tspire_timer 0
schedule function tspire:map/runtime/assign_batch 1t replace
