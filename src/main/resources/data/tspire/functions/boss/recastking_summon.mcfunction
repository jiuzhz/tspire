# 【王权征召】发动：自身缓慢 10 两秒；两秒后由 recastking_summon_go 结算
scoreboard players set #RK_C3 tspire_timer 0
scoreboard players set #RK_T2 tspire_timer 40
scoreboard players set #RK_ARM2 tspire_timer 1
effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:slowness 2 9 true
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:block minecraft:gold_block ~ ~1 ~ 1.5 0.5 1.5 0.05 40 force
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:totem_of_undying ~ ~1.3 ~ 2 1 2 0.02 40 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.piglin_brute.ambient master @s ~ ~ ~ 1.2 0.6
title @a[team=tspire_party] title {"text":"王权征召！","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"它在召集自己的卫队…","color":"gray"}
