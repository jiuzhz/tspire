# 沼泽猎手【标枪投掷】· 结算 —— 每 7 秒；半径 7 格；2 点伤害 + 中毒 4 秒
# 【v0.6.44】前 2 秒的前摇在 boss/mirehunter_javelin_aim，本文件只负责到点结算。
# 特效加强：范围粒子圈 + 中心水花 + 音效 + 全屏提示

scoreboard players set #MIRE_C2 tspire_timer 0

# 5 格范围边缘画圈（8 点）+ 地面水花
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~7 ~1 ~ 0 0 0 0 3 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~-7 ~1 ~ 0 0 0 0 3 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~ ~1 ~7 0 0 0 0 3 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~ ~1 ~-7 0 0 0 0 3 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~3.5 ~1 ~3.5 0 0 0 0 3 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~-3.5 ~1 ~3.5 0 0 0 0 3 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~3.5 ~1 ~-3.5 0 0 0 0 3 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:end_rod ~-3.5 ~1 ~-3.5 0 0 0 0 3 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:splash ~ ~1 ~ 3 0.3 3 0.1 40 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:witch ~ ~1 ~ 2 0.2 2 0.05 20 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:sculk_soul ~ ~0.3 ~ 3 0.2 3 0.04 45 force

# 7 格内先造成 2 点伤害，再中毒 4 秒
# 【v0.6.45 修正】这里必须是 `minecraft:poison`（**药水效果**）。
#   v0.6.43 修"minecraft:poison 不是粒子"时用了全局替换，把这一行**效果**也换成了
#   `minecraft:witch` —— 而 witch 只是粒子、不是效果，于是这个效果命令无法解析，
#   整个函数加载失败，【标枪投掷】的中毒与冷却清零（同文件内的 #MIRE_C2 = 0）全都失效。
#   粒子那一行（上一行）保持 minecraft:witch 是对的。
execute at @e[tag=tspire_boss_mirehunter,limit=1] as @a[team=tspire_party,scores={tspire_dead=0},distance=..7] run damage @s 2 minecraft:magic
execute at @e[tag=tspire_boss_mirehunter,limit=1] run effect give @a[team=tspire_party,distance=..7] minecraft:poison 4 0 true

title @a[team=tspire_party] actionbar {"text":"【毒标枪】7 格内中毒 —— 出圈！","color":"green","bold":true}
tellraw @a[team=tspire_party] [{"text":"[沼泽猎手] ","color":"green","bold":true},{"text":"毒标枪！","color":"gold","bold":true},{"text":"7 格内受到 2 点伤害并中毒 4 秒，别站桩。","color":"yellow"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:item.trident.throw master @s ~ ~ ~ 1 1.2
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.drowned.shoot master @s ~ ~ ~ 1 0.9
