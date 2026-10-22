# 共鸣 · 昏睡：回复 50% 生命（8 点 instant_health II + regeneration 5 秒约 2 点 = 约 10 点）
execute if score @s tspire_my_choice matches 0 run effect give @s minecraft:instant_health 1 1 true
execute if score @s tspire_my_choice matches 0 run effect give @s minecraft:regeneration 5 0 true
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[共鸣] ","color":"aqua","bold":true},{"text":"你靠着书架睡了一会儿 —— 醒来时伤口好了大半（回复约 10 点生命）。","color":"green"}]
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2