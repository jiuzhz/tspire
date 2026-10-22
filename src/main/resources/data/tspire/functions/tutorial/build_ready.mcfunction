# Load the tutorial strip first. Old drops in freshly loaded chunks must be removed next tick.
execute in tspire:tower run forceload add -144 -112 -96 48
scoreboard players set #MAP_USED tspire_timer 1
schedule function tspire:tutorial/build_ready_finish 2t replace
