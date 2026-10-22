# 传统派 · 放弃：无事发生
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[传统派] ","color":"gold","bold":true},{"text":"你笑笑走开了 —— 什么都没发生。","color":"gray"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.villager.ambient master @s ~ ~ ~ 1 1
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 3
