# ============================================================
# 裂颅者【钉刺陷阱】· 布下 5 个（每 12 秒）
# ============================================================
# 选点法与沼泽猎手【泥沼】一致（1.20.1 没有宏）：
#   · 掷一个均匀的 0..7 基准方向 #SKU_R（8 个方向 = 每 45°）；
#   · 5 个点取 #SKU_R、+2、+4、+6、+1（mod 8）—— 模 8 下是 0,2,4,6,1，**互不相同**；
#   · 距离固定 8 格（Boss 12 格范围内 ✓）。
# 每个点是半径 **2 格**的陷阱（marker tag `tspire_spike2`），粒子明显；
# 整批持续 **10 秒**（#SKU_T2 0..200），踩中即消失（见 skullcrusher_trap_check）。
# ============================================================

scoreboard players set #SKU_C3 tspire_timer 0
scoreboard players set #SKU_T2 tspire_timer 0

# 清掉上一批还没消失的陷阱
kill @e[tag=tspire_spike2]

# 均匀掷 0..7
scoreboard players set #SKU_R tspire_timer 0
execute if score #SKU_R tspire_timer matches 0 if predicate tspire:roll/d8 run scoreboard players set #SKU_R tspire_timer 7
execute if score #SKU_R tspire_timer matches 0 if predicate tspire:roll/d7 run scoreboard players set #SKU_R tspire_timer 6
execute if score #SKU_R tspire_timer matches 0 if predicate tspire:roll/d6 run scoreboard players set #SKU_R tspire_timer 5
execute if score #SKU_R tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #SKU_R tspire_timer 4
execute if score #SKU_R tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #SKU_R tspire_timer 3
execute if score #SKU_R tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #SKU_R tspire_timer 2
execute if score #SKU_R tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #SKU_R tspire_timer 1

# 另四个方向：+2 / +4 / +6 / +1（各 mod 8）
scoreboard players operation #SKU_K2 tspire_timer = #SKU_R tspire_timer
scoreboard players add #SKU_K2 tspire_timer 2
execute if score #SKU_K2 tspire_timer matches 8.. run scoreboard players remove #SKU_K2 tspire_timer 8
scoreboard players operation #SKU_K3 tspire_timer = #SKU_R tspire_timer
scoreboard players add #SKU_K3 tspire_timer 4
execute if score #SKU_K3 tspire_timer matches 8.. run scoreboard players remove #SKU_K3 tspire_timer 8
scoreboard players operation #SKU_K4 tspire_timer = #SKU_R tspire_timer
scoreboard players add #SKU_K4 tspire_timer 6
execute if score #SKU_K4 tspire_timer matches 8.. run scoreboard players remove #SKU_K4 tspire_timer 8
scoreboard players operation #SKU_K5 tspire_timer = #SKU_R tspire_timer
scoreboard players add #SKU_K5 tspire_timer 1
execute if score #SKU_K5 tspire_timer matches 8.. run scoreboard players remove #SKU_K5 tspire_timer 8

# --- 5 个陷阱，距离 8 格（8 方向各 8 行，共 5 组）---
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_R tspire_timer matches 0 run summon minecraft:marker ~8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_R tspire_timer matches 1 run summon minecraft:marker ~5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_R tspire_timer matches 2 run summon minecraft:marker ~ ~ ~8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_R tspire_timer matches 3 run summon minecraft:marker ~-5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_R tspire_timer matches 4 run summon minecraft:marker ~-8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_R tspire_timer matches 5 run summon minecraft:marker ~-5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_R tspire_timer matches 6 run summon minecraft:marker ~ ~ ~-8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_R tspire_timer matches 7 run summon minecraft:marker ~5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}

execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K2 tspire_timer matches 0 run summon minecraft:marker ~8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K2 tspire_timer matches 1 run summon minecraft:marker ~5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K2 tspire_timer matches 2 run summon minecraft:marker ~ ~ ~8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K2 tspire_timer matches 3 run summon minecraft:marker ~-5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K2 tspire_timer matches 4 run summon minecraft:marker ~-8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K2 tspire_timer matches 5 run summon minecraft:marker ~-5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K2 tspire_timer matches 6 run summon minecraft:marker ~ ~ ~-8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K2 tspire_timer matches 7 run summon minecraft:marker ~5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}

execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K3 tspire_timer matches 0 run summon minecraft:marker ~8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K3 tspire_timer matches 1 run summon minecraft:marker ~5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K3 tspire_timer matches 2 run summon minecraft:marker ~ ~ ~8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K3 tspire_timer matches 3 run summon minecraft:marker ~-5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K3 tspire_timer matches 4 run summon minecraft:marker ~-8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K3 tspire_timer matches 5 run summon minecraft:marker ~-5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K3 tspire_timer matches 6 run summon minecraft:marker ~ ~ ~-8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K3 tspire_timer matches 7 run summon minecraft:marker ~5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}

execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K4 tspire_timer matches 0 run summon minecraft:marker ~8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K4 tspire_timer matches 1 run summon minecraft:marker ~5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K4 tspire_timer matches 2 run summon minecraft:marker ~ ~ ~8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K4 tspire_timer matches 3 run summon minecraft:marker ~-5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K4 tspire_timer matches 4 run summon minecraft:marker ~-8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K4 tspire_timer matches 5 run summon minecraft:marker ~-5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K4 tspire_timer matches 6 run summon minecraft:marker ~ ~ ~-8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K4 tspire_timer matches 7 run summon minecraft:marker ~5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}

execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K5 tspire_timer matches 0 run summon minecraft:marker ~8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K5 tspire_timer matches 1 run summon minecraft:marker ~5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K5 tspire_timer matches 2 run summon minecraft:marker ~ ~ ~8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K5 tspire_timer matches 3 run summon minecraft:marker ~-5.7 ~ ~5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K5 tspire_timer matches 4 run summon minecraft:marker ~-8 ~ ~ {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K5 tspire_timer matches 5 run summon minecraft:marker ~-5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K5 tspire_timer matches 6 run summon minecraft:marker ~ ~ ~-8 {Tags:["tspire_spike2"]}
execute at @e[tag=tspire_boss_skullcrusher,limit=1] if score #SKU_K5 tspire_timer matches 7 run summon minecraft:marker ~5.7 ~ ~-5.7 {Tags:["tspire_spike2"]}

# 布下瞬间：每个陷阱闪一圈（半径 2）
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~ ~0.2 ~ 2 0.05 2 0.02 25 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:enchanted_hit ~ ~0.5 ~ 1.5 0.1 1.5 0.02 15 force

title @a[team=tspire_party] actionbar {"text":"【钉刺陷阱】场上出现 5 处尖刺 —— 踩中会被定住 3 秒！","color":"dark_red","bold":true}
tellraw @a[team=tspire_party] [{"text":"[裂颅者] ","color":"red","bold":true},{"text":"钉刺陷阱！","color":"gold","bold":true},{"text":"5 处半径 2 的尖刺持续 10 秒；踩中受 3 点伤害、被缓慢 10 定住 3 秒，并被强行转向它。","color":"yellow"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.piston.extend master @s ~ ~ ~ 1 0.6
execute as @a[team=tspire_party] at @s run playsound minecraft:block.pointed_dripstone.land master @s ~ ~ ~ 0.9 0.7
