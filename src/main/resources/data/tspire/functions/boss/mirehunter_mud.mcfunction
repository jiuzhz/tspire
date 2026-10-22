# ============================================================
# 沼泽猎手【泥沼】· 布下 3 片泥沼（每 12 秒）
# ============================================================
# 选点规则（1.20.1 没有宏，所以用"先掷一个基准方向、再取 120° 间隔"的办法）：
#   · 掷一个均匀的 0..7 方向 #MUD_R（8 个方向 = 每 45°）；
#   · 另两个方向 = #MUD_R + 3、#MUD_R + 6（mod 8）—— 三者互不相同且大致均分，
#     所以"3 个不同的点"是**结构性保证**的，不需要去重。
#   · 距离固定 8 格（Boss 12 格范围内 ✓）。
# 每个点生成一个 tspire_mud marker 当圆心，半径 5 的判定与边缘粒子见
# boss/mirehunter_mud_check。三片同时存在 10 秒（#MUD_T 0..200）。
# ============================================================

scoreboard players set #MIRE_C1 tspire_timer 0
scoreboard players set #MUD_T tspire_timer 0

# 清掉上一轮还没消失的泥沼
kill @e[tag=tspire_mud]

# 均匀掷 0..7
scoreboard players set #MUD_R tspire_timer 0
execute if score #MUD_R tspire_timer matches 0 if predicate tspire:roll/d8 run scoreboard players set #MUD_R tspire_timer 7
execute if score #MUD_R tspire_timer matches 0 if predicate tspire:roll/d7 run scoreboard players set #MUD_R tspire_timer 6
execute if score #MUD_R tspire_timer matches 0 if predicate tspire:roll/d6 run scoreboard players set #MUD_R tspire_timer 5
execute if score #MUD_R tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #MUD_R tspire_timer 4
execute if score #MUD_R tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #MUD_R tspire_timer 3
execute if score #MUD_R tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #MUD_R tspire_timer 2
execute if score #MUD_R tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #MUD_R tspire_timer 1

# 另两个方向 = +3 / +6（mod 8）
scoreboard players operation #MUD_K2 tspire_timer = #MUD_R tspire_timer
scoreboard players add #MUD_K2 tspire_timer 3
execute if score #MUD_K2 tspire_timer matches 8.. run scoreboard players remove #MUD_K2 tspire_timer 8
scoreboard players operation #MUD_K3 tspire_timer = #MUD_R tspire_timer
scoreboard players add #MUD_K3 tspire_timer 6
execute if score #MUD_K3 tspire_timer matches 8.. run scoreboard players remove #MUD_K3 tspire_timer 8

# --- 第 1 片（方向 #MUD_R）---
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_R tspire_timer matches 0 run summon minecraft:marker ~8 ~ ~ {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_R tspire_timer matches 1 run summon minecraft:marker ~5.7 ~ ~5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_R tspire_timer matches 2 run summon minecraft:marker ~ ~ ~8 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_R tspire_timer matches 3 run summon minecraft:marker ~-5.7 ~ ~5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_R tspire_timer matches 4 run summon minecraft:marker ~-8 ~ ~ {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_R tspire_timer matches 5 run summon minecraft:marker ~-5.7 ~ ~-5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_R tspire_timer matches 6 run summon minecraft:marker ~ ~ ~-8 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_R tspire_timer matches 7 run summon minecraft:marker ~5.7 ~ ~-5.7 {Tags:["tspire_mud"]}

# --- 第 2 片（方向 #MUD_K2）---
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K2 tspire_timer matches 0 run summon minecraft:marker ~8 ~ ~ {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K2 tspire_timer matches 1 run summon minecraft:marker ~5.7 ~ ~5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K2 tspire_timer matches 2 run summon minecraft:marker ~ ~ ~8 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K2 tspire_timer matches 3 run summon minecraft:marker ~-5.7 ~ ~5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K2 tspire_timer matches 4 run summon minecraft:marker ~-8 ~ ~ {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K2 tspire_timer matches 5 run summon minecraft:marker ~-5.7 ~ ~-5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K2 tspire_timer matches 6 run summon minecraft:marker ~ ~ ~-8 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K2 tspire_timer matches 7 run summon minecraft:marker ~5.7 ~ ~-5.7 {Tags:["tspire_mud"]}

# --- 第 3 片（方向 #MUD_K3）---
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K3 tspire_timer matches 0 run summon minecraft:marker ~8 ~ ~ {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K3 tspire_timer matches 1 run summon minecraft:marker ~5.7 ~ ~5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K3 tspire_timer matches 2 run summon minecraft:marker ~ ~ ~8 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K3 tspire_timer matches 3 run summon minecraft:marker ~-5.7 ~ ~5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K3 tspire_timer matches 4 run summon minecraft:marker ~-8 ~ ~ {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K3 tspire_timer matches 5 run summon minecraft:marker ~-5.7 ~ ~-5.7 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K3 tspire_timer matches 6 run summon minecraft:marker ~ ~ ~-8 {Tags:["tspire_mud"]}
execute at @e[tag=tspire_boss_mirehunter,limit=1] if score #MUD_K3 tspire_timer matches 7 run summon minecraft:marker ~5.7 ~ ~-5.7 {Tags:["tspire_mud"]}

# 布下瞬间的表现（每片边缘闪一下）
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~ ~0.2 ~ 5 0.1 5 0.02 30 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:large_smoke ~ ~0.5 ~ 3.5 0.2 3.5 0.02 20 force

title @a[team=tspire_party] actionbar {"text":"【泥沼】场上出现 3 片泥沼 —— 别在里面站超过 1.5 秒！","color":"green","bold":true}
tellraw @a[team=tspire_party] [{"text":"[沼泽猎手] ","color":"green","bold":true},{"text":"泥沼！","color":"gold","bold":true},{"text":"3 片泥沼持续 10 秒；在里面待满 1.5 秒会被缓慢 10 定住 3 秒，而且 Boss 会加速。缓过来后有 5 秒免疫。","color":"yellow"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.slime_block.place master @s ~ ~ ~ 1.2 0.7
