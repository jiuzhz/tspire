# 神秘节点掷到 10% 的「战斗」分支（v0.7.7）
#   把节点类型换成战斗，然后走正常的战斗流程（与 enter_mystery_merchant/_chest 同一套做法：
#   必须先换类型标签，否则它变成可复用节点后再次进入会走 enter_service 什么都不发生）。
execute as @e[tag=tspire_node_current] run tag @s add tspire_type_combat
execute as @e[tag=tspire_node_current] run tag @s remove tspire_type_mystery
tellraw @a[team=tspire_party] [{"text":"[神秘节点] ","color":"light_purple"},{"text":"门后不是房间 —— 一群怪物扑了上来！","color":"red","bold":true}]
function tspire:map/enter_combat
