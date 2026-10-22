# Reward demo forced to floor 1
scoreboard players set #FLOOR tspire_timer 1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
function tspire:rewards/offer_parts
tellraw @s {"text":"[Reward demo] floor 1 done.","color":"gold"}
