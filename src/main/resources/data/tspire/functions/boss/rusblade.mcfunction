# ============================================================
# 锈刃督军 · 三机制（v0.6.32 重做）
# ============================================================
# 玩家要求：
#   1) 【重铸】改为【威压】：自身 8 格内玩家获得 8 秒缓慢；8 格外获得 10 秒虚弱；
#      每 15 秒触发一次。
#   2) 【亡者征召】：血量低于 50% 时改为 **3 只**（基础 2 只 → 残血 3 只，**不是翻倍**；v0.6.44 起去掉南侧那只）。
#   3) 【破甲重击】重做：Boss 先获得缓慢 10 持续 3 秒，随后获得 5 秒速度 II 与力量。
#      每 28 秒触发一次。
#
# 三个机制周期不同（12s / 15s / 28s），所以各自用一个专用计时假玩家，
# 不能共用 #BOSS_TIMER（那个还被 boss/active 的通用技能用着）。
# 本函数由 boss/tick 每 tick 调用。
# ============================================================

# 三个冷却各自累加
execute if entity @e[tag=tspire_boss_rusblade] run scoreboard players add #RUS_C1 tspire_timer 1
execute if entity @e[tag=tspire_boss_rusblade] run scoreboard players add #RUS_C2 tspire_timer 1
execute if entity @e[tag=tspire_boss_rusblade] run scoreboard players add #RUS_C3 tspire_timer 1

# v0.7.89：9 秒：亡者征召
execute if entity @e[tag=tspire_boss_rusblade] if score #RUS_C1 tspire_timer matches 180.. run function tspire:boss/rusblade_summon
# v0.7.89：12 秒：威压
execute if entity @e[tag=tspire_boss_rusblade] if score #RUS_C2 tspire_timer matches 240.. run function tspire:boss/rusblade_pressure
# v0.7.89：17 秒：破甲重击
execute if entity @e[tag=tspire_boss_rusblade] if score #RUS_C3 tspire_timer matches 340.. run function tspire:boss/rusblade_smash

# 破甲重击的第二段：先给自己缓慢 10（3 秒），60 tick 后再上速度 II + 力量 5 秒
execute if score #RUS_SMASH tspire_timer matches 1 run scoreboard players add #RUS_SMASH_T tspire_timer 1
execute if score #RUS_SMASH tspire_timer matches 1 if score #RUS_SMASH_T tspire_timer matches 60.. run function tspire:boss/rusblade_smash_go
