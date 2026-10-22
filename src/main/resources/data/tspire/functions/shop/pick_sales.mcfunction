# Draw exactly two distinct positions among the ten part/crystal slots.
scoreboard players set @s tspire_sale_a -1
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d10 run scoreboard players set @s tspire_sale_a 0
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d9 run scoreboard players set @s tspire_sale_a 1
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d8 run scoreboard players set @s tspire_sale_a 2
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d7 run scoreboard players set @s tspire_sale_a 3
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d6 run scoreboard players set @s tspire_sale_a 4
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d5 run scoreboard players set @s tspire_sale_a 5
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d4 run scoreboard players set @s tspire_sale_a 6
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d3 run scoreboard players set @s tspire_sale_a 7
execute if score @s tspire_sale_a matches -1 if predicate tspire:roll/d2 run scoreboard players set @s tspire_sale_a 8
execute if score @s tspire_sale_a matches -1 run scoreboard players set @s tspire_sale_a 9
scoreboard players set @s tspire_sale_b -1
execute if score @s tspire_sale_b matches -1 if predicate tspire:roll/d9 run scoreboard players set @s tspire_sale_b 0
execute if score @s tspire_sale_b matches -1 if predicate tspire:roll/d8 run scoreboard players set @s tspire_sale_b 1
execute if score @s tspire_sale_b matches -1 if predicate tspire:roll/d7 run scoreboard players set @s tspire_sale_b 2
execute if score @s tspire_sale_b matches -1 if predicate tspire:roll/d6 run scoreboard players set @s tspire_sale_b 3
execute if score @s tspire_sale_b matches -1 if predicate tspire:roll/d5 run scoreboard players set @s tspire_sale_b 4
execute if score @s tspire_sale_b matches -1 if predicate tspire:roll/d4 run scoreboard players set @s tspire_sale_b 5
execute if score @s tspire_sale_b matches -1 if predicate tspire:roll/d3 run scoreboard players set @s tspire_sale_b 6
execute if score @s tspire_sale_b matches -1 if predicate tspire:roll/d2 run scoreboard players set @s tspire_sale_b 7
execute if score @s tspire_sale_b matches -1 run scoreboard players set @s tspire_sale_b 8
execute if score @s tspire_sale_b >= @s tspire_sale_a run scoreboard players add @s tspire_sale_b 1
execute if score @s tspire_sale_a matches 5.. run scoreboard players add @s tspire_sale_a 1
execute if score @s tspire_sale_b matches 5.. run scoreboard players add @s tspire_sale_b 1
