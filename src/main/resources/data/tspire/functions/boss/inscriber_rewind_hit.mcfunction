# 【铭刻逆流】窗口内被打到 → 全体失明 2 秒 + BOSS 随机传送（安全）+ 自身发光 6 秒
scoreboard players set #INS_LOOK tspire_timer 0

# 全体失明 2 秒（v0.7.19：注释/标题原来写"3 秒"，以代码 2 秒为准并对齐文案）
effect give @a[team=tspire_party,scores={tspire_dead=0}] minecraft:blindness 2 0 true

# 随机传送：方向 0..7（均匀）+ 距离 3 或 6，全部相对房间中心 → 不会出场地/进墙
scoreboard players set #INS_K tspire_timer 0
execute if score #INS_K tspire_timer matches 0 if predicate tspire:roll/d8 run scoreboard players set #INS_K tspire_timer 7
execute if score #INS_K tspire_timer matches 0 if predicate tspire:roll/d7 run scoreboard players set #INS_K tspire_timer 6
execute if score #INS_K tspire_timer matches 0 if predicate tspire:roll/d6 run scoreboard players set #INS_K tspire_timer 5
execute if score #INS_K tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #INS_K tspire_timer 4
execute if score #INS_K tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #INS_K tspire_timer 3
execute if score #INS_K tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #INS_K tspire_timer 2
execute if score #INS_K tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #INS_K tspire_timer 1
scoreboard players set #INS_D tspire_timer 3
execute if predicate tspire:roll/d2 run scoreboard players set #INS_D tspire_timer 6
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 0 if score #INS_D tspire_timer matches 3 run tp @e[tag=tspire_boss_inscriber,limit=1] ~3 ~ ~
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 0 if score #INS_D tspire_timer matches 6 run tp @e[tag=tspire_boss_inscriber,limit=1] ~6 ~ ~
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 2 if score #INS_D tspire_timer matches 3 run tp @e[tag=tspire_boss_inscriber,limit=1] ~ ~ ~3
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 2 if score #INS_D tspire_timer matches 6 run tp @e[tag=tspire_boss_inscriber,limit=1] ~ ~ ~6
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 4 if score #INS_D tspire_timer matches 3 run tp @e[tag=tspire_boss_inscriber,limit=1] ~-3 ~ ~
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 4 if score #INS_D tspire_timer matches 6 run tp @e[tag=tspire_boss_inscriber,limit=1] ~-6 ~ ~
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 6 if score #INS_D tspire_timer matches 3 run tp @e[tag=tspire_boss_inscriber,limit=1] ~ ~ ~-3
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 6 if score #INS_D tspire_timer matches 6 run tp @e[tag=tspire_boss_inscriber,limit=1] ~ ~ ~-6
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 1 if score #INS_D tspire_timer matches 3 run tp @e[tag=tspire_boss_inscriber,limit=1] ~2.1 ~ ~2.1
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 1 if score #INS_D tspire_timer matches 6 run tp @e[tag=tspire_boss_inscriber,limit=1] ~4.2 ~ ~4.2
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 3 if score #INS_D tspire_timer matches 3 run tp @e[tag=tspire_boss_inscriber,limit=1] ~-2.1 ~ ~2.1
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 3 if score #INS_D tspire_timer matches 6 run tp @e[tag=tspire_boss_inscriber,limit=1] ~-4.2 ~ ~4.2
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 5 if score #INS_D tspire_timer matches 3 run tp @e[tag=tspire_boss_inscriber,limit=1] ~-2.1 ~ ~-2.1
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 5 if score #INS_D tspire_timer matches 6 run tp @e[tag=tspire_boss_inscriber,limit=1] ~-4.2 ~ ~-4.2
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 7 if score #INS_D tspire_timer matches 3 run tp @e[tag=tspire_boss_inscriber,limit=1] ~2.1 ~ ~-2.1
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #INS_K tspire_timer matches 7 if score #INS_D tspire_timer matches 6 run tp @e[tag=tspire_boss_inscriber,limit=1] ~4.2 ~ ~-4.2

# 自身发光 6 秒 + 表现
effect give @e[tag=tspire_boss_inscriber,limit=1] minecraft:glowing 6 0 true
execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:smoke ~ ~1 ~ 1.5 1 1.5 0.05 60 force
execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:sculk_soul ~ ~1 ~ 1.5 1 1.5 0.05 40 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.illusioner.mirror_move master @s ~ ~ ~ 1.3 0.7
title @a[team=tspire_party] title {"text":"逆流被打断！","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"全场失明 2 秒 —— 它换了位置（会发光 6 秒）","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[铭刻者] ","color":"light_purple","bold":true},{"text":"逆流失败！","color":"gold","bold":true},{"text":"它没能回到过去：全场失明 2 秒，它随机挪到了场地另一处，并现形 6 秒。","color":"yellow"}]
