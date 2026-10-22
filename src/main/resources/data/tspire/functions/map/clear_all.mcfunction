# ============================================================
# 把整座塔刷干净（三层全清 + 清掉所有残留实体）
# ============================================================
# 手动清理和地图演示使用；正常开局改走 map/prepare 分批准备。
#
# 【为什么需要它】
#   地形是按层建的，但一局只会建到当前那层。重开时如果不把**其他两层**也清掉，
#   第 2/3 层会留着上一局的房间和节点标记 —— 看起来就是"房间没刷新"。
#
# 【还有 forceload】
#   一层在 Z 轴上有 200 格，玩家的加载半径覆盖不到远端。
#   没有 forceload 的话，远端那些 fill 会**静默失败**（不报错、只是不生效），
#   于是房间只生成一半、重开也不干净。这里顺手把塔的区块常驻加载。
# ============================================================

execute in tspire:tower unless entity @e[tag=tspire_anchor] run summon minecraft:marker 0 64 0 {Tags:["tspire_anchor"]}

# 塔的区块常驻加载（56 个区块，只在这一局前后有意义）
execute in tspire:tower run forceload add -48 -416 48 32

# 三层体积全清
execute in tspire:tower at @e[tag=tspire_anchor] run function tspire:map/clear_floor
execute in tspire:tower at @e[tag=tspire_anchor] positioned ~ ~32 ~ run function tspire:map/clear_floor
execute in tspire:tower at @e[tag=tspire_anchor] positioned ~ ~64 ~ run function tspire:map/clear_floor

# 清掉所有残留实体
execute in tspire:tower run kill @e[tag=tspire_node]
execute in tspire:tower run kill @e[tag=tspire_starter]
execute in tspire:tower run kill @e[tag=tspire_shop]
execute in tspire:tower run kill @e[tag=tspire_offer]
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_boss]
execute in tspire:tower run kill @e[type=minecraft:item]

# 入夜（14000，比 12000 的日落更暗）
# 注意：1.20.1 的 /time 会遍历**所有维度**，所以主世界也会跟着变成黄昏。
#       想让塔单独停在黄昏就得靠 doDaylightCycle（下面是按维度设的）。
time set 14000
execute in tspire:tower run gamerule doDaylightCycle false
scoreboard players set #MAP_READY1 tspire_timer 0
scoreboard players set #MAP_READY2 tspire_timer 0
scoreboard players set #MAP_READY3 tspire_timer 0
scoreboard players set #MAP_USED tspire_timer 1
