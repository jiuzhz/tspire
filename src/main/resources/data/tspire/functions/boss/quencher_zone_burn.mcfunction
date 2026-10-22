# ============================================================
# 【燃烧蓄能】燃烧阶段每 tick —— 执行位置 = 圆心
# ============================================================
# 纯粒子版：无火焰方块。
# 【v0.6.44 特效调整（玩家要求）】粒子重点画在**技能范围边缘**：
#   以前是在 5 格圈里大扩散地随机撒火焰（delta 10/4），范围感很糊；
#   现在沿半径 5 画一圈 12 个点（火焰 + 岩浆），燃烧阶段再叠大烟柱，
#   圈内只留少量中心柱 —— 玩家一眼就能看出"边界在哪、要不要出圈"。
# 伤害在两秒前摇后每 20 tick 1 点（3 秒共 3 点），只在燃烧期结算。
# ============================================================

# --- 边缘圈：半径 5 的 12 个等分点（每 tick 都画，提示期 + 燃烧期）---
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~5 ~0.2 ~ 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~-5 ~0.2 ~ 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~ ~0.2 ~5 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~ ~0.2 ~-5 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~3.5 ~0.2 ~3.5 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~-3.5 ~0.2 ~3.5 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~3.5 ~0.2 ~-3.5 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~-3.5 ~0.2 ~-3.5 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~4.6 ~0.2 ~1.9 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~-4.6 ~0.2 ~1.9 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~4.6 ~0.2 ~-1.9 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:flame ~-4.6 ~0.2 ~-1.9 0 0 0 0 2 force

# 边缘再叠一层岩浆点，让边界更"烫"、更显眼
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~5 ~0.3 ~ 0 0 0 0 1 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~-5 ~0.3 ~ 0 0 0 0 1 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~ ~0.3 ~5 0 0 0 0 1 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~ ~0.3 ~-5 0 0 0 0 1 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~3.5 ~0.3 ~3.5 0 0 0 0 1 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~-3.5 ~0.3 ~3.5 0 0 0 0 1 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~3.5 ~0.3 ~-3.5 0 0 0 0 1 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~-3.5 ~0.3 ~-3.5 0 0 0 0 1 force

# 边缘的大烟柱（只在燃烧阶段，避免和预警圈混淆）
execute if score #QZ_T tspire_timer matches 41..60 run particle minecraft:large_smoke ~5 ~0.6 ~ 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches 41..60 run particle minecraft:large_smoke ~-5 ~0.6 ~ 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches 41..60 run particle minecraft:large_smoke ~ ~0.6 ~5 0 0 0 0 2 force
execute if score #QZ_T tspire_timer matches 41..60 run particle minecraft:large_smoke ~ ~0.6 ~-5 0 0 0 0 2 force

# 少量中心柱：留一点"里面也在烧"的实感，不再满圈乱撒
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:small_flame ~ ~0.4 ~ 0.6 0.5 0.6 0.02 6 force
execute if score #QZ_T tspire_timer matches ..60 run particle minecraft:lava ~ ~0.2 ~ 0.5 0.1 0.5 0 2 force

# --- 灼烧伤害：两秒前摇结束后，每秒 1 点，共 3 次。重叠圆心不叠伤。---
execute if score #QZ_T tspire_timer matches 1 as @a[team=tspire_party,tag=!tspire_burn_hit,scores={tspire_dead=0},distance=..5] run function tspire:boss/quencher_zone_hit
execute if score #QZ_T tspire_timer matches 21 as @a[team=tspire_party,tag=!tspire_burn_hit,scores={tspire_dead=0},distance=..5] run function tspire:boss/quencher_zone_hit
execute if score #QZ_T tspire_timer matches 41 as @a[team=tspire_party,tag=!tspire_burn_hit,scores={tspire_dead=0},distance=..5] run function tspire:boss/quencher_zone_hit
