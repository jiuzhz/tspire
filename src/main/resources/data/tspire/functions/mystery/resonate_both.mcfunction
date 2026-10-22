# 共鸣 · 共鸣：三类水晶各一枚（loot_tables/mystery/crystal_{upgrade,ability,slotless}.json）
execute if score @s tspire_my_choice matches 0 run loot give @s loot tspire:mystery/crystal_upgrade
execute if score @s tspire_my_choice matches 0 run loot give @s loot tspire:mystery/crystal_ability
execute if score @s tspire_my_choice matches 0 run loot give @s loot tspire:mystery/crystal_slotless
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[共鸣] ","color":"aqua","bold":true},{"text":"你跟着书页念了下去 —— 三枚强化水晶从书缝里掉了出来（升级 / 能力 / 无槽位 各一枚）。","color":"green"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:block.enchantment_table.use master @s ~ ~ ~ 1 1.6
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1