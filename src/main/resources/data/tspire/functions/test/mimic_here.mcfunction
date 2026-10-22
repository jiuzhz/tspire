# Force the mimic event in the current mystery room.
# Run as a player standing within 10 blocks of its current node marker.
execute at @s if entity @e[tag=tspire_node_current,tag=tspire_type_mystery,distance=..10,limit=1] run function tspire:test/mimic_here_do
execute at @s unless entity @e[tag=tspire_node_current,tag=tspire_type_mystery,distance=..10,limit=1] run tellraw @s {"text":"[Test] Stand inside the current mystery room before running this command.","color":"red"}
