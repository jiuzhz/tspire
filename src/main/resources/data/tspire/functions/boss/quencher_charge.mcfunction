# ============================================================
# 淬火者【燃烧蓄能】—— 发动（v0.6.30 新机制）
# ============================================================
# 玩家要求：
#   每 10 秒，以**玩家当前所在位置**为圆心（只判定一次，之后不再跟随），
#   5 格范围内先有明显粒子标注，2 秒前摇后产生火焰并让范围内玩家燃烧 3 秒。
#
# 实现要点：
#   · 位置只取一次：发动瞬间在最近队友脚下放一个 tspire_firez marker，
#     之后整个技能都围绕这个 marker，玩家跑开也不会跟着走。
#   · 前摇 40 tick（2 秒）画粒子圈（见 boss/ring5 + boss/quencher_zone）。
#   · 燃烧阶段 60 tick：**纯粒子版**（不铺火焰方块，避免烧掉落物）
#     两秒前摇结束后每 20 tick 给圈内玩家 1 点 in_fire 伤害；
#     结束只销毁圆心 marker。
#
# 由 boss/tick 每 tick 计数 #QUENCH_CD 触发（10 秒 = 200 tick），执行者不限。
# ============================================================

scoreboard players set #QUENCH_CD tspire_timer 0
scoreboard players set #QZ tspire_timer 1
scoreboard players set #QZ_T tspire_timer 0

# 【v0.6.31】**每名玩家脚下各生成一个**（不再只锁一名玩家）：
#   有多少人就有多少个圆心 marker，后面的状态机对每个 marker 都跑一遍。
# 【v0.6.43】排除阵亡/旁观的队友（`tspire_dead=1`）：他们仍然在 tspire_party 队伍里，
#   会在**旁观视角所在的位置**留下一个火圈，看着像"没人也着火"，
#   而且如果活着的队友正好站在那里就会莫名挨烧。只给活着的队友布圆心。
execute in tspire:tower run kill @e[tag=tspire_firez]
execute in tspire:tower as @a[team=tspire_party,scores={tspire_dead=0},nbt={Dimension:"tspire:tower"}] at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_firez"]}

title @a[team=tspire_party] title {"text":"燃烧蓄能","color":"red","bold":true}
title @a[team=tspire_party] subtitle {"text":"脚下的 5 格范围即将燃起 —— 快离开！","color":"yellow"}
tellraw @a[team=tspire_party] [{"text":"[淬火者] ","color":"red","bold":true},{"text":"燃烧蓄能！","color":"gold","bold":true},{"text":"2 秒后你**当时站立的位置**周围 5 格会燃起火焰，燃烧 3 秒。","color":"yellow"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.charge master @s ~ ~ ~ 1 0.8
