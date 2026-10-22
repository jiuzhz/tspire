# ============================================================
# 工匠节点菜单（可点击聊天，设计文档 §3.1.2）
# ============================================================
# 【v0.6.27 新增】共鸣：花 30 金币随机获得一枚强化水晶，每局限一次。
# 修复：价格递增（基础 15，每修一次 +5），范围含背包里的工具，另送 32 支箭。
#
# 【重铸暂时隐藏】重铸（重随机部件材料）已经实现，但用户要把它挪到别的模块，
# 所以这里不再挂入口。函数与生成器都还在：
#   artisan/reforge, artisan/reforge_do, artisan/reforge_f{1,2,3},
#   tools/gen-reforge.ps1, data/tspire/item_modifiers/reforge/*
# 想放回来只要把下面那行注释里的 tellraw 加回来。
# ============================================================

# 先把本次修复价格算出来（@s tspire_repair_cost），菜单才能显示
function tspire:artisan/repair_cost
function tspire:artisan/heal_cost

tellraw @s [{"text":"========== 工匠节点 ==========","color":"gold","bold":true}]
tellraw @s [{"text":"[修复] 修满全身装备与背包里的工具 —— ","color":"light_purple","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 1"},"hoverEvent":{"action":"show_text","contents":"主手 / 副手 / 头盔 / 胸甲 / 护腿 / 靴子 + 背包里所有工具，耐久全部恢复；每修一次额外给 32 支箭，价格每次 +5。"}},{"score":{"name":"@s","objective":"tspire_repair_cost"},"color":"gold"},{"text":" 金币","color":"gold"}]
tellraw @s [{"text":"[回血] 再恢复 25% 生命 —— ","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 2"},"hoverEvent":{"action":"show_text","contents":"本局每次付费回血价格增加 5 金币；进节点时免费回血不计次数。"}},{"score":{"name":"@s","objective":"tspire_heal_cost"},"color":"gold"},{"text":" 金币","color":"gold"}]
tellraw @s [{"text":"[共鸣] 随机获得一枚强化水晶 —— 30 金币（每个工匠节点限一次）","color":"light_purple","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 3"},"hoverEvent":{"action":"show_text","contents":"从当前强化池里随机抽一枚水晶。采掘类强化已被剔除。"}}]
tellraw @s [{"text":"[融合] 主手 + 副手两枚部件合成一枚更高阶部件 —— 30 金币（每个工匠节点限一次）","color":"aqua","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 4"},"hoverEvent":{"action":"show_text","contents":"主手与副手各持一枚部件，消耗两者，得到与主手同类型、材料取自更高一层材料池的部件。"}}]
tellraw @s [{"text":"工匠砧：修复 / 安装强化　部件制造台：替换部件　强化调配台：安装水晶　工作站：合成","color":"dark_gray"}]
tellraw @s [{"text":"当前金币：","color":"gray"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]
tellraw @s [{"text":"==============================","color":"gold","bold":true}]
