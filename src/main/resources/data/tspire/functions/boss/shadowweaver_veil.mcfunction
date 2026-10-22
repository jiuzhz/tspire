# ============================================================
# 织影巫师【暗影帷幕】· HP ≤ 200 时每 20 秒（v0.6.52 重做，玩家指定）
# ============================================================
# 玩家要求（按顺序）：
#   1) 给予**所有玩家 3 秒失明**；
#   2) 把 Boss **随机传送**到场地内的一个位置；
#   3) 在**原位置**生成 1 只 **5 点血**的恼鬼（与【唤鬼】同标签 `tspire_mob`）；
#   4) 自身获得 **5 秒隐身**；
#   5) 隐身结束后给自身 **2 秒发光**（由 boss/shadowweaver_glow 收尾）。
#
# ⚠️ "不要把 Boss 传送到场地外"：不用随机坐标，而是**以房间中心为原点**，
#   掷"方向 0..7 + 距离（3 或 6）"来偏移 —— 房间半径 7、最大偏移 6，
#   所以落点**一定在房间内**（与【泥沼】/【钉刺陷阱】同一套安全选点法）。
# ============================================================

scoreboard players set #WEA_C2 tspire_timer 0

# --- 1) 先在原位置放一只 5 点血的恼鬼（必须在传送之前）---
execute at @e[tag=tspire_boss_shadowweaver,limit=1] run summon minecraft:vex ~ ~ ~ {Tags:["tspire_mob"],PersistenceRequired:1b,Health:5f,Attributes:[{Name:"minecraft:generic.max_health",Base:5}]}
execute at @e[tag=tspire_boss_shadowweaver,limit=1] run particle minecraft:squid_ink ~ ~1 ~ 1 1 1 0.1 40 force
execute at @e[tag=tspire_boss_shadowweaver,limit=1] run particle minecraft:sculk_soul ~ ~1 ~ 2 1 2 0.04 55 force
execute at @e[tag=tspire_boss_shadowweaver,limit=1] run particle minecraft:smoke ~ ~1 ~ 1 0.8 1 0.05 30 force

# --- 2) 所有玩家 3 秒失明 ---
effect give @a[team=tspire_party,scores={tspire_dead=0}] minecraft:blindness 3 0 true
title @a[team=tspire_party] title {"text":"暗影帷幕！","color":"dark_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"失明 3 秒 —— 它钻进阴影里了","color":"gray"}

# --- 3) 随机传送（方向 0..7 均匀 + 距离 3 或 6）---
scoreboard players set #WEA_K tspire_timer 0
execute if score #WEA_K tspire_timer matches 0 if predicate tspire:roll/d8 run scoreboard players set #WEA_K tspire_timer 7
execute if score #WEA_K tspire_timer matches 0 if predicate tspire:roll/d7 run scoreboard players set #WEA_K tspire_timer 6
execute if score #WEA_K tspire_timer matches 0 if predicate tspire:roll/d6 run scoreboard players set #WEA_K tspire_timer 5
execute if score #WEA_K tspire_timer matches 0 if predicate tspire:roll/d5 run scoreboard players set #WEA_K tspire_timer 4
execute if score #WEA_K tspire_timer matches 0 if predicate tspire:roll/d4 run scoreboard players set #WEA_K tspire_timer 3
execute if score #WEA_K tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #WEA_K tspire_timer 2
execute if score #WEA_K tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #WEA_K tspire_timer 1
scoreboard players set #WEA_D tspire_timer 3
execute if predicate tspire:roll/d2 run scoreboard players set #WEA_D tspire_timer 6

# 方向 0..7 × 距离 3/6 → 以房间中心为原点的偏移（半径 7 的房间里绝对安全）
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 0 if score #WEA_D tspire_timer matches 3 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~3 ~ ~
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 0 if score #WEA_D tspire_timer matches 6 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~6 ~ ~
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 2 if score #WEA_D tspire_timer matches 3 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~ ~ ~3
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 2 if score #WEA_D tspire_timer matches 6 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~ ~ ~6
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 4 if score #WEA_D tspire_timer matches 3 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~-3 ~ ~
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 4 if score #WEA_D tspire_timer matches 6 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~-6 ~ ~
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 6 if score #WEA_D tspire_timer matches 3 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~ ~ ~-3
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 6 if score #WEA_D tspire_timer matches 6 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~ ~ ~-6
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 1 if score #WEA_D tspire_timer matches 3 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~2.1 ~ ~2.1
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 1 if score #WEA_D tspire_timer matches 6 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~4.2 ~ ~4.2
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 3 if score #WEA_D tspire_timer matches 3 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~-2.1 ~ ~2.1
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 3 if score #WEA_D tspire_timer matches 6 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~-4.2 ~ ~4.2
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 5 if score #WEA_D tspire_timer matches 3 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~-2.1 ~ ~-2.1
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 5 if score #WEA_D tspire_timer matches 6 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~-4.2 ~ ~-4.2
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 7 if score #WEA_D tspire_timer matches 3 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~2.1 ~ ~-2.1
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] if score #WEA_K tspire_timer matches 7 if score #WEA_D tspire_timer matches 6 run tp @e[tag=tspire_boss_shadowweaver,limit=1] ~4.2 ~ ~-4.2

# --- 4) 自身 5 秒隐身 ---
effect give @e[tag=tspire_boss_shadowweaver,limit=1] minecraft:invisibility 5 0 true
# --- 5) 预约"隐身结束后 2 秒发光"：101 = 100 tick 隐身 + 1 tick 余量 ---
scoreboard players set #WEA_GLOW tspire_timer 101

# --- 表现与提示 ---
execute at @e[tag=tspire_boss_shadowweaver,limit=1] run particle minecraft:smoke ~ ~1 ~ 1.5 1 1.5 0.05 60 force
execute at @e[tag=tspire_boss_shadowweaver,limit=1] run particle minecraft:sculk_soul ~ ~1 ~ 1.5 1 1.5 0.03 30 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.evoker.cast_spell master @s ~ ~ ~ 1.3 0.5
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.vex.ambient master @s ~ ~ ~ 1.2 0.6
tellraw @a[team=tspire_party] [{"text":"[织影巫师] ","color":"dark_purple","bold":true},{"text":"暗影帷幕！","color":"gold","bold":true},{"text":"全场失明 3 秒；它在原位置留了一只 5 血恼鬼，自己隐身 5 秒钻到场地另一处（隐身结束后会发光 2 秒）。","color":"yellow"}]
