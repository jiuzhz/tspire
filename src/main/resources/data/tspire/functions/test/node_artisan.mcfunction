# Demo: artisan node at the player's position
# Creates a fake node marker and runs the real artisan logic.
kill @e[tag=tspire_demo_node]
execute at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_node","tspire_row0","tspire_node_avail","tspire_type_artisan","tspire_demo_node"]}
execute at @s run function tspire:map/enter_artisan
tellraw @s {"text":"[Demo] artisan node built around you.","color":"gold"}
