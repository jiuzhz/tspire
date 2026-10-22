function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 23
title @a[team=tspire_party] title {"text":"寄 生","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"房间里只有一株会说话的寄生植物。","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"寄生：植物低声诱你拿走它的种子。","color":"yellow"}]
tellraw @a[team=tspire_party] {"text":"  [拿走种子：获得寄生诅咒] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 29"},"hoverEvent":{"action":"show_text","contents":"本局每进入一个战斗／精英／BOSS 房间失去 2 点生命；每完成一个战斗／精英／BOSS 房间恢复 4 点生命"}}
tellraw @a[team=tspire_party] {"text":"  [拒绝：失去 8 点生命，随机获得缠怨藤部件] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 30"},"hoverEvent":{"action":"show_text","contents":"至少需要 9 点生命；失去 8 点生命并获得缠怨藤合法部件"}}
tellraw @a[team=tspire_party] {"text":"（每人各自决定；全队都选完后房门才会打开）","color":"gray"}
