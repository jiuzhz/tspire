# 传统派 · 试点装备：头盔 → 「原版精神」海龟壳（保护 IV / 耐久 III / 绑定诅咒）
execute if score @s tspire_my_choice matches 0 run item replace entity @s armor.head with minecraft:turtle_helmet{display:{Name:'{"text":"原版精神","italic":false}'},Enchantments:[{id:"minecraft:protection",lvl:4},{id:"minecraft:unbreaking",lvl:3},{id:"minecraft:binding_curse",lvl:1}]}
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[传统派] ","color":"gold","bold":true},{"text":"「这才叫做装备嘛。」你的头盔换成了「原版精神」海龟壳 —— 绑定诅咒，穿上就脱不掉了。","color":"yellow"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:item.armor.equip_turtle master @s ~ ~ ~ 1 1
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
