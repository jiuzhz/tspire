# Reward demo forced to floor 3
scoreboard players set #FLOOR tspire_timer 3
loot give @s loot tspire:rewards/battle_random_f3
loot give @s loot tspire:rewards/battle_random_f3
loot give @s loot tspire:rewards/battle_random_f3
loot give @s loot tspire:rewards/battle_random_f3
function tspire:rewards/offer_parts
tellraw @s {"text":"[Reward demo] floor 3 done.","color":"gold"}
