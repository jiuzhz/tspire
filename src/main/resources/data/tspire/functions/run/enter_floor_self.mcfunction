# 单名队员进入新一层的状态重置
execute store result score @s tspire_layer run scoreboard players get #FLOOR tspire_timer
scoreboard players set @s tspire_battle 0
scoreboard players set @s tspire_dead 0
