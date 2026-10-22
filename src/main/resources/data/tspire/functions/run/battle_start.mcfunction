# ============================================================
# 开始一场战斗
# 前置：#FLOOR 已设好（1..3），玩家在竞技场里
# 副作用：#BATTLE +1、#BATTLE_ACTIVE=1
# ============================================================

# 战斗序号 +1（决定简单池 / 困难池，见 §7.4）
scoreboard players add #BATTLE tspire_timer 1
scoreboard players set #BATTLE_ACTIVE tspire_timer 1
scoreboard players set #BATTLE_TIMER tspire_timer 0
# 【v0.7.53】本场是否见过怪的标记（battle_tick 用它拦住「无怪即胜」）
scoreboard players set #BATTLE_SEEN tspire_timer 0

# 【v0.7 赐福 · 战斗之神】战斗开始：30 秒力量；BOSS 战改为力量 II
execute as @a[team=tspire_party,scores={tspire_bless_war=1}] run effect give @s minecraft:strength 30 0 true
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] as @a[team=tspire_party,scores={tspire_bless_war=1}] run effect give @s minecraft:strength 30 1 true

# 封门
function tspire:terrain/lock

# 【v0.6.20 多人修正】把还堵在走廊上的队友拉进竞技场。
#   战斗是"第一个人踏进房间"就开打的（map/player_check），封门只封当前房间，
#   慢一步的队友会被关在门外，整场打不到怪也吃不到奖励。
#   以当前节点为中心：距离 > 8 格（房间半宽 7）就挪到中心北侧 2 格。
# 【v0.6.22 加固】加 tag=!tspire_node_reusable，并且只在 200 格内才拉 ——
#   防止"有一个残留的工匠/商人节点也带着 tspire_node_current"时把人传送回去。
execute as @a[team=tspire_party] at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if entity @s[distance=8..200] run tp @s ~ ~ ~2

# 按当前战斗序号抽组并生成（spawn_batch 内部会先检查实体上限）
# 【v0.6.25】Boss 房间**不刷普通编队**：Boss 自己会召唤小怪（见 boss/active）。
# 【v0.6.28 关键修正】出怪坐标的**原点改成"房间正中"（当前节点 marker）**，不再是玩家。
#   原来 roll_group 是 as 玩家跑的，编队的 ~ 就是玩家脚下 —— 玩家刚踏进触发点
#   （离房间中心 3 格内）怪就已经在脸上，实测"一到触发点就被打一下"。
#   现在以节点中心为原点，编队铺在北半场（z -3/-5/-7），玩家从南门进来至少隔 3~7 格，
#   而且全都在玩家正前方。没有 current 节点时（测试场景）退回原来的玩家原点。
execute unless entity @e[tag=tspire_node_current,tag=tspire_type_boss,limit=1] if entity @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] run function tspire:mobs/spawn_batch
execute unless entity @e[tag=tspire_node_current,tag=tspire_type_boss,limit=1] unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] run function tspire:mobs/spawn_batch
execute unless entity @e[tag=tspire_node_current,tag=tspire_type_boss,limit=1] run function tspire:mystery/pig_bless_apply

title @a[team=tspire_party] actionbar {"text":"战斗开始","color":"red","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ravager.roar master @s ~ ~ ~ 0.7 1
