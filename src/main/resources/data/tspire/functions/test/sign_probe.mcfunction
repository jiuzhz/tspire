# ============================================================
# 告示牌诊断（v0.7.42）
# ============================================================
# 用法：站在**工匠节点房间里**执行
#   /function tspire:test/sign_probe
#
# 这一版额外回答两个问题：
#   1) 牌子是**墙牌**（oak_wall_sign）还是**立牌**（oak_sign）？
#      —— 装饰铺的是墙牌；如果是立牌，说明这块牌子来自**旧版本装饰**，新装饰没跑过。
#   2) "每次进房重写告示牌"那条到底执行过几次？（#SIGN_RUN 计数）
# ============================================================

tellraw @s [{"text":"===== 告示牌诊断 v2 =====","color":"gold","bold":true}]

# 0) 统计与计数
scoreboard players set #SP_CNT tspire_timer 0
execute as @e[tag=tspire_type_artisan,distance=..30] run scoreboard players add #SP_CNT tspire_timer 1
tellraw @s [{"text":"30 格内工匠节点 = ","color":"gray"},{"score":{"name":"#SP_CNT","objective":"tspire_timer"},"color":"yellow"},{"text":"   「进房重写告示牌」执行次数 = ","color":"gray"},{"score":{"name":"#SIGN_RUN","objective":"tspire_timer"},"color":"aqua"},{"text":"（0 = 那条根本没跑过）","color":"dark_gray"}]

# 1) 牌子 A 的**方块类型**（墙牌 / 立牌）
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-6 ~1 ~0 minecraft:oak_wall_sign tellraw @s [{"text":"牌子A 方块 = ","color":"yellow"},{"text":"oak_wall_sign（墙牌，新装饰）","color":"green"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-6 ~1 ~0 minecraft:run tellraw @s [{"text":"牌子A 方块 = ","color":"yellow"},{"text":"oak_wall_sign（墙牌，新装饰）","color":"green"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-6 ~1 ~0 minecraft:oak_sign tellraw @s [{"text":"牌子A 方块 = ","color":"yellow"},{"text":"oak_sign（**立牌** → 旧装饰没被替换）","color":"red"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-6 ~1 ~0 minecraft:run tellraw @s [{"text":"牌子A 方块 = ","color":"yellow"},{"text":"oak_sign（**立牌** → 旧装饰没被替换）","color":"red"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] unless block ~-6 ~1 ~0 minecraft:oak_wall_sign block ~-6 ~1 ~0 minecraft:oak_sign run tellraw @s [{"text":"牌子A 方块 = 既不是墙牌也不是立牌（是别的方块/空气）","color":"red"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] unless block ~-6 ~1 ~0 minecraft:unless block ~-6 ~1 ~0 minecraft:oak_sign run tellraw @s [{"text":"牌子A 方块 = 既不是墙牌也不是立牌（是别的方块/空气）","color":"red"}]
# 背后支撑（墙牌必须贴在这块上）
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-7 ~1 ~0 tconstruct:seared_bricks run tellraw @s [{"text":"   背后支撑 = tconstruct:seared_bricks ✓（墙牌贴得住）","color":"gray"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] unless block ~-7 ~1 ~0 tconstruct:seared_bricks run tellraw @s [{"text":"   背后支撑 = **不是**焦黑砖（墙牌会掉）","color":"red"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] run tellraw @s [{"text":"   正面文字 = ","color":"yellow"},{"nbt":"front_text.messages","block":"~-6 ~1 ~0","color":"white"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] run tellraw @s [{"text":"   背面文字 = ","color":"dark_gray"},{"nbt":"back_text.messages","block":"~-6 ~1 ~0","color":"dark_gray"}]

# 2) 牌子 B
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-6 ~1 ~4 minecraft:spruce_wall_sign tellraw @s [{"text":"牌子B 方块 = ","color":"yellow"},{"text":"spruce_wall_sign（墙牌，新装饰）","color":"green"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-6 ~1 ~4 minecraft:run tellraw @s [{"text":"牌子B 方块 = ","color":"yellow"},{"text":"spruce_wall_sign（墙牌，新装饰）","color":"green"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-6 ~1 ~4 minecraft:spruce_sign tellraw @s [{"text":"牌子B 方块 = ","color":"yellow"},{"text":"spruce_sign（**立牌** → 旧装饰）","color":"red"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] if block ~-6 ~1 ~4 minecraft:run tellraw @s [{"text":"牌子B 方块 = ","color":"yellow"},{"text":"spruce_sign（**立牌** → 旧装饰）","color":"red"}]
execute at @e[tag=tspire_type_artisan,limit=1,sort=nearest] run tellraw @s [{"text":"   正面文字 = ","color":"yellow"},{"nbt":"front_text.messages","block":"~-6 ~1 ~4","color":"white"}]

tellraw @s [{"text":"怎么读：① 若「进房重写次数」= 0 → 那条接线没跑到；② 若牌子是**立牌** → 装饰是旧版本，需要开新一局或重进该层；③ 若牌子=墙牌但文字空 → setblock 的 NBT 确实没生效，我换写法。","color":"gray"}]