# 单独一刻建图；先预约传送，建图被截断时仍可继续。
# Compatibility: a run already active during a datapack reload has no staged
# preparation state. Build that next hall with the old safe path once.
execute unless score #MAP_SCHEMA tspire_timer matches 3 if score #FLOOR tspire_timer matches 2 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~32 ~ run function tspire:map/build_hall
execute unless score #MAP_SCHEMA tspire_timer matches 3 if score #FLOOR tspire_timer matches 2 run scoreboard players set #MAP_READY2 tspire_timer 1
execute unless score #MAP_SCHEMA tspire_timer matches 3 if score #FLOOR tspire_timer matches 3 in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~64 ~ run function tspire:map/build_hall
execute unless score #MAP_SCHEMA tspire_timer matches 3 if score #FLOOR tspire_timer matches 3 run scoreboard players set #MAP_READY3 tspire_timer 1
execute if score #FLOOR tspire_timer matches 2 if score #MAP_READY2 tspire_timer matches 1 run function tspire:map/build_floor
execute if score #FLOOR tspire_timer matches 3 if score #MAP_READY3 tspire_timer matches 1 run function tspire:map/build_floor
execute if score #FLOOR tspire_timer matches 2 unless score #MAP_READY2 tspire_timer matches 1 run schedule function tspire:run/next_floor_build 1t replace
execute if score #FLOOR tspire_timer matches 3 unless score #MAP_READY3 tspire_timer matches 1 run schedule function tspire:run/next_floor_build 1t replace
