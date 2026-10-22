# Resume a stalled stage-9 map task from its last completed step.
scoreboard players add #MAP_RETRIES tspire_timer 1
execute if score #MAP_RETRIES tspire_timer matches 1..2 run tellraw @a[team=tspire_party] {"text":"[匠魂尖塔] 地图生成中断，正在自动续建。","color":"yellow"}
execute if score #MAP_RETRIES tspire_timer matches 1..2 unless score #MAP_STEP tspire_timer matches 0..35 run function tspire:start/recover_map_reset
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 0 run schedule function tspire:map/runtime/row_1 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 1 run schedule function tspire:map/runtime/row_2 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 2 run schedule function tspire:map/runtime/row_3 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 3 run schedule function tspire:map/runtime/row_4 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 4 run schedule function tspire:map/runtime/row_5 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 5 run schedule function tspire:map/runtime/row_6 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 6 run schedule function tspire:map/runtime/row_7 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 7 run schedule function tspire:map/runtime/row_8 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 8 run schedule function tspire:map/runtime/row_9 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 9 run schedule function tspire:map/runtime/row_10 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 10 run schedule function tspire:map/runtime/row_11 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 11 run schedule function tspire:map/runtime/row_12 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 12 run schedule function tspire:map/runtime/row_13 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 13 run schedule function tspire:map/runtime/row_14 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 14 run schedule function tspire:map/runtime/row_15 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 15 run schedule function tspire:map/runtime/finish_positions 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 16..17 run schedule function tspire:map/runtime/assign_batch 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 18..20 run schedule function tspire:map/build_row_1 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 21 run schedule function tspire:map/build_row_2 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 22 run schedule function tspire:map/build_row_3 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 23 run schedule function tspire:map/build_row_4 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 24 run schedule function tspire:map/build_row_5 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 25 run schedule function tspire:map/build_row_6 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 26 run schedule function tspire:map/build_row_7 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 27 run schedule function tspire:map/build_row_8 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 28 run schedule function tspire:map/build_row_9 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 29 run schedule function tspire:map/build_row_10 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 30 run schedule function tspire:map/build_row_11 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 31 run schedule function tspire:map/build_row_12 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 32 run schedule function tspire:map/build_row_13 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 33 run schedule function tspire:map/build_row_14 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 34 run schedule function tspire:map/build_row_15 1t replace
execute if score #PICK_STAGE tspire_timer matches 9 if score #MAP_RETRIES tspire_timer matches 1..2 if score #MAP_STEP tspire_timer matches 35 run schedule function tspire:map/build_row_16 1t replace
execute if score #MAP_RETRIES tspire_timer matches 3 run tellraw @a[team=tspire_party] {"text":"[匠魂尖塔] 地图连续两次续建失败。请运行 /function tspire:test/start_check 并保存输出。","color":"red"}
scoreboard players set #PICK_WAIT tspire_timer 0
