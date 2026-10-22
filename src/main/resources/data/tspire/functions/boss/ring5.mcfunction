# 半径 5 的粒子圈（12 个点，两层）—— 执行位置 = 圆心
# 由 boss/quencher_zone 在前摇期间每 tick 调用
# 【v0.6.31】玩家反馈特效太少 → 从 8 点加到 12 点，并补一圈贴地火焰粒子

particle minecraft:end_rod ~5 ~1 ~ 0 0 0 0 3 force
particle minecraft:end_rod ~4.3 ~1 ~-2.5 0 0 0 0 3 force
particle minecraft:end_rod ~2.5 ~1 ~4.3 0 0 0 0 3 force
particle minecraft:end_rod ~0 ~1 ~5 0 0 0 0 3 force
particle minecraft:end_rod ~-2.5 ~1 ~4.3 0 0 0 0 3 force
particle minecraft:end_rod ~-4.3 ~1 ~2.5 0 0 0 0 3 force
particle minecraft:end_rod ~-5 ~1 ~0 0 0 0 0 3 force
particle minecraft:end_rod ~-4.3 ~1 ~-2.5 0 0 0 0 3 force
particle minecraft:end_rod ~-2.5 ~1 ~-4.3 0 0 0 0 3 force
particle minecraft:end_rod ~0 ~1 ~-5 0 0 0 0 3 force
particle minecraft:end_rod ~2.5 ~1 ~-4.3 0 0 0 0 3 force
particle minecraft:end_rod ~4.3 ~1 ~2.5 0 0 0 0 3 force

# 贴地火焰 + 中心蓄能光柱
particle minecraft:flame ~-5 ~0.1 ~-5 10 0.1 10 0.02 12 force
particle minecraft:end_rod ~ ~0.5 ~ 0.2 1.5 0.2 0.1 8 force
