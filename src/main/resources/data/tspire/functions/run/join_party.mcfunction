# Idle sign-up: each player makes this choice independently.
execute if score #TUTOR_BUSY tspire_timer matches 1 unless entity @s[tag=tspire_tutorial] run tellraw @s {"text":"[匠魂尖塔] 新手教程正在进行，结束后再加入正式队伍。","color":"yellow"}
execute unless score #TUTOR_BUSY tspire_timer matches 1 if score #RUN_STARTED tspire_timer matches 1 run function tspire:run/join_mid
execute unless score #RUN_STARTED tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 1.. run tellraw @s {"text":"[匠魂尖塔] 构筑间正在准备，暂不能入队。","color":"yellow"}
execute unless score #TUTOR_BUSY tspire_timer matches 1 unless score #RUN_STARTED tspire_timer matches 1 unless score #PICK_STAGE tspire_timer matches 1.. unless entity @s[team=tspire_party] run function tspire:run/join_party_do
execute unless score #RUN_STARTED tspire_timer matches 1 unless score #PICK_STAGE tspire_timer matches 1.. if entity @s[team=tspire_party] run tellraw @s [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"你已加入尖塔队伍。 ","color":"green"},{"text":"[开始游戏]","color":"yellow","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 5"},"hoverEvent":{"action":"show_text","contents":"让所有已入队玩家一起开始"}}]
