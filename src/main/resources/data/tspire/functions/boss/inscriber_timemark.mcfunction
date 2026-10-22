# 铭刻者【时间铭刻】—— 每 15 秒：全体 7 秒折返 + 5 秒虚弱（v0.7.2 调短）
# 折返 = 匠魂效果 `tconstruct:returning`（语言键 effect.tconstruct.returning = 折返）。

scoreboard players set #INS_C1 tspire_timer 0

effect give @a[team=tspire_party,scores={tspire_dead=0}] tconstruct:returning 7 0 true
effect give @a[team=tspire_party,scores={tspire_dead=0}] minecraft:weakness 5 0 true

execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:enchant ~ ~1 ~ 2 1 2 0.5 60 force
execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:end_rod ~ ~1 ~ 1.5 0.8 1.5 0.1 40 force
execute as @a[team=tspire_party] at @s run playsound minecraft:block.enchantment_table.use master @s ~ ~ ~ 1.2 0.7
execute as @a[team=tspire_party] at @s run playsound minecraft:block.amethyst_block.chime master @s ~ ~ ~ 0.9 0.6
title @a[team=tspire_party] title {"text":"时间铭刻！","color":"light_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"折返 7 秒 + 虚弱 5 秒","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[铭刻者] ","color":"light_purple","bold":true},{"text":"时间铭刻！","color":"gold","bold":true},{"text":"全场获得折返 7 秒与虚弱 5 秒 —— 折返会把你弹回原位。","color":"yellow"}]
