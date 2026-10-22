# 预览：一层战斗房装饰 第 2 种（云杉营地：草方块 + 灰化土 + 圆石/石砖结构 + 云杉木）
execute if entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run function tspire:deco/f1_2
execute unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] run function tspire:deco/f1_2
title @s actionbar {"text":"[deco] 已生成 2 号装饰","color":"green","bold":true}
