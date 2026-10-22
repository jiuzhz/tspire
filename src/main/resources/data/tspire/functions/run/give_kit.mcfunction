# ============================================================
# 匠魂尖塔 - 发放开局物资（设计文档 §2.4）
# 全队发放，整局只发一次
# 写法约定（§13.11.5）：一律用 @a[team=tspire_party] 而不是 @s
#
# 数值来自 tspire:config/defaults（可调参数），不要在这里写死
# ============================================================

# 【v0.6.28 更正】上一版误删了「工匠大百科」。玩家澄清：要删的是**《尖塔地图》**
#   （那本书现在不再发放，旧地图书功能已移除），工匠大百科照常给。
give @a[team=tspire_party] tconstruct:encyclopedia 1
give @a[team=tspire_party] minecraft:cooked_beef 32
# 【v0.6.26】一捆箭：所有弓都带"自容箭袋"(bulk_quiver)，而箭袋会**优先用背包里的箭**，
# 所以给弓的同时必须给箭，否则弓到手就是废铁。
give @a[team=tspire_party] minecraft:arrow 32
scoreboard players operation @a[team=tspire_party] tspire_gold = #CFG_START_GOLD tspire_config

tellraw @a [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"开局物资：","color":"white"},{"text":"工匠大百科 ×1","color":"aqua"},{"text":" / ","color":"gray"},{"text":"牛排 ×32","color":"aqua"},{"text":" / ","color":"gray"},{"text":"箭 ×32","color":"aqua"},{"text":" / ","color":"gray"},{"text":"金币 ×","color":"gold"},{"score":{"name":"#CFG_START_GOLD","objective":"tspire_config"},"color":"gold"}]
