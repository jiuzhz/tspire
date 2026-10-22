function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 19
title @a[team=tspire_party] title {"text":"奶 酪","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"房间里堆满了奶酪，空气中都是香味。","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"奶酪：房间里堆满了奶酪，空气中都是香味。","color":"yellow"}]
tellraw @a[team=tspire_party] {"text":"  [花 60 金币吃点奶酪：奶酪 ×16] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 13"},"hoverEvent":{"action":"show_text","contents":"后果：奶酪 ×16"}}
tellraw @a[team=tspire_party] {"text":"  [直接离开：得到一件奶酪材料部件] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 14"},"hoverEvent":{"action":"show_text","contents":"后果：得到一件奶酪材料部件"}}
tellraw @a[team=tspire_party] [{"text":"（每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
