# ============================================================
# 淬火者【灰烬重生】（设计文档 §7.6 三机制之 3）
# ============================================================
# 文档原文：「**【灰烬重生】**（死亡触发）首次死亡时复活一次并恢复 40% HP，
#            同时召唤 2 只烈焰人——必须击杀两次才算通过。」
#
# 【v0.6.31 调整（玩家要求）】触发不明显 → 现在会：
#   1. 把淬火者**传送到房间正中**（当前节点 marker 位置）
#   2. 血量回复到 40%（max_health 300 → 120）
#   3. 召唤 **2 只普通烈焰人**（不带本层装备，纯增援）
#   4. 明显的标题 + 聊天栏 + 音效 + 一圈粒子
#
# 【为什么用"濒死触发"而不是"死亡触发"】
#   1.20.1 拦不住实体死亡（没有死亡事件、也阻止不了实体消失），
#   所以只能在它**还剩一截血**的时候抢先救回来。阈值取 max_health 的 20% = 60 点，
#   正常一刀砍不出 60 点，实际表现就是"第一次快被打死时复活"。
# ============================================================

scoreboard players set #QUENCH_REV tspire_timer 1

# 1) 传送到房间正中
execute at @e[tag=tspire_node_current,limit=1] run tp @e[tag=tspire_boss_quencher,limit=1] ~ ~ ~

# 2) 回 40% 血（并让 health 判据继续跟踪）
# 【v0.7.1 修复】v0.6.59 起 Boss 血量随人数缩放（200/250/300），但这里一直写死 `Health:120f` ——
#   120 只在 3 人局是 40%；1 人局（上限 200）等于回 **60%**，2 人局（250）回 **48%**，比设计强得多。
#   现在按人数分三档：80/200 = 100/250 = 120/300 = **都是 40%**。
#   （`data merge` 读不了计分板，1.20.1 又没有宏，所以只能写三条。）
execute if score #PARTY_SIZE tspire_timer matches ..1 run data merge entity @e[tag=tspire_boss_quencher,limit=1] {Health:80f}
execute if score #PARTY_SIZE tspire_timer matches 2 run data merge entity @e[tag=tspire_boss_quencher,limit=1] {Health:100f}
execute if score #PARTY_SIZE tspire_timer matches 3.. run data merge entity @e[tag=tspire_boss_quencher,limit=1] {Health:120f}

# 3) 2 只普通烈焰人（不带 tconstruct 装备）
execute at @e[tag=tspire_boss_quencher,limit=1] run summon minecraft:blaze ~2 ~ ~ {Tags:["tspire_mob"],PersistenceRequired:1b}
execute at @e[tag=tspire_boss_quencher,limit=1] run summon minecraft:blaze ~-2 ~ ~ {Tags:["tspire_mob"],PersistenceRequired:1b}

# 4) 短暂抗性 + 明显的表现
effect give @e[tag=tspire_boss_quencher,limit=1] minecraft:resistance 3 4 true
execute at @e[tag=tspire_boss_quencher,limit=1] run particle minecraft:soul_fire_flame ~ ~1 ~ 1.5 1 1.5 0.05 60 force
execute at @e[tag=tspire_boss_quencher,limit=1] run particle minecraft:lava ~ ~1 ~ 1 0.5 1 0 30 force

title @a[team=tspire_party] title {"text":"灰烬重生！","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"淬火者回到场地中央复活了 —— 必须击杀两次","color":"red"}
tellraw @a[team=tspire_party] [{"text":"[淬火者] ","color":"red","bold":true},{"text":"灰烬重生！","color":"gold","bold":true},{"text":"它被传送到场地中央、恢复了 40% 生命，并召来 2 只烈焰人。","color":"yellow"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.death master @s ~ ~ ~ 1 0.6
execute as @a[team=tspire_party] at @s run playsound minecraft:item.totem.use master @s ~ ~ ~ 1 0.8
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ender_dragon.growl master @s ~ ~ ~ 1 0.7
