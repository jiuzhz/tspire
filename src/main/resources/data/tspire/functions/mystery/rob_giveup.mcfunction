# 抢劫 · 放弃：扣 75 金币（不足则扣到 0）
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 75
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run scoreboard players set @s tspire_gold 0
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 75
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[抢劫] ","color":"yellow","bold":true},{"text":"你决定不要那些金币了 —— 混乱总要有人付账（-75 金币，剩下 ","color":"yellow"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":"）。","color":"yellow"}]
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2