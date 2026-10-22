# ============================================================
# 商人「丢下自动收购」探针（v0.7.56）
# ============================================================
# 背景：日志实测 merchant/sell_drop 触发 **0 次** —— 也就是说"丢下收购"这条分支
#   从来没进过（手上拿着卖的 merchant/sell 触发了几十次）。判定入口是：
#     tick/second:37  execute if #RUN_STARTED=1 in tspire:tower as @e[item] at @s
#                     if entity @e[tag=tspire_merchant_npc,distance=..6] run function …/sell_drop
#   所以只要下面任何一项不成立，丢下就完全没反应。
#
# 用法：站在商人旁边（先往地上丢一件匠魂物品），执行
#   /function tspire:test/merchant_drop_probe
# 它会把四个条件逐条打印出来，一眼看出卡在哪一条。
# ============================================================

tellraw @s [{"text":"===== 商人丢售探针 =====","color":"gold","bold":true}]
tellraw @s [{"text":"① 本局进行中(#RUN_STARTED) = ","color":"gray"},{"score":{"name":"#RUN_STARTED","objective":"tspire_timer"},"color":"yellow"},{"text":"（必须是 1）","color":"dark_gray"}]
tellraw @s [{"text":"② 收购总开关(#CFG_SELL_ENABLED) = ","color":"gray"},{"score":{"name":"#CFG_SELL_ENABLED","objective":"tspire_config"},"color":"yellow"},{"text":"（必须 ≥1）","color":"dark_gray"}]

# ③ 场上有几个带 tspire_merchant_npc 标签的商人 + 最近那个离你多远
scoreboard players set #MD_N tspire_timer 0
execute as @e[tag=tspire_merchant_npc] run scoreboard players add #MD_N tspire_timer 1
tellraw @s [{"text":"③ 附近商人 NPC 数 = ","color":"gray"},{"score":{"name":"#MD_N","objective":"tspire_timer"},"color":"yellow"},{"text":"（0 = 站得离商人太远，或这个商人没带标签）","color":"dark_gray"}]
execute as @e[tag=tspire_merchant_npc,limit=1,sort=nearest] at @s run tellraw @s [{"text":"   最近商人坐标 = ","color":"gray"},{"nbt":"Pos","entity":"@s","color":"aqua"}]

# ④ 最近的掉落物到最近商人的距离（判定阈值是 6 格！）
scoreboard players set #MD_ITEM tspire_timer 0
execute as @e[type=minecraft:item,limit=1,sort=nearest] run scoreboard players set #MD_ITEM tspire_timer 1
tellraw @s [{"text":"④ 附近有掉落物吗 = ","color":"gray"},{"score":{"name":"#MD_ITEM","objective":"tspire_timer"},"color":"yellow"},{"text":"（0 = 你还没丢东西，或丢得太远）","color":"dark_gray"}]
execute as @e[tag=tspire_merchant_npc,limit=1,sort=nearest] at @s run tellraw @s [{"text":"   最近商人到最近掉落物的距离 = ","color":"gray"},{"nbt":"Pos","entity":"@e[type=minecraft:item,limit=1,sort=nearest,distance=..40]","color":"white"},{"text":"  ← 判定是 6 格内！","color":"dark_gray"}]

tellraw @s [{"text":"判读：①②必须成立；③=0 说明商人标签丢了；④那行把两个坐标一比 —— 距离 >6 就是丢太远了（判定只在 6 格内生效）。","color":"gray"}]