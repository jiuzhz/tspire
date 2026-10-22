execute if score #RUN_STARTED tspire_timer matches 1 run tellraw @s {"text":"[新手教程] 当前已有正式对局，请等本局结束。","color":"yellow"}
execute if score #PICK_STAGE tspire_timer matches 1.. run tellraw @s {"text":"[新手教程] 地图正在准备，请稍后再试。","color":"yellow"}
execute if score #TUTOR_BUSY tspire_timer matches 1 run tellraw @s {"text":"[新手教程] 另一名玩家正在学习，教程结束后再试。","color":"yellow"}
tag @s add tspire_tutorial_requester
scoreboard players set #TUTOR_OTHER tspire_timer 0
execute as @a[team=tspire_party,tag=!tspire_tutorial_requester] run scoreboard players set #TUTOR_OTHER tspire_timer 1
tag @s remove tspire_tutorial_requester
execute if score #TUTOR_OTHER tspire_timer matches 1 run tellraw @s {"text":"[新手教程] 已有其他玩家报名正式对局。请等队伍完成或取消报名后再试。","color":"yellow"}
execute unless score #RUN_STARTED tspire_timer matches 1 unless score #PICK_STAGE tspire_timer matches 1.. unless score #TUTOR_BUSY tspire_timer matches 1 if score #TUTOR_OTHER tspire_timer matches 0 run function tspire:tutorial/start
