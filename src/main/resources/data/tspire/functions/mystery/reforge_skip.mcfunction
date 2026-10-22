# 不重铸：随机 2 个**本层**材料池的部件（每人独立结算）
execute if score @s tspire_my_choice matches 0 if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:rewards/part_f1
execute if score @s tspire_my_choice matches 0 if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:rewards/part_f1
execute if score @s tspire_my_choice matches 0 if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:rewards/part_f2
execute if score @s tspire_my_choice matches 0 if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:rewards/part_f2
execute if score @s tspire_my_choice matches 0 if score #FLOOR tspire_timer matches 3 run loot give @s loot tspire:rewards/part_f3
execute if score @s tspire_my_choice matches 0 if score #FLOOR tspire_timer matches 3 run loot give @s loot tspire:rewards/part_f3
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[重铸] ","color":"green","bold":true},{"text":"你把炉子让给了别人，转身从部件堆里挑走两块材料。","color":"green"}]
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2