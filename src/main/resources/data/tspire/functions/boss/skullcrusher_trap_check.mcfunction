# ============================================================
# 裂颅者【钉刺陷阱】· 逐 tick 判定（由 boss/skullcrusher 调用，不限执行者）
# ============================================================
# 半径 **2 格**：玩家进入 → 3 点伤害 + **缓慢 10**（amplifier 9）3 秒
#   + **强制看向 Boss**（原地 tp 并 facing Boss 的眼睛）+ 提示，
#   然后 `kill @s` 把这一枚消耗掉（一次性）。
# 未触发的陷阱持续冒粒子（marker 本身不可见）。
# 整批持续 10 秒（#SKU_T2 0..200），到点由 skullcrusher_trap_end 清场；
# 每 12 秒重新布点，所以中间有 2 秒空档。
# 注意每一条都写了 `as @e[...] at @s` —— **`as` 不换位置**，
#   漏掉 `at @s` 的话 `distance=..2` 会在错误的位置计算（泥沼就踩过这个坑）。
# ============================================================

scoreboard players add #SKU_T2 tspire_timer 1

# 未触发时的警示粒子（半径 2 的 8 点圈 + 中心柱）
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~2 ~0.2 ~ 0 0 0 0 3 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~-2 ~0.2 ~ 0 0 0 0 3 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~ ~0.2 ~2 0 0 0 0 3 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~ ~0.2 ~-2 0 0 0 0 3 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~1.4 ~0.2 ~1.4 0 0 0 0 2 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~-1.4 ~0.2 ~1.4 0 0 0 0 2 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~1.4 ~0.2 ~-1.4 0 0 0 0 2 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:crit ~-1.4 ~0.2 ~-1.4 0 0 0 0 2 force
execute as @e[tag=tspire_spike2] at @s run particle minecraft:enchanted_hit ~ ~0.4 ~ 0.4 0.1 0.4 0.02 4 force

# --- 触发判定：**逐枚**判断，不能用全局标记 -------------------------------
# v0.6.48 修正：先前用 `#SPIKE_HIT` 这个全局假玩家做判断，结果是
#   "任意一枚被踩中 -> 所有 5 枚全被 kill"。现在每一条都把条件写在
#   `as @e[tag=tspire_spike2] at @s if entity @a[...]` 里，逐枚独立结算。
# 结算（对每名踩中的玩家）：3 点伤害 + 缓慢 10 3 秒 + 强行看向 Boss
execute as @e[tag=tspire_spike2] at @s as @a[team=tspire_party,distance=..2,scores={tspire_dead=0}] run damage @s 3 minecraft:magic
execute as @e[tag=tspire_spike2] at @s as @a[team=tspire_party,distance=..2,scores={tspire_dead=0}] run effect give @s minecraft:slowness 3 9 true
execute as @e[tag=tspire_spike2] at @s as @a[team=tspire_party,distance=..2,scores={tspire_dead=0}] run tp @s ~ ~ ~ facing entity @e[tag=tspire_boss_skullcrusher,limit=1] eyes
execute as @e[tag=tspire_spike2] at @s as @a[team=tspire_party,distance=..2,scores={tspire_dead=0}] run title @s actionbar {"text":"踩中钉刺！被强行转向裂颅者，缓慢 10 持续 3 秒","color":"red","bold":true}

# --- 该枚陷阱的表现与消耗（一次性，逐枚）---
execute as @e[tag=tspire_spike2] at @s if entity @a[team=tspire_party,distance=..2,scores={tspire_dead=0}] run particle minecraft:enchanted_hit ~ ~0.3 ~ 1 0.2 1 0.05 40 force
execute as @e[tag=tspire_spike2] at @s if entity @a[team=tspire_party,distance=..2,scores={tspire_dead=0}] run particle minecraft:crit ~ ~0.3 ~ 1.5 0.2 1.5 0.05 30 force
execute as @e[tag=tspire_spike2] at @s if entity @a[team=tspire_party,distance=..2,scores={tspire_dead=0}] as @a[team=tspire_party] at @s run playsound minecraft:block.pointed_dripstone.break master @s ~ ~ ~ 1.2 0.7
execute as @e[tag=tspire_spike2] at @s if entity @a[team=tspire_party,distance=..2,scores={tspire_dead=0}] run kill @s

# --- 10 秒到点：整批清场 ---
execute if score #SKU_T2 tspire_timer matches 201.. run function tspire:boss/skullcrusher_trap_end
