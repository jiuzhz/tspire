# ============================================================
# 铭刻者 · 四机制（v0.6.56 按玩家规格重做）
# ============================================================
# 血量（v0.7.10 玩家要求：随人数缩放，整条曲线降低：1/2/3+ 人 = 400 / 500 / 600）。原三机制里【镜像分身】【铭刻重写】【强化剥离】全部替换：
#   1) 【时间铭刻】  每 15 秒：所有玩家 7 秒**折返**（tconstruct:returning）+ 5 秒虚弱
#   2) 【铭刻逆流】  每 **47 秒**：BOSS 传送到场地中央、自身缓慢 10 八秒、
#      所有玩家缓慢 II 八秒；窗口内 BOSS 一受伤就**立刻**结算（失明 2 秒 + 随机传送）；
#      撑满窗口没受伤 → 回复 **16** 点血（v0.7.10，原 32 点）。传送后在它脚下留一圈黑粒子，跟随本体 30 秒。
#      （安全，不出场地/不卡墙）+ 自身发光 6 秒
#   3) 【时间书虫】  **HP ≤ 50% 才会发动**，每 10 秒生成 2 只蠹虫（v0.7.2：不再"残血多召一只"）
#   4) 【遗忘蚀刻】  HP < 50% 后每 **65 秒**，按在场人数分支（1 / 2 / 3+）
# 血量来源：boss/tick 每 tick 把 Health 写进 tspire_boss_hp。
# ============================================================

# ---------- 1) 【时间铭刻】每 15 秒（300 tick）----------
scoreboard players add #INS_C1 tspire_timer 1
execute if score #INS_C1 tspire_timer matches 300.. run function tspire:boss/inscriber_timemark

# ---------- 2) 【铭刻逆流】每 47 秒（940 tick）----------
scoreboard players add #INS_C2 tspire_timer 1
execute if score #INS_C2 tspire_timer matches 940.. run function tspire:boss/inscriber_rewind

# 【v0.7.10】传送后跟着本体的黑粒子（30 秒），由 inscriber_aura 自己计时
execute if entity @e[tag=tspire_ins_aura] run function tspire:boss/inscriber_aura

# 铭刻逆流的观察窗口（160 tick = 8 秒）：受伤则**立刻**结算，撑满窗口才回血（见 rewind_watch）
execute if score #INS_LOOK tspire_timer matches 1.. run function tspire:boss/inscriber_rewind_watch

# ---------- 3) 【时间书虫】**HP ≤ 50% 后**每 10 秒（200 tick）----------
#   v0.7.2（玩家要求）：改成血量门触发；周期 8 -> 10 秒；并去掉"残血多召一只"。
scoreboard players add #INS_C3 tspire_timer 1
execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer if score #INS_C3 tspire_timer matches 200.. run function tspire:boss/inscriber_bookworm

# ---------- 4) 【遗忘蚀刻】HP < 50% 后每 65 秒（1300 tick）----------
scoreboard players add #INS_C4 tspire_timer 1
execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer if score #INS_C4 tspire_timer matches 1300.. run function tspire:boss/inscriber_oblivion
