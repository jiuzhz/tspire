# 贪婪 · 小金币箱：+28 金币；逐人独立，每人的选择只能结算一次。
execute if score @s tspire_my_choice matches 0 run scoreboard players add @s tspire_gold 28
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[贪婪] ","color":"gold","bold":true},{"text":"你拿走了小箱子 —— 金币 +28（现在 ","color":"green"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":" 金币）。","color":"green"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.item.pickup master @s ~ ~ ~ 1 1
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
