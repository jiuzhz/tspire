scoreboard players set #TUTOR_BUSY tspire_timer 0
scoreboard players set #TUTOR_MODE tspire_timer 0
scoreboard players set #TUTOR_OFFLINE tspire_timer 0
scoreboard players set #RUN_STARTED tspire_timer 0
scoreboard players set #PICK_STAGE tspire_timer 0
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
bossbar set tspire_hud visible false
function tspire:rewards/offer_clear
execute in minecraft:overworld as @e[tag=tspire_tutorial_return] at @s run function tspire:tutorial/clear_return
execute in minecraft:the_nether as @e[tag=tspire_tutorial_return] at @s run function tspire:tutorial/clear_return
execute in minecraft:the_end as @e[tag=tspire_tutorial_return] at @s run function tspire:tutorial/clear_return
execute in tspire:tower as @e[tag=tspire_tutorial_return] at @s run function tspire:tutorial/clear_return
execute in tspire:tower run kill @e[tag=tspire_tutorial_node]
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[type=minecraft:item]
execute in tspire:tower run kill @e[type=minecraft:experience_orb]
execute in tspire:tower run forceload remove -144 -112 -96 48
team empty tspire_party
tag @a[tag=tspire_tutorial] remove tspire_tutorial
