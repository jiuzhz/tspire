# 把执行玩家纳入尖塔队伍并补齐缺失的计分板
# 被 tspire:load 调用；也可手动 /function tspire:load/join
# ============================================================
# 【v0.6.20 修正：必须幂等】
#   原来这里是一串 `set @s xxx 0`，而 tspire:load 每次 /reload 都会调它 ——
#   结果每次 reload 都把所有人的 phase 和**金币清零**，还顺手废掉了
#   "中断恢复"（人还在塔里，phase 却被打回 0）。
#   现在改用 `add ... 0`：只给**还没有这条分数**的玩家补一个 0，
#   已经有进度的玩家原样保留。
#   真正的一局重置在 run/reset_player 里做，那里才是该清零的地方。
# ============================================================

team join tspire_party @s

scoreboard players add @s tspire_phase 0
scoreboard players add @s tspire_layer 0
scoreboard players add @s tspire_battle 0
scoreboard players add @s tspire_ready 0
scoreboard players add @s tspire_dead 0
scoreboard players add @s tspire_gold 0
