# At the current view-line point, claim the nearest combat mob, then step 0.5 block.
execute unless entity @e[tag=tspire_probe_target,limit=1] as @e[tag=tspire_mob,distance=..2,sort=nearest,limit=1] run tag @s add tspire_probe_target
execute unless entity @e[tag=tspire_probe_target,limit=1] as @e[tag=tspire_boss,distance=..2,sort=nearest,limit=1] run tag @s add tspire_probe_target
scoreboard players add #AIM_STEP tspire_timer 1
execute unless entity @e[tag=tspire_probe_target,limit=1] if score #AIM_STEP tspire_timer matches ..31 if block ~ ~ ~ minecraft:air positioned ^ ^ ^0.5 run function tspire:test/aim_damage_ray
