# 诅咒雕像：生命超过 20 时获得 4 秒凋零；触发后冷却 1200 tick。
execute if score @s tspire_curse_cd matches 1.. run scoreboard players remove @s tspire_curse_cd 1
execute if score @s tspire_hp matches 21.. if score @s tspire_curse_cd matches 0 run effect give @s minecraft:wither 4 0 true
execute if score @s tspire_hp matches 21.. if score @s tspire_curse_cd matches 0 run tellraw @s {"text":"贪婪诅咒生效了","color":"dark_gray","bold":true}
execute if score @s tspire_hp matches 21.. if score @s tspire_curse_cd matches 0 run scoreboard players set @s tspire_curse_cd 1200
