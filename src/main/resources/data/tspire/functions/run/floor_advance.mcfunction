# 打完 Boss 后推进：第 3 层打完 = 通关
scoreboard players add #FLOOR tspire_timer 1
execute if score #FLOOR tspire_timer matches 4 run function tspire:run/win
execute if score #FLOOR tspire_timer matches 1..3 run function tspire:run/next_floor
