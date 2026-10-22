# 预览：一层战斗房装饰 第 4 种（石砌营地：草方块 + 灰化土 + 圆石墙/台阶 + 篝火 + 苔石）
execute if entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run function tspire:deco/f1_4
execute unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] run function tspire:deco/f1_4
title @s actionbar {"text":"[deco] 已生成 4 号装饰","color":"green","bold":true}
