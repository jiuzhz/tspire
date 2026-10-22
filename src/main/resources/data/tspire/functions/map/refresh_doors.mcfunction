# 按节点状态统一刷门
# ============================================================
# 【v0.6.25 重写：只有"还能去的"房间是开的】
#   开门：tspire_node_avail（本行还没选的可选节点）
#         tspire_node_current（当前所在节点；战斗时另由 terrain/lock 临时封）
#   封门：其它一切 —— 包括
#         tspire_node_locked（本行被放弃的）
#         tspire_node_done  （已经走过的）← v0.6.25 新增，防止回头
#   封条用可见的封条石（geometry.json 的 sealBlock），玩家一眼就能看出
#   "这间进不去 / 回不去了"。
#
# 【为什么要保留 current 才安全】
#   complete_node 结算完之后，玩家还站在那个房间里。如果立刻把它封死，
#   人就被关在里面了。所以 complete_node **不再摘掉 current**，
#   让它继续开着北门给玩家走出去；等玩家踏进下一个节点时，
#   map/enter 会统一清掉旧 current，这时旧房间才会被彻底封上。
# ============================================================

execute as @e[tag=tspire_node] unless entity @s[tag=tspire_node_avail] unless entity @s[tag=tspire_node_current] at @s run function tspire:map/seal_doors
execute as @e[tag=tspire_node_avail] at @s run function tspire:map/unseal_doors
execute as @e[tag=tspire_node_current] at @s run function tspire:map/unseal_doors
