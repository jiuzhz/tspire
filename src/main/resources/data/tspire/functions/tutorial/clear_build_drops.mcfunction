# Building over old grass can spawn fresh drops after the first cleanup.
# Keep the learner away until the block updates settle and the second cleanup finishes.
execute if score #TUTOR_MODE tspire_timer matches 1 in tspire:tower run kill @e[type=minecraft:item]
execute if score #TUTOR_MODE tspire_timer matches 1 in tspire:tower run kill @e[type=minecraft:experience_orb]
execute if score #TUTOR_MODE tspire_timer matches 1 run scoreboard players set #PICK_STAGE tspire_timer 2
