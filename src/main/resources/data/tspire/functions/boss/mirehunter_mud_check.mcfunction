# ============================================================
# 沼泽猎手【泥沼】· 逐 tick 判定（每 tick 由 boss/mirehunter 调用）
# ============================================================
# 计时：#MUD_T 0..200（200 tick = 10 秒），到点由 mirehunter_mud_end 清场。
# 边缘粒子：8 个点画半径 5 的圈（`as @e[tag=tspire_mud]` 一次覆盖三片）。
#
# 玩家判定（不用宏也能做"在任意一片泥里"）：
#   1) 先给所有人的 tspire_mud_in 清 0；
#   2) `as @e[tag=tspire_mud] as @a[...,distance=..4]` —— 内层选择器的 distance
#      是相对 **marker 的位置** 算的，于是能标出"踩在任意一片里"的人；
#   3) 在泥里的 tspire_mud_t += 1，不在泥里的直接清零（离开就重新计时）。
# 触发：tspire_mud_t ≥ **30（1.5 秒）** 且免疫 tspire_mud_imm == 0（v0.6.59 从 3 秒改到 2 秒，v0.6.60 再改到 1.5 秒）
#   → 玩家**缓慢 10**（amplifier 9）3 秒、Boss **速度 II** 5 秒；
#     然后把免疫置 160（3 秒被困 + 5 秒免疫 = 8 秒），并清零计时。
# 顺序很重要：所有判定都读 tspire_mud_imm == 0，所以必须"先结算、最后写免疫/清零"。
# ============================================================

scoreboard players add #MUD_T tspire_timer 1
scoreboard players add @a[team=tspire_party] tspire_mud_t 0
scoreboard players add @a[team=tspire_party] tspire_mud_imm 0
scoreboard players add @a[team=tspire_party] tspire_mud_in 0

# --- 边缘粒子：半径 4 的 8 个点 + 中心少量气泡 ---
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~5 ~0.2 ~ 0 0 0 0 3 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~-5 ~0.2 ~ 0 0 0 0 3 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~ ~0.2 ~5 0 0 0 0 3 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~ ~0.2 ~-5 0 0 0 0 3 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~3.5 ~0.2 ~3.5 0 0 0 0 3 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~-3.5 ~0.2 ~3.5 0 0 0 0 3 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~3.5 ~0.2 ~-3.5 0 0 0 0 3 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:item_slime ~-3.5 ~0.2 ~-3.5 0 0 0 0 3 force
execute as @e[tag=tspire_mud] at @s run particle minecraft:sculk_soul ~ ~0.3 ~ 4 0.1 4 0.01 4 force

# --- 免疫倒计时 ---
execute as @a[team=tspire_party,scores={tspire_mud_imm=1..}] run scoreboard players remove @s tspire_mud_imm 1

# --- 标记"这一 tick 是否踩在泥里" ---
scoreboard players set @a[team=tspire_party] tspire_mud_in 0
# v0.6.48 CRITICAL FIX: `as` only changes the EXECUTOR -- it does NOT move the execution
#   position (that is what `at` does). Without `at @s` the `distance=..4` below was measured
#   from wherever boss/tick happened to be executing (the tower origin), so NO player ever
#   matched -> the mud had particles (those lines do use `at @s`) but never slowed anyone.
execute as @e[tag=tspire_mud] at @s as @a[team=tspire_party,distance=..5,scores={tspire_dead=0}] run scoreboard players set @s tspire_mud_in 1

# --- 累计 / 清零 ---
execute as @a[team=tspire_party,scores={tspire_mud_in=1}] run scoreboard players add @s tspire_mud_t 1
execute as @a[team=tspire_party,scores={tspire_mud_in=0}] run scoreboard players set @s tspire_mud_t 0
# 免疫期内**不累计**：否则 8 秒免疫一结束、之前攒的 3 秒立刻又触发一次。
# 这样"缓过来之后要重新站满 1.5 秒才会再被定住"，符合"5 秒不受泥沼控制"的说法。
execute as @a[team=tspire_party,scores={tspire_mud_imm=1..}] run scoreboard players set @s tspire_mud_t 0

# --- 踩满 1.5 秒且不在免疫期 → 先结算效果与提示 ---
execute as @a[team=tspire_party,scores={tspire_mud_t=30..,tspire_mud_imm=0}] run effect give @s minecraft:slowness 3 9 true
execute as @a[team=tspire_party,scores={tspire_mud_t=30..,tspire_mud_imm=0}] run title @s actionbar {"text":"陷进泥沼了！被缓慢 10 定住 3 秒","color":"dark_green","bold":true}
execute as @a[team=tspire_party,scores={tspire_mud_t=30..,tspire_mud_imm=0}] run tellraw @s [{"text":"[沼泽猎手] ","color":"green","bold":true},{"text":"你陷进泥沼：","color":"dark_green","bold":true},{"text":"缓慢 10 持续 3 秒，Boss 同时获得速度 II —— 缓过来后有 5 秒不会再被泥沼控制。","color":"yellow"}]
execute as @a[team=tspire_party,scores={tspire_mud_t=30..,tspire_mud_imm=0}] at @s run particle minecraft:item_slime ~ ~0.3 ~ 0.8 0.4 0.8 0.05 40 force
execute if entity @a[team=tspire_party,scores={tspire_mud_t=30..,tspire_mud_imm=0}] run effect give @e[tag=tspire_boss_mirehunter,limit=1] minecraft:speed 5 1 true
execute if entity @a[team=tspire_party,scores={tspire_mud_t=30..,tspire_mud_imm=0}] as @a[team=tspire_party] at @s run playsound minecraft:entity.drowned.hurt master @s ~ ~ ~ 1.2 0.6
execute if entity @a[team=tspire_party,scores={tspire_mud_t=30..,tspire_mud_imm=0}] run title @a[team=tspire_party] actionbar {"text":"【泥沼】有人被定住了 —— Boss 加速！","color":"green","bold":true}

# --- 再写免疫与清零 ---
execute as @a[team=tspire_party,scores={tspire_mud_t=30..,tspire_mud_imm=0}] run scoreboard players set @s tspire_mud_imm 100
execute as @a[team=tspire_party,scores={tspire_mud_imm=1..}] run scoreboard players set @s tspire_mud_t 0

# --- 10 秒到点：清场 ---
execute if score #MUD_T tspire_timer matches 201.. run function tspire:boss/mirehunter_mud_end
