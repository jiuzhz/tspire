# 药房 · 买一瓶：25 金币 → 特殊奖励池随机 1 件（各自独立骰，可能重复）
# 钱不够 → 只提示、不扣钱、不消耗选择（可以去选别的档）
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 25
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"[药房] ","color":"red"},{"text":"金币不足：这一档需要 25 金币（你有 ","color":"red"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":"）。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 25
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run function tspire:rewards/special_give
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run tellraw @s [{"text":"[药房] ","color":"light_purple","bold":true},{"text":"买一瓶 成交 —— 你拿走 1 瓶东西（剩 ","color":"green"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":" 金币）。","color":"green"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. as @s at @s run playsound minecraft:entity.item.pickup master @s ~ ~ ~ 1 1.2
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players set @s tspire_my_choice 1
