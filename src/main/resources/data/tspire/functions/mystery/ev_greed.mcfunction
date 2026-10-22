# ============================================================
# 神秘事件：贪婪（仅第 1~2 层 —— 由 mystery/pick_f1 / pick_f2 抽取）
# ============================================================
# 房间描述 + 两个选择。**后果直接写在按钮与 hover 上**（玩家要求：所有神秘事件
# 必须让玩家看到选择的后果）。
#   · 小金币箱            → +28 金币（无风险）
#   · 大金币箱（带诅咒）  → 受到固定 12 点伤害 +110 金币
# 逐人独立：每人自己点一个，互不影响；全队都选完后由 mystery/tick 放行。
# ============================================================

function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 1

title @a[team=tspire_party] title {"text":"贪 婪","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"两口箱子，一口轻，一口沉得发烫","color":"yellow"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"贪婪：","color":"gold","bold":true},{"text":"房间正中并排摆着两口塞满金币的箱子 —— 一口小巧精致，一口压得地板发响，箱盖内侧刻着一圈看不懂的诅咒纹路。","color":"yellow"}]
# 大金币箱按钮逐人判断血量：生命 ≤12 点时显示灰字，点击处理函数也会即时复核血量。
execute as @a[team=tspire_party,scores={tspire_dead=0}] run tellraw @s [{"text":"  [打开小金币箱：+28 金币] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 19"},"hoverEvent":{"action":"show_text","contents":"后果：立刻获得 28 金币（没有风险）"}}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches 13.. run tellraw @s [{"text":"      [打开大金币箱：生命 -12 → +110 金币] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 20"},"hoverEvent":{"action":"show_text","contents":"后果：受到固定 12 点伤害，获得 110 金币；至少需要 13 点生命"}}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches ..12 run tellraw @s [{"text":"      [打开大金币箱] 生命不足（至少需要 13 点，你现在 ","color":"dark_gray"},{"score":{"name":"@s","objective":"tspire_hp"},"color":"dark_gray"},{"text":" 点）—— 选不了","color":"dark_gray"}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自选一个；全队都选完后这扇门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.chest.open master @s ~ ~ ~ 1 1
