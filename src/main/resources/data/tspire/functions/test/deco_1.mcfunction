# 预览：一层战斗房装饰 第 1 种（云杉林地：草方块 + 灰化土 + 苔藓/蘑菇/云杉栅栏）
# 锚点优先取"当前节点"，没有当前节点就锚在玩家脚下（站在任意一间 15×15 房间里都能预览）。
execute if entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run function tspire:deco/f1_1
execute unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] run function tspire:deco/f1_1
title @s actionbar {"text":"[deco] 已生成 1 号装饰","color":"green","bold":true}
