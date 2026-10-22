execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 run function tspire:hp/read
execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches ..17 run tellraw @s {"text":"生命不足 9 点，无法承受拒绝的代价。","color":"red"}
execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 18.. run damage @s 8 minecraft:magic
execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 18.. run loot give @s loot tspire:mystery/parasite_part
execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 18.. run tellraw @s [{"text":"[寄生] ","color":"light_purple","bold":true},{"text":"你拒绝了植物，失去 8 点生命，获得一件缠怨藤部件。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 23 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 18.. run scoreboard players set @s tspire_my_choice 2
