# ============================================================
# V4 结论 + 联动材料排除的回归测试
# ============================================================
# 结论（已定案，别再试别的写法）：
#   材料谓词里**只有 mantle 的包装器有效**。tconstruct:and / tconstruct:tag /
#   tconstruct:invert 都会报 `Unknown Material Predicate loader`，
#   而把 tag 写成字符串 "#tspire:test_pool" 直接没有产出。
#
#   正式写法（抄匠魂自己的 mantle/loot_injectors/spawn_bonus_chest.json）：
#     "material": {
#       "type": "mantle:inverted",
#       "inverted_type": "mantle:tag",
#       "tag": "tspire:compat_excluded"
#     }
#   材料 tag 文件放在 data/<ns>/tinkering/tags/materials/<name>.json
#   （不是 data/<ns>/tags/materials/）。
#
# 本函数做两件事：
#   1) 给一把「纯 tier」的剑，确认基础链路还活着
#   2) 给三把「tier 0~4 + 排除联动材料」的剑，检查里面有没有联动材料
#
# 验收：把三把剑挨个拿在手里看材料名，**不应出现**
#       铝 / 青铜 / 康铜 / 琥珀金 / 殷钢 / 铅 / 亡灵金属 / 镍铬 / 锇 /
#       白镴 / 银 / 钢叶 / 处理木 / 铁木 / 覆膜黏木 / 火焰
# ============================================================

tellraw @s [{"text":"[V4] ","color":"gold"},{"text":"发 1 把对照剑 + 3 把排除联动材料的剑。","color":"white"}]

loot give @s loot tspire:test/forge_sword
tellraw @s [{"text":"  A 纯 tier（对照，材料可能包含联动材料）","color":"gray"}]

loot give @s loot tspire:test/forge_sword_inverted
tellraw @s [{"text":"  D tier 0~4 + mantle:inverted 排除联动材料（正式方案）","color":"yellow"}]

tellraw @s [{"text":"把 D 的剑拿在手里看材料，出现联动材料就是回归失败。","color":"gold"}]
