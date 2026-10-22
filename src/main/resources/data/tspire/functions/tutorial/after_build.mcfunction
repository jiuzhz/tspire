# Begin the actual game loop at four fixed markers, in a separate west strip.
execute in tspire:tower run summon minecraft:marker -120 64 0 {Tags:["tspire_node","tspire_tutorial_node","tspire_row1","tspire_col0","tspire_node_avail","tspire_type_combat"]}
execute in tspire:tower run summon minecraft:marker -120 64 -24 {Tags:["tspire_node","tspire_tutorial_node","tspire_row2","tspire_col0","tspire_node_locked","tspire_type_merchant"]}
execute in tspire:tower run summon minecraft:marker -120 64 -48 {Tags:["tspire_node","tspire_tutorial_node","tspire_row3","tspire_col0","tspire_node_locked","tspire_type_artisan"]}
execute in tspire:tower run summon minecraft:marker -120 64 -80 {Tags:["tspire_node","tspire_tutorial_node","tspire_row4","tspire_col0","tspire_node_locked","tspire_type_boss"]}
execute in tspire:tower run function tspire:map/refresh_doors
execute in tspire:tower run tp @a[tag=tspire_tutorial] -120 64 24
execute in tspire:tower run spawnpoint @a[tag=tspire_tutorial] -120 64 24
tellraw @a[tag=tspire_tutorial] [{"text":"[新手教程] ","color":"aqua"},{"text":"构筑完成！现在沿西侧固定路线，依次进入红色战斗、绿色商人、橙色工匠和黑色 BOSS 房。","color":"white"}]
tellraw @a[tag=tspire_tutorial] [{"text":"[教程提示] ","color":"aqua"},{"text":"节点会按正式规则触发；战斗获胜也会获得正式奖励。 ","color":"gray"},{"text":"[退出教程]","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 108"}}]
