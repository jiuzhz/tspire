# ============================================================
# 神秘事件：重铸（三层均可能出现 —— pick_f1 / pick_f2 / pick_f3）
# ============================================================
# 房间描述：小型冶炼炉 + 一堆材料部件
#   · 花 40 金币重铸主手匠魂工具的材料：**60% 本层池 / 40% 更高一层池**（第 3 层没有更高 → 仍本层）
#     做出这个选择后，**在离开这个房间之前可以反复花 40 金币重铸**
#   · 不重铸：随机获得 **2 个本层材料池的部件**
# 选择 id：1 = 重铸（可重复），2 = 不重铸
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 2
title @a[team=tspire_party] title {"text":"重 铸","color":"aqua","bold":true}
title @a[team=tspire_party] subtitle {"text":"小冶炼炉还热着，旁边的部件码得整整齐齐","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"重铸：","color":"aqua","bold":true},{"text":"房间中央立着一座小型冶炼炉，炉火未熄；旁边整整齐齐码着不少材料部件 —— 它们显然在等你把手里的工具递进去。","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [花 40 金币重铸主手工具] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 39"},"hoverEvent":{"action":"show_text","contents":"后果：扣 40 金币，把主手匠魂工具的材料重掷一遍（60% 本层池 / 40% 更高层池）。选完之后还能继续花 40 金币再重铸。"}},{"text":"      [不重铸] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 40"},"hoverEvent":{"action":"show_text","contents":"后果：随机获得 2 个本层材料池的部件"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.anvil.use master @s ~ ~ ~ 0.8 1.4