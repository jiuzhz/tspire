# 【熔火地脉】每 tick（#MLZ ≥ 1 时由 moltenlord 调用）
# v0.7.19 修复（玩家实测：血量锁失效、火焰在前摇里就出现）：
#   · #MLZ_T 1..30   = 1.5 秒前摇：Boss 缓慢 10，只画"将要燃烧的范围"粒子，**不点火**
#   · #MLZ_T = 41    = 点燃：按**点燃瞬间**的血量档 fill 一次真火焰
#                      （#ML_WIDE_F：1 = 5×5（HP ≤ 50%），0 = 3×3）——宽度在这之后冻结，
#                        否则火焰烧到一半血量跌破 60% 会让"伤害半径"和"火块范围"对不上
#   · #MLZ_T 41..140 = 火焰存续 5 秒，每 20 tick 结算 1 点 in_fire 伤害（60/80/100/120）
#   · #MLZ_T 141..   = 收摊（moltenlord_lava_end 统一清火）
scoreboard players add #MLZ_T tspire_timer 1

# 前 2 秒把 Boss 钉在原地（每 tick 刷新，2 秒一到自然过期）
execute if score #MLZ_T tspire_timer matches ..30 run effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:slowness 1 9 true

# 点燃那一拍：把宽度档冻结到 #ML_WIDE_F，然后铺火
execute if score #MLZ_T tspire_timer matches 31 run scoreboard players operation #ML_WIDE_F tspire_timer = #ML_WIDE tspire_timer
execute if score #MLZ_T tspire_timer matches 31 at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 1 run fill ~-2 ~ ~-2 ~2 ~ ~2 minecraft:fire keep
execute if score #MLZ_T tspire_timer matches 31 at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 0 run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:fire keep
execute if score #MLZ_T tspire_timer matches 31 run title @a[team=tspire_party] actionbar {"text":"【熔火地脉】地面燃起来了 —— 5 秒！","color":"red","bold":true}
execute if score #MLZ_T tspire_timer matches 31 as @a[team=tspire_party] at @s run playsound minecraft:item.firecharge.use master @s ~ ~ ~ 1.4 0.8

# 边缘粒子：3×3（半径 1.5）或 5×5（半径 2.5）—— 前摇时是预警，点燃后是火边
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE tspire_timer matches 1 run particle minecraft:flame ~2.5 ~0.2 ~ 0 0 0 0 2 force
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE tspire_timer matches 1 run particle minecraft:flame ~-2.5 ~0.2 ~ 0 0 0 0 2 force
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE tspire_timer matches 1 run particle minecraft:flame ~ ~0.2 ~2.5 0 0 0 0 2 force
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE tspire_timer matches 1 run particle minecraft:flame ~ ~0.2 ~-2.5 0 0 0 0 2 force
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE tspire_timer matches 0 run particle minecraft:flame ~1.5 ~0.2 ~ 0 0 0 0 2 force
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE tspire_timer matches 0 run particle minecraft:flame ~-1.5 ~0.2 ~ 0 0 0 0 2 force
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE tspire_timer matches 0 run particle minecraft:flame ~ ~0.2 ~1.5 0 0 0 0 2 force
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE tspire_timer matches 0 run particle minecraft:flame ~ ~0.2 ~-1.5 0 0 0 0 2 force
execute at @e[tag=tspire_lava,limit=1] run particle minecraft:lava ~ ~0.1 ~ 1 0.05 1 0.02 4 force

# 伤害：只在火焰真的存在之后（#MLZ_T ≥ 41），每 20 tick 一次，半径按冻结档
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 1 if score #MLZ_T tspire_timer matches 60 as @a[team=tspire_party,distance=..2.7] run damage @s 1 minecraft:in_fire
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 1 if score #MLZ_T tspire_timer matches 80 as @a[team=tspire_party,distance=..2.7] run damage @s 1 minecraft:in_fire
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 1 if score #MLZ_T tspire_timer matches 100 as @a[team=tspire_party,distance=..2.7] run damage @s 1 minecraft:in_fire
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 1 if score #MLZ_T tspire_timer matches 120 as @a[team=tspire_party,distance=..2.7] run damage @s 1 minecraft:in_fire
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 0 if score #MLZ_T tspire_timer matches 60 as @a[team=tspire_party,distance=..1.7] run damage @s 1 minecraft:in_fire
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 0 if score #MLZ_T tspire_timer matches 80 as @a[team=tspire_party,distance=..1.7] run damage @s 1 minecraft:in_fire
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 0 if score #MLZ_T tspire_timer matches 100 as @a[team=tspire_party,distance=..1.7] run damage @s 1 minecraft:in_fire
execute at @e[tag=tspire_lava,limit=1] if score #ML_WIDE_F tspire_timer matches 0 if score #MLZ_T tspire_timer matches 120 as @a[team=tspire_party,distance=..1.7] run damage @s 1 minecraft:in_fire

# 5 秒火（2 秒前摇 + 100 tick）结束：清场
execute if score #MLZ_T tspire_timer matches 141.. run function tspire:boss/moltenlord_lava_end
