# Reward demo forced to floor 2
scoreboard players set #FLOOR tspire_timer 2
loot give @s loot tspire:rewards/battle_random_f2
loot give @s loot tspire:rewards/battle_random_f2
loot give @s loot tspire:rewards/battle_random_f2
loot give @s loot tspire:rewards/battle_random_f2
function tspire:rewards/offer_parts
tellraw @s {"text":"[Reward demo] floor 2 done.","color":"gold"}
