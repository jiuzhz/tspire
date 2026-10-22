# ============================================================
# 匠魂尖塔 - V1 验证
# 问题：只给 tic_materials 的工具，面板会不会自动算出来？
# ============================================================
# 步骤：
#   1. /function tspire:test/v1_tool_nbt
#   2. 手持发放的剑
#   3. /tconstruct durability @s
# 判定：
#   耐久非 0  -> 面板可算，动态组装零代码，项目可为纯数据包
#   耐久为 0  -> 需要写模组调用 ToolStack.createTool
# ------------------------------------------------------------
# sword = 3 槽：small_blade + tool_handle + tool_handle
# （槽数与 materials 数组长度必须严格一致，见设计文档 §2.3）

give @s tconstruct:sword{tic_materials:["tconstruct:iron","tconstruct:wood","tconstruct:wood"]} 1

tellraw @s [{"text":"[V1] ","color":"gold"},{"text":"已发放铁剑（仅 tic_materials，无 tic_stats）。","color":"white"}]
tellraw @s [{"text":"     手持它执行 ","color":"gray"},{"text":"/tconstruct durability @s","color":"yellow"},{"text":"，耐久非 0 即通过。","color":"gray"}]
