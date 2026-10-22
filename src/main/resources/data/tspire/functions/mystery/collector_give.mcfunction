# 黏液收藏家 · 奉上（主手必须拿黏液头颅）
execute if score @s tspire_my_choice matches 0 unless entity @s[nbt={SelectedItem:{id:"tconstruct:slime_helmet"}}] run tellraw @s [{"text":"[收藏家] ","color":"green","bold":true},{"text":"「（他皱眉）你手上没有黏液头颅啊。」","color":"red"}]
execute if score @s tspire_my_choice matches 0 if entity @s[nbt={SelectedItem:{id:"tconstruct:slime_helmet"}}] run item replace entity @s weapon.mainhand with air
execute if score @s tspire_my_choice matches 0 if entity @s[nbt={SelectedItem:{id:"tconstruct:slime_helmet"}}] run loot give @s loot tspire:mystery/knightslime_tool
execute if score @s tspire_my_choice matches 0 if entity @s[nbt={SelectedItem:{id:"tconstruct:slime_helmet"}}] run tellraw @s [{"text":"[收藏家] ","color":"green","bold":true},{"text":"「太好了，太好了……」他收下头颅，塞给你一件沉甸甸的金属物件。","color":"green"}]
execute if score @s tspire_my_choice matches 0 if entity @s[nbt={SelectedItem:{id:"tconstruct:slime_helmet"}}] as @s at @s run playsound minecraft:block.anvil.use master @s ~ ~ ~ 1 1.2
execute if score @s tspire_my_choice matches 0 if entity @s[nbt={SelectedItem:{id:"tconstruct:slime_helmet"}}] run scoreboard players set @s tspire_my_choice 1
