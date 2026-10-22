# 黏液 · 直接离开：−40 金币（不足则扣到 0）
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 40
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run scoreboard players set @s tspire_gold 0
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 40
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[黏液] ","color":"green","bold":true},{"text":"你绕开黏液走人 —— 鞋底还是被黏走了一些金币（−40）。","color":"red"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.villager.no master @s ~ ~ ~ 1 1
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 3
