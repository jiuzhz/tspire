# ============================================================
# 神秘事件：诅咒雕像（**仅第 2 层** —— 由 mystery/pick_f2 抽取）
# ============================================================
#   · 触碰雕像：此后**每进入一个房间额外获得 12 金币**，但**每当生命值超过 20 时获得 4 秒凋零（冷却 60 秒）**
#   · 不触碰：受到 5 点伤害，获得 35 金币（一次性）
# 选择 id：1 = 触碰，2 = 不触碰
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 5
title @a[team=tspire_party] title {"text":"诅 咒 雕 像","color":"dark_gray","bold":true}
title @a[team=tspire_party] subtitle {"text":"一座尘封的贪婪之神雕像","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"诅咒雕像：","color":"dark_gray","bold":true},{"text":"房间中央是一座盖满灰尘的雕像，供台上刻着一行字：『拿走吧，代价以后再算。』雕像的手心还留着一小堆无人取走的金币。","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [触碰雕像] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 17"},"hoverEvent":{"action":"show_text","contents":"后果：此后每进入一个房间额外 +12 金币；但每当生命值超过 20 时获得 4 秒凋零（冷却 60 秒）"}},{"text":"      [不触碰，只拿走台上的金币] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 18"},"hoverEvent":{"action":"show_text","contents":"后果：受到 5 点伤害，获得 35 金币"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.soul_sand.break master @s ~ ~ ~ 0.8 0.6