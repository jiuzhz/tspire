# 援兵 · 包售后 200 金币 → 20 血铁傀儡 + 5 铁锭
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 200
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"[援兵] ","color":"gold","bold":true},{"text":"金币不够（需要 200）。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 200
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run summon minecraft:iron_golem ~ ~ ~ {Tags:["tspire_ally"],PersistenceRequired:1b,PlayerCreated:1b,Health:40f,Attributes:[{Name:"minecraft:generic.max_health",Base:40}]}
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run give @s minecraft:iron_ingot 6
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run tellraw @s [{"text":"[援兵] ","color":"gold","bold":true},{"text":"「包售后！」铁傀儡跟着你，另外塞给你 6 个铁锭 —— 它挨打时你自己修。","color":"green"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. as @s at @s run playsound minecraft:block.anvil.use master @s ~ ~ ~ 1 1.1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players set @s tspire_my_choice 2
