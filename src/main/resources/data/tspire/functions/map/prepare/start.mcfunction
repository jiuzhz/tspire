# Restore three tower floors in small batches while no run is active.
scoreboard players set #MAP_BUILDING tspire_timer 1
scoreboard players set #MAP_SCHEMA tspire_timer 3
scoreboard players set #MAP_USED tspire_timer 0
scoreboard players set #MAP_RESTART tspire_timer 0
scoreboard players set #MAP_READY1 tspire_timer 0
scoreboard players set #MAP_READY2 tspire_timer 0
scoreboard players set #MAP_READY3 tspire_timer 0
execute in tspire:tower unless entity @e[tag=tspire_anchor] run summon minecraft:marker 0 64 0 {Tags:["tspire_anchor"]}
schedule function tspire:map/prepare/forceload_1 1t replace
