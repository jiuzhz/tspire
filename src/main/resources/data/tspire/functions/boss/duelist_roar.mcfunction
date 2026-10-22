# ============================================================
# 钴蓝决斗者【决斗嘶吼】· HP ≤ 250 后每 16 秒（原【玛玉灵回响】）
# ============================================================
# 玩家指定：HP 低于 250 后每 16 秒嘶吼一次，全场播放音效（末影龙嘶吼），
#   场上所有玩家获得 12 秒虚弱 + 12 秒**穿甲 2**。
# 穿甲是匠魂自带效果：`tconstruct:pierce`（语言键 effect.tconstruct.pierce = 穿甲），
#   "穿甲 2" → amplifier 1。
# 虚弱 = 虚弱 I（amplifier 0，玩家没写等级）。
# 血量来源：boss/tick 每 tick 写入 `tspire_boss_hp`。
# ============================================================

scoreboard players set #DUE_C2 tspire_timer 0

# 全场效果
effect give @a[team=tspire_party,scores={tspire_dead=0}] minecraft:weakness 12 0 true
effect give @a[team=tspire_party,scores={tspire_dead=0}] tconstruct:pierce 12 1 true

# 表现：末影龙嘶吼 + 冲击波
execute at @e[tag=tspire_boss_duelist,limit=1] run particle minecraft:sonic_boom ~ ~1 ~ 0 0 0 0 1 force
execute at @e[tag=tspire_boss_duelist,limit=1] run particle minecraft:cloud ~ ~1 ~ 3 0.5 3 0.1 60 force
execute at @e[tag=tspire_boss_duelist,limit=1] run particle minecraft:crit ~ ~1 ~ 2 0.5 2 0.2 40 force
execute at @e[tag=tspire_boss_duelist,limit=1] run particle minecraft:enchanted_hit ~ ~1 ~ 3 0.5 3 0.15 55 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ender_dragon.growl master @s ~ ~ ~ 1.4 1
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ender_dragon.ambient master @s ~ ~ ~ 1.2 0.8
title @a[team=tspire_party] title {"text":"决斗嘶吼！","color":"dark_aqua","bold":true}
title @a[team=tspire_party] subtitle {"text":"全队被虚弱与穿甲压制 12 秒","color":"red"}
tellraw @a[team=tspire_party] [{"text":"[钴蓝决斗者] ","color":"aqua","bold":true},{"text":"决斗嘶吼！","color":"gold","bold":true},{"text":"全场玩家虚弱 I + 穿甲 II，持续 12 秒 —— 你的护甲挡不住它了。","color":"yellow"}]
