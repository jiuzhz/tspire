# ============================================================
# 神秘事件：共鸣（三层均可能出现）
# ============================================================
#   · 共鸣：随机获得 **3 枚强化水晶** —— 分别是**升级强化 / 能力强化 / 无槽位强化**各一
#   · 昏睡：回复 50% 生命（≈10 点：instant_health II = 8 点 + regeneration 5 秒约 2 点）
# 选择 id：1 = 共鸣，2 = 昏睡
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 7
title @a[team=tspire_party] title {"text":"共 鸣","color":"aqua","bold":true}
title @a[team=tspire_party] subtitle {"text":"满墙的书，让人昏昏欲睡","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"共鸣：","color":"aqua","bold":true},{"text":"房间四壁都是书架，书脊上的字迹在灯下缓缓流动。你才站了片刻，眼皮就沉得厉害 —— 这些书在等你一起念。","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [共鸣] ","color":"aqua","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 44"},"hoverEvent":{"action":"show_text","contents":"后果：随机获得 3 枚强化水晶（升级强化 / 能力强化 / 无槽位强化 各一枚）"}},{"text":"      [昏睡一会儿] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 45"},"hoverEvent":{"action":"show_text","contents":"后果：回复 50% 生命（约 10 点）"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.enchantment_table.use master @s ~ ~ ~ 1 1.2