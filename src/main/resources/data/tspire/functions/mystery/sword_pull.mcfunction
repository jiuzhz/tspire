# 石中剑 · 拔剑：生命 >15 点才允许（菜单里低血量的按钮本来就不可点，这里是第二道防线）
# ============================================================
# 【v0.7.20 修复】
#   1) 守卫改成即时读取（`function tspire:hp/read`）：原来读 tspire_hp（health 判据，
#      只在被显示时同步），判据偏高就会在真实血量很低时放行 → 扣 15 点 → **扣死**。
#   2) **先置位再扣血**：旧版连点两次会在同一拍跑两遍（各扣 15 点 = 必死）。现在一进来
#      就把这次选择消费掉；血量不够就撤回（置回 0）并只提示，玩家可以改选别的。
#   阈值：15 点伤害要求 #HP_H ≥ 32（= 16 点）→ 扣完至少剩 1 点。
# ============================================================
# 1) 先消费选择（防连点重复结算）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
# 2) 即时读取真实生命
execute if score @s tspire_my_choice matches 1 run function tspire:hp/read
# 3) 生命不够 → 撤回选择 + 提示（不消耗这一选）
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches ..31 run scoreboard players set @s tspire_my_choice 0
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches ..31 run tellraw @s [{"text":"[石中剑] ","color":"red","bold":true},{"text":"你现在的生命承受不住拔剑的反噬（需要 16 点以上）—— 石堆纹丝不动。","color":"red"}]
# 4) 生命够 → 结算
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 32.. run damage @s 15 minecraft:magic
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 32.. run loot give @s loot tspire:mystery/sword_t3
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 32.. run tellraw @s [{"text":"[石中剑] ","color":"white","bold":true},{"text":"剑被拔出来了！反噬撕裂了你的手臂（-15 生命），但你手里多了一把沉甸甸的剑。","color":"green"}]
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 32.. as @s at @s run playsound minecraft:entity.player.attack.crit master @s ~ ~ ~ 1 0.8
