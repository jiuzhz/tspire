# Four type assignments per tick keep the floor transition responsive.
execute in tspire:tower if entity @e[tag=tspire_type_pending] run function tspire:map/runtime/assign_one
execute in tspire:tower if entity @e[tag=tspire_type_pending] run function tspire:map/runtime/assign_one
execute in tspire:tower if entity @e[tag=tspire_type_pending] run function tspire:map/runtime/assign_one
execute in tspire:tower if entity @e[tag=tspire_type_pending] run function tspire:map/runtime/assign_one
scoreboard players set #MAP_STEP tspire_timer 17
scoreboard players set #PICK_WAIT tspire_timer 0
execute in tspire:tower if entity @e[tag=tspire_type_pending] run schedule function tspire:map/runtime/assign_batch 1t replace
execute in tspire:tower unless entity @e[tag=tspire_type_pending] run schedule function tspire:map/build_row_1 1t replace
