# 【再锻】3 秒后：换武器（随机 3~4 级材料的匠魂手斧）+ 随机 45 秒增益
scoreboard players set #RK_ARM tspire_timer 0

# 换主手武器（战利品表由 gen-shops.ps1 生成，条目 = 每种 3/4 级材料一把 hand_axe）
loot replace entity @e[tag=tspire_boss_recastking,limit=1] weapon.mainhand loot tspire:boss_gear/recast_axe

# 随机 45 秒：抗性提升 / 力量 / 速度（均匀 1..3）
scoreboard players set #RK_BUFF tspire_timer 0
execute if score #RK_BUFF tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #RK_BUFF tspire_timer 3
execute if score #RK_BUFF tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #RK_BUFF tspire_timer 2
execute if score #RK_BUFF tspire_timer matches 0 run scoreboard players set #RK_BUFF tspire_timer 1
execute if score #RK_BUFF tspire_timer matches 1 run effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:resistance 45 0 true
execute if score #RK_BUFF tspire_timer matches 2 run effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:strength 45 0 true
execute if score #RK_BUFF tspire_timer matches 3 run effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:speed 45 0 true
execute if score #RK_BUFF tspire_timer matches 1 run title @a[team=tspire_party] actionbar {"text":"【再锻】重铸完成：换上新斧 + 抗性提升 45 秒","color":"gold","bold":true}
execute if score #RK_BUFF tspire_timer matches 2 run title @a[team=tspire_party] actionbar {"text":"【再锻】重铸完成：换上新斧 + 力量 45 秒","color":"gold","bold":true}
execute if score #RK_BUFF tspire_timer matches 3 run title @a[team=tspire_party] actionbar {"text":"【再锻】重铸完成：换上新斧 + 速度 45 秒","color":"gold","bold":true}
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:enchant ~ ~1.5 ~ 1 0.5 1 0.5 50 force
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:crit ~ ~1 ~ 1.5 0.7 1.5 0.15 65 force
execute as @a[team=tspire_party] at @s run playsound minecraft:block.anvil.use master @s ~ ~ ~ 1.2 1.2
