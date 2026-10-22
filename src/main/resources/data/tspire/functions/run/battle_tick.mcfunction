# 战斗进行中：每 tick 由 tspire:tick 调用
# ============================================================
# 【v0.7.53 修「精英房没出怪就瞬间通关」】
#   原来判据只有两条：#BATTLE_TIMER >= 20（= 1 秒）且场上没有 tspire_mob。
#   battle_tick 是**每 tick** 跑的，所以"20"只有 1 秒宽限 —— 一旦这一场因为
#   **出怪上限被占满**而一只怪都没生成，"无怪即胜"当场成立 → 房间瞬间完成。
#   现在拆成三段：
#     1) 每 tick 记录「本场是否见过怪」(#BATTLE_SEEN)
#     2) 见过怪 + 场上清空 + 过了宽限 → 正常胜利
#     3) 一直没见过怪，且已经过了 20 秒 → 判定为**空房**，提示一句再自结
#        （不再 1 秒闪结；同时开局清场 + 之后的出怪重试会尽量避免走到这一步）
# ============================================================

scoreboard players add #BATTLE_TIMER tspire_timer 1

# 1) 本场见过怪吗（一旦见过就粘住，怪死光也不会丢）
execute if entity @e[tag=tspire_mob] run scoreboard players set #BATTLE_SEEN tspire_timer 1

# 2) 正常胜利：见过怪、场上已清空、且过了 1 秒宽限
execute if score #BATTLE_TIMER tspire_timer matches 20.. if score #BATTLE_SEEN tspire_timer matches 1 unless entity @e[tag=tspire_mob] run function tspire:run/battle_win

# 3) 空房兜底：20 秒（400 tick）内一只怪都没出现 → 提示 + 自结，避免卡住
execute if score #BATTLE_TIMER tspire_timer matches 400 if score #BATTLE_SEEN tspire_timer matches 0 run title @a[team=tspire_party] actionbar {"text":"本场没有敌人（出怪被上限拦截）—— 房间已自动结算","color":"yellow"}
execute if score #BATTLE_TIMER tspire_timer matches 400 if score #BATTLE_SEEN tspire_timer matches 0 run function tspire:run/battle_win