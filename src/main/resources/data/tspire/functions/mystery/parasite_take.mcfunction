execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 run tag @s add tspire_parasite_pending
execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 run scoreboard players operation @s tspire_para_run = #RUN_ID tspire_timer
execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[寄生] ","color":"light_purple","bold":true},{"text":"你带走了种子。接下来进入战斗／精英／BOSS 房间失去 2 点生命，完成战斗恢复 4 点生命。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
