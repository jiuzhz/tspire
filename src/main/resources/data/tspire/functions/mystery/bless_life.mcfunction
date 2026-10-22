# 赐福 · 生命之神（逐人独立，只能选一次；选了别的神就没有机会了）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_bless_life 1
execute if score @s tspire_my_choice matches 0 run effect give @s minecraft:instant_health 1 0 true
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[赐福] ","color":"red","bold":true},{"text":"生命之神的目光落在你身上 —— 此后每进入一个房间，你都会获得 10 秒生命恢复。","color":"green"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.player.levelup master @s ~ ~ ~ 1 1.4
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1