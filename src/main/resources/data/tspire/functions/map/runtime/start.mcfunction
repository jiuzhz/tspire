# A new layout is drawn for every floor, every run. The hall is already prepared.
scoreboard players set #MAP_N tspire_timer 0
scoreboard players set #MAP_WIDE tspire_timer 0
scoreboard players set #MAP_FIRST_WIDTH tspire_timer 0
scoreboard players set #MAP_LAST_WIDTH tspire_timer 0
scoreboard players set #MAP_STEP tspire_timer 0
scoreboard players set #PICK_WAIT tspire_timer 0
schedule function tspire:map/runtime/row_1 1t replace
