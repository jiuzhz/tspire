# 伪装者 · 不加入：回复 10% 生命（≈2 点：regeneration 5 秒）
execute if score @s tspire_my_choice matches 0 run effect give @s minecraft:regeneration 5 0 true
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[伪装者] ","color":"green","bold":true},{"text":"你摇了摇头往后退 —— 黏液下那些脸同时转向你，却什么也没做。你在门外喘了口气（回复约 2 点生命）。","color":"green"}]
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2