scoreboard players set #SHOP_TWO tspire_timer 2
scoreboard players operation #PRICE3 tspire_timer /= #SHOP_TWO tspire_timer
execute if score #PRICE3 tspire_timer matches ..4 run scoreboard players set #PRICE3 tspire_timer 5
