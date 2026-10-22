# 铭刻者【铭刻逆流】· 8 秒观察窗口（每 tick，只在 #INS_LOOK ≥ 1 时调用）
# 逐 tick 用血量差累计 BOSS 受到的伤害（1.20.1 没有命中事件）：
#   有掉血 → #INS_HIT 置 1（一旦受伤就不再撤销）
# v0.7.2（玩家要求）：**一受伤就立刻结算**，不再等窗口走完。
#   #INS_HIT: 0 = 未受伤, 1 = 刚受伤待结算, 2 = 受伤已结算, 3 = 未受伤已回血
# 窗口撑满（#INS_LOOK 从 1 减到 0）且没受伤 → 回复 16 点血（v0.7.10）
# v0.7.19：取血 scale 从 1 改成 2（半颗心）—— "打到它"不应该因为一次伤害不足 1 点就漏判。

execute store result score #INS_NOW tspire_timer run data get entity @e[tag=tspire_boss_inscriber,limit=1] Health 2
execute if score #INS_HIT tspire_timer matches 0 if score #INS_NOW tspire_timer < #INS_LAST tspire_timer run scoreboard players set #INS_HIT tspire_timer 1
scoreboard players operation #INS_LAST tspire_timer = #INS_NOW tspire_timer

# 剩余时间提示（每 40 tick 刷新一次 actionbar）
execute if score #INS_LOOK tspire_timer matches 1.. run title @a[team=tspire_party] actionbar {"text":"【铭刻逆流】逆流窗口进行中 —— 打到它！","color":"dark_purple","bold":true}

# v0.7.2：受伤 -> 立刻结算并关掉窗口（不等倒计时）
execute if score #INS_HIT tspire_timer matches 1 run function tspire:boss/inscriber_rewind_hit
execute if score #INS_HIT tspire_timer matches 1 run scoreboard players set #INS_HIT tspire_timer 2
execute if score #INS_HIT tspire_timer matches 2 run scoreboard players set #INS_LOOK tspire_timer 0

# 窗口倒计时；撑满且没受伤才回血
execute if score #INS_LOOK tspire_timer matches 1.. run scoreboard players remove #INS_LOOK tspire_timer 1
execute if score #INS_LOOK tspire_timer matches 0 if score #INS_HIT tspire_timer matches 0 run function tspire:boss/inscriber_rewind_heal
execute if score #INS_LOOK tspire_timer matches 0 if score #INS_HIT tspire_timer matches 0 run scoreboard players set #INS_HIT tspire_timer 3
