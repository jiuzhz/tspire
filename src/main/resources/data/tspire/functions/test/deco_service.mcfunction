# 预览：服务节点的固定装饰（按当前节点的类型自动选）
#   工匠节点 -> map/build_workshop（工匠房装饰 + 箱子内容）
#   商人节点 -> map/build_merchant_stall（商人房装饰 + 商人 NPC）
#   宝箱节点 -> deco/chest（宝箱房装饰；奖励仍由进场流程直接发放）
# 站在别的房间里执行不会铺任何东西，只会给一句提示（服务房装饰都是固定坐标布局）。
execute if entity @e[tag=tspire_node_current,tag=tspire_type_artisan] in tspire:tower as @e[tag=tspire_node_current,limit=1] at @s run function tspire:map/build_workshop
execute if entity @e[tag=tspire_node_current,tag=tspire_type_merchant] in tspire:tower as @e[tag=tspire_node_current,limit=1] at @s run function tspire:map/build_merchant_stall
execute if entity @e[tag=tspire_node_current,tag=tspire_type_chest] in tspire:tower as @e[tag=tspire_node_current,limit=1] at @s run function tspire:deco/chest
execute if entity @e[tag=tspire_node_current,tag=tspire_type_artisan] run title @s actionbar {"text":"[deco] 已铺工匠房装饰（含箱子内容）","color":"green","bold":true}
execute if entity @e[tag=tspire_node_current,tag=tspire_type_merchant] run title @s actionbar {"text":"[deco] 已铺商人房装饰（含商人 NPC）","color":"green","bold":true}
execute if entity @e[tag=tspire_node_current,tag=tspire_type_chest] run title @s actionbar {"text":"[deco] 已铺宝箱房装饰","color":"green","bold":true}
execute unless entity @e[tag=tspire_node_current,tag=tspire_type_artisan] unless entity @e[tag=tspire_node_current,tag=tspire_type_merchant] unless entity @e[tag=tspire_node_current,tag=tspire_type_chest] run tellraw @s [{"text":"[deco] 当前不是工匠/商人/宝箱节点 —— 请站到对应房间里再执行；战斗房装饰用 test/deco_1..5 或 test/deco_random","color":"yellow"}]
