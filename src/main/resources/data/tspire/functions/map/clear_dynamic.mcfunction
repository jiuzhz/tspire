# Dynamic entities are reset when starting a run. Fixed halls are prepared separately.
execute in tspire:tower run kill @e[tag=tspire_node]
execute in tspire:tower run kill @e[tag=tspire_starter]
execute in tspire:tower run kill @e[tag=tspire_shop]
execute in tspire:tower run kill @e[tag=tspire_offer]
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_boss]
execute in tspire:tower run kill @e[type=minecraft:item]
time set 14000
execute in tspire:tower run gamerule doDaylightCycle false
