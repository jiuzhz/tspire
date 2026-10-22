execute if score #MYST_EV tspire_timer matches 21 if score @s tspire_my_choice matches 0 run effect give @s minecraft:instant_health 1 10 true
execute if score #MYST_EV tspire_timer matches 21 if score @s tspire_my_choice matches 0 run tag @s add tspire_hunger
execute if score #MYST_EV tspire_timer matches 21 if score @s tspire_my_choice matches 0 run effect give @s minecraft:hunger 1000000 0 true
execute if score #MYST_EV tspire_timer matches 21 if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[饥饿] ","color":"yellow","bold":true},{"text":"生命已恢复，但饥饿将持续。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 21 if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
