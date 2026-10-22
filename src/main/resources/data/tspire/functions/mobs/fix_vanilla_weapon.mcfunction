# v0.7.11（玩家反馈"骷髅生成时有概率拿原版弓"）：兜底纠正。
#   骷髅/流浪者/凋灵骷髅在 /summon 时会自带原版武器（弓 / 石剑），我们的 mobs/equip
#   本来会把主手替换成匠魂武器；只要那一步因为任何原因没生效（掉落表随机到无效材料而
#   报错、怪物在 equip 之前就被别的流程动过手…），原版武器就会留在手上。
#   这里每秒检查一次：手上还是原版武器的，直接换成对应层的匠魂武器。
# 执行者 = 那只怪物；层数取 #FLOOR。
execute if score #FLOOR tspire_timer matches 1 run function tspire:mobs/weapon_f1
execute if score #FLOOR tspire_timer matches 2 run function tspire:mobs/weapon_f2
execute if score #FLOOR tspire_timer matches 3 run function tspire:mobs/weapon_f3
