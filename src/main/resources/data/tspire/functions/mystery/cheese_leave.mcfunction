execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 run loot give @s loot tspire:mystery/cheese_part
execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[奶酪] ","color":"yellow","bold":true},{"text":"获得一件奶酪部件（弓弦或绑带）。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 19 if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
