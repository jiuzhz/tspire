# 【凋零剑压】场地内生成 3 只**无 AI、30 血**的烈焰人（固定点 + 黑色特效），
#   BOSS 同时获得**抗性提升 III**；每死一只抗性掉一级（见 moltenlord_cube_watch）。
# v0.7.19 修复（玩家实测）：
#   · 岩浆怪 → **烈焰人**：岩浆怪死亡会分裂成小岩浆怪，分裂体不带 tag，
#     于是"还剩几只"永远查不准（玩家看到的"抗性不掉 / 怪还活着却又放技能"就是它）。
#     烈焰人不会分裂，NoAI 之后也不会打人。
#   · 抗性时长 999999 → 5 秒（每 tick 按存活数重刷）：原来那条 effect 的时长单位是**秒**，
#     等于给 BOSS 挂了永久抗性，三只全死了抗性也还在。
#   · 掉落置空：这 3 只是机制单位，不该被刷成烈焰棒农场。
scoreboard players set #ML_C2 tspire_timer 0
scoreboard players set #ML_RES tspire_timer 3
scoreboard players set #ML_CUBES tspire_timer 3
kill @e[tag=tspire_mcube]

execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] run summon minecraft:blaze ~10 ~ ~4 {Tags:["tspire_mob","tspire_mcube","tspire_mcube_a"],PersistenceRequired:1b,NoAI:1b,DeathLootTable:"minecraft:empty",Health:30f,Attributes:[{Name:"minecraft:generic.max_health",Base:30}]}
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] run summon minecraft:blaze ~-10 ~ ~4 {Tags:["tspire_mob","tspire_mcube","tspire_mcube_b"],PersistenceRequired:1b,NoAI:1b,DeathLootTable:"minecraft:empty",Health:30f,Attributes:[{Name:"minecraft:generic.max_health",Base:30}]}
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] run summon minecraft:blaze ~10 ~ ~-4 {Tags:["tspire_mob","tspire_mcube","tspire_mcube_c"],PersistenceRequired:1b,NoAI:1b,DeathLootTable:"minecraft:empty",Health:30f,Attributes:[{Name:"minecraft:generic.max_health",Base:30}]}

# 黑色特效：每个护体单位周围一圈黑烟/墨汁
execute as @e[tag=tspire_mcube] at @s run particle minecraft:smoke ~ ~0.3 ~ 0.6 0.3 0.6 0.02 20 force
execute as @e[tag=tspire_mcube] at @s run particle minecraft:squid_ink ~ ~0.3 ~ 0.5 0.2 0.5 0.02 10 force

# BOSS 抗性提升 III（amplifier 2）：只给 5 秒，之后由 cube_watch 每 tick 按存活数重刷
effect clear @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance
effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance 5 2 true

execute as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.ambient master @s ~ ~ ~ 1.2 0.7
title @a[team=tspire_party] title {"text":"凋零剑压！","color":"dark_red","bold":true}
title @a[team=tspire_party] subtitle {"text":"3 只烈焰人护体 —— 每杀一只，它的抗性就掉一级","color":"gold"}
tellraw @a[team=tspire_party] [{"text":"[熔核暴君] ","color":"gold","bold":true},{"text":"凋零剑压！","color":"red","bold":true},{"text":"场上出现 3 只 30 血的无 AI 烈焰人，它为每只提供一级抗性（当前抗性提升 III）；杀光后 40 秒才会再次护体。","color":"yellow"}]
