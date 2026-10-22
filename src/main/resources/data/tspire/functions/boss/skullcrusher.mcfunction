# ============================================================
# 裂颅者 · 三机制（v0.6.48 重做，玩家指定）
# ============================================================
# 1) 【三连射】每 **8 秒**（原来 3 秒）—— 仍在 boss/active 里按 #BOSS_TIMER 走
#    （那里已改成 120..159 前摇 / 160 触发，本文件不动它）。
# 2) 【战术突进】每 **16 秒**（`#SKU_C2` 到 320）：
#    · 前摇 **2 秒**（280..319）：Boss 每 tick **朝向最近的玩家**，
#      且**只在落点**生成粒子（见 skullcrusher_charge_aim）。
#    · 到点由 skullcrusher_charge 结算：突进 5 格，落点 4 格内的玩家被
#      **水平**击退 5 格 + 4 点伤害 + 虚弱 + 缓慢 II。
#      ⚠️ 击退只走 X/Z 主轴，**刻意不向下推** —— 玩家报过被击退出图。
# 3) 【钉刺陷阱】每 **12 秒**（`#SKU_C3` 到 240）：Boss 12 格内选 **5 个点**
#    （沿用沼泽猎手【泥沼】的"基准方向 + 固定步进"选点法），每点半径 **2 格**、
#    粒子明显；玩家进入 2 格内 → 3 点伤害 + **缓慢 10** 3 秒 + **强制看向 Boss**，
#    该陷阱随即消失；整批持续 **10 秒**（`#SKU_T2` 0..200）。
# ============================================================

# ---------- 【战术突进】每 16 秒 ----------
scoreboard players add #SKU_C2 tspire_timer 1
execute if score #SKU_C2 tspire_timer matches 280..319 run function tspire:boss/skullcrusher_charge_aim
execute if score #SKU_C2 tspire_timer matches 320.. run function tspire:boss/skullcrusher_charge

# ---------- 【钉刺陷阱】每 12 秒布 5 个 ----------
scoreboard players add #SKU_C3 tspire_timer 1
execute if score #SKU_C3 tspire_timer matches 240.. run function tspire:boss/skullcrusher_traps

# ---------- 陷阱逐 tick 判定（整批存在时才跑）----------
execute if score #SKU_T2 tspire_timer matches ..200 run function tspire:boss/skullcrusher_trap_check
