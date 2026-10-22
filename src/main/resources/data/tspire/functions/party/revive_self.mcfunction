# 复活单名队员。切换模式后等待两刻，待生命值更新再按配置扣血。
gamemode adventure @s
execute if entity @s[tag=tspire_hunger] run effect give @s minecraft:hunger 1000000 0 true
execute if entity @s[tag=tspire_treasure] run effect give @s minecraft:slowness 1000000 0 true
scoreboard players set @s tspire_dead 0
tag @s add tspire_revive_pending
schedule function tspire:party/revive_finalize 2t replace
function tspire:party/gather
title @s title {"text":"复活","color":"green","bold":true}
title @s subtitle {"text":"只保留了一部分生命","color":"gray"}
tellraw @s [{"text":"[尖塔] ","color":"gold"},{"text":"你已复活。","color":"green"},{"text":"（生命上限的 ","color":"gray"},{"score":{"name":"#CFG_REVIVE_HP_PERCENT","objective":"tspire_config"},"color":"yellow"},{"text":"%）","color":"gray"}]
playsound minecraft:block.beacon.activate master @s ~ ~ ~ 0.8 1.6
