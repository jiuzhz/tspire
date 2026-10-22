# ============================================================
# 按当前层分派到对应层的战斗房装饰（v0.7.21）
# ============================================================
# 执行前提：**at 房间中心**（或玩家脚下，仅用于预览）。
# 只有战斗 / 精英节点用它；工匠 / 宝箱 / 商人节点是固定装饰（各自一套）。
# `#FLOOR` 不在 1..3 时（测试场）兜底用一层的池子。
# ============================================================
execute if score #FLOOR tspire_timer matches 2 run function tspire:deco/pick_f2
execute if score #FLOOR tspire_timer matches 3.. run function tspire:deco/pick_f3
execute unless score #FLOOR tspire_timer matches 2.. run function tspire:deco/pick_f1
