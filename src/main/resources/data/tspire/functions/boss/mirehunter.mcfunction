# ============================================================
# 沼泽猎手 · 三机制（v0.6.44 全面重做，玩家指定）
# ============================================================
# 1) 【泥沼】（主动，每 **12 秒** = 240 tick，冷却 `#MIRE_C1`）
#    在 Boss 12 格范围内选 **3 个不同的点**，各生成半径 5 的泥沼，持续 **10 秒**；
#    泥沼边缘有粒子提示。玩家在泥里累计超过 **1.5 秒** → 获得**缓慢 10** 3 秒，
#    同时 Boss 获得**速度 II** 5 秒；缓慢结束后玩家有 **5 秒**免疫泥沼控制。
#    实现见 boss/mirehunter_mud（选点并布下 3 个 tspire_mud marker）
#    与 boss/mirehunter_mud_check（逐 tick 判定 + 计时 + 免疫）。
# 2) 【标枪投掷】（主动，每 **7 秒** = 140 tick，冷却 `#MIRE_C2`）
#    前置 **2 秒前摇**（100..139）：见 boss/mirehunter_javelin_aim；
#    到 140 由 boss/mirehunter_javelin 结算（半径 7、中毒 5 秒、边缘粒子圈）。
# 3) 【泥沼现身】（阶段，HP ≤ 50% = 150，每 **16 秒** = 320 tick，冷却 `#MIRE_C3`）
#    若有玩家在 Boss **12 格以外**，就传送到那名玩家附近 —— 见 boss/mirehunter_appear。
#    （旧名【淤泥附身】，本轮按玩家要求改名并重做。）
# ============================================================

# ---------- 1) 【泥沼】每 12 秒布 3 片 ----------
scoreboard players add #MIRE_C1 tspire_timer 1
execute if score #MIRE_C1 tspire_timer matches 240.. run function tspire:boss/mirehunter_mud

# ---------- 2) 【标枪投掷】每 7 秒，前 2 秒是前摇 ----------
scoreboard players add #MIRE_C2 tspire_timer 1
execute if score #MIRE_C2 tspire_timer matches 100..139 run function tspire:boss/mirehunter_javelin_aim
execute if score #MIRE_C2 tspire_timer matches 140.. run function tspire:boss/mirehunter_javelin

# ---------- 3) 【泥沼现身】残血阶段每 16 秒 ----------
scoreboard players add #MIRE_C3 tspire_timer 1
execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer if score #MIRE_C3 tspire_timer matches 320.. run function tspire:boss/mirehunter_appear

# ---------- 泥沼逐 tick 判定（区域存在时才跑）----------
execute if score #MUD_T tspire_timer matches ..200 run function tspire:boss/mirehunter_mud_check
