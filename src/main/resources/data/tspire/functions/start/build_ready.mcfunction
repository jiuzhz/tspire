# Floor 1 hall is ready; draw the route and carve its rooms over 16 ticks.
execute if score #TUTOR_MODE tspire_timer matches 1 run function tspire:tutorial/build_ready
execute unless score #TUTOR_MODE tspire_timer matches 1 run scoreboard players set #PICK_STAGE tspire_timer 9
execute unless score #TUTOR_MODE tspire_timer matches 1 run function tspire:map/clear_dynamic
execute unless score #TUTOR_MODE tspire_timer matches 1 run function tspire:map/build_floor
