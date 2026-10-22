# ============================================================
# 神秘事件：海龟（v0.7.7 新增）
# **不限层数**：pick_f1 / pick_f2 / pick_f3 都含本事件（1/2/3 层都能抽到）。
# ============================================================
#   一只海龟说它曾是一只转来转去的猴子，被诅咒成绿皮王八，求你 V 它 50 块把它推进水里。
#   · 花 50 金币解救：获得「化身！绿皮王八！」海龟鳞甲（副手 +5 护甲、−15% 移速）
#   · 嘲笑：获得一瓶「绿皮王八的诅咒」（神龟药水）
# 选择 id：1 = 解救，2 = 嘲笑
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 17
title @a[team=tspire_party] title {"text":"海 龟","color":"green","bold":true}
title @a[team=tspire_party] subtitle {"text":"一只海龟正努力地对你说话","color":"dark_green"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"海龟：","color":"green","bold":true},{"text":"「我本来是只转来转去的猴子……被诅咒成绿皮王八了。V 我 50，把我推进水里，救救我。」","color":"yellow"}]
# 【v0.7.10】选项 1 之前**完全点不动**：turtle_save 用了不存在的物品 id minecraft:turtle_scute，
#   整个函数在加载期就失败（日志："Failed to load function tspire:mystery/turtle_save"）。已修成 minecraft:scute。
tellraw @a[team=tspire_party] [{"text":"  [花 50 金币解救它 → 「化身！绿皮王八！」海龟鳞甲] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 55"},"hoverEvent":{"action":"show_text","contents":"海龟鳞甲：拿在副手 +5 护甲、−15% 移动速度"}}]
tellraw @a[team=tspire_party] [{"text":"  [嘲笑它 → 「绿皮王八的诅咒」（神龟药水）] ","color":"dark_green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 56"},"hoverEvent":{"action":"show_text","contents":"它气鼓鼓地塞给你一瓶药"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.turtle.ambient_land master @s ~ ~ ~ 1 1
