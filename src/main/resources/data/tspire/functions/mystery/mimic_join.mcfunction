# 伪装者 · 加入：随机黏液头颅（loot_tables/mystery/slime_skull.json —— 4 种非末影材质等概率）
execute if score @s tspire_my_choice matches 0 run loot give @s loot tspire:mystery/slime_skull
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[伪装者] ","color":"green","bold":true},{"text":"他们也给你套上一颗黏液头颅 —— 温热的黏液在头皮上收紧。没有人再看你一眼。","color":"green"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.slime.squish master @s ~ ~ ~ 1 1
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1