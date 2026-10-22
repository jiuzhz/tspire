scoreboard players operation #P_RESLEVEL tspire_timer = #P_RES tspire_timer
scoreboard players add #P_RESLEVEL tspire_timer 1
scoreboard players set #P_20 tspire_timer 20
scoreboard players operation #P_RESLEVEL tspire_timer *= #P_20 tspire_timer
execute if score #P_RESLEVEL tspire_timer matches 100.. run scoreboard players set #P_RESLEVEL tspire_timer 100
scoreboard players operation #P_100 tspire_timer -= #P_RESLEVEL tspire_timer
scoreboard players operation #P_FINAL tspire_timer *= #P_100 tspire_timer
scoreboard players set #P_100 tspire_timer 100
scoreboard players operation #P_FINAL tspire_timer /= #P_100 tspire_timer
