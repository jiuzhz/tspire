# 领取候选 3（执行者 = 点按钮的玩家）
# 详见 offer_take_0。

execute if score @s tspire_offer matches 1 run tellraw @s [{"text":"你已经领过这一份奖励了。","color":"red"}]
scoreboard players set #OFFER_SLOT tspire_timer 3
# v0.7.16：奖励层**只用早已存在的计分板**现算（BOSS 房 +1、封顶 3），与 offer_parts 同一套算法。
#   为什么不用新计分板：Minecraft 在**解析期**就校验计分板名，而新建的计分板要等 load 跑完
#   （也就是下一次 /reload）才存在 —— 引用它会让本函数整个加载失败（日志：错误的命令参数）。
scoreboard players operation #REW_F tspire_timer = #FLOOR tspire_timer
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] run scoreboard players add #REW_F tspire_timer 1
execute if score #REW_F tspire_timer matches 4.. run scoreboard players set #REW_F tspire_timer 3
execute if score @s tspire_offer matches 0 if score #REW_F tspire_timer matches 1 run function tspire:rewards/offer_f1
execute if score @s tspire_offer matches 0 if score #REW_F tspire_timer matches 2 run function tspire:rewards/offer_f2
execute if score @s tspire_offer matches 0 if score #REW_F tspire_timer matches 3 run function tspire:rewards/offer_f3
execute if score @s tspire_offer matches 0 run tellraw @s [{"text":"已领取候选 3。","color":"green"}]
execute if score @s tspire_offer matches 0 run scoreboard players set @s tspire_offer 1
