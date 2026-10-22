# 【熔火地脉】5 秒火到点：统一清火 + 复位状态
# v0.6.58：先清火焰（只清 fire，不会挖掉地板），再清标记 —— 顺序不能反，
#   标记一旦消失就没有锚点可以 fill 了。
# v0.7.19：再加一次"房间整片扫"兜底 —— 只 replace minecraft:fire，
#   所以哪怕扫到房间外面也不会动到地板或建筑，漏在边角上的火一律清干净。
execute at @e[tag=tspire_lava,limit=1] run fill ~-3 ~ ~-3 ~3 ~ ~3 minecraft:air replace minecraft:fire
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run fill ~-9 ~-4 ~-10 ~9 ~6 ~10 minecraft:air replace minecraft:fire
kill @e[tag=tspire_lava]
scoreboard players set #MLZ tspire_timer 0
scoreboard players set #MLZ_T tspire_timer 0
scoreboard players set #ML_WIDE_F tspire_timer 0
scoreboard players set #ML_C1 tspire_timer 0
particle minecraft:large_smoke ~ ~0.3 ~ 1 0.2 1 0.05 20 force
# 【v0.7.25 补音效】地脉收摊：火灭 + 余烬散开
execute as @a[team=tspire_party] at @s run playsound minecraft:block.fire.extinguish master @s ~ ~ ~ 1.3 0.8
execute as @a[team=tspire_party] at @s run playsound minecraft:block.lava.pop master @s ~ ~ ~ 1.0 0.6
tellraw @a[team=tspire_party] [{"text":"[熔核暴君] ","color":"gold"},{"text":"地脉冷却了。","color":"gray"}]