# ============================================================
# Boss 单挑 · 自检（v0.7.2 改版：检查**真实 BOSS 房**）
# ============================================================
# 玩家反馈"用测试指令被传进构筑间、还摔死了"。这条指令把关键状态打出来，
# 一眼能看出是哪一环断了。建筑本体现在是真实 BOSS 房（节点 z=-390），
# 所以检查项也换成了真实房间的地砖/空气与真实节点。
# 用法：/function tspire:test/boss_arena_check
# ============================================================

tellraw @s [{"text":"========== BOSS 房自检 ==========","color":"gold","bold":true}]

# 1) 大厅地板（0 63 10）：整层建过才会有
execute in tspire:tower if block 0 63 10 minecraft:polished_andesite tellraw @s [{"text":"[ok] 大厅地板存在（0 63 10）—— 这一层建出来了","color":"green"}]
execute in tspire:tower if block 0 63 10 minecraft:run tellraw @s [{"text":"[ok] 大厅地板存在（0 63 10）—— 这一层建出来了","color":"green"}]
execute in tspire:tower unless block 0 63 10 minecraft:polished_andesite tellraw @s [{"text":"[!!] 大厅地板缺失 —— 这一层没建（先点下面的按钮重建）","color":"red"}]
execute in tspire:tower unless block 0 63 10 minecraft:run tellraw @s [{"text":"[!!] 大厅地板缺失 —— 这一层没建（先点下面的按钮重建）","color":"red"}]

# 2) 真实 BOSS 房：节点地砖是黑混凝土（预设画的），房间内部是空气
#    节点 y = 64 / 96 / 128 -> 地砖在 y-1 = 63 / 95 / 127
execute if score #FLOOR tspire_timer matches ..1 in tspire:tower if block 0 63 -390 minecraft:black_concrete tellraw @s [{"text":"[ok] 第 1 层 BOSS 节点地砖存在（0 63 -390）","color":"green"}]
execute if score #FLOOR tspire_timer matches ..1 in tspire:tower if block 0 63 -390 minecraft:run tellraw @s [{"text":"[ok] 第 1 层 BOSS 节点地砖存在（0 63 -390）","color":"green"}]
execute if score #FLOOR tspire_timer matches 2 in tspire:tower if block 0 95 -390 minecraft:black_concrete tellraw @s [{"text":"[ok] 第 2 层 BOSS 节点地砖存在（0 95 -390）","color":"green"}]
execute if score #FLOOR tspire_timer matches 2 in tspire:tower if block 0 95 -390 minecraft:run tellraw @s [{"text":"[ok] 第 2 层 BOSS 节点地砖存在（0 95 -390）","color":"green"}]
execute if score #FLOOR tspire_timer matches 3.. in tspire:tower if block 0 127 -390 minecraft:black_concrete tellraw @s [{"text":"[ok] 第 3 层 BOSS 节点地砖存在（0 127 -390）","color":"green"}]
execute if score #FLOOR tspire_timer matches 3.. in tspire:tower if block 0 127 -390 minecraft:run tellraw @s [{"text":"[ok] 第 3 层 BOSS 节点地砖存在（0 127 -390）","color":"green"}]
execute if score #FLOOR tspire_timer matches ..1 in tspire:tower if block 0 64 -390 minecraft:air tellraw @s [{"text":"[ok] BOSS 房内部已挖空（0 64 -390）","color":"green"}]
execute if score #FLOOR tspire_timer matches ..1 in tspire:tower if block 0 64 -390 minecraft:run tellraw @s [{"text":"[ok] BOSS 房内部已挖空（0 64 -390）","color":"green"}]
execute if score #FLOOR tspire_timer matches ..1 in tspire:tower unless block 0 64 -390 minecraft:air tellraw @s [{"text":"[!!] BOSS 房内部不是空气 —— room_boss 没跑到（build_floor 的 fill 可能因区块没加载而静默失败）","color":"red"}]
execute if score #FLOOR tspire_timer matches ..1 in tspire:tower unless block 0 64 -390 minecraft:run tellraw @s [{"text":"[!!] BOSS 房内部不是空气 —— room_boss 没跑到（build_floor 的 fill 可能因区块没加载而静默失败）","color":"red"}]

# 3) 真实 BOSS 节点 marker 与战斗开关
execute in tspire:tower if entity @e[tag=tspire_test_node] run tellraw @s [{"text":"[ok] 当前节点 marker 存在（真实 BOSS 节点已标为当前）","color":"green"}]
execute in tspire:tower unless entity @e[tag=tspire_test_node] run tellraw @s [{"text":"[!!] 没有当前节点 marker —— Boss 机制（灰烬重生/泥沼现身…）找不到原点，先点下面的按钮","color":"red"}]
tellraw @s [{"text":"战斗开关 #BATTLE_ACTIVE=","color":"gray"},{"score":{"name":"#BATTLE_ACTIVE","objective":"tspire_timer"},"color":"yellow"},{"text":"  #PARTY_SIZE=","color":"gray"},{"score":{"name":"#PARTY_SIZE","objective":"tspire_timer"},"color":"yellow"},{"text":"  #FLOOR=","color":"gray"},{"score":{"name":"#FLOOR","objective":"tspire_timer"},"color":"yellow"}]

# 4) 一键修：重建真实楼层与 BOSS 房（不生成 Boss）
tellraw @s [{"text":"  点这里重建真实 BOSS 房：","color":"gray"},{"text":"/function tspire:test/boss_arena_rebuild","color":"yellow","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_arena_rebuild"},"hoverEvent":{"action":"show_text","contents":"按当前 #FLOOR 重建整层（含真实 BOSS 房）、把真实节点标为当前、全队传送进房间（不生成 Boss）"}}]