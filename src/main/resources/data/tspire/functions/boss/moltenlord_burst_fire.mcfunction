# 【熔核爆发】· 15 秒过载期间每 tick：
#   每 40 tick（2 秒）为一波：先在每名玩家脚下放"预警"标记（粒子），
#   再用 5 段标签（fz1→fz5，每段 20 tick）让火焰存活 5 秒并逐秒结算伤害。
#   标签链就是"每个区域自己的年龄"—— 1.20.1 没有宏，标记实体又不能自增计数器。
#
# 【v0.7.20 修复】★"15 秒过后技能永不结束、BOSS 一直被钉在场地中心"的真 bug：
#   原来只有 #MLZ2_T 一个计数器，而波次每 40 tick 就把它**清零**（`set #MLZ2_T 0`）——
#   于是它永远在 1..40 之间循环，文件末尾那句 `#MLZ2_T matches 300..` 是**死代码**。
#   技能因此永不收摊：缓慢 10 每 2 秒重刷、把自己钉在中心，冷却也永远不重新计。
#   现在拆成两个计数器：
#     #MLZ2_W = **波内计时**（1..40；波次推进与"每 2 秒 1 点伤害"都看它）
#     #MLZ2_T = **技能总时长**（1..300；只有它决定收摊）
scoreboard players add #MLZ2_T tspire_timer 1
scoreboard players add #MLZ2_W tspire_timer 1

# 【v0.7.25 补音效】每波开头一声"喷发"（firecharge 起爆 + 一声闷响）——
#   波内第 1 tick 触发，15 秒里共 8 次，音量压低免得吵
execute if score #MLZ2_W tspire_timer matches 1 as @a[team=tspire_party] at @s run playsound minecraft:item.firecharge.use master @s ~ ~ ~ 1.1 0.8
execute if score #MLZ2_W tspire_timer matches 1 as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.shoot master @s ~ ~ ~ 0.7 0.6

# --- 每 2 秒一波 ---
# v0.6.58（玩家要求）：改用**真火焰方块**，并靠标签接力按时清理：
#   · fz1 = 预警（只有粒子，还没有火）
#   · fz2 / fz3 / fz4 = 燃烧中，每波都会补一次 `fill … fire keep`
#   · 晋升到 fz5 之前先把这一片的火清掉，然后 kill —— 火焰因此正好存活约 5 秒。
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz5] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:air replace minecraft:fire
# 先把上一波的 5 段全部推进一格，再在玩家脚下放新的 fz1 ---
execute if score #MLZ2_W tspire_timer matches 40 run kill @e[tag=tspire_fz5]
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz4] run tag @s add tspire_fz5
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz5,tag=tspire_fz4] run tag @s remove tspire_fz4
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz3] run tag @s add tspire_fz4
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz4,tag=tspire_fz3] run tag @s remove tspire_fz3
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz2] run tag @s add tspire_fz3
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz3,tag=tspire_fz2] run tag @s remove tspire_fz2
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz1] run tag @s add tspire_fz2
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz2,tag=tspire_fz1] run tag @s remove tspire_fz1
execute if score #MLZ2_W tspire_timer matches 40 as @a[team=tspire_party,scores={tspire_dead=0}] at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_fz1"]}
# 补火：燃烧中的三段每波都刷新一次（keep = 只填空气，不覆盖地板）
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz2] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:fire keep
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz3] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:fire keep
execute if score #MLZ2_W tspire_timer matches 40 as @e[tag=tspire_fz4] at @s run fill ~-1 ~ ~-1 ~1 ~ ~1 minecraft:fire keep
# v0.7.19：过载期间把它**钉在场地中心**（每 2 秒重刷缓慢 10 + 重新对位），
#   保证 15 秒都待在中央，而不是飘到墙角去。
execute if score #MLZ2_W tspire_timer matches 40 run effect give @e[tag=tspire_boss_moltenlord,limit=1] minecraft:slowness 3 9 true
execute if score #MLZ2_W tspire_timer matches 40 in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run tp @e[tag=tspire_boss_moltenlord,limit=1] ~ ~1 ~
# 注意：这里只清**波内**计时器；总时长 #MLZ2_T 必须继续往上数，否则收摊那一句永远到不了
execute if score #MLZ2_W tspire_timer matches 40 run scoreboard players set #MLZ2_W tspire_timer 0

# --- 预警与火焰粒子：fz1 是预警（1 秒），fz2 起是真火焰 ---
execute as @e[tag=tspire_fz1] at @s run particle minecraft:enchanted_hit ~ ~0.2 ~ 1.4 0.05 1.4 0.05 25 force
execute as @e[tag=tspire_fz1] at @s run particle minecraft:crit ~ ~0.2 ~ 1.2 0.05 1.2 0.05 15 force
execute as @e[tag=tspire_fz2] at @s run particle minecraft:flame ~1.5 ~0.2 ~ 0 0 0 0 2 force
execute as @e[tag=tspire_fz2] at @s run particle minecraft:flame ~-1.5 ~0.2 ~ 0 0 0 0 2 force
execute as @e[tag=tspire_fz2] at @s run particle minecraft:flame ~ ~0.2 ~1.5 0 0 0 0 2 force
execute as @e[tag=tspire_fz2] at @s run particle minecraft:flame ~ ~0.2 ~-1.5 0 0 0 0 2 force
execute as @e[tag=tspire_fz2] at @s run particle minecraft:lava ~ ~0.1 ~ 1 0.05 1 0.02 4 force
execute as @e[tag=tspire_fz3] at @s run particle minecraft:flame ~1.5 ~0.2 ~ 0 0 0 0 2 force
execute as @e[tag=tspire_fz3] at @s run particle minecraft:flame ~-1.5 ~0.2 ~ 0 0 0 0 2 force
execute as @e[tag=tspire_fz3] at @s run particle minecraft:flame ~ ~0.2 ~1.5 0 0 0 0 2 force
execute as @e[tag=tspire_fz3] at @s run particle minecraft:flame ~ ~0.2 ~-1.5 0 0 0 0 2 force
execute as @e[tag=tspire_fz4] at @s run particle minecraft:flame ~1.5 ~0.2 ~ 0 0 0 0 2 force
execute as @e[tag=tspire_fz4] at @s run particle minecraft:flame ~-1.5 ~0.2 ~ 0 0 0 0 2 force
execute as @e[tag=tspire_fz4] at @s run particle minecraft:flame ~ ~0.2 ~1.5 0 0 0 0 2 force
execute as @e[tag=tspire_fz4] at @s run particle minecraft:flame ~ ~0.2 ~-1.5 0 0 0 0 2 force
execute as @e[tag=tspire_fz5] at @s run particle minecraft:large_smoke ~ ~0.3 ~ 1 0.2 1 0.03 12 force

# --- 伤害：站在真火焰（fz2..fz5）里每 20 tick（波内第 20 tick）吃 1 点 ---
execute if score #MLZ2_W tspire_timer matches 20 as @e[tag=tspire_fz2] at @s as @a[team=tspire_party,distance=..1.7] run damage @s 1 minecraft:in_fire
execute if score #MLZ2_W tspire_timer matches 20 as @e[tag=tspire_fz3] at @s as @a[team=tspire_party,distance=..1.7] run damage @s 1 minecraft:in_fire
execute if score #MLZ2_W tspire_timer matches 20 as @e[tag=tspire_fz4] at @s as @a[team=tspire_party,distance=..1.7] run damage @s 1 minecraft:in_fire
execute if score #MLZ2_W tspire_timer matches 20 as @e[tag=tspire_fz5] at @s as @a[team=tspire_party,distance=..1.7] run damage @s 1 minecraft:in_fire

# --- 15 秒（300 tick）到点：收摊（只看总时长计时器）---
execute if score #MLZ2_T tspire_timer matches 300.. run function tspire:boss/moltenlord_burst_end
