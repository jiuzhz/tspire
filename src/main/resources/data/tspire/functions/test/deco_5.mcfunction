# 预览：一层战斗房装饰 第 5 种（红树林湿地：草方块 + 灰化土 + 红树林根/红树林叶）
execute if entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run function tspire:deco/f1_5
execute unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] run function tspire:deco/f1_5
title @s actionbar {"text":"[deco] 已生成 5 号装饰","color":"green","bold":true}
