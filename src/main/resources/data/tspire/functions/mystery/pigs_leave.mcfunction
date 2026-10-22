execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 run function tspire:hp/read
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches ..9 run tellraw @s [{"text":"[猪！] ","color":"red","bold":true},{"text":"生命不足，无法硬挤出去。","color":"red"}]
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 10.. run damage @s 4 minecraft:magic
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 10.. run tellraw @s [{"text":"[猪！] ","color":"red","bold":true},{"text":"你从猪群中挤出一条路，生命 -4。","color":"red"}]
execute if score #MYST_EV tspire_timer matches 20 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 10.. run scoreboard players set @s tspire_my_choice 1
