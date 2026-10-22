# 神秘节点掷到"其实是宝箱"（5%）—— 直接复用宝箱节点流程
# 同样先把类型标签换成 chest（宝箱节点是一次性的，这里主要是让类型语义保持自洽）
execute as @e[tag=tspire_node_current,limit=1] run tag @s add tspire_type_chest
execute as @e[tag=tspire_node_current,limit=1] run tag @s remove tspire_type_mystery
tellraw @a[team=tspire_party] [{"text":"[神秘节点] ","color":"light_purple","bold":true},{"text":"房间里空无一人，正中央摆着一口没有上锁的箱子。","color":"yellow"}]
function tspire:map/enter_chest