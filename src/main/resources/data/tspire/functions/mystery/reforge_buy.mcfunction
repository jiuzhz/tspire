# 重铸（可重复）：每次 40 金币。只有"还没选不重铸"（choice 0 或 1）时可用。
# 钱不够 → 只提示，不扣钱、不消耗选择，玩家还可以改选"不重铸"。
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 40
execute if score @s tspire_my_choice matches 2 run tellraw @s [{"text":"[重铸] ","color":"aqua"},{"text":"你已经决定不重铸了。","color":"gray"}]
execute if score @s tspire_my_choice matches 0..1 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"[重铸] ","color":"red"},{"text":"金币不足：重铸需要 40 金币（你有 ","color":"red"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":"）。","color":"red"}]
execute if score @s tspire_my_choice matches 0..1 if score #TMP tspire_timer matches 0.. run function tspire:mystery/reforge_do