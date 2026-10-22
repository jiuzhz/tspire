# 【熔火地脉】发动：1.5 秒前摇（Boss 缓慢 10 + 脚下标记），**前摇结束（#MLZ_T = 31）才点火**
# v0.7.19 修复：原来在发动这一刻就 fill 火焰，1.5 秒前摇形同虚设（玩家实测"火焰在前摇里就出来"）。
#   火焰的生成、伤害结算、清场现在全部由 moltenlord_lava_zone 按 #MLZ_T 分阶段执行。
scoreboard players set #ML_C1 tspire_timer 0
scoreboard players set #MLZ tspire_timer 1
scoreboard players set #MLZ_T tspire_timer 0

# 清掉上一轮的火焰标记，重新在 Boss 脚下放一个（这是整段技能的锚点）
kill @e[tag=tspire_lava]
execute at @e[tag=tspire_boss_moltenlord,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["tspire_lava"]}

# 1.5 秒前摇：自身缓慢 10（每 tick 刷新，见 moltenlord_lava_zone）
# 时长由 zone 每 tick 刷新（#MLZ_T 1..30 = 1.5 秒前摇），这行只负责起手那一下
effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:slowness 2 9 true

execute at @e[tag=tspire_boss_moltenlord,limit=1] run particle minecraft:lava ~ ~0.2 ~ 3 0.1 3 0.05 40 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.shoot master @s ~ ~ ~ 1.2 0.6
# 【v0.7.25 补音效】起手蓄力：blaze 充能 + 脚下岩浆翻涌
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.charge master @s ~ ~ ~ 1.3 0.5
execute as @a[team=tspire_party] at @s run playsound minecraft:block.lava.pop master @s ~ ~ ~ 1.4 0.7
title @a[team=tspire_party] actionbar {"text":"⚠ 【熔火地脉】脚下开始喷发 —— 离开这块地！","color":"gold","bold":true}
tellraw @a[team=tspire_party] [{"text":"[熔核暴君] ","color":"gold","bold":true},{"text":"熔火地脉！","color":"red","bold":true},{"text":"1.5 秒后它脚下 3×3 的地面会燃起火焰并持续 5 秒；血量掉到 50% 以下后范围扩大到 5×5。","color":"yellow"}]
