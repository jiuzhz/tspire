# 单名玩家每 tick 的节点接近检测（由 tspire:tick/player 调用）
# ============================================================
# 两条触发路径：
#   A. 服务节点（工匠 / 商人）：打了 tspire_node_reusable 的，**可以反复进**。
#      只要人不在里面（@s tspire_service = 0）就触发，回头再来同样有效。
#   B. 普通节点：只有 tspire_node_avail 且**没被消费过**（!tspire_node_spent）才触发。
#      战斗 / 精英 / 宝箱 / Boss 都是"进一次就消费掉"，防止刷。
#
# 【别再加全局冷却】v0.6.10 用 #NODE_COOLDOWN 做防重复，结果每个节点都要等 2 秒
#   才响应，玩起来就是"后面的房间有延迟触发"。防重复靠"节点只消费一次"就够了。
#
# 注意：这里**不要**加 execute in tspire:tower —— 本函数由 tick/player 用
#   `as @a at @s` 调用，维度已经跟着玩家切到塔里了。

# A. 服务节点（可复用）
execute if score @s tspire_service matches 0 if score #BATTLE_ACTIVE tspire_timer matches 0 if entity @e[tag=tspire_node_reusable,distance=..3,limit=1] run function tspire:map/enter_service

# B. 普通节点（一次性）
execute if score #BATTLE_ACTIVE tspire_timer matches 0 if entity @e[tag=tspire_node_avail,tag=!tspire_node_spent,distance=..3,limit=1] run function tspire:map/enter

# 走远了就允许服务节点再次触发
execute unless entity @e[tag=tspire_node_reusable,distance=..4] run scoreboard players set @s tspire_service 0

# 收掉服务节点身上的 tspire_node_current。
# 【v0.6.22】工匠/商人可复用、不会再走 complete_node，所以如果不主动清，
#   这个 tag 会永远挂在它们身上；之后走进战斗房间就会**同时存在两个 current**，
#   battle_start 里 `@e[tag=tspire_node_current,limit=1]` 就会随便挑一个 ——
#   实测表现是"打到第三行被传送回第二行的工匠节点"。
#
# 【为什么是每 tick 无条件跑，而不是只在"走远"那一支里跑】
#   多人局里几乎总有人离服务节点 4 格以上，无条件清更简单也不会漏。
#   这里**故意**做成每 tick 清：enter_service 在本函数第 16 行才把 tag 加上，
#   而 enter_artisan / enter_merchant 里用到 current 的 complete_node 已经在
#   同一 tick 的更早位置跑完了 —— 所以"加上又立刻被清掉"是预期行为，
#   服务节点的 current 本来就只需要活在那一次调用里。
#   战斗节点没有 tspire_node_reusable，不会被这条清掉。
tag @e[tag=tspire_node_current,tag=tspire_node_reusable] remove tspire_node_current
