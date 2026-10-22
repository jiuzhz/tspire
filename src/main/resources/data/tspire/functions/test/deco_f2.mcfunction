# 预览：二层战斗房装饰（随机一种，和进场时同一套挑选逻辑）
# 锚点优先"当前节点"，没有当前节点就锚在玩家脚下（站在任意房间里都能预览）。
execute if entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run function tspire:deco/pick_f2
execute unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] run function tspire:deco/pick_f2
title @s actionbar [{"text":"[deco] 二层 · 随机到 "},{"score":{"name":"#DECO","objective":"tspire_timer"},"color":"green","bold":true},{"text":" 号装饰","bold":true}]
