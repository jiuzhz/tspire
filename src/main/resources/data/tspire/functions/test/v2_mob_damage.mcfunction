# ============================================================
# 匠魂尖塔 - V2 验证
# 问题：怪物拿匠魂工具，打人是否真的更疼？
# ============================================================
# 生成两只丧尸在同一位置：
#   A 组：原版铁剑
#   B 组：匠魂剑（仅 tic_materials，材料 tier 2）
# 把两只丧尸都困住，分别让它们打你一次，比较伤害。
# 判定：
#   伤害相同 -> 匠魂工具不提供攻击属性，必须写模组补属性修饰符（唯一硬性模组需求）
#   伤害更高 -> 原生机制够用，纯数据包可行
# ------------------------------------------------------------

kill @e[tag=tspire_v2]

summon minecraft:zombie ~2 ~ ~2 {HandItems:[{id:"minecraft:iron_sword",Count:1b},{}],HandDropChances:[0.0f,0.0f],Tags:["tspire_v2"],CustomName:'"V2-A 原版铁剑"',CustomNameVisible:1b,PersistenceRequired:1b,NoAI:1b}
summon minecraft:zombie ~2 ~ ~4 {HandItems:[{id:"tconstruct:sword",Count:1b,tag:{tic_materials:["tconstruct:iron","tconstruct:wood","tconstruct:wood"]}},{}],HandDropChances:[0.0f,0.0f],Tags:["tspire_v2"],CustomName:'"V2-B 匠魂铁剑"',CustomNameVisible:1b,PersistenceRequired:1b,NoAI:1b}

tellraw @s [{"text":"[V2] ","color":"gold"},{"text":"已生成两只 NoAI 丧尸。","color":"white"}]
tellraw @s [{"text":"     A 组原版铁剑 / B 组匠魂铁剑。","color":"gray"}]
tellraw @s [{"text":"     取消 NoAI 后分别让它打你一次，比较伤害。","color":"gray"}]
tellraw @s [{"text":"     清理：","color":"gray"},{"text":"/kill @e[tag=tspire_v2]","color":"yellow"}]
