# 【熔核爆发】15 秒到点：**统一清火** + 退出过载（冷却从 0 重新计 30 秒）
# v0.6.58：清火必须在 kill 之前（kill 之后就没有锚点了）
# v0.7.19：除了每个标记脚下的 3×3，再按房间中心整片扫一次 fire —— 只 replace
#   minecraft:fire，扫到房间外面也只会清火、不会动地板或建筑，所以漏在边角的火一并清掉。
#   顺带把【熔火地脉】遗留的火/标记也一起收掉（"15 秒结束后统一清火"）。
execute as @e[tag=tspire_fz1] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:air replace minecraft:fire
execute as @e[tag=tspire_fz2] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:air replace minecraft:fire
execute as @e[tag=tspire_fz3] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:air replace minecraft:fire
execute as @e[tag=tspire_fz4] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:air replace minecraft:fire
execute as @e[tag=tspire_fz5] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:air replace minecraft:fire
execute at @e[tag=tspire_lava,limit=1] run fill ~-3 ~ ~-3 ~3 ~ ~3 minecraft:air replace minecraft:fire
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run fill ~-9 ~-4 ~-10 ~9 ~6 ~10 minecraft:air replace minecraft:fire
kill @e[tag=tspire_fz1]
kill @e[tag=tspire_fz2]
kill @e[tag=tspire_fz3]
kill @e[tag=tspire_fz4]
kill @e[tag=tspire_fz5]
kill @e[tag=tspire_lava]
scoreboard players set #MLZ2 tspire_timer 0
scoreboard players set #MLZ2_T tspire_timer 0
scoreboard players set #MLZ2_W tspire_timer 0
scoreboard players set #MLZ tspire_timer 0
scoreboard players set #MLZ_T tspire_timer 0
scoreboard players set #ML_WIDE_F tspire_timer 0
scoreboard players set #ML_C1 tspire_timer 0
scoreboard players set #ML_C3 tspire_timer 0
# 缓慢 10 到这一刻正好收掉（否则最后一次重刷会多拖 2 秒）
effect clear @e[tag=tspire_boss_moltenlord,limit=1] minecraft:slowness
effect clear @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run particle minecraft:large_smoke ~ ~0.3 ~ 3 0.3 3 0.05 30 force
# 【v0.7.25 补音效】收摊：火灭 + 一声低沉的余烬
execute as @a[team=tspire_party] at @s run playsound minecraft:block.fire.extinguish master @s ~ ~ ~ 1.4 0.7
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.death master @s ~ ~ ~ 1.0 0.5
tellraw @a[team=tspire_party] [{"text":"[熔核暴君] ","color":"gold"},{"text":"熔核爆发结束，场上的火都灭了，它冷却下来了。","color":"gray"}]