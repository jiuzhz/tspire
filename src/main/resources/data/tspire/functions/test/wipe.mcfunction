# ============================================================
# 一键清空当前房间的尖塔怪物与技能残留（测试用）
# 用法：/function tspire:test/wipe
# ============================================================
# 说明：
#   · `tspire_mob` 包含了 Boss（Boss 同时带 tspire_mob 与 tspire_boss），
#     所以这一条会把普通怪和 Boss 一起清掉；
#   · 清光之后**下一 tick 会由 run/battle_tick 自动判定战斗胜利**
#     （它在塔维度里检查 `unless entity @e[tag=tspire_mob]`），
#     正常开门、发奖励 —— 也就是说这是"跳过这一场"，不是"静默删除"。
#     想只要清怪、不想结算，就别用这个函数，改成单独杀 marker 那几行。
#   · 技能残留（裂颅者的尖刺、战术突进的落点、淬火者的燃烧环）**不带 tspire_mob**，
#     所以要单独清；否则地上会留着看不见的陷阱/火圈。
#   · 绝对不要 `kill @e[type=minecraft:marker]` —— 那会把节点标记
#     （`tspire_node`）和 `tspire_anchor` 一起杀掉，整座塔的路线就坏了。
# ============================================================

execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_spike]
execute in tspire:tower run kill @e[tag=tspire_dash_to]
execute in tspire:tower run kill @e[tag=tspire_firez]
execute in tspire:tower run kill @e[tag=tspire_boss]

# 淬火者【燃烧蓄能】的状态机收尾（残留的火圈会让 #QZ 停在燃烧阶段）
execute in tspire:tower run function tspire:boss/quencher_zone_end

tellraw @s [{"text":"[测试] ","color":"gold","bold":true},{"text":"已清空当前房间的全部尖塔怪物与技能残留。","color":"white"}]
tellraw @s [{"text":"（若当时正在战斗，下一 tick 会按「战斗胜利」正常结算开门。）","color":"gray"}]
