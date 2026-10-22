function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 22
title @a[team=tspire_party] title {"text":"藏 宝 图","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"房间中央放着一张藏宝图，标记指向第二层的宝箱。","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"藏宝图：房间中央放着一张藏宝图，标记指向第二层的宝箱。","color":"yellow"}]
tellraw @a[team=tspire_party] {"text":"  [拿走藏宝图：持续缓慢，首次进二层宝箱得 300 金币] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 53"},"hoverEvent":{"action":"show_text","contents":"后果：持续缓慢，首次进二层宝箱得 300 金币"}}
tellraw @a[team=tspire_party] {"text":"  [直接离开：随机获得一件特殊奖励] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 54"},"hoverEvent":{"action":"show_text","contents":"后果：随机获得一件特殊奖励"}}
tellraw @a[team=tspire_party] [{"text":"（每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
