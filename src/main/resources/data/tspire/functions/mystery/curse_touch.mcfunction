# 诅咒雕像 · 触碰（逐人独立；持续效果由 mystery/curse_tick + map/enter 结算）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_curse_greed 1
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_curse_cd 1200
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[诅咒雕像] ","color":"dark_gray","bold":true},{"text":"你的手按上了冰冷的石面 —— 此后每进入一个房间额外 +12 金币；但生命超过 20 时，贪婪之神会索取 4 秒凋零，每次间隔至少 60 秒。","color":"red"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.wither.spawn master @s ~ ~ ~ 0.6 1.4
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1