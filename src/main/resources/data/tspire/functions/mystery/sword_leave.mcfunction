# 石中剑 · 不拔剑：回复 25% 生命（≈5 点：instant_health I = 4 + regeneration 3 秒约 1）
execute if score @s tspire_my_choice matches 0 run effect give @s minecraft:instant_health 1 0 true
execute if score @s tspire_my_choice matches 0 run effect give @s minecraft:regeneration 3 0 true
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[石中剑] ","color":"green","bold":true},{"text":"你把手收了回来 —— 有些剑不值得用命去换。你靠着石堆歇了一会儿（回复约 5 点生命）。","color":"green"}]
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2