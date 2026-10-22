# 【熔核爆发】重做 · 发动（HP ≤ 50% = #TH_HALF，冷却 30 秒；技能期间暂停计数 → 实际 45 秒）
#   传送回场地中心 → 15 秒缓慢 10 → 期间每 2 秒在每名玩家脚下生成 3×3 火焰
scoreboard players set #ML_C3 tspire_timer 0
scoreboard players set #MLZ2 tspire_timer 1
scoreboard players set #MLZ2_T tspire_timer 0
scoreboard players set #MLZ2_W tspire_timer 0

# 回中心 + 15 秒缓慢 10（v0.7.19：锚点用"房间中心节点"，落点抬高 1 格免得卡进地板；
#   整段过载期间每 2 秒由 moltenlord_burst_fire 重新钉一次，见那边）
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run tp @e[tag=tspire_boss_moltenlord,limit=1] ~ ~1 ~
effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:slowness 15 9 true
# 【v0.7.54 玩家要求】熔核爆发期间**同时获得 15 秒抗性提升 III**（和缓慢 10 一起上，一起收）
effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance 15 2 true

execute at @e[tag=tspire_boss_moltenlord,limit=1] run particle minecraft:lava ~ ~1 ~ 2 1 2 0.1 80 force
execute at @e[tag=tspire_boss_moltenlord,limit=1] run particle minecraft:flame ~ ~1 ~ 2 1 2 0.2 60 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.death master @s ~ ~ ~ 1.4 0.6
# 【v0.7.25 补音效】爆发的"炸开"声：原版龙火球爆炸 + 一声低沉的火焰
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.dragon_fireball.explode master @s ~ ~ ~ 1.6 0.7
execute as @a[team=tspire_party] at @s run playsound minecraft:block.fire.ambient master @s ~ ~ ~ 1.2 0.6
title @a[team=tspire_party] title {"text":"熔核爆发！","color":"dark_red","bold":true}
title @a[team=tspire_party] subtitle {"text":"脚下会不断喷发 15 秒 —— 别停在原地","color":"gold"}
tellraw @a[team=tspire_party] [{"text":"[熔核暴君] ","color":"gold","bold":true},{"text":"熔核爆发！","color":"red","bold":true},{"text":"它回到场地中央进入过载 15 秒：每 2 秒在每名玩家脚下生成 3×3 火焰（持续 5 秒）。","color":"yellow"}]
