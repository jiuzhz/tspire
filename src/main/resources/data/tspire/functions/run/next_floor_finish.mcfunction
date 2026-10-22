# 全队传送到新层起点
# 【v0.7.31 修 "打完 Boss 有时不传送"】原来写的是
#     execute if score #FLOOR ... in tspire:tower run tp @a[team=tspire_party] 0 96 0
#   `in` 放在**选择器之前** → `@a` 是在**塔维度里**解析的 → 人不在塔里（例如阵亡后重生到别处）
#   就被静默跳过，永远留在原地。改成 `as @a[...] in tspire:tower run tp @s` —— 先按玩家选人，
#   再把执行维度切到塔里，tp 就能把**任何位置**的队员都拉过来。
execute if score #FLOOR tspire_timer matches 2 as @a[team=tspire_party] in tspire:tower run tp @s 0 96 0
execute if score #FLOOR tspire_timer matches 2 as @e[tag=tspire_ally] in tspire:tower run tp @s 0 96 0
execute if score #FLOOR tspire_timer matches 3 as @a[team=tspire_party] in tspire:tower run tp @s 0 128 0
execute if score #FLOOR tspire_timer matches 3 as @e[tag=tspire_ally] in tspire:tower run tp @s 0 128 0

# 重生点跟着往上挪，否则阵亡会掉回第 1 层（同上：先选人再切维度）
execute if score #FLOOR tspire_timer matches 2 as @a[team=tspire_party] in tspire:tower run spawnpoint @s 0 96 0
execute if score #FLOOR tspire_timer matches 3 as @a[team=tspire_party] in tspire:tower run spawnpoint @s 0 128 0

# 【v0.7.32 玩家要求】进第 2 / 3 层时**全队回满血**。
#   用 instant_health（amplifier 10 → 治疗量远超任何玩家的最大生命，回满即止，不会溢出）。
#   （不碰 /attribute —— 本项目已禁用该指令，见 boss/spawn 的注释。）
effect give @a[team=tspire_party] minecraft:instant_health 1 10 true

execute if score #FLOOR tspire_timer matches 2 run title @a[team=tspire_party] title {"text":"第 2 层 · 暗原","color":"gold","bold":true}
execute if score #FLOOR tspire_timer matches 3 run title @a[team=tspire_party] title {"text":"第 3 层 · 异界","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"越往上，敌人装备越好","color":"gray"}
execute as @a[team=tspire_party] at @s run playsound minecraft:block.beacon.activate master @s ~ ~ ~ 1 1
