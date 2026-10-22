# 传统派 · 试点武器：「原版精神」铁剑（锋利 V / 耐久 III / 消失诅咒）
execute if score @s tspire_my_choice matches 0 run give @s minecraft:iron_sword{display:{Name:'{"text":"原版精神","italic":false}'},Enchantments:[{id:"minecraft:sharpness",lvl:5},{id:"minecraft:unbreaking",lvl:3},{id:"minecraft:vanishing_curse",lvl:1}]}
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[传统派] ","color":"gold","bold":true},{"text":"「简单点，不好吗？」「原版精神」已放进你的背包（**不替换手上的东西**） —— 锋利 V，但带着消失诅咒。","color":"yellow"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:item.trident.throw master @s ~ ~ ~ 0.8 1.4
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2
