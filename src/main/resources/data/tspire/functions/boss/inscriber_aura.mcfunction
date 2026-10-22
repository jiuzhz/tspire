# 【铭刻逆流】传送后的黑粒子（v0.7.10 玩家要求）：跟着本体走，持续 30 秒。
# 每 tick 由 boss/inscriber 在 marker 存在时调用。marker 挂在 BOSS 脚下（不是眼睛高度）。
# 30 秒 = 600 tick 后自动收掉（计数器只在 marker 活着时走，见下）；BOSS 死亡/换房时也立刻收掉。
scoreboard players add #INS_AURA tspire_timer 1
# BOSS 已经不在（被打死 / 换层 / 测试清场）就立刻收掉 marker，否则粒子会留在原地空转。
execute unless entity @e[tag=tspire_boss_inscriber] run kill @e[tag=tspire_ins_aura]
execute at @e[tag=tspire_boss_inscriber,limit=1] run tp @e[tag=tspire_ins_aura,limit=1] ~ ~ ~
execute at @e[tag=tspire_ins_aura,limit=1] run particle minecraft:squid_ink ~ ~0.15 ~ 0.4 0.1 0.4 0.01 4 force
execute at @e[tag=tspire_ins_aura,limit=1] run particle minecraft:smoke ~ ~0.1 ~ 0.3 0.05 0.3 0.005 2 force
execute if score #INS_AURA tspire_timer matches 600.. run kill @e[tag=tspire_ins_aura]
