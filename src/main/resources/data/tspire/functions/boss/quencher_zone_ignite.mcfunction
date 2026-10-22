# 【燃烧蓄能】进入燃烧阶段（前摇结束）—— 执行者不限
# ============================================================
# v0.6.30b：改成**纯粒子版**（玩家要求）—— 不铺真实火焰方块，
#   只用粒子 + 每 5 tick 一次的灼烧伤害来表现"燃烧"。
#   好处：不会烧掉地上的掉落物、不会留残留方块。
# 持续 3 秒（60 tick）：前 2 秒（40 tick）出粒子，整整 3 秒都有伤害，
#   这样"燃烧 3 秒、范围表现 2 秒"两个数字都对得上。
# ============================================================

scoreboard players set #QZ tspire_timer 2
scoreboard players set #QZ_T tspire_timer 0

title @a[team=tspire_party] title {"text":"燃烧！","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"站在圈内会持续被灼烧 3 秒","color":"red"}
execute as @a[team=tspire_party] at @s run playsound minecraft:item.firecharge.use master @s ~ ~ ~ 1 0.7
