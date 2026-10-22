# 在房间正中放一只锁住的箱子（**必须在塔维度里执行**）
# v0.6.22 起它只是"这里有三选一奖励"的视觉标志：奖励本身走聊天菜单，
# 箱子是 Lock 的、打不开，里面也不再装东西。
# 顺序：先按旧 marker 挖掉旧箱子（offer_clear 已做），再放新的。

# 有当前节点就放在房间正中；没有（例如 test/reward_demo 单独试）就放在执行者脚下
execute unless entity @e[tag=tspire_node_current] at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_offer"]}
execute at @e[tag=tspire_node_current,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["tspire_offer"]}
execute at @e[tag=tspire_offer] run setblock ~ ~ ~ minecraft:chest{Lock:"tspire_sealed"}
