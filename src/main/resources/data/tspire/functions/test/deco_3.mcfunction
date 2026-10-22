# 预览：一层战斗房装饰 第 3 种（樱花庭院：草方块 + 灰化土 + 樱花木/樱花叶 + 灯笼/磁石/粉瓣）
execute if entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run function tspire:deco/f1_3
execute unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] run function tspire:deco/f1_3
title @s actionbar {"text":"[deco] 已生成 3 号装饰","color":"green","bold":true}
