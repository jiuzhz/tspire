# ============================================================
# 匠魂尖塔 - V5 验证
# 问题：mob_equipment 的 chance / match / priority 行为是否符合预期？
# ============================================================
# 依赖文件：data/tspire/tinkering/mob_equipment/test_zombie_sword.json
#   chance = 1.0，match = 空手（minecraft:air），slot = mainhand
# 判定：
#   生成的丧尸 100% 手持匠魂剑 -> chance / match 生效
#   丧尸仍拿原版装备或空手 -> 需要调整 match 或与匠魂自带规则冲突（看 priority）
# 注意：
#   匠魂自带的 melting_pan.json 也作用于 zombie（offhand），
#   因此丧尸可能同时持剑（主手）+ 熔炼锅（副手），这是正常的。
# ------------------------------------------------------------

kill @e[tag=tspire_v5]

summon minecraft:zombie ~2 ~ ~2 {Tags:["tspire_v5"],CustomName:'"V5 空手丧尸"',CustomNameVisible:1b,PersistenceRequired:1b,NoAI:1b}
summon minecraft:zombie ~2 ~ ~4 {HandItems:[{id:"minecraft:iron_sword",Count:1b},{}],HandDropChances:[0.0f,0.0f],Tags:["tspire_v5"],CustomName:'"V5 已持铁剑"',CustomNameVisible:1b,PersistenceRequired:1b,NoAI:1b}

tellraw @s [{"text":"[V5] ","color":"gold"},{"text":"已生成两只丧尸（一只空手、一只已持铁剑）。","color":"white"}]
tellraw @s [{"text":"     空手那只应被换上匠魂剑（match 只匹配空手）。","color":"gray"}]
tellraw @s [{"text":"     清理：","color":"gray"},{"text":"/kill @e[tag=tspire_v5]","color":"yellow"}]
