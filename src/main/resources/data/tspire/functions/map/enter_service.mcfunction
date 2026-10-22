# ============================================================
# 服务节点（工匠 / 商人）—— 离开房间后还能再回来用
# ============================================================
# 执行者 = 玩家。
#
# 这两类节点不是"一次性"的：玩家走完一段路想回头修装备 / 补货都应该可以。
# 所以它们完成时会被打上 tspire_node_reusable，之后由 map/player_check
# 走这条**独立分支**触发 —— 不参与"一行只能选一个"的 node_begin，
# 也不会把同一行其他房间锁掉。
#
# @s tspire_service = 1 表示"人还在这个服务节点里"，避免站在房间里每秒重复弹菜单；
# 走远（4 格以外）由 tick/player 清零。
# ============================================================

scoreboard players set @s tspire_service 1

# 【v0.6.22】先把旧 current 清干净，保证同一时刻只有一个 current
# （否则 battle_start 的"拉队友进房间"会选中上一个工匠/商人节点）
tag @e[tag=tspire_node_current] remove tspire_node_current
tag @e[tag=tspire_node_reusable,distance=..3,limit=1,sort=nearest] add tspire_node_current

# 【v0.6.27 关键修正】服务节点**也要锁掉本行其余房间**。
#   原来只有普通节点走 node_begin，工匠/商人只贴个 current 就完事 ——
#   于是同一行的其他房间仍然是 avail、门也开着，玩家从出口绕回去就能进，
#   实测就是"走过宝箱/商人/工匠节点后，封口石没生效、能进同行的其他房间"。
#   第一次进这个服务节点时补跑一次 node_begin（幂等），之后（节点已 done）不再重复。
execute as @e[tag=tspire_node_current,limit=1] unless entity @s[tag=tspire_node_done] run function tspire:map/node_begin

execute if entity @e[tag=tspire_node_current,tag=tspire_type_artisan,distance=..3,limit=1] run function tspire:map/enter_artisan
execute if entity @e[tag=tspire_node_current,tag=tspire_type_merchant,distance=..3,limit=1] run function tspire:map/enter_merchant
