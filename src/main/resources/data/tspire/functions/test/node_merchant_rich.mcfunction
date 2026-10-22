# Demo helper: grant 200 gold then show the merchant menu
scoreboard players set @s tspire_gold 200
execute at @s run kill @e[tag=tspire_demo_node]
execute at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_node","tspire_row0","tspire_node_avail","tspire_type_merchant","tspire_demo_node"]}
execute at @s run function tspire:map/enter_merchant
