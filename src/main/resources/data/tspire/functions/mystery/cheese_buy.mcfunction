execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 run scoreboard players operation #TMP tspire_timer = @s tspire_gold
execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 run scoreboard players remove #TMP tspire_timer 60
execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"[奶酪] ","color":"red","bold":true},{"text":"金币不足 60，先选另一条路吧。","color":"red"}]
execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 60
execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run give @s tconstruct:cheese_ingot 16
execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run tellraw @s [{"text":"[奶酪] ","color":"yellow","bold":true},{"text":"花费 60 金币，抱走了 16 个奶酪。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players set @s tspire_my_choice 1
