# 赐福 · 工匠之神（逐人独立）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_bless_artisan 1
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[赐福] ","color":"gold","bold":true},{"text":"工匠之神认可了你的手艺 —— 此后每完成一个房间，你都会额外得到 1 个本层材料池的部件。","color":"green"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:block.anvil.use master @s ~ ~ ~ 1 1.6
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2