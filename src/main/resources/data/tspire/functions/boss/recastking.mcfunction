# ============================================================
# 重铸之王 · 三机制（血量随人数 400/500/600，见 boss/spawn/recastking）
# ============================================================
# 1) 【再锻】BOSS 生成时立刻一次，之后每 **65 秒**（v0.7.10 玩家要求，原 55 秒）：
#    传送回场地中心 → 缓慢 10 三秒 →（三秒后）换上一把**随机 3~4 级匠魂材料的手斧**
#    + 随机获得 45 秒 抗性提升 / 力量 / 速度 之一。
#    武器替换实现方式：`loot replace entity <boss> weapon.mainhand loot tspire:boss_gear/recast_axe`
#    （表由 gen-shops.ps1 生成：hand_axe + 每个 3/4 级材料各一条）✓ 可实现，未降级。
# 2) 【金铸壁垒】HP ≤ 75%（`#TH_75`：300 / 375 / 450）时每 **39 秒**：8 格内玩家**水平**外推 4 格 + 虚弱 4s + 缓慢 II 4s；
#    自身缓慢 10 六秒 + 虚弱 V 六秒 + 抗性提升 IV 六秒（v0.7.19：抗性保留，判定标准明确为"血量掉 6 点"）；随后 6 秒观察窗口结束判：
#      · 这 6 秒内累计受到 ≥6 点伤害 → **立刻**结算（v0.7.10，同铭刻者【铭刻逆流】）：自身缓慢 II 五秒 + 虚弱 八秒
#      · 不足 6 点 → 周围召唤 2 名随机卫兵（猪灵蛮兵或弩手猪灵，均 50 血）+ 自身力量 五秒
# 3) 【王权征召】HP ≤ **25%**（`#TH_25`：100 / 125 / 150）时每 **24 秒**：自身缓慢 10 两秒；两秒后：
#      · 场上没有任何守卫（tag=tspire_guard）→ 召唤 **1** 名 50 血随机卫兵（=【金铸壁垒】那种）+ 给它抗性提升 IV 十秒
#      · 有 → 把它们的血量全部回满 + 给它们力量 十秒
# 血量（v0.7.10 玩家要求：随人数缩放，整条曲线降低：1/2/3+ 人 = 400 / 500 / 600，
#   由 boss/spawn/recastking 决定并同步 #MAXHP）。血量来源：boss/tick 每 tick 写入 tspire_boss_hp。
# ============================================================

# ---------- 1) 【再锻】每 65 秒（1300 tick，v0.7.10 由 1100 改）----------
scoreboard players add #RK_C1 tspire_timer 1
execute if score #RK_C1 tspire_timer matches 1300.. run function tspire:boss/recastking_reforge
# 前摇 3 秒结束的那一拍：换武器 + 上随机增益
execute if score #RK_T tspire_timer matches 1.. run scoreboard players remove #RK_T tspire_timer 1
execute if score #RK_T tspire_timer matches 0 if score #RK_ARM tspire_timer matches 1 run function tspire:boss/recastking_reforge_go

# ---------- 2) 【金铸壁垒】HP ≤ 75%（随人数 300 / 375 / 450）时每 39 秒（780 tick）----------
scoreboard players add #RK_C2 tspire_timer 1
execute if score #BNOW tspire_timer <= #TH_75 tspire_timer if score #RK_C2 tspire_timer matches 780.. run function tspire:boss/recastking_bulwark
# 6 秒观察窗口（累计伤害）
execute if score #RK_LOOK tspire_timer matches 1.. run function tspire:boss/recastking_bulwark_watch

# ---------- 3) 【王权征召】HP ≤ 25%（随人数 100 / 125 / 150）时每 24 秒（480 tick）----------
scoreboard players add #RK_C3 tspire_timer 1
execute if score #BNOW tspire_timer <= #TH_25 tspire_timer if score #RK_C3 tspire_timer matches 480.. run function tspire:boss/recastking_summon
execute if score #RK_T2 tspire_timer matches 1.. run scoreboard players remove #RK_T2 tspire_timer 1
execute if score #RK_T2 tspire_timer matches 0 if score #RK_ARM2 tspire_timer matches 1 run function tspire:boss/recastking_summon_go
