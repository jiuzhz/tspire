# 赐福 · 战斗之神（逐人独立）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_bless_war 1
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[赐福] ","color":"dark_red","bold":true},{"text":"战斗之神把血抹在你额头上 —— 此后每场战斗开始你都会获得 30 秒力量；BOSS 战开始时是力量 II。","color":"green"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.ravager.roar master @s ~ ~ ~ 0.8 1.2
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 3