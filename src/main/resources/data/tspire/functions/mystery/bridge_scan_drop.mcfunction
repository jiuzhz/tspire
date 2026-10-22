# @s is a dropped item in the tower dimension.
scoreboard players set #BR_SCAN tspire_timer 0
execute store result score #BR_SCAN tspire_timer run data get entity @s Item.tag.tspire_bridge_serial
execute if score #BR_SCAN tspire_timer = #BR_TARGET tspire_timer run kill @s
