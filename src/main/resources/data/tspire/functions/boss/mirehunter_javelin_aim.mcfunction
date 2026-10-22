# ============================================================
# 沼泽猎手【标枪投掷】· 2 秒前摇（#MIRE_C2 = 100..139）
# ============================================================
# 玩家要求给【标枪投掷】加 2 秒前摇。前摇期间：
#   · 每 tick 给 Boss 缓慢（amplifier 6）把它钉住，别让它边追边蓄力；
#   · 地上按最终半径 7 画一圈预警（8 点 end_rod），玩家能看清要走多远；
#   · actionbar 按剩余时间倒计时；最后 10 tick 加一层中心水花提示"要来了"。
# 到 140 由 boss/mirehunter_javelin 结算（那里会重置 #MIRE_C2）。
# ============================================================

effect give @e[tag=tspire_boss_mirehunter,limit=1] minecraft:slowness 1 6 true
execute if score #MIRE_C2 tspire_timer matches 100 as @a[team=tspire_party] at @s run playsound minecraft:item.trident.riptide_1 master @s ~ ~ ~ 0.8 0.6
execute if score #MIRE_C2 tspire_timer matches 130 as @a[team=tspire_party] at @s run playsound minecraft:block.bubble_column.whirlpool_inside master @s ~ ~ ~ 0.8 0.8

# 半径 7 的预警圈（8 点）
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~7 ~0.2 ~ 0 0 0 0 1 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~-7 ~0.2 ~ 0 0 0 0 1 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~ ~0.2 ~7 0 0 0 0 1 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~ ~0.2 ~-7 0 0 0 0 1 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~3.5 ~0.2 ~3.5 0 0 0 0 1 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~-3.5 ~0.2 ~3.5 0 0 0 0 1 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~3.5 ~0.2 ~-3.5 0 0 0 0 1 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~-3.5 ~0.2 ~-3.5 0 0 0 0 1 force

# 前摇中段的持续提示（每 tick 都有，靠 actionbar 覆盖不刷屏）
title @a[team=tspire_party] actionbar {"text":"⚠ 【标枪投掷】蓄力中 —— 离开 7 格范围！","color":"yellow","bold":true}

# 最后 10 tick（139..130）加强：中心水花 + 毒气，明确"马上落下"
execute if score #MIRE_C2 tspire_timer matches 130..139 at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:splash ~ ~1 ~ 1.5 0.2 1.5 0.05 20 force
execute if score #MIRE_C2 tspire_timer matches 130..139 at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:witch ~ ~1 ~ 1.2 0.2 1.2 0.03 12 force
execute if score #MIRE_C2 tspire_timer matches 130..139 run title @a[team=tspire_party] actionbar {"text":"⚠ 【标枪投掷】即将命中！","color":"red","bold":true}
