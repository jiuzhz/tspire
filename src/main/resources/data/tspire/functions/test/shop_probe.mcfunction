# ============================================================
# 商店诊断（v0.7.25 新增）—— 排查"商人节点不发货 / 说已售出 / 说已买过"
# ============================================================
# 用法：站在出问题的地方（商人房里，或跑过 test/shop_demo 的地方）执行
#   /function tspire:test/shop_probe
# 只发给执行者。它把商店整条链路的现场状态一次打印出来：
#   · #FLOOR / 你的 shop_f · shop_l · shop_node / 金币
#   · 场上 tspire_shop 标记**数量**与坐标（正常恰好 1 个；>1 = 有陈年旧标记在抢供货）
#   · 标记处是什么方块 + 15 个货架格里装了几格（0 = 货架没摆上）
#   · 你的 15 个购买标记 tspire_buy0..14（全 1 = 系统认为你每格都买过了）
#   · 15 个价格 #PRICE0..14（全 0 = shop/*_fill 没跑到）
# ============================================================

# --- 现场统计（先算，再打印）---
scoreboard players set #SHOP_MARKS tspire_timer 0
execute as @e[tag=tspire_shop] run scoreboard players add #SHOP_MARKS tspire_timer 1
scoreboard players set #SHOP_STOCK tspire_timer 0
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:0b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:1b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:2b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:3b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:4b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:5b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:6b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:7b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:8b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:9b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:10b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:11b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:12b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:13b}] run scoreboard players add #SHOP_STOCK tspire_timer 1
execute at @e[tag=tspire_shop,limit=1] if data block ~ ~ ~ Items[{Slot:14b}] run scoreboard players add #SHOP_STOCK tspire_timer 1

# --- 打印 ---
tellraw @s [{"text":"=== 商店诊断 ===","color":"gold","bold":true}]
tellraw @s [{"text":"[层/玩家] #FLOOR=","color":"yellow"},{"score":{"name":"#FLOOR","objective":"tspire_timer"},"color":"white"},{"text":"  shop_f=","color":"yellow"},{"score":{"name":"@s","objective":"tspire_shop_f"},"color":"white"},{"text":"  shop_l=","color":"yellow"},{"score":{"name":"@s","objective":"tspire_shop_l"},"color":"white"},{"text":"  shop_node=","color":"yellow"},{"score":{"name":"@s","objective":"tspire_shop_node"},"color":"white"},{"text":"  金币=","color":"yellow"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"aqua"},{"text":"  （shop_f 应等于 #FLOOR）","color":"gray"}]
tellraw @s [{"text":"[标记] tspire_shop 数量=","color":"yellow"},{"score":{"name":"#SHOP_MARKS","objective":"tspire_timer"},"color":"white"},{"text":" 坐标=","color":"yellow"},{"nbt":"Pos","entity":"@e[tag=tspire_shop,limit=1]","color":"gray"},{"text":"  （正常恰好 1 个）","color":"gray"}]
execute at @e[tag=tspire_shop,limit=1] run tellraw @s [{"text":"[柜台] 标记处方块=","color":"yellow"},{"nbt":"id","block":"~ ~ ~","color":"aqua"},{"text":"   已装格数=","color":"yellow"},{"score":{"name":"#SHOP_STOCK","objective":"tspire_timer"},"color":"white"},{"text":" / 15","color":"gray"}]
tellraw @s [{"text":"[已购买 0..14] ","color":"yellow"},{"score":{"name":"@s","objective":"tspire_buy0"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy1"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy2"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy3"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy4"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy5"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy6"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy7"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy8"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy9"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy10"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy11"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy12"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy13"},"color":"white"},{"score":{"name":"@s","objective":"tspire_buy14"},"color":"white"},{"text":"  （全 1 = 认为你每格都买过了）","color":"gray"}]
tellraw @s [{"text":"[价格 #PRICE0..14] ","color":"yellow"},{"score":{"name":"#PRICE0","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE1","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE2","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE3","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE4","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE5","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE6","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE7","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE8","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE9","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE10","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE11","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE12","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE13","objective":"tspire_timer"},"color":"white"},{"score":{"name":"#PRICE14","objective":"tspire_timer"},"color":"white"},{"text":"  （全 0 = 货架没 fill 过）","color":"gray"}]
tellraw @s [{"text":"判读：","color":"gold"},{"text":"① 已装格数 0 → 货架没摆上（标记数 0 或 >1）；② 买过标记全 1 → 被换节点/reset 清了又置位；③ 价格全 0 → shop/*_fill 没跑到。把上面四行发我即可。","color":"gray"}]
