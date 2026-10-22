execute if score #MYST_EV tspire_timer matches 22 if score @s tspire_my_choice matches 0 run tag @s add tspire_treasure
execute if score #MYST_EV tspire_timer matches 22 if score @s tspire_my_choice matches 0 run effect give @s minecraft:slowness 1000000 0 true
execute if score #MYST_EV tspire_timer matches 22 if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[藏宝图] ","color":"yellow","bold":true},{"text":"标记了二层的宝箱；在找到前脚步沉重。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 22 if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
