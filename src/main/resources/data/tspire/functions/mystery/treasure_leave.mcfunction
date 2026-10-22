execute if score #MYST_EV tspire_timer matches 22 if score @s tspire_my_choice matches 0 run function tspire:rewards/special_give
execute if score #MYST_EV tspire_timer matches 22 if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[藏宝图] ","color":"yellow","bold":true},{"text":"你没拿地图，却找到了一件特殊奖励。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 22 if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
