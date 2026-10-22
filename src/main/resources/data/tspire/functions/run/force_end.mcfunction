# End the current party run as a loss, then empty inventories and return everyone.
tag @a[team=tspire_party] add tspire_force_end_return
scoreboard players set #FORCE_END tspire_timer 1
function tspire:run/lose
scoreboard players set #FORCE_END tspire_timer 0
execute as @a[tag=tspire_force_end_return] run clear @s
execute as @a[tag=tspire_force_end_return] run function tspire:run/quit
tag @a[tag=tspire_force_end_return] remove tspire_force_end_return
