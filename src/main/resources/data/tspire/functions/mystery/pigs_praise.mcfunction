execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 run scoreboard players operation #TMP tspire_timer = @s tspire_gold
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 run scoreboard players remove #TMP tspire_timer 200
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"金币不足200。","color":"red"}]
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 200
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run tag @s add tspire_pig_bless
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players operation @s tspire_pig_run = #RUN_ID tspire_timer
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run tellraw @s [{"text":"获得猪猪祝福：进入战斗或BOSS房时削弱敌人。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players set @s tspire_my_choice 1
