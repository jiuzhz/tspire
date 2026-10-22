# ============================================================
# 节点转「当前」（执行者 = 节点 marker）
# ============================================================
# 这里是**路线选择**真正生效的地方：
#   1. 当前节点从 available 变 current
#   2. 同一层里**其他还开着的节点立刻锁死** —— 一条路线一行只能走一个
#      （设计文档 §3.1「玩家从底部起点出发，选择路径到达顶部 Boss 节点」）
#
# 为什么要锁：不锁的话玩家可以把一行的节点全部刷完，路线选择就没有意义了。
# 锁的对象是所有 tspire_node_avail；因为同一时刻只有一行是开着的，
# 所以不需要按行筛选。
#
# 解锁下一行的连边由 map/runtime/unlock_next 在 complete_node 时处理。
# ============================================================

tag @s remove tspire_node_avail
tag @s add tspire_node_current
# 工匠 / 商人 是服务节点，不打"已消费"标记 —— 它们完成时会变成 reusable
execute unless entity @s[tag=tspire_type_artisan] unless entity @s[tag=tspire_type_merchant] run tag @s add tspire_node_spent

# 同层其余可选节点：锁死（注意 @s 已经不在 avail 里了，不会被自己锁到）
tag @e[tag=tspire_node_avail] add tspire_node_locked
tag @e[tag=tspire_node_avail] remove tspire_node_avail

# 被锁的房间把门堵上（否则玩家还能走进去）
function tspire:map/refresh_doors
