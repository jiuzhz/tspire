# ============================================================
# 匠魂尖塔 - V3 验证
# 问题：add_tool_data 的 randomized.tier 接受整数还是区间？整条链路是否可用？
# ============================================================
# 在脚下生成 3 把通过战利品表随机锻造的匠魂剑（3 槽，tier 1）。
# 判定：
#   生成成功且三把材料/面板各不相同 -> add_tool_data 可用，这是"动态组装"的核心
#   报错或为空 -> 检查控制台：可能是 randomized.tier 写法问题，或 __comment 之类未知字段
# ------------------------------------------------------------

loot spawn ~ ~1 ~ loot tspire:test/forge_sword
loot spawn ~1 ~1 ~ loot tspire:test/forge_sword
loot spawn ~-1 ~1 ~ loot tspire:test/forge_sword

tellraw @s [{"text":"[V3] ","color":"gold"},{"text":"已在脚下生成 3 把战利品表锻造的匠魂剑。","color":"white"}]
tellraw @s [{"text":"     三把材料/面板应各不相同。若为空，查控制台报错。","color":"gray"}]
