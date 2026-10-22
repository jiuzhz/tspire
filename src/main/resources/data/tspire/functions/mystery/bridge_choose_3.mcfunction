scoreboard players operation #BR_TARGET tspire_timer = @s tspire_brid3
execute as @a run function tspire:mystery/bridge_scan_player
execute in tspire:tower as @e[type=minecraft:item] run function tspire:mystery/bridge_scan_drop
tellraw @s [{"text":"[吊桥] ","color":"light_purple","bold":true},{"text":"你放弃了候选 3，另外两件留在身上。","color":"yellow"}]
scoreboard players set @s tspire_my_choice 3
