# 宝箱节点（§3.1：直接获得 1 个随机部件或 1 件随机武器）
execute if score #FLOOR tspire_timer matches 2 if entity @e[tag=tspire_node_current,tag=tspire_type_chest,limit=1] as @a[team=tspire_party,tag=tspire_treasure] run function tspire:mystery/treasure_claim
# 宝箱节点奖励：见 rewards/chest_* 与设计文档 §3.3（v0.7 起已是正式奖池，不再是占位实现）
execute as @e[tag=tspire_node_avail,tag=tspire_type_chest,distance=..3,limit=1,sort=nearest] run tag @s add tspire_node_current
execute as @e[tag=tspire_node_current] run tag @s remove tspire_node_avail

# 【v0.7.21】宝箱节点的房间装饰（玩家手搭）：锚点 = 当前节点，**只在第一次进来时铺一次**。
#   注意：宝箱奖励是下面直接 `loot give` 发的，装饰里有没有箱子、有没有东西都不参与结算。
execute unless entity @e[tag=tspire_node_current,tag=tspire_node_built] at @e[tag=tspire_node_current] run function tspire:deco/chest
tag @e[tag=tspire_node_current] add tspire_node_built

# 【v0.6.23 多人修正】`loot give @a[...]` 只骰一次、结果发给所有人（人人相同）。
# 改成 as 每名玩家各自骰一次。
execute if score #FLOOR tspire_timer matches 1 as @a[team=tspire_party] run loot give @s loot tspire:mob_gear/weapon_f1
execute if score #FLOOR tspire_timer matches 2 as @a[team=tspire_party] run loot give @s loot tspire:mob_gear/weapon_f2
execute if score #FLOOR tspire_timer matches 3 as @a[team=tspire_party] run loot give @s loot tspire:mob_gear/weapon_f3

# 【v0.6.26 新增机制】宝箱节点同时恢复 20% 生命（每人各自结算，见 map/chest_heal）
function tspire:util/roll_d6
scoreboard players add @a[team=tspire_party] tspire_gold 14
scoreboard players operation @a[team=tspire_party] tspire_gold += #ROLL tspire_timer
tellraw @a[team=tspire_party] [{"text":"[宝箱节点] ","color":"gold"},{"text":"额外金币 15~20。","color":"yellow"}]
# v0.7.12 BUG FIX（玩家反馈"没给强化水晶却发了给水晶的消息"）：
#   `execute if predicate` **每执行一次就重新掷一次**，原来发放与消息各自掷了两颗骰子，
#   两次结果互相独立 -> 消息和实际发放对不上（还有反过来的"悄悄给了但没提示"）。
#   现在**只掷一次**把结果记进 #CHEST_CRY，发放与消息都读它。
scoreboard players set #CHEST_CRY tspire_timer 0
execute if predicate tspire:roll/d2 unless predicate tspire:roll/d10 run scoreboard players set #CHEST_CRY tspire_timer 1
execute if score #CHEST_CRY tspire_timer matches 1 as @a[team=tspire_party] run loot give @s loot tspire:rewards/crystal
execute if score #CHEST_CRY tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"[宝箱节点] ","color":"light_purple"},{"text":"额外开出一枚强化水晶！（45%）","color":"aqua"}]
execute as @a[team=tspire_party] run function tspire:map/chest_heal

tellraw @a[team=tspire_party] [{"text":"[宝箱节点] ","color":"gold"},{"text":"获得一件匠魂装备。","color":"white"},{"text":"（并恢复 20% 生命）","color":"green"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.item.pickup master @s ~ ~ ~ 0.8 1
function tspire:map/complete_node
