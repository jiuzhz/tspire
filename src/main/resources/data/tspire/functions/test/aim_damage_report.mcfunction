# One hit with the target current melee attack attribute, after armor/toughness/resistance.
scoreboard players set #P_ATTACK tspire_timer 0
scoreboard players set #P_ARMOR tspire_timer 0
scoreboard players set #P_TOUGH tspire_timer 0
scoreboard players set #P_HEALTH tspire_timer 0
scoreboard players set #P_RES tspire_timer -1
execute store result score #P_ATTACK tspire_timer run attribute @e[tag=tspire_probe_target,limit=1] minecraft:generic.attack_damage get 100
execute store result score #P_ARMOR tspire_timer run attribute @s minecraft:generic.armor get 100
execute store result score #P_TOUGH tspire_timer run attribute @s minecraft:generic.armor_toughness get 100
execute store result score #P_HEALTH tspire_timer run data get entity @s Health 100
execute if data entity @s ActiveEffects[{Id:11b}] store result score #P_RES tspire_timer run data get entity @s ActiveEffects[{Id:11b}].Amplifier 1
# Armor reduction = clamp(max(armor/5, armor - damage/(2+toughness/4)), 0, 20) / 25.
scoreboard players set #P_100 tspire_timer 100
scoreboard players set #P_5 tspire_timer 5
scoreboard players set #P_4 tspire_timer 4
scoreboard players set #P_25 tspire_timer 25
scoreboard players set #P_2500 tspire_timer 2500
scoreboard players operation #P_DEN tspire_timer = #P_TOUGH tspire_timer
scoreboard players operation #P_DEN tspire_timer /= #P_4 tspire_timer
scoreboard players add #P_DEN tspire_timer 200
scoreboard players operation #P_PEN tspire_timer = #P_ATTACK tspire_timer
scoreboard players operation #P_PEN tspire_timer *= #P_100 tspire_timer
scoreboard players operation #P_PEN tspire_timer /= #P_DEN tspire_timer
scoreboard players operation #P_RED tspire_timer = #P_ARMOR tspire_timer
scoreboard players operation #P_RED tspire_timer -= #P_PEN tspire_timer
scoreboard players operation #P_MIN tspire_timer = #P_ARMOR tspire_timer
scoreboard players operation #P_MIN tspire_timer /= #P_5 tspire_timer
execute if score #P_RED tspire_timer < #P_MIN tspire_timer run scoreboard players operation #P_RED tspire_timer = #P_MIN tspire_timer
execute if score #P_RED tspire_timer matches 2001.. run scoreboard players set #P_RED tspire_timer 2000
scoreboard players operation #P_LEFT tspire_timer = #P_2500 tspire_timer
scoreboard players operation #P_LEFT tspire_timer -= #P_RED tspire_timer
scoreboard players operation #P_FINAL tspire_timer = #P_ATTACK tspire_timer
scoreboard players operation #P_FINAL tspire_timer *= #P_LEFT tspire_timer
scoreboard players operation #P_FINAL tspire_timer /= #P_2500 tspire_timer
# Resistance reduces the result by 20% per level, capped at 100%.
execute if score #P_RES tspire_timer matches 0.. run function tspire:test/aim_damage_resist
# Display values rounded to one decimal using two score components.
scoreboard players set #P_10 tspire_timer 10
scoreboard players operation #P_ATTACK10 tspire_timer = #P_ATTACK tspire_timer
scoreboard players add #P_ATTACK10 tspire_timer 5
scoreboard players operation #P_ATTACK10 tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_ATTACKI tspire_timer = #P_ATTACK10 tspire_timer
scoreboard players operation #P_ATTACKI tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_ATTACKF tspire_timer = #P_ATTACK10 tspire_timer
scoreboard players operation #P_ATTACKF tspire_timer %= #P_10 tspire_timer
scoreboard players operation #P_FINAL10 tspire_timer = #P_FINAL tspire_timer
scoreboard players add #P_FINAL10 tspire_timer 5
scoreboard players operation #P_FINAL10 tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_FINALI tspire_timer = #P_FINAL10 tspire_timer
scoreboard players operation #P_FINALI tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_FINALF tspire_timer = #P_FINAL10 tspire_timer
scoreboard players operation #P_FINALF tspire_timer %= #P_10 tspire_timer
scoreboard players operation #P_ARMOR10 tspire_timer = #P_ARMOR tspire_timer
scoreboard players add #P_ARMOR10 tspire_timer 5
scoreboard players operation #P_ARMOR10 tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_ARMORI tspire_timer = #P_ARMOR10 tspire_timer
scoreboard players operation #P_ARMORI tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_ARMORF tspire_timer = #P_ARMOR10 tspire_timer
scoreboard players operation #P_ARMORF tspire_timer %= #P_10 tspire_timer
scoreboard players operation #P_TOUGH10 tspire_timer = #P_TOUGH tspire_timer
scoreboard players add #P_TOUGH10 tspire_timer 5
scoreboard players operation #P_TOUGH10 tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_TOUGHI tspire_timer = #P_TOUGH10 tspire_timer
scoreboard players operation #P_TOUGHI tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_TOUGHF tspire_timer = #P_TOUGH10 tspire_timer
scoreboard players operation #P_TOUGHF tspire_timer %= #P_10 tspire_timer
scoreboard players operation #P_HEALTH10 tspire_timer = #P_HEALTH tspire_timer
scoreboard players add #P_HEALTH10 tspire_timer 5
scoreboard players operation #P_HEALTH10 tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_HEALTHI tspire_timer = #P_HEALTH10 tspire_timer
scoreboard players operation #P_HEALTHI tspire_timer /= #P_10 tspire_timer
scoreboard players operation #P_HEALTHF tspire_timer = #P_HEALTH10 tspire_timer
scoreboard players operation #P_HEALTHF tspire_timer %= #P_10 tspire_timer
tellraw @s [{"text":"=== 视线伤害探针 ===","color":"gold","bold":true}]
tellraw @s [{"text":"目标：","color":"yellow"},{"selector":"@e[tag=tspire_probe_target,limit=1]","color":"white"},{"text":"（","color":"gray"},{"nbt":"id","entity":"@e[tag=tspire_probe_target,limit=1]","color":"gray"},{"text":"）","color":"gray"}]
tellraw @s [{"text":"目标主手：","color":"yellow"},{"nbt":"HandItems[0].id","entity":"@e[tag=tspire_probe_target,limit=1]","color":"white"},{"text":"  材料：","color":"gray"},{"nbt":"HandItems[0].tag.tic_materials","entity":"@e[tag=tspire_probe_target,limit=1]","color":"green"}]
tellraw @s [{"text":"目标当前近战攻击：","color":"yellow"},{"score":{"name":"#P_ATTACKI","objective":"tspire_timer"},"color":"aqua"},{"text":"."},{"score":{"name":"#P_ATTACKF","objective":"tspire_timer"},"color":"aqua"},{"text":" 点（已含主手攻击属性及力量等属性效果）","color":"gray"}]
tellraw @s [{"text":"你的护甲：","color":"yellow"},{"score":{"name":"#P_ARMORI","objective":"tspire_timer"},"color":"aqua"},{"text":"."},{"score":{"name":"#P_ARMORF","objective":"tspire_timer"},"color":"aqua"},{"text":"；韧性：","color":"yellow"},{"score":{"name":"#P_TOUGHI","objective":"tspire_timer"},"color":"aqua"},{"text":"."},{"score":{"name":"#P_TOUGHF","objective":"tspire_timer"},"color":"aqua"},{"text":"；当前血量：","color":"red"},{"score":{"name":"#P_HEALTHI","objective":"tspire_timer"},"color":"aqua"},{"text":"."},{"score":{"name":"#P_HEALTHF","objective":"tspire_timer"},"color":"aqua"}]
tellraw @s [{"text":"头盔：","color":"gray"},{"nbt":"Inventory[{Slot:103b}].id","entity":"@s","color":"white"},{"text":" 材料 ","color":"gray"},{"nbt":"Inventory[{Slot:103b}].tag.tic_materials","entity":"@s","color":"green"}]
tellraw @s [{"text":"胸甲：","color":"gray"},{"nbt":"Inventory[{Slot:102b}].id","entity":"@s","color":"white"},{"text":" 材料 ","color":"gray"},{"nbt":"Inventory[{Slot:102b}].tag.tic_materials","entity":"@s","color":"green"}]
tellraw @s [{"text":"护腿：","color":"gray"},{"nbt":"Inventory[{Slot:101b}].id","entity":"@s","color":"white"},{"text":" 材料 ","color":"gray"},{"nbt":"Inventory[{Slot:101b}].tag.tic_materials","entity":"@s","color":"green"}]
tellraw @s [{"text":"靴子：","color":"gray"},{"nbt":"Inventory[{Slot:100b}].id","entity":"@s","color":"white"},{"text":" 材料 ","color":"gray"},{"nbt":"Inventory[{Slot:100b}].tag.tic_materials","entity":"@s","color":"green"}]
tellraw @s [{"text":"预计这次普通近战掉血：","color":"gold"},{"score":{"name":"#P_FINALI","objective":"tspire_timer"},"color":"red"},{"text":".","color":"red"},{"score":{"name":"#P_FINALF","objective":"tspire_timer"},"color":"red"},{"text":" 点","color":"red"}]
execute if score #P_FINAL tspire_timer >= #P_HEALTH tspire_timer run tellraw @s {"text":"按当前血量，这一次普通近战足以致死。","color":"red"}
tellraw @s [{"text":"只计算普通近战与护甲、韧性、抗性；附魔保护、匠魂特殊减伤/穿甲、技能额外伤害、多次命中及部分模组效果另算。","color":"dark_gray"}]
