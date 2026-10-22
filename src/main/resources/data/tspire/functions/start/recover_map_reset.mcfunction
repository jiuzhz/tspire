# Legacy stage-9 state has no checkpoint. Rebuild the fixed halls and start again.
function tspire:map/runtime/cancel
schedule clear tspire:map/build_row_1
schedule clear tspire:map/build_row_2
schedule clear tspire:map/build_row_3
schedule clear tspire:map/build_row_4
schedule clear tspire:map/build_row_5
schedule clear tspire:map/build_row_6
schedule clear tspire:map/build_row_7
schedule clear tspire:map/build_row_8
schedule clear tspire:map/build_row_9
schedule clear tspire:map/build_row_10
schedule clear tspire:map/build_row_11
schedule clear tspire:map/build_row_12
schedule clear tspire:map/build_row_13
schedule clear tspire:map/build_row_14
schedule clear tspire:map/build_row_15
schedule clear tspire:map/build_row_16
scoreboard players set #PICK_STAGE tspire_timer 8
function tspire:map/prepare/start
