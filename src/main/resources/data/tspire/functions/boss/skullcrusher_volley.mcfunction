# ============================================================
# 裂颅者【三连射】· 真·三支箭扇形（v0.6.50 实现，玩家选方案 A）
# ============================================================
# 之前【三连射】只有 actionbar + 音效 + 力量 II，**箭其实是原版掠夺者 AI 自己射的**，
# "3 支箭 / 45° 扇形"从来没实现。现在真的射出 3 支箭。
#
# 1.20.1 没有宏，所以用"把朝向分桶 + 预计算 Motion"的办法：
#   · 读 Boss 的 Rotation[0]（yaw，-180..180）→ 归一到 0..359；
#   · bucket = (yaw + 22) / 45 mod 8 —— 8 个方向桶（每 45°）；
#   · 每个桶配 3 组预计算的 Motion（中间那支 + 左右各偏 ~10°），
#     在 Boss 前方 1.5 格处生成，避免箭一出生就打到自己。
# yaw 约定：0 = +Z，90 = -X，180 = -Z，270 = +X。
# 箭：damage 4、Pickup:0（不可拾取）、crit，带 tag tspire_arrow 方便清理。
# ============================================================

# --- 1) 读朝向并分桶 ---
execute store result score #YAW tspire_timer run data get entity @e[tag=tspire_boss_skullcrusher,limit=1] Rotation[0] 1
execute if score #YAW tspire_timer matches ..-1 run scoreboard players add #YAW tspire_timer 360
scoreboard players set #C45 tspire_timer 45
scoreboard players operation #BUCKET tspire_timer = #YAW tspire_timer
scoreboard players add #BUCKET tspire_timer 22
scoreboard players operation #BUCKET tspire_timer /= #C45 tspire_timer
execute if score #BUCKET tspire_timer matches 8.. run scoreboard players remove #BUCKET tspire_timer 8

# --- 2) 按桶射出 3 支箭（生成点 = 前方 1.5 格、高度 +1.2）---
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 0 run summon minecraft:arrow ~ ~1.2 ~1.5 {Motion:[0.0,0.1,2.0],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 0 run summon minecraft:arrow ~0.35 ~1.2 ~1.5 {Motion:[0.35,0.1,1.97],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 0 run summon minecraft:arrow ~-0.35 ~1.2 ~1.5 {Motion:[-0.35,0.1,1.97],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}

execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 1 run summon minecraft:arrow ~-1.06 ~1.2 ~1.06 {Motion:[-1.41,0.1,1.41],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 1 run summon minecraft:arrow ~-0.9 ~1.2 ~1.3 {Motion:[-1.66,0.1,1.16],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 1 run summon minecraft:arrow ~-1.3 ~1.2 ~0.9 {Motion:[-1.16,0.1,1.66],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}

execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 2 run summon minecraft:arrow ~-1.5 ~1.2 ~ {Motion:[-2.0,0.1,0.0],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 2 run summon minecraft:arrow ~-1.5 ~1.2 ~0.35 {Motion:[-1.97,0.1,0.35],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 2 run summon minecraft:arrow ~-1.5 ~1.2 ~-0.35 {Motion:[-1.97,0.1,-0.35],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}

execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 3 run summon minecraft:arrow ~-1.06 ~1.2 ~-1.06 {Motion:[-1.41,0.1,-1.41],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 3 run summon minecraft:arrow ~-1.3 ~1.2 ~-0.9 {Motion:[-1.16,0.1,-1.66],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 3 run summon minecraft:arrow ~-0.9 ~1.2 ~-1.3 {Motion:[-1.66,0.1,-1.16],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}

execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 4 run summon minecraft:arrow ~ ~1.2 ~-1.5 {Motion:[0.0,0.1,-2.0],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 4 run summon minecraft:arrow ~-0.35 ~1.2 ~-1.5 {Motion:[-0.35,0.1,-1.97],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 4 run summon minecraft:arrow ~0.35 ~1.2 ~-1.5 {Motion:[0.35,0.1,-1.97],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}

execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 5 run summon minecraft:arrow ~1.06 ~1.2 ~-1.06 {Motion:[1.41,0.1,-1.41],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 5 run summon minecraft:arrow ~1.3 ~1.2 ~-0.9 {Motion:[1.66,0.1,-1.16],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 5 run summon minecraft:arrow ~0.9 ~1.2 ~-1.3 {Motion:[1.16,0.1,-1.66],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}

execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 6 run summon minecraft:arrow ~1.5 ~1.2 ~ {Motion:[2.0,0.1,0.0],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 6 run summon minecraft:arrow ~1.5 ~1.2 ~-0.35 {Motion:[1.97,0.1,-0.35],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 6 run summon minecraft:arrow ~1.5 ~1.2 ~0.35 {Motion:[1.97,0.1,0.35],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}

execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 7 run summon minecraft:arrow ~1.06 ~1.2 ~1.06 {Motion:[1.41,0.1,1.41],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 7 run summon minecraft:arrow ~0.9 ~1.2 ~1.3 {Motion:[1.16,0.1,1.66],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s if score #BUCKET tspire_timer matches 7 run summon minecraft:arrow ~1.3 ~1.2 ~0.9 {Motion:[1.66,0.1,1.16],damage:4.0,Pickup:0b,crit:1b,Tags:["tspire_arrow"]}

# --- 3) 表现与提示（原有 actionbar / 音效在 boss/active 里）---
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.arrow.shoot master @s ~ ~ ~ 1.4 0.9
title @a[team=tspire_party] actionbar {"text":"【三连射】三支弩箭呈扇形飞来 —— 侧移躲开！","color":"gold","bold":true}
