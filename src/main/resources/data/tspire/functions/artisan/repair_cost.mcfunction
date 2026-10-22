# ============================================================
# 工匠节点：算出本次修复的价格（执行者 = 玩家）
# ============================================================
# 【v0.6.27】修复改成**递增定价**：基础 #CFG_REPAIR_COST，每修复一次再加
#   #CFG_REPAIR_COST_STEP（默认 5）金币，本局内累加。
#   价格存进 @s tspire_repair_cost，菜单与扣钱都读它（1.20.1 没有宏，
#   tellraw 又读不了运算结果，所以必须先落到计分板上）。
# ============================================================

scoreboard players operation @s tspire_repair_cost = #CFG_REPAIR_COST tspire_config
scoreboard players operation #TMP_STEP tspire_timer = @s tspire_repairs
scoreboard players operation #TMP_STEP tspire_timer *= #CFG_REPAIR_COST_STEP tspire_config
scoreboard players operation @s tspire_repair_cost += #TMP_STEP tspire_timer
