# ============================================================
# BOSS 单挑：分两拍建场（v0.7.4，由 tick/tower 每 tick 调用）
# ============================================================
# 玩家报"BOSS 没在挑战房间里，而是在初始构筑间"。根因：
#   `forceload add` 与 `map/build_floor` 原来在**同一 tick** 执行 —— 远端区块（z≈-390）
#   还没真正加载，预设里的 summon / setblock / fill 会**静默失败**：
#   → 真实 BOSS 节点根本没生成；
#   → 于是 `@e[tag=tspire_test_node,limit=1]` 只能匹配到**旧版测试场留下的那个标记**（大厅 28 64 20），
#     BOSS 就被生成到那里去了。
# 现在拆成两拍，中间至少隔一个 tick：
#   #ARENA=1 -> 建层 + 标节点 + 全队传送 + 开战；
#   #ARENA=2 -> 生成指定的那只 Boss（#TESTBOSS 1..9，0 = 按层随机）。
execute if score #ARENA tspire_timer matches 1 run function tspire:test/arena_build_now
execute if score #ARENA tspire_timer matches 2 run function tspire:test/arena_spawn_now
