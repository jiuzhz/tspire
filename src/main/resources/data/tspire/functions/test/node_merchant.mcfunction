# Demo: merchant node at the player's position
kill @e[tag=tspire_demo_node]
execute at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_node","tspire_row0","tspire_node_avail","tspire_type_merchant","tspire_demo_node"]}
execute at @s run function tspire:map/enter_merchant
tellraw @s {"text":"[Demo] merchant menu shown (5% chance of an ancient tool shelf).","color":"gold"}
