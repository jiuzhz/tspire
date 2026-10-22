# The tutorial is a real single-player run with a fixed route.
scoreboard players set #TUTOR_BUSY tspire_timer 1
scoreboard players set #TUTOR_MODE tspire_timer 1
scoreboard players set @s tspire_tutorial 1
tag @s add tspire_tutorial
execute at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_tutorial_return"]}
execute at @s run forceload add ~ ~
scoreboard players set @s tspire_tut_mode 0
execute if entity @s[gamemode=creative] run scoreboard players set @s tspire_tut_mode 1
execute if entity @s[gamemode=adventure] run scoreboard players set @s tspire_tut_mode 2
execute if entity @s[gamemode=spectator] run scoreboard players set @s tspire_tut_mode 3
scoreboard players set #TUTOR_OFFLINE tspire_timer 0
team join tspire_party @s
tellraw @s [{"text":"[新手教程] ","color":"aqua"},{"text":"即将按正式规则开始构筑。开局会清空背包；教程里的奖励会照常发放。","color":"white"}]
function tspire:run/start_run
