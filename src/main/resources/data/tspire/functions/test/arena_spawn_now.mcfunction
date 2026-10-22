# 第 2 拍：生成指定的 Boss（#TESTBOSS：1 淬火者 / 2 锈刃督军 / 3 沼泽猎手 / 4 钴蓝决斗者 /
#   5 裂颅者 / 6 织影巫师 / 7 铭刻者 / 8 熔核暴君 / 9 重铸之王；0 = 按 #FLOOR 随机）
scoreboard players set #ELITE tspire_timer 1
execute if score #TESTBOSS tspire_timer matches 1 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/quencher
execute if score #TESTBOSS tspire_timer matches 2 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/rusblade
execute if score #TESTBOSS tspire_timer matches 3 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/mirehunter
execute if score #TESTBOSS tspire_timer matches 4 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/duelist
execute if score #TESTBOSS tspire_timer matches 5 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/skullcrusher
execute if score #TESTBOSS tspire_timer matches 6 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/shadowweaver
execute if score #TESTBOSS tspire_timer matches 7 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/inscriber
execute if score #TESTBOSS tspire_timer matches 8 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/moltenlord
execute if score #TESTBOSS tspire_timer matches 9 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn/recastking
execute if score #TESTBOSS tspire_timer matches 0 at @e[tag=tspire_test_node,limit=1] run function tspire:boss/spawn
scoreboard players set #TESTBOSS tspire_timer 0
scoreboard players set #ARENA tspire_timer 0
