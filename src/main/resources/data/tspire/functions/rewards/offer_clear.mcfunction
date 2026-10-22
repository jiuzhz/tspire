# 收起三选一宝箱（自带塔维度上下文，从哪调用都行）
# 顺序不能反：先按 marker 位置挖掉 Lock 宝箱，再杀 marker
execute in tspire:tower at @e[tag=tspire_offer] run setblock ~ ~ ~ minecraft:air
execute in tspire:tower run kill @e[tag=tspire_offer]
