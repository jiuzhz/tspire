# Replace the current mystery event with the mimic event, without rerolling.
scoreboard players set #MYST_ACTIVE tspire_timer 1
scoreboard players set #MYST_REROLL tspire_timer 0
scoreboard players set #MYST_REROLL_N tspire_timer 0
scoreboard players set @a[team=tspire_party] tspire_my_choice 0
function tspire:terrain/lock
function tspire:mystery/ev_mimic
execute at @e[tag=tspire_node_current,tag=tspire_type_mystery,limit=1,sort=nearest] run fill ~-7 ~-1 ~-7 ~7 ~4 ~7 minecraft:air
execute at @e[tag=tspire_node_current,tag=tspire_type_mystery,limit=1,sort=nearest] run kill @e[type=minecraft:item,distance=..9]
execute at @e[tag=tspire_node_current,tag=tspire_type_mystery,limit=1,sort=nearest] run kill @e[type=minecraft:experience_orb,distance=..9]
execute at @e[tag=tspire_node_current,tag=tspire_type_mystery,limit=1,sort=nearest] run function tspire:mystery/props
execute at @e[tag=tspire_node_current,tag=tspire_type_mystery,limit=1,sort=nearest] run function tspire:deco/mys_apply
