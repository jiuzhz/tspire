# 塔维度内的每 tick 逻辑（由 tspire:tick 用 execute in 调用）
# 单独拆出来是为了让所有实体选择器都跑在塔维度里 —— 否则 @e 会去主世界找

# 岩浆怪分裂体一出生就加入本场敌人；必须在每 tick 胜利判定之前执行。
execute if score #BATTLE_ACTIVE tspire_timer matches 1 at @e[tag=tspire_node_current,limit=1] as @e[type=minecraft:magma_cube,distance=..18,tag=!tspire_mob] run tag @s add tspire_mob
execute if score #BATTLE_ACTIVE tspire_timer matches 1 run function tspire:run/battle_tick
execute if score #BATTLE_ACTIVE tspire_timer matches 1 if entity @e[tag=tspire_boss] run function tspire:boss/tick

# 【v0.7.4】BOSS 单挑的分两拍建场（#ARENA 1..2）
execute if score #ARENA tspire_timer matches 1.. run function tspire:test/arena_tick

# 【v0.7 神秘事件门禁】全队都做出选择后才放行（放在这里 = 每 tick 只跑一次，不随人数重复）
execute if score #MYST_ACTIVE tspire_timer matches 1 run function tspire:mystery/tick

# v0.6.52（玩家要求）：BOSS 一死，就把它召唤出来的怪物一起清掉。
#   只在"这一场是 BOSS 房、且场上已经没有 tspire_boss"时生效 —— 普通战斗房不受影响。
#   清掉之后 run/battle_tick 的"全灭"判定（unless entity @e[tag=tspire_mob]）会在同一 tick 成立，
#   胜利与奖励照常发放。（没有这一段时，Boss 召的小怪会一直拖着不判胜。）
execute if score #BATTLE_ACTIVE tspire_timer matches 1 if entity @e[tag=tspire_node_current,tag=tspire_type_boss] unless entity @e[tag=tspire_boss] run kill @e[tag=tspire_mob]

# 三选一宝箱：自 v0.6.18 起箱子是 Lock 的，玩家打不开，只能点聊天菜单领取，
# 所以这里不再需要"箱子空了就收摊"的每 tick 检查（那条判定本身也不可靠）。
