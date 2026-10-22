# 抽奖机 · 不抽了：无事发生，放行
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"你决定见好就收，转身离开。","color":"gray"}]
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
