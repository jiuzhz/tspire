# 【凋零剑压】· 每 tick 统计存活的三只护体单位（a/b/c），抗性等级 = 存活数
# v0.7.19 修复（玩家实测"抗性不掉、怪还活着就又放技能"）：
#   原来这一行是
#       execute store result score #ML_NOW tspire_timer if entity @e[tag=tspire_mcube]
#   两个坑叠在一起：
#     1) `if entity` 的"结果"是 0/1（布尔），不是实体数量；
#     2) 条件不成立时 store **根本不写入**，分数保留上一次的旧值。
#   于是 #ML_NOW 恒为 1，下一行又把 #ML_CUBES 压成 1 → 之后无论死几只都不再触发，
#   抗性永远停在第一级的数值上。现在直接按 a/b/c 三个 tag 相加，得到真实存活数。
scoreboard players set #ML_NOW tspire_timer 0
execute if entity @e[tag=tspire_mcube_a] run scoreboard players add #ML_NOW tspire_timer 1
execute if entity @e[tag=tspire_mcube_b] run scoreboard players add #ML_NOW tspire_timer 1
execute if entity @e[tag=tspire_mcube_c] run scoreboard players add #ML_NOW tspire_timer 1

# 少一只就有一次反馈
execute if score #ML_NOW tspire_timer < #ML_CUBES tspire_timer at @e[tag=tspire_boss_moltenlord,limit=1] run particle minecraft:squid_ink ~ ~1 ~ 1.5 1 1.5 0.08 40 force
execute if score #ML_NOW tspire_timer < #ML_CUBES tspire_timer run title @a[team=tspire_party] actionbar {"text":"【凋零剑压】一只护体单位碎了 —— 它的抗性掉了一级","color":"gold","bold":true}
# 【v0.7.25 补音效】护体单位碎裂：玻璃碎裂 + 信标失效（抗性掉级），只在"少一只"那一刻响
execute if score #ML_NOW tspire_timer < #ML_CUBES tspire_timer as @a[team=tspire_party] at @s run playsound minecraft:block.glass.break master @s ~ ~ ~ 1.2 0.6
execute if score #ML_NOW tspire_timer < #ML_CUBES tspire_timer as @a[team=tspire_party] at @s run playsound minecraft:block.beacon.deactivate master @s ~ ~ ~ 1.0 0.9

# 等级 = 存活数；并记下这一 tick 的存活数供下一 tick 比较
scoreboard players operation #ML_RES tspire_timer = #ML_NOW tspire_timer
scoreboard players operation #ML_CUBES tspire_timer = #ML_NOW tspire_timer

# 按当前等级重刷抗性（只给 5 秒，所以杀光后最多 5 秒抗性就消失；等级 0 = 立刻清掉）
execute if score #ML_RES tspire_timer matches 3 run effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance 5 2 true
execute if score #ML_RES tspire_timer matches 2 run effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance 5 1 true
execute if score #ML_RES tspire_timer matches 1 run effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance 5 0 true
execute if score #ML_RES tspire_timer matches 0 unless score #MLZ2 tspire_timer matches 1.. run effect clear @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance

# 粒子随等级变化：等级越高越多
execute at @e[tag=tspire_boss_moltenlord,limit=1] if score #ML_RES tspire_timer matches 3 run particle minecraft:flame ~ ~1 ~ 1.2 1 1.2 0.05 12 force
execute at @e[tag=tspire_boss_moltenlord,limit=1] if score #ML_RES tspire_timer matches 2 run particle minecraft:flame ~ ~1 ~ 1 0.8 1 0.04 7 force
execute at @e[tag=tspire_boss_moltenlord,limit=1] if score #ML_RES tspire_timer matches 1 run particle minecraft:flame ~ ~1 ~ 0.8 0.6 0.8 0.03 3 force

# 护体单位自身的黑色特效
execute as @e[tag=tspire_mcube] at @s run particle minecraft:smoke ~ ~0.3 ~ 0.6 0.3 0.6 0.02 15 force
