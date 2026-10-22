execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 run function tspire:mystery/steak_clear
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 run give @s tconstruct:bacon 64
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[猪！] ","color":"yellow","bold":true},{"text":"背包牛排已清空，获得64个培根。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
