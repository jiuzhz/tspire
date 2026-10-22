# 把最近的可进入节点标记为「当前节点」，然后开战
execute as @e[tag=tspire_node_avail,distance=..3,limit=1,sort=nearest] run function tspire:map/node_begin

# 【v0.7.20 / v0.7.21】三层的战斗房与精英房：进场时**随机挑一种手工房间装饰**就地铺上。
#   顺序必须在 battle_start 之前 —— 先铺完地板装饰，再出怪，否则怪会被生成在树/石头里。
#   神秘节点的战斗（map/enter_mystery_combat 也走这里）不铺：那是事件房，不是战斗房。
#   装饰文件是 tools/gen-deco.js 从测试存档里读出来的（锚点 = 当前节点标记 = 房间中心）。
#   每层 5 种，各 1/5（deco/pick_f1..f3）。
execute if score #FLOOR tspire_timer matches 1 if entity @e[tag=tspire_node_current,tag=tspire_type_combat] run function tspire:deco/apply_f1
execute if score #FLOOR tspire_timer matches 1 if entity @e[tag=tspire_node_current,tag=tspire_type_elite] run function tspire:deco/apply_f1
execute if score #FLOOR tspire_timer matches 2 if entity @e[tag=tspire_node_current,tag=tspire_type_combat] run function tspire:deco/apply_f2
execute if score #FLOOR tspire_timer matches 2 if entity @e[tag=tspire_node_current,tag=tspire_type_elite] run function tspire:deco/apply_f2
execute if score #FLOOR tspire_timer matches 3 if entity @e[tag=tspire_node_current,tag=tspire_type_combat] run function tspire:deco/apply_f3
execute if score #FLOOR tspire_timer matches 3 if entity @e[tag=tspire_node_current,tag=tspire_type_elite] run function tspire:deco/apply_f3

function tspire:run/battle_start
execute if score #TUTOR_MODE tspire_timer matches 1 run function tspire:tutorial/combat_hint
