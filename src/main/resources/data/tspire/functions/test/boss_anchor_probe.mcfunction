# ============================================================
# BOSS 场地锚点诊断（v0.7.72）—— 在 BOSS 房里执行：
#   /function tspire:test/boss_anchor_probe
# 它会同时打印：你（玩家）、当前节点、BOSS 本体 三者的坐标。
#
# 判读：
#   · 节点坐标 ≈ BOSS 本体坐标（差 ~9 格 z）→ 出怪/场地是【节点锚定】✓ 正常
#   · BOSS 本体坐标 跟着【你】的位置走      → 还是玩家锚定 ✗（我要继续查别的入口）
# ============================================================
tellraw @s [{"text":"===== BOSS 场地锚点诊断 =====","color":"gold","bold":true}]
tellraw @s [{"text":"① 你（玩家）坐标 = ","color":"gray"},{"nbt":"Pos","entity":"@s","color":"aqua"}]
tellraw @s [{"text":"② 当前节点坐标   = ","color":"gray"},{"nbt":"Pos","entity":"@e[tag=tspire_node_current,limit=1]","color":"yellow"}]
tellraw @s [{"text":"③ BOSS 本体坐标  = ","color":"gray"},{"nbt":"Pos","entity":"@e[tag=tspire_boss,limit=1]","color":"red"}]
tellraw @s [{"text":"④ 当前节点标签 = ","color":"gray"},{"selector":"@e[tag=tspire_node_current,limit=1]","color":"white"}]
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] run tellraw @s [{"text":"   ✓ 带 tspire_type_boss","color":"green"}]
execute if entity @e[tag=tspire_node_current,tag=tspire_type_combat] run tellraw @s [{"text":"   ⚠ 还带 tspire_type_combat —— 会先走 enter_combat 的装饰分支","color":"yellow"}]
tellraw @s [{"text":"判读：②③ 应互相关联（与你的位置无关）；若 ③ 随你移动而变，说明还有别的生成入口。","color":"gray"}]