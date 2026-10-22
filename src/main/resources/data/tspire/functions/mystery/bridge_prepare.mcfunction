# Mark each selected stack with a global serial, not just its slot.
scoreboard players set @s tspire_br1 0
scoreboard players set @s tspire_br2 0
scoreboard players set @s tspire_br3 0
scoreboard players set @s tspire_brid1 0
scoreboard players set @s tspire_brid2 0
scoreboard players set @s tspire_brid3 0
function tspire:mystery/bridge_candidates
execute if entity @e[tag=tspire_bridge_candidate,distance=..0.2] store result score @s tspire_br1 run scoreboard players get @e[tag=tspire_bridge_candidate,distance=..0.2,sort=random,limit=1] tspire_brslot
execute if score @s tspire_br1 matches 1.. run scoreboard players operation #BR_SELECTED tspire_timer = @s tspire_br1
execute if score @s tspire_br1 matches 1.. as @e[tag=tspire_bridge_candidate,distance=..0.2] if score @s tspire_brslot = #BR_SELECTED tspire_timer run tag @s remove tspire_bridge_candidate
execute if score @s tspire_br1 matches 1.. run scoreboard players add #BR_SERIAL tspire_timer 1
execute if score @s tspire_br1 matches 1.. run scoreboard players operation @s tspire_brid1 = #BR_SERIAL tspire_timer
execute if score @s tspire_br1 matches 1.. store result storage tspire:bridge serial int 1 run scoreboard players get #BR_SERIAL tspire_timer
execute if score @s tspire_br1 matches 1 run item modify entity @s hotbar.0 tspire:bridge/mark
execute if score @s tspire_br1 matches 2 run item modify entity @s hotbar.1 tspire:bridge/mark
execute if score @s tspire_br1 matches 3 run item modify entity @s hotbar.2 tspire:bridge/mark
execute if score @s tspire_br1 matches 4 run item modify entity @s hotbar.3 tspire:bridge/mark
execute if score @s tspire_br1 matches 5 run item modify entity @s hotbar.4 tspire:bridge/mark
execute if score @s tspire_br1 matches 6 run item modify entity @s hotbar.5 tspire:bridge/mark
execute if score @s tspire_br1 matches 7 run item modify entity @s hotbar.6 tspire:bridge/mark
execute if score @s tspire_br1 matches 8 run item modify entity @s hotbar.7 tspire:bridge/mark
execute if score @s tspire_br1 matches 9 run item modify entity @s hotbar.8 tspire:bridge/mark
execute if score @s tspire_br1 matches 10 run item modify entity @s inventory.0 tspire:bridge/mark
execute if score @s tspire_br1 matches 11 run item modify entity @s inventory.1 tspire:bridge/mark
execute if score @s tspire_br1 matches 12 run item modify entity @s inventory.2 tspire:bridge/mark
execute if score @s tspire_br1 matches 13 run item modify entity @s inventory.3 tspire:bridge/mark
execute if score @s tspire_br1 matches 14 run item modify entity @s inventory.4 tspire:bridge/mark
execute if score @s tspire_br1 matches 15 run item modify entity @s inventory.5 tspire:bridge/mark
execute if score @s tspire_br1 matches 16 run item modify entity @s inventory.6 tspire:bridge/mark
execute if score @s tspire_br1 matches 17 run item modify entity @s inventory.7 tspire:bridge/mark
execute if score @s tspire_br1 matches 18 run item modify entity @s inventory.8 tspire:bridge/mark
execute if score @s tspire_br1 matches 19 run item modify entity @s inventory.9 tspire:bridge/mark
execute if score @s tspire_br1 matches 20 run item modify entity @s inventory.10 tspire:bridge/mark
execute if score @s tspire_br1 matches 21 run item modify entity @s inventory.11 tspire:bridge/mark
execute if score @s tspire_br1 matches 22 run item modify entity @s inventory.12 tspire:bridge/mark
execute if score @s tspire_br1 matches 23 run item modify entity @s inventory.13 tspire:bridge/mark
execute if score @s tspire_br1 matches 24 run item modify entity @s inventory.14 tspire:bridge/mark
execute if score @s tspire_br1 matches 25 run item modify entity @s inventory.15 tspire:bridge/mark
execute if score @s tspire_br1 matches 26 run item modify entity @s inventory.16 tspire:bridge/mark
execute if score @s tspire_br1 matches 27 run item modify entity @s inventory.17 tspire:bridge/mark
execute if score @s tspire_br1 matches 28 run item modify entity @s inventory.18 tspire:bridge/mark
execute if score @s tspire_br1 matches 29 run item modify entity @s inventory.19 tspire:bridge/mark
execute if score @s tspire_br1 matches 30 run item modify entity @s inventory.20 tspire:bridge/mark
execute if score @s tspire_br1 matches 31 run item modify entity @s inventory.21 tspire:bridge/mark
execute if score @s tspire_br1 matches 32 run item modify entity @s inventory.22 tspire:bridge/mark
execute if score @s tspire_br1 matches 33 run item modify entity @s inventory.23 tspire:bridge/mark
execute if score @s tspire_br1 matches 34 run item modify entity @s inventory.24 tspire:bridge/mark
execute if score @s tspire_br1 matches 35 run item modify entity @s inventory.25 tspire:bridge/mark
execute if score @s tspire_br1 matches 36 run item modify entity @s inventory.26 tspire:bridge/mark
execute if score @s tspire_br1 matches 37 run item modify entity @s weapon.offhand tspire:bridge/mark
execute if score @s tspire_br1 matches 38 run item modify entity @s armor.feet tspire:bridge/mark
execute if score @s tspire_br1 matches 39 run item modify entity @s armor.legs tspire:bridge/mark
execute if score @s tspire_br1 matches 40 run item modify entity @s armor.chest tspire:bridge/mark
execute if score @s tspire_br1 matches 41 run item modify entity @s armor.head tspire:bridge/mark
execute if entity @e[tag=tspire_bridge_candidate,distance=..0.2] store result score @s tspire_br2 run scoreboard players get @e[tag=tspire_bridge_candidate,distance=..0.2,sort=random,limit=1] tspire_brslot
execute if score @s tspire_br2 matches 1.. run scoreboard players operation #BR_SELECTED tspire_timer = @s tspire_br2
execute if score @s tspire_br2 matches 1.. as @e[tag=tspire_bridge_candidate,distance=..0.2] if score @s tspire_brslot = #BR_SELECTED tspire_timer run tag @s remove tspire_bridge_candidate
execute if score @s tspire_br2 matches 1.. run scoreboard players add #BR_SERIAL tspire_timer 1
execute if score @s tspire_br2 matches 1.. run scoreboard players operation @s tspire_brid2 = #BR_SERIAL tspire_timer
execute if score @s tspire_br2 matches 1.. store result storage tspire:bridge serial int 1 run scoreboard players get #BR_SERIAL tspire_timer
execute if score @s tspire_br2 matches 1 run item modify entity @s hotbar.0 tspire:bridge/mark
execute if score @s tspire_br2 matches 2 run item modify entity @s hotbar.1 tspire:bridge/mark
execute if score @s tspire_br2 matches 3 run item modify entity @s hotbar.2 tspire:bridge/mark
execute if score @s tspire_br2 matches 4 run item modify entity @s hotbar.3 tspire:bridge/mark
execute if score @s tspire_br2 matches 5 run item modify entity @s hotbar.4 tspire:bridge/mark
execute if score @s tspire_br2 matches 6 run item modify entity @s hotbar.5 tspire:bridge/mark
execute if score @s tspire_br2 matches 7 run item modify entity @s hotbar.6 tspire:bridge/mark
execute if score @s tspire_br2 matches 8 run item modify entity @s hotbar.7 tspire:bridge/mark
execute if score @s tspire_br2 matches 9 run item modify entity @s hotbar.8 tspire:bridge/mark
execute if score @s tspire_br2 matches 10 run item modify entity @s inventory.0 tspire:bridge/mark
execute if score @s tspire_br2 matches 11 run item modify entity @s inventory.1 tspire:bridge/mark
execute if score @s tspire_br2 matches 12 run item modify entity @s inventory.2 tspire:bridge/mark
execute if score @s tspire_br2 matches 13 run item modify entity @s inventory.3 tspire:bridge/mark
execute if score @s tspire_br2 matches 14 run item modify entity @s inventory.4 tspire:bridge/mark
execute if score @s tspire_br2 matches 15 run item modify entity @s inventory.5 tspire:bridge/mark
execute if score @s tspire_br2 matches 16 run item modify entity @s inventory.6 tspire:bridge/mark
execute if score @s tspire_br2 matches 17 run item modify entity @s inventory.7 tspire:bridge/mark
execute if score @s tspire_br2 matches 18 run item modify entity @s inventory.8 tspire:bridge/mark
execute if score @s tspire_br2 matches 19 run item modify entity @s inventory.9 tspire:bridge/mark
execute if score @s tspire_br2 matches 20 run item modify entity @s inventory.10 tspire:bridge/mark
execute if score @s tspire_br2 matches 21 run item modify entity @s inventory.11 tspire:bridge/mark
execute if score @s tspire_br2 matches 22 run item modify entity @s inventory.12 tspire:bridge/mark
execute if score @s tspire_br2 matches 23 run item modify entity @s inventory.13 tspire:bridge/mark
execute if score @s tspire_br2 matches 24 run item modify entity @s inventory.14 tspire:bridge/mark
execute if score @s tspire_br2 matches 25 run item modify entity @s inventory.15 tspire:bridge/mark
execute if score @s tspire_br2 matches 26 run item modify entity @s inventory.16 tspire:bridge/mark
execute if score @s tspire_br2 matches 27 run item modify entity @s inventory.17 tspire:bridge/mark
execute if score @s tspire_br2 matches 28 run item modify entity @s inventory.18 tspire:bridge/mark
execute if score @s tspire_br2 matches 29 run item modify entity @s inventory.19 tspire:bridge/mark
execute if score @s tspire_br2 matches 30 run item modify entity @s inventory.20 tspire:bridge/mark
execute if score @s tspire_br2 matches 31 run item modify entity @s inventory.21 tspire:bridge/mark
execute if score @s tspire_br2 matches 32 run item modify entity @s inventory.22 tspire:bridge/mark
execute if score @s tspire_br2 matches 33 run item modify entity @s inventory.23 tspire:bridge/mark
execute if score @s tspire_br2 matches 34 run item modify entity @s inventory.24 tspire:bridge/mark
execute if score @s tspire_br2 matches 35 run item modify entity @s inventory.25 tspire:bridge/mark
execute if score @s tspire_br2 matches 36 run item modify entity @s inventory.26 tspire:bridge/mark
execute if score @s tspire_br2 matches 37 run item modify entity @s weapon.offhand tspire:bridge/mark
execute if score @s tspire_br2 matches 38 run item modify entity @s armor.feet tspire:bridge/mark
execute if score @s tspire_br2 matches 39 run item modify entity @s armor.legs tspire:bridge/mark
execute if score @s tspire_br2 matches 40 run item modify entity @s armor.chest tspire:bridge/mark
execute if score @s tspire_br2 matches 41 run item modify entity @s armor.head tspire:bridge/mark
execute if entity @e[tag=tspire_bridge_candidate,distance=..0.2] store result score @s tspire_br3 run scoreboard players get @e[tag=tspire_bridge_candidate,distance=..0.2,sort=random,limit=1] tspire_brslot
execute if score @s tspire_br3 matches 1.. run scoreboard players operation #BR_SELECTED tspire_timer = @s tspire_br3
execute if score @s tspire_br3 matches 1.. as @e[tag=tspire_bridge_candidate,distance=..0.2] if score @s tspire_brslot = #BR_SELECTED tspire_timer run tag @s remove tspire_bridge_candidate
execute if score @s tspire_br3 matches 1.. run scoreboard players add #BR_SERIAL tspire_timer 1
execute if score @s tspire_br3 matches 1.. run scoreboard players operation @s tspire_brid3 = #BR_SERIAL tspire_timer
execute if score @s tspire_br3 matches 1.. store result storage tspire:bridge serial int 1 run scoreboard players get #BR_SERIAL tspire_timer
execute if score @s tspire_br3 matches 1 run item modify entity @s hotbar.0 tspire:bridge/mark
execute if score @s tspire_br3 matches 2 run item modify entity @s hotbar.1 tspire:bridge/mark
execute if score @s tspire_br3 matches 3 run item modify entity @s hotbar.2 tspire:bridge/mark
execute if score @s tspire_br3 matches 4 run item modify entity @s hotbar.3 tspire:bridge/mark
execute if score @s tspire_br3 matches 5 run item modify entity @s hotbar.4 tspire:bridge/mark
execute if score @s tspire_br3 matches 6 run item modify entity @s hotbar.5 tspire:bridge/mark
execute if score @s tspire_br3 matches 7 run item modify entity @s hotbar.6 tspire:bridge/mark
execute if score @s tspire_br3 matches 8 run item modify entity @s hotbar.7 tspire:bridge/mark
execute if score @s tspire_br3 matches 9 run item modify entity @s hotbar.8 tspire:bridge/mark
execute if score @s tspire_br3 matches 10 run item modify entity @s inventory.0 tspire:bridge/mark
execute if score @s tspire_br3 matches 11 run item modify entity @s inventory.1 tspire:bridge/mark
execute if score @s tspire_br3 matches 12 run item modify entity @s inventory.2 tspire:bridge/mark
execute if score @s tspire_br3 matches 13 run item modify entity @s inventory.3 tspire:bridge/mark
execute if score @s tspire_br3 matches 14 run item modify entity @s inventory.4 tspire:bridge/mark
execute if score @s tspire_br3 matches 15 run item modify entity @s inventory.5 tspire:bridge/mark
execute if score @s tspire_br3 matches 16 run item modify entity @s inventory.6 tspire:bridge/mark
execute if score @s tspire_br3 matches 17 run item modify entity @s inventory.7 tspire:bridge/mark
execute if score @s tspire_br3 matches 18 run item modify entity @s inventory.8 tspire:bridge/mark
execute if score @s tspire_br3 matches 19 run item modify entity @s inventory.9 tspire:bridge/mark
execute if score @s tspire_br3 matches 20 run item modify entity @s inventory.10 tspire:bridge/mark
execute if score @s tspire_br3 matches 21 run item modify entity @s inventory.11 tspire:bridge/mark
execute if score @s tspire_br3 matches 22 run item modify entity @s inventory.12 tspire:bridge/mark
execute if score @s tspire_br3 matches 23 run item modify entity @s inventory.13 tspire:bridge/mark
execute if score @s tspire_br3 matches 24 run item modify entity @s inventory.14 tspire:bridge/mark
execute if score @s tspire_br3 matches 25 run item modify entity @s inventory.15 tspire:bridge/mark
execute if score @s tspire_br3 matches 26 run item modify entity @s inventory.16 tspire:bridge/mark
execute if score @s tspire_br3 matches 27 run item modify entity @s inventory.17 tspire:bridge/mark
execute if score @s tspire_br3 matches 28 run item modify entity @s inventory.18 tspire:bridge/mark
execute if score @s tspire_br3 matches 29 run item modify entity @s inventory.19 tspire:bridge/mark
execute if score @s tspire_br3 matches 30 run item modify entity @s inventory.20 tspire:bridge/mark
execute if score @s tspire_br3 matches 31 run item modify entity @s inventory.21 tspire:bridge/mark
execute if score @s tspire_br3 matches 32 run item modify entity @s inventory.22 tspire:bridge/mark
execute if score @s tspire_br3 matches 33 run item modify entity @s inventory.23 tspire:bridge/mark
execute if score @s tspire_br3 matches 34 run item modify entity @s inventory.24 tspire:bridge/mark
execute if score @s tspire_br3 matches 35 run item modify entity @s inventory.25 tspire:bridge/mark
execute if score @s tspire_br3 matches 36 run item modify entity @s inventory.26 tspire:bridge/mark
execute if score @s tspire_br3 matches 37 run item modify entity @s weapon.offhand tspire:bridge/mark
execute if score @s tspire_br3 matches 38 run item modify entity @s armor.feet tspire:bridge/mark
execute if score @s tspire_br3 matches 39 run item modify entity @s armor.legs tspire:bridge/mark
execute if score @s tspire_br3 matches 40 run item modify entity @s armor.chest tspire:bridge/mark
execute if score @s tspire_br3 matches 41 run item modify entity @s armor.head tspire:bridge/mark
kill @e[tag=tspire_bridge_marker,distance=..0.2]
function tspire:mystery/bridge_menu
