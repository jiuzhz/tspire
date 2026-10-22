# Chunks are loaded; clear old entities before placing the tutorial rooms.
execute if score #TUTOR_MODE tspire_timer matches 1 run function tspire:map/clear_dynamic
execute if score #TUTOR_MODE tspire_timer matches 1 in tspire:tower run kill @e[type=minecraft:experience_orb]
execute if score #TUTOR_MODE tspire_timer matches 1 in tspire:tower run function tspire:tutorial/build
schedule function tspire:tutorial/clear_build_drops 2t replace
