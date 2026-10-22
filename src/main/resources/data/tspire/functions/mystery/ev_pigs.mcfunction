function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 20
title @a[team=tspire_party] title {"text":"猪！","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"一群猪挤满了整个房间，正齐刷刷地看着你。","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"猪！一群猪挤满了整个房间，正齐刷刷地看着你。","color":"yellow"}]
tellraw @a[team=tspire_party] {"text":"  [花 200 金币赞美群猪 → 猪猪祝福] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 36"},"hoverEvent":{"action":"show_text","contents":"后果：敌人缓慢和虚弱 6 秒；每多一名祝福持有者，两种效果各延长 3 秒"}}
tellraw @a[team=tspire_party] {"text":"  [想吃群猪：清空牛排，得到培根 ×64] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 37"},"hoverEvent":{"action":"show_text","contents":"后果：清空牛排，得到培根 ×64"}}
tellraw @a[team=tspire_party] {"text":"  [挤出房间：生命 -4] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 38"},"hoverEvent":{"action":"show_text","contents":"后果：生命 -4"}}
tellraw @a[team=tspire_party] [{"text":"（每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
