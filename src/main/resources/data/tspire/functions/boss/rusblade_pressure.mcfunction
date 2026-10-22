# 锈刃督军【威压】—— 每 15 秒
# 自身 8 格内：8 秒缓慢 II；8 格外（64 格内）：10 秒虚弱
# 【v0.6.43】玩家要求：缓慢效果提升至缓慢 2（amplifier 1）
scoreboard players set #RUS_C2 tspire_timer 0

execute at @e[tag=tspire_boss_rusblade,limit=1] run effect give @a[team=tspire_party,distance=..8] minecraft:slowness 8 1 true
execute at @e[tag=tspire_boss_rusblade,limit=1] run effect give @a[team=tspire_party,distance=8..64] minecraft:weakness 10 0 true

execute at @e[tag=tspire_boss_rusblade,limit=1] run particle minecraft:smoke ~ ~1 ~ 4 1 4 0.02 40 force
execute at @e[tag=tspire_boss_rusblade,limit=1] run particle minecraft:angry_villager ~ ~1.3 ~ 3 0.6 3 0.05 45 force
title @a[team=tspire_party] actionbar {"text":"【威压】近身被缓慢 II，远处被削弱 —— 换个距离打！","color":"dark_red","bold":true}
tellraw @a[team=tspire_party] [{"text":"[锈刃督军] ","color":"dark_red","bold":true},{"text":"威压！","color":"gold","bold":true},{"text":"8 格内 8 秒缓慢 II；8 格外 10 秒虚弱。","color":"yellow"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ravager.roar master @s ~ ~ ~ 0.8 0.7
