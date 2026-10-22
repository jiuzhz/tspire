# 药房 · 办卡：100 金币 → 不死图腾 ×1
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 100
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"[药房] ","color":"red"},{"text":"金币不足：办卡需要 100 金币（你有 ","color":"red"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":"）。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 100
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run give @s minecraft:totem_of_undying 1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run tellraw @s [{"text":"[药房] ","color":"gold","bold":true},{"text":"老板把一张烫金的卡推给你，顺手塞来一个不死图腾（-100 金币）。","color":"green"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. as @s at @s run playsound minecraft:item.totem.use master @s ~ ~ ~ 1 1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players set @s tspire_my_choice 4