# ============================================================
# 神秘事件门禁（每 tick，由 tick/player 调用一次）
# ============================================================
# 「所有玩家必须做出选择后才能离开房间」：
#   · 房间的门要不要开，取决于 complete_node 有没有跑（没跑 → 下一行门是封的、上一间也是封的）；
#   · 所以这里只做一件事：**所有还活着的队员都选完了** → 结算并 complete_node。
# 阵亡（旁观）的人不再计数，否则全队会卡死；队伍全灭时也不卡（要求至少有一名存活队员）。
# @s tspire_my_choice：0 = 还没选，≥1 = 已选（具体含义由事件自己定义）。
# ============================================================

execute if score #MYST_ACTIVE tspire_timer matches 1 if entity @a[team=tspire_party,scores={tspire_dead=0}] unless entity @a[team=tspire_party,scores={tspire_dead=0,tspire_my_choice=0}] run function tspire:mystery/finish
execute if score #MYST_ACTIVE tspire_timer matches 1 run title @a[team=tspire_party] actionbar {"text":"选择吧 —— 所有人都做出选择后门才会打开","color":"gray"}

# v0.7.8：重掷请求（3 人以上抽到援兵）—— 放在门禁之前处理
execute if score #MYST_REROLL tspire_timer matches 1 run function tspire:mystery/do_reroll

# v0.7.4 持续拉人：roll_event 只在事件开始拉一次，不够 ——
#   被击退出去、掉线重连、或老存档里已经卡在走廊的人，必须每 tick 拉回来，
#   否则他做不了选择 → 门永远不会开。
execute if score #MYST_ACTIVE tspire_timer matches 1 as @a[team=tspire_party,scores={tspire_dead=0}] at @e[tag=tspire_node_current,limit=1] if entity @s[distance=8..200] run tp @s ~ ~ ~2
