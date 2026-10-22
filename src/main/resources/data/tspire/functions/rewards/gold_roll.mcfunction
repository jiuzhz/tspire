# ============================================================
# 战斗金币：7 + 均匀 1..5 = 8..12（执行者 = 玩家）
# ============================================================
# 【v0.6.46】玩家要求：每场战斗结束的金币在 8~12 之间浮动。
# 每人各调用一次，所以多人时各人拿到的数目不同。

function tspire:util/roll_d5
scoreboard players add @s tspire_gold 7
scoreboard players operation @s tspire_gold += #ROLL tspire_timer
