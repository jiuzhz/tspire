# 【铭刻逆流】窗口内没被打到 → 回复生命
# v0.7.10 玩家要求：回复量 32 → **16 点**。instant_health 每级治疗 4<<amplifier，
#   amplifier **2 = 16 点**，这次是**精确值**（不再需要近似说明）。
scoreboard players set #INS_LOOK tspire_timer 0
effect give @e[tag=tspire_boss_inscriber,limit=1] minecraft:instant_health 1 2 true
execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:heart ~ ~1 ~ 1.5 1 1.5 0.1 30 force
execute as @a[team=tspire_party] at @s run playsound minecraft:block.beacon.activate master @s ~ ~ ~ 1 1.4
title @a[team=tspire_party] actionbar {"text":"【铭刻逆流】8 秒内无人命中 —— 它回复了生命！","color":"red","bold":true}
tellraw @a[team=tspire_party] [{"text":"[铭刻者] ","color":"light_purple","bold":true},{"text":"铭刻逆流完成：","color":"gold","bold":true},{"text":"这次没人打到它，它恢复了 16 点生命。","color":"red"}]
