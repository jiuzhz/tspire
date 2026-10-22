# 援兵 · 不买：+1 金币
execute if score @s tspire_my_choice matches 0 run scoreboard players add @s tspire_gold 1
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[援兵] ","color":"gold","bold":true},{"text":"「这都买不起？……喏，可怜你一枚金币。」","color":"yellow"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 3
