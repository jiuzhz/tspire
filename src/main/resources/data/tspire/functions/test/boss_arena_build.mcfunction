# BOSS 单挑测试：同步生成真实 BOSS 节点和房间，不再依赖旧预设路线。
execute in tspire:tower run forceload add -48 -416 48 32
function tspire:map/runtime/cancel
schedule clear tspire:map/build_row_1
schedule clear tspire:map/build_row_2
schedule clear tspire:map/build_row_3
schedule clear tspire:map/build_row_4
schedule clear tspire:map/build_row_5
schedule clear tspire:map/build_row_6
schedule clear tspire:map/build_row_7
schedule clear tspire:map/build_row_8
schedule clear tspire:map/build_row_9
schedule clear tspire:map/build_row_10
schedule clear tspire:map/build_row_11
schedule clear tspire:map/build_row_12
schedule clear tspire:map/build_row_13
schedule clear tspire:map/build_row_14
schedule clear tspire:map/build_row_15
schedule clear tspire:map/build_row_16
execute in tspire:tower run kill @e[tag=tspire_node]
execute if score #FLOOR tspire_timer matches 1 in tspire:tower positioned 0 64 0 run function tspire:map/runtime/place_boss
execute if score #FLOOR tspire_timer matches 2 in tspire:tower positioned 0 96 0 run function tspire:map/runtime/place_boss
execute if score #FLOOR tspire_timer matches 3 in tspire:tower positioned 0 128 0 run function tspire:map/runtime/place_boss
execute in tspire:tower at @e[tag=tspire_node,tag=tspire_type_boss,limit=1] run fill ~-15 ~-1 ~-15 ~15 ~5 ~16 minecraft:deepslate
execute in tspire:tower at @e[tag=tspire_node,tag=tspire_type_boss,limit=1] run function tspire:map/room_boss
execute in tspire:tower at @e[tag=tspire_node,tag=tspire_type_boss,limit=1] run setblock ~ ~-1 ~ minecraft:black_concrete
execute in tspire:tower run tag @e[tag=tspire_node,tag=tspire_type_boss] remove tspire_node_locked
execute in tspire:tower run tag @e[tag=tspire_node,tag=tspire_type_boss] add tspire_node_avail
execute in tspire:tower run function tspire:map/refresh_doors
