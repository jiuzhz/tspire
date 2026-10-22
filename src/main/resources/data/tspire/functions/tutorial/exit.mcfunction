# Return the learner to the saved location; retain acquired equipment and rewards.
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #BOSS_ACTIVE tspire_timer 0
scoreboard players set #RUN_STARTED tspire_timer 0
scoreboard players set #PICK_STAGE tspire_timer 0
bossbar set tspire_hud visible false
function tspire:rewards/offer_clear
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_node,tag=tspire_tutorial_node]
execute in minecraft:overworld as @e[tag=tspire_tutorial_return,limit=1] at @s run tp @a[tag=tspire_tutorial,limit=1] ~ ~ ~
execute in minecraft:the_nether as @e[tag=tspire_tutorial_return,limit=1] at @s run tp @a[tag=tspire_tutorial,limit=1] ~ ~ ~
execute in minecraft:the_end as @e[tag=tspire_tutorial_return,limit=1] at @s run tp @a[tag=tspire_tutorial,limit=1] ~ ~ ~
execute in tspire:tower as @e[tag=tspire_tutorial_return,limit=1] at @s run tp @a[tag=tspire_tutorial,limit=1] ~ ~ ~
effect clear @s
execute at @s run spawnpoint @s ~ ~ ~
execute if score @s tspire_tut_mode matches 0 run gamemode survival @s
execute if score @s tspire_tut_mode matches 1 run gamemode creative @s
execute if score @s tspire_tut_mode matches 2 run gamemode adventure @s
execute if score @s tspire_tut_mode matches 3 run gamemode spectator @s
scoreboard players set @s tspire_phase 0
scoreboard players set @s tspire_dead 0
team leave @s
tag @s remove tspire_tutorial
scoreboard players set @s tspire_tutorial 0
function tspire:tutorial/cleanup
tellraw @s [{"text":"[新手教程] ","color":"aqua"},{"text":"已返回原位置，教程获得的装备和奖励留在背包。 ","color":"white"},{"text":"[加入正式队伍]","color":"yellow","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 105"}}]
