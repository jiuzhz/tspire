execute if score #MYST_EV tspire_timer matches 18 if score @s tspire_my_choice matches 0 run function tspire:hp/read
execute if score #MYST_EV tspire_timer matches 18 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches ..13 run tellraw @s [{"text":"生命不足，无法选择白色药水。","color":"red"}]
execute if score #MYST_EV tspire_timer matches 18 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 14.. run damage @s 6 minecraft:magic
execute if score #MYST_EV tspire_timer matches 18 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 14.. run give @s minecraft:milk_bucket 1
execute if score #MYST_EV tspire_timer matches 18 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 14.. run tellraw @s [{"text":"[巫女] ","color":"yellow","bold":true},{"text":"生命-6，获得牛奶。","color":"yellow"}]
execute if score #MYST_EV tspire_timer matches 18 if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 14.. run scoreboard players set @s tspire_my_choice 1
