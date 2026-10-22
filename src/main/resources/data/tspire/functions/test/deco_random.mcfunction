# 预览：按当前层随机挑一种战斗房装饰（和进场时走的是同一套挑选逻辑，会报出骰到的号）
# 锚点优先"当前节点"，没有当前节点就锚在玩家脚下。
execute if entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run function tspire:deco/pick_any
execute unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] run function tspire:deco/pick_any
title @s actionbar [{"text":"[deco] 随机到 "},{"score":{"name":"#DECO","objective":"tspire_timer"},"color":"green","bold":true},{"text":" 号装饰（当前层 = "},{"score":{"name":"#FLOOR","objective":"tspire_timer"},"color":"yellow"},{"text":"）","bold":true}]
