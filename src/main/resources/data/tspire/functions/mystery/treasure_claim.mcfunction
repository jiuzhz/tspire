tag @s remove tspire_treasure
effect clear @s minecraft:slowness
scoreboard players add @s tspire_gold 300
tellraw @s [{"text":"[藏宝图] ","color":"gold","bold":true},{"text":"找到了二层宝箱，获得300金币，缓慢已解除。","color":"gold"}]
