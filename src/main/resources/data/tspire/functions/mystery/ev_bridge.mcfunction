function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 24
title @a[team=tspire_party] title {"text":"吊 桥","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"摇晃的吊桥悬在虚空之上。","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"吊桥：桥身突然剧烈摇晃，你不得不丢下一件装备。","color":"yellow"}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] at @s run function tspire:mystery/bridge_prepare
tellraw @a[team=tspire_party] {"text":"（每人各自从抽出的候选中放弃一件；全队都选完后房门才会打开）","color":"gray"}
