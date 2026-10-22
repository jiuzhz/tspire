# An offline timeout released the arena; return the former learner safely.
tag @s remove tspire_tutorial
scoreboard players set @s tspire_tutorial 0
execute in minecraft:overworld run spreadplayers 0 0 0 512 false @s
execute in minecraft:overworld at @s run spawnpoint @s ~ ~ ~
execute if score @s tspire_tut_mode matches 0 run gamemode survival @s
execute if score @s tspire_tut_mode matches 1 run gamemode creative @s
execute if score @s tspire_tut_mode matches 2 run gamemode adventure @s
execute if score @s tspire_tut_mode matches 3 run gamemode spectator @s
scoreboard players set @s tspire_phase 0
scoreboard players set @s tspire_dead 0
tellraw @s {"text":"[新手教程] 你离线较久，教程已结束；已送回主世界。","color":"yellow"}
