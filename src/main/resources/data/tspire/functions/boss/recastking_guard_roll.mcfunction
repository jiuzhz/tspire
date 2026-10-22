# 在执行位置随机召一名 50 血卫兵。
scoreboard players set #RK_GUARD tspire_timer 0
execute if predicate tspire:roll/d2 run scoreboard players set #RK_GUARD tspire_timer 1
execute if score #RK_GUARD tspire_timer matches 0 run summon minecraft:piglin_brute ~ ~ ~ {Tags:["tspire_mob","tspire_guard"],PersistenceRequired:1b,Health:50f,Attributes:[{Name:"minecraft:generic.max_health",Base:50}],HandItems:[{id:"minecraft:golden_sword",Count:1b},{}]}
execute if score #RK_GUARD tspire_timer matches 1 run summon minecraft:piglin ~ ~ ~ {IsImmuneToZombification:1b,Tags:["tspire_mob","tspire_guard"],PersistenceRequired:1b,Health:50f,Attributes:[{Name:"minecraft:generic.max_health",Base:50}],HandItems:[{id:"minecraft:crossbow",Count:1b},{}]}
