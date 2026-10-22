# 援兵 · 体验款 75 金币 → 40 血铁傀儡（跟随、不攻击玩家；v0.7.18 由 20 血提高）
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 75
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"[援兵] ","color":"gold","bold":true},{"text":"金币不够（需要 75）。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 75
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run summon minecraft:iron_golem ~ ~ ~ {Tags:["tspire_ally"],PersistenceRequired:1b,PlayerCreated:1b,Health:40f,Attributes:[{Name:"minecraft:generic.max_health",Base:40}]}
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run tellraw @s [{"text":"[援兵] ","color":"gold","bold":true},{"text":"商人拍了拍铁傀儡：「跟着这位客人。」它朝你走了过来。","color":"green"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. as @s at @s run playsound minecraft:entity.iron_golem.repair master @s ~ ~ ~ 1 1.1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players set @s tspire_my_choice 1
