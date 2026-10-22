# ============================================================
# 神秘事件：赐福（**仅第 3 层** —— 由 mystery/pick_f3 抽取）
# ============================================================
# 房间里立着三座雕像，各自给一种**永久（本局内）**祝福：
#   · 生命之神（id 1）：每进入一个房间 → 10 秒生命恢复
#   · 工匠之神（id 2）：每完成一个房间 → 额外 1 个本层材料池部件
#   · 战斗之神（id 3）：每场战斗开始 → 力量 30 秒；BOSS 战改为力量 II
# 祝福逐人独立（挂在各自身上），代价是一次只能选一位神。
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 4
title @a[team=tspire_party] title {"text":"赐 福","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"三座雕像静立，等你触碰","color":"yellow"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"赐福：","color":"gold","bold":true},{"text":"房间深处立着三座石雕，落满灰尘却仍在微微发光 —— 生命、工匠、战斗，各据一角。你只能带走一位神的注视。","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [生命之神] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 10"},"hoverEvent":{"action":"show_text","contents":"后果：此后每进入一个房间，获得 10 秒生命恢复"}},{"text":"   [工匠之神] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 11"},"hoverEvent":{"action":"show_text","contents":"后果：此后每完成一个房间，额外获得 1 个本层材料池部件"}},{"text":"   [战斗之神] ","color":"dark_red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 12"},"hoverEvent":{"action":"show_text","contents":"后果：此后每场战斗开始获得力量 30 秒；BOSS 战开始获得力量 II"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自选一位；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.beacon.activate master @s ~ ~ ~ 0.8 1.2