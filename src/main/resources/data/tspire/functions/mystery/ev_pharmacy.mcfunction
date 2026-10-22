# ============================================================
# 神秘事件：药房（三层均可能出现）
# ============================================================
#   · 买一瓶：25 金币 → 从特殊奖励池随机 1 件
#   · 买两瓶：40 金币 → 随机 2 件（可以重复）
#   · 买三瓶：60 金币 → 随机 3 件（可以重复）
#   · 办卡：100 金币 → 不死图腾 ×1
#   · 不买：什么都不买，但会掉 10% 生命（v0.7.2 玩家要求）
# 选择 id：1 = 一瓶，2 = 两瓶，3 = 三瓶，4 = 办卡，5 = 不买
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 9
title @a[team=tspire_party] title {"text":"药 房","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"柜台上摆满了瓶子，老板一言不发","color":"gray"}

tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"药房：","color":"light_purple","bold":true},{"text":"房间被改成了药房，柜台后面站着一个不说话的人。玻璃瓶里泡着看不出来源的东西，价目牌挂在最显眼的地方。","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [买一瓶：25 金币 → 随机 1 件特殊奖励] ","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 31"},"hoverEvent":{"action":"show_text","contents":"后果：-25 金币，从特殊奖励池随机抽 1 件（金苹果 / 强效治疗 / 力量 / 迅捷 / 生命恢复 之一）"}}]
tellraw @a[team=tspire_party] [{"text":"  [买两瓶：40 金币 → 随机 2 件（可重复）] ","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 32"},"hoverEvent":{"action":"show_text","contents":"后果：-40 金币，随机抽 2 件（可能抽到同一种）"}}]
tellraw @a[team=tspire_party] [{"text":"  [买三瓶：60 金币 → 随机 3 件（可重复）] ","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 33"},"hoverEvent":{"action":"show_text","contents":"后果：-60 金币，随机抽 3 件（可能抽到同一种）"}}]
tellraw @a[team=tspire_party] [{"text":"  [办卡：100 金币 → 不死图腾 ×1] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 34"},"hoverEvent":{"action":"show_text","contents":"后果：-100 金币，获得一个不死图腾"}}]
tellraw @a[team=tspire_party] [{"text":"  [不买：什么都不拿，代价是掉 10% 生命] ","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 35"},"hoverEvent":{"action":"show_text","contents":"空手离开：生命 -10%（20 点上限 → 2 点）"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.brewing_stand.brew master @s ~ ~ ~ 1 1.2