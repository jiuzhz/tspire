# ============================================================
# 钴蓝决斗者 · 三机制（v0.6.50 重做，玩家指定）
# ============================================================
# 1) 【死斗】（被动）—— 原【疾风连击】。**v0.6.55 起的现行规则**：
#    玩家**掉血** 且 **3 格内有 Boss** → 该玩家 `tconstruct:bleeding` 3 秒，
#    触发后该玩家 **10 秒冷却**（`tspire_dm_cd`，逐人）。
#    ⚠️ 1.20.1 没有"命中事件"，这是能得到的最接近的写法（不是"被 Boss 打中"才算）。
# 2) 【破釜】（主动，每 **15 秒**，`#DUE_C1` 300）—— 原【崩刃】。
#    随机获得一种效果：8 秒**速度 II** / 12 秒**抗性提升** / 6 秒**力量**，
#    每种都给 actionbar + 聊天提示。
# 3) 【决斗嘶吼】（阶段，HP ≤ **250**（500 的 50%），每 **16 秒**，`#DUE_C2` 320）
#    —— 原【玛玉灵回响】。全场播放**末影龙嘶吼**，所有玩家获得
#    12 秒**虚弱** + 12 秒**穿甲 II**（`tconstruct:pierce`，匠魂效果）。
# 血量来源：`boss/tick` 每 tick 把 Health 写进 `tspire_boss_hp`（见那里的说明）。
# ============================================================

# ---------- 1) 【死斗】被动：每 2 秒（40 tick）检查一轮"掉血 + 3 格内"----------
# 【v0.6.55】改成现行规则后**重新默认开启**（`#CFG_DUELIST_DEATHMATCH = 1`）；
#   嫌强就把它改回 0（函数保留，不用改代码）。
#   注意：计时器照常走，所以开关打开后不会等 2 秒才第一次触发。
scoreboard players add #DUE_C3 tspire_timer 1
execute if score #CFG_DUELIST_DEATHMATCH tspire_config matches 1.. if score #DUE_C3 tspire_timer matches 40.. run function tspire:boss/duelist_deathmatch

# ---------- 2) 【破釜】每 15 秒 ----------
scoreboard players add #DUE_C1 tspire_timer 1
execute if score #DUE_C1 tspire_timer matches 300.. run function tspire:boss/duelist_allin

# ---------- 3) 【决斗嘶吼】HP ≤ 250 后每 16 秒 ----------
scoreboard players add #DUE_C2 tspire_timer 1
execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer if score #DUE_C2 tspire_timer matches 320.. run function tspire:boss/duelist_roar
