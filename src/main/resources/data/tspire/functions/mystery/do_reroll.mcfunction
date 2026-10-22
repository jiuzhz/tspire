# ============================================================
# 神秘事件重掷（v0.7.9 修复）—— 由 mystery/tick 每 tick 调用
# ============================================================
# 【v0.7.9 BUG】原来只有 #MYST_REROLL 一个分数、而且**不清零**：
#   tick 每 tick 都 `add 1` → 一旦到 5 就每 tick 都调一次 ev_pharmacy →
#   **药房菜单每 tick 重印一遍**（玩家实测"药房反复刷信息"）。
# 现在拆成两个：#MYST_REROLL = 一次性请求（0/1，取用后立刻清零）；
#   #MYST_REROLL_N = 重掷次数（决定最多重掷 3 次，之后兜底给药房）。
# ============================================================
scoreboard players set #MYST_REROLL tspire_timer 0
scoreboard players add #MYST_REROLL_N tspire_timer 1
# 重掷（最多 3 次）
execute if score #MYST_REROLL_N tspire_timer matches 1..3 run function tspire:mystery/roll_event
# 兜底：连续 3 次都抽到援兵就换成药房（只调一次）
execute if score #MYST_REROLL_N tspire_timer matches 4 run function tspire:mystery/ev_pharmacy
