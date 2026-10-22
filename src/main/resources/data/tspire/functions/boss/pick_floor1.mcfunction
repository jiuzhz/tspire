# 每层 3 个候选 Boss，随机抽 1 个（设计文档 §7.6）
# 用 random_chance 谓词链做均匀抽取，抽中即置 #PICKED=1

scoreboard players set #PICKED tspire_timer 0

execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d3 run function tspire:boss/spawn/quencher
execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d2 run function tspire:boss/spawn/rusblade
execute if score #PICKED tspire_timer matches 0 if predicate tspire:roll/d1 run function tspire:boss/spawn/mirehunter
