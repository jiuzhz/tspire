# 【再锻】发动：回中心 + 缓慢 10 三秒，三秒后由 recastking_reforge_go 换武器与增益
scoreboard players set #RK_C1 tspire_timer 0
scoreboard players set #RK_T tspire_timer 60
scoreboard players set #RK_ARM tspire_timer 1

# 回到场地中心（房间中心 marker 的位置）
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run tp @e[tag=tspire_boss_recastking,limit=1] ~ ~ ~
effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:slowness 3 9 true

execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:lava ~ ~1 ~ 1.5 0.5 1.5 0.05 40 force
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:crit ~ ~1 ~ 1.5 0.5 1.5 0.3 30 force
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:flame ~ ~0.4 ~ 1.8 0.3 1.8 0.03 45 force
execute as @a[team=tspire_party] at @s run playsound minecraft:block.anvil.land master @s ~ ~ ~ 1.2 0.7
execute as @a[team=tspire_party] at @s run playsound minecraft:block.smithing_table.use master @s ~ ~ ~ 0.9 0.8
title @a[team=tspire_party] title {"text":"再锻！","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"它回到熔炉中央 —— 要换武器了","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[重铸之王] ","color":"gold","bold":true},{"text":"再锻！","color":"red","bold":true},{"text":"它回到场地中央重铸自己：3 秒后换上一把新的匠魂手斧，并获得一种强化。","color":"yellow"}]
