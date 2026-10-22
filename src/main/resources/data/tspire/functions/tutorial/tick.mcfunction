# Pause for a temporarily disconnected learner, then release the shared arena.
execute if entity @a[tag=tspire_tutorial] run scoreboard players set #TUTOR_OFFLINE tspire_timer 0
execute unless entity @a[tag=tspire_tutorial] run scoreboard players add #TUTOR_OFFLINE tspire_timer 1
execute if score #TUTOR_OFFLINE tspire_timer matches 300.. run function tspire:tutorial/cleanup
execute if score #RUN_STARTED tspire_timer matches 1 as @a[tag=tspire_tutorial] unless entity @s[nbt={Dimension:"tspire:tower"}] run function tspire:tutorial/exit
