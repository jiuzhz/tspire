# ============================================================
# 本局结算界面 —— run/win 与 run/lose 都会调用
# ============================================================
# 调用前必须先设置：#RESULT tspire_timer = 1 表示通关 / 0 表示失败
#
# 每名队员看到的是**自己的**成绩：金币、用时、通过节点、本局阵亡次数。
# 这些统计在 run/reset_player 里清零，由 tick/second 与 map/complete_node 累加。
# ============================================================

tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":"========== 本局结算 ==========","color":"gold","bold":true}]

execute if score #RESULT tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"结果：","color":"gray"},{"text":"通关","color":"green","bold":true},{"text":"　三层塔已被攻克","color":"gray"}]
execute if score #RESULT tspire_timer matches 0 unless score #FORCE_END tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"结果：","color":"gray"},{"text":"失败","color":"red","bold":true},{"text":"　全队阵亡","color":"gray"}]
execute if score #RESULT tspire_timer matches 0 if score #FORCE_END tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"结果：","color":"gray"},{"text":"失败","color":"red","bold":true},{"text":"　主动结束","color":"gray"}]

execute as @a[team=tspire_party] run tellraw @s [{"text":"到达层数：","color":"gray"},{"score":{"name":"@s","objective":"tspire_layer"},"color":"white"},{"text":"　　通过节点：","color":"gray"},{"score":{"name":"@s","objective":"tspire_nodes"},"color":"white"}]
execute as @a[team=tspire_party] run tellraw @s [{"text":"用时：","color":"gray"},{"score":{"name":"@s","objective":"tspire_time"},"color":"white"},{"text":" 秒　　剩余金币：","color":"gray"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]
execute as @a[team=tspire_party] run tellraw @s [{"text":"本局阵亡：","color":"gray"},{"score":{"name":"@s","objective":"tspire_death_total"},"color":"red"},{"text":" 次","color":"gray"}]
execute as @a[team=tspire_party] run tellraw @s [{"text":"分层用时：","color":"gray"},{"text":"一层 ","color":"dark_gray"},{"score":{"name":"@s","objective":"tspire_t1"},"color":"white"},{"text":" 秒  二层 ","color":"dark_gray"},{"score":{"name":"@s","objective":"tspire_t2"},"color":"white"},{"text":" 秒  三层 ","color":"dark_gray"},{"score":{"name":"@s","objective":"tspire_t3"},"color":"white"},{"text":" 秒","color":"dark_gray"}]
execute as @a[team=tspire_party] run tellraw @s [{"text":"购买次数：","color":"gray"},{"score":{"name":"@s","objective":"tspire_bought"},"color":"yellow"},{"text":" 次","color":"gray"}]

tellraw @a[team=tspire_party] [{"text":" "}]
execute unless score #FORCE_END tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"[ 退出（回主世界） ]","color":"aqua","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 70"},"hoverEvent":{"action":"show_text","contents":"传送至主世界原点附近的安全地面"}}]
tellraw @a[team=tspire_party] [{"text":"[ 加入下一局 ]","color":"yellow","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 105"},"hoverEvent":{"action":"show_text","contents":"加入下一局队伍；入队后点击开始游戏"}}]
tellraw @a[team=tspire_party] [{"text":" "}]
