function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 21
function tspire:mystery/hunger_convert
title @a[team=tspire_party] title {"text":"饥 饿","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"腐烂的臭味弥漫房间，背包里的牛排全变成了腐肉。","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"饥饿：腐烂的臭味弥漫房间，背包里的牛排全变成了腐肉。","color":"yellow"}]
tellraw @a[team=tspire_party] {"text":"  [忍受饥饿：回满生命，本局持续饥饿] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 21"},"hoverEvent":{"action":"show_text","contents":"后果：回满生命，本局持续饥饿"}}
tellraw @a[team=tspire_party] {"text":"  [花 90 金币强行进食 → 混合药水 ×2] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 22"},"hoverEvent":{"action":"show_text","contents":"花费 90 金币；每瓶药水饮下后有饱和 10 秒、饥饿 180 秒、力量 II 60 秒"}}
tellraw @a[team=tspire_party] [{"text":"（每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
