# ============================================================
# 奖励池演示：不用打架，直接抽 6 次随机奖励看内容
# 用法：/function tspire:test/reward_demo
# ============================================================
# 会直接给你 3 组「随机奖励 ×2」+ 1 个三选一宝箱。
#
# 期望能看到：
#   - 强化水晶（tconstruct:modifier_crystal）—— 名字类似「急迫水晶」「幸运水晶」，
#     提示行会显示「强化ID: tconstruct:xxx」，这是本次新解析出来的 NBT 键名
#   - 材料部件（小型剑刃 / 工具手柄 / 绑定结 / 大板），带 Material 词条
#   - 修补材料（铁锭、铜锭之类）
#   - 随机匠魂装备
#   - 偶尔出现远古工具（熔炼锅 / 战争镐 / 战斗牌 / 喷流刃）
#   - 偶尔出现投掷工具（手里剑 / 投斧）
#
# 换层：/function tspire:test/reward_demo_f1 / _f2 / _f3
# ============================================================

scoreboard players set #FLOOR tspire_timer 1

loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1

function tspire:rewards/offer_parts

tellraw @s [{"text":"[奖励演示] ","color":"gold"},{"text":"已发 8 项随机奖励 + 1 个三选一宝箱。","color":"white"}]
tellraw @s [{"text":"重点看有没有出现强化水晶。","color":"yellow"}]
