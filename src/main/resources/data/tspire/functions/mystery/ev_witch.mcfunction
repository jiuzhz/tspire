function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 18
title @a[team=tspire_party] title {"text":"巫 女","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"沼泽里，一位神秘的巫女笑着递来四瓶药。","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"巫女：沼泽里，一位神秘的巫女笑着递来四瓶药。","color":"yellow"}]
tellraw @a[team=tspire_party] {"text":"  [拿黑色药水：凋零 20 秒、力量 II 60 秒] ","color":"dark_purple","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 60"},"hoverEvent":{"action":"show_text","contents":"后果：凋零 20 秒、力量 II 60 秒"}}
tellraw @a[team=tspire_party] {"text":"  [拿红色药水：抗火 180 秒、缓慢 120 秒] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 61"},"hoverEvent":{"action":"show_text","contents":"后果：抗火 180 秒、缓慢 120 秒"}}
tellraw @a[team=tspire_party] {"text":"  [拿蓝色药水：速度 300 秒、中毒 40 秒] ","color":"aqua","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 62"},"hoverEvent":{"action":"show_text","contents":"后果：速度 300 秒、中毒 40 秒"}}
tellraw @a[team=tspire_party] {"text":"  [拿白色药水：生命 -6、获得牛奶桶] ","color":"white","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 63"},"hoverEvent":{"action":"show_text","contents":"后果：生命 -6、获得牛奶桶"}}
tellraw @a[team=tspire_party] [{"text":"（每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
