# 锈刃督军【亡者征召】—— 每 12 秒；血量 < 50% 时残血改为 3 只（去掉南侧那只）
# 血量用 tspire_boss_hp（health 判据）读；督军 max_health 见 boss/spawn/rusblade。

scoreboard players set #RUS_C1 tspire_timer 0

# 血量低于 50% -> 3 只；否则 2 只
scoreboard players set #RUS_DOUBLE tspire_timer 0
execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer run scoreboard players set #RUS_DOUBLE tspire_timer 1

execute at @e[tag=tspire_boss_rusblade,limit=1] if score #MOB_COUNT tspire_timer < #MOB_CAP tspire_timer run summon minecraft:zombie ~2 ~ ~ {Tags:["tspire_mob","tspire_mob_new","tspire_gear"],PersistenceRequired:1b}
execute at @e[tag=tspire_boss_rusblade,limit=1] if score #MOB_COUNT tspire_timer < #MOB_CAP tspire_timer run summon minecraft:zombie ~-2 ~ ~ {Tags:["tspire_mob","tspire_mob_new","tspire_gear"],PersistenceRequired:1b}
# v0.6.52（玩家要求）：残血从"召 4 只"改成"召 3 只"，并且
#   **去掉靠南（+Z）那一只** —— 它会在玩家正面/脸上刷出来。
#   现在残血 = 东西两只 + 北边一只，共 3 只。
# （原来这里是 ~ ~ ~2 的南侧召唤，已删除）
execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer at @e[tag=tspire_boss_rusblade,limit=1] if score #MOB_COUNT tspire_timer < #MOB_CAP tspire_timer run summon minecraft:zombie ~ ~ ~-2 {Tags:["tspire_mob","tspire_mob_new","tspire_gear"],PersistenceRequired:1b}

function tspire:mobs/equip
tag @e[tag=tspire_mob_new] remove tspire_mob_new

execute if score #RUS_DOUBLE tspire_timer matches 1 run title @a[team=tspire_party] actionbar {"text":"【亡者征召】残血暴走 —— 一次召来 3 只增援（东西 + 北侧）！","color":"dark_red","bold":true}
execute if score #RUS_DOUBLE tspire_timer matches 0 run title @a[team=tspire_party] actionbar {"text":"【亡者征召】锈刃督军召唤了增援！","color":"dark_red","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.zombie.ambient master @s ~ ~ ~ 1 0.6
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.zombie.break_wooden_door master @s ~ ~ ~ 0.8 0.7
