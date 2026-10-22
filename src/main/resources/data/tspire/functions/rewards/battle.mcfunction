# ============================================================
# 战斗奖励（设计文档 §3.3）
#   第二类 金币
#   第三类 随机奖励 ×2（普通战斗）/ ×4（**精英节点**，v0.7.21）；池子：
#     水晶 35.2% / 部件 30.2% / 装备 15.5% / 金苹果 17.9% / 远古 0.6% / 投掷 0.6%
#   第一类 材料部件三选一（放进宝箱，玩家自取一个）
# ============================================================

# --- 第二类：金币（普通战斗 8~12；**精英节点 15~20**，v0.7.21 玩家要求） ---
#   判定看**当前节点标记的 elite 标签**（比读 #ELITE 稳：那是个会被下一层/下一房覆盖的全局分数）。
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite] as @a[team=tspire_party] run function tspire:rewards/gold_roll_elite
execute unless entity @e[tag=tspire_node_current,tag=tspire_type_elite] as @a[team=tspire_party] run function tspire:rewards/gold_roll
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] run scoreboard players add @a[team=tspire_party] tspire_gold 100
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] run tellraw @a[team=tspire_party] [{"text":"[BOSS 奖励] ","color":"gold","bold":true},{"text":"击杀奖励 +100 金币","color":"yellow"}]

# 【v0.6.44】BOSS 房的奖励池取**更高一层**（玩家要求：不然 boss 奖励没用）。
#   #REW_F = #FLOOR，boss 房再 +1，上限 3。判定与 run/battle_start 同一套（tspire_type_boss）。
scoreboard players operation #REW_F tspire_timer = #FLOOR tspire_timer
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] run scoreboard players add #REW_F tspire_timer 1
execute if score #REW_F tspire_timer matches 4.. run scoreboard players set #REW_F tspire_timer 3

# --- 第三类：随机奖励 ×2（表里 rolls=2） ---
# 【v0.6.23 多人修正】原来是 `loot give @a[team=tspire_party] loot <表>`。
#   那条命令**只骰一次**，然后把同一份结果发给所有人 —— 实测"每个玩家获得的随机
#   奖励一致"。改成 as 每名玩家各自骰一次，人人不同。
execute if score #REW_F tspire_timer matches 1 as @a[team=tspire_party] run loot give @s loot tspire:rewards/battle_random_f1
execute if score #REW_F tspire_timer matches 2 as @a[team=tspire_party] run loot give @s loot tspire:rewards/battle_random_f2
execute if score #REW_F tspire_timer matches 3 as @a[team=tspire_party] run loot give @s loot tspire:rewards/battle_random_f3

# 【v0.7.21 玩家要求】**精英节点：随机奖励提升到 4 项** —— 再补发一轮
#   （表里 rolls=2，所以"两轮"正好 4 项；每一轮都是各自独立掷骰，多人时人人不同）。
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite] if score #REW_F tspire_timer matches 1 as @a[team=tspire_party] run loot give @s loot tspire:rewards/battle_random_f1
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite] if score #REW_F tspire_timer matches 2 as @a[team=tspire_party] run loot give @s loot tspire:rewards/battle_random_f2
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite] if score #REW_F tspire_timer matches 3 as @a[team=tspire_party] run loot give @s loot tspire:rewards/battle_random_f3

# --- 第一类：材料部件三选一 ---
function tspire:rewards/offer_parts

execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite] run tellraw @a[team=tspire_party] [{"text":"[奖励] ","color":"gold"},{"text":"精英节点：+15~20 金币，+4 项随机奖励","color":"aqua","bold":true}]
execute unless entity @e[tag=tspire_node_current,tag=tspire_type_elite] run tellraw @a[team=tspire_party] [{"text":"[奖励] ","color":"gold"},{"text":"+8~12 金币，+2 项随机奖励","color":"white"}]
tellraw @a[team=tspire_party] [{"text":"         房间正中的箱子锁着，点聊天栏里的三选一领取。","color":"gray"}]
