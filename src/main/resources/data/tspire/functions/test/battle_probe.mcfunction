# ============================================================
# 战斗探针（v0.7.61）—— 下次出现"怪物节点没出怪"时，站进那个房间执行：
#   /function tspire:test/battle_probe
# 它会打印：战斗是否激活、计时器、本场是否见过怪、场上还剩几只、以及节点类型。
# ============================================================
tellraw @s [{"text":"===== 战斗探针 =====","color":"gold","bold":true}]
tellraw @s [{"text":"#BATTLE_ACTIVE = ","color":"gray"},{"score":{"name":"#BATTLE_ACTIVE","objective":"tspire_timer"},"color":"yellow"},{"text":"（1=这场还在打）","color":"dark_gray"}]
tellraw @s [{"text":"#BATTLE_TIMER  = ","color":"gray"},{"score":{"name":"#BATTLE_TIMER","objective":"tspire_timer"},"color":"yellow"},{"text":"（20 tick = 1 秒宽限；400 = 空房兜底）","color":"dark_gray"}]
tellraw @s [{"text":"#BATTLE_SEEN   = ","color":"gray"},{"score":{"name":"#BATTLE_SEEN","objective":"tspire_timer"},"color":"yellow"},{"text":"（0 = 本场一只怪都没出现过）","color":"dark_gray"}]
tellraw @s [{"text":"#BATTLE 序号   = ","color":"gray"},{"score":{"name":"#BATTLE","objective":"tspire_timer"},"color":"yellow"},{"text":"（1、2 = 简单池；3 起 = 困难池）","color":"dark_gray"}]
tellraw @s [{"text":"#FLOOR         = ","color":"gray"},{"score":{"name":"#FLOOR","objective":"tspire_timer"},"color":"yellow"}]

# 场上还剩几只 mob / 各类数量
scoreboard players set #BP_MOB tspire_timer 0
execute as @e[tag=tspire_mob] run scoreboard players add #BP_MOB tspire_timer 1
scoreboard players set #BP_ITEM tspire_timer 0
execute in tspire:tower run scoreboard players set #BP_ITEM tspire_timer 0
tellraw @s [{"text":"场上 tspire_mob 数量 = ","color":"gray"},{"score":{"name":"#BP_MOB","objective":"tspire_timer"},"color":"yellow"},{"text":"（0 且 #BATTLE_SEEN=1 → 怪生成了但已经死光，属正常胜利）","color":"dark_gray"}]

# 当前节点类型（战斗 / 精英 / BOSS）
tellraw @s [{"text":"当前节点标签：","color":"gray"},{"selector":"@e[tag=tspire_node_current,limit=1]","color":"aqua"}]
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite] run tellraw @s [{"text":"  → 这是一个【精英节点】","color":"red"}]
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] run tellraw @s [{"text":"  → 这是一个【BOSS 节点】","color":"red"}]
execute unless entity @e[tag=tspire_node_current,tag=tspire_type_elite] unless entity @e[tag=tspire_node_current,tag=tspire_type_boss] run tellraw @s [{"text":"  → 普通战斗节点","color":"gray"}]

# 最近的怪离你多远（判断是不是"生成在墙里/地下"）
tellraw @s [{"text":"最近一只 tspire_mob 的坐标：","color":"gray"},{"nbt":"Pos","entity":"@e[tag=tspire_mob,limit=1,sort=nearest]","color":"white"}]
tellraw @s [{"text":"判读：① #BATTLE_SEEN=0 且没怪 → 根本没生成（看上一条报错/上限）；② 有怪但位置很低或在墙里 → 生成点有问题；③ 怪已死光 → 正常。","color":"gray"}]

# ===== v0.7.64 追加：出怪上限与配置（定位"没出怪"的关键两项） =====
tellraw @s [{"text":"--- 出怪上限 ---","color":"gold"}]
tellraw @s [{"text":"#PARTY_SIZE = ","color":"gray"},{"score":{"name":"#PARTY_SIZE","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"#CFG_MOB_CAP_BASE = ","color":"gray"},{"score":{"name":"#CFG_MOB_CAP_BASE","objective":"tspire_config"},"color":"yellow"},{"text":"（配置缺失会是 0/空）","color":"dark_gray"}]
tellraw @s [{"text":"#CFG_MOB_CAP_PER_PLAYER = ","color":"gray"},{"score":{"name":"#CFG_MOB_CAP_PER_PLAYER","objective":"tspire_config"},"color":"yellow"}]
tellraw @s [{"text":"#MOB_CAP（算出来） = ","color":"gray"},{"score":{"name":"#MOB_CAP","objective":"tspire_timer"},"color":"aqua"},{"text":"   #MOB_COUNT（场上） = ","color":"gray"},{"score":{"name":"#MOB_COUNT","objective":"tspire_timer"},"color":"aqua"}]
tellraw @s [{"text":"判读：#MOB_CAP = 0 → 配置项没读到（出怪必然不出）；#MOB_COUNT ≥ #MOB_CAP → 被上限拦住。两者都正常却仍无怪 → 是 roll_group 抽到的编队函数缺失。","color":"gray"}]

# 手动重算一次（顺手修：把配置读一遍再算上限，方便比对）
function tspire:mobs/cap
tellraw @s [{"text":"（已重算一次）现在 #MOB_CAP = ","color":"gray"},{"score":{"name":"#MOB_CAP","objective":"tspire_timer"},"color":"aqua"},{"text":"   #MOB_COUNT = ","color":"gray"},{"score":{"name":"#MOB_COUNT","objective":"tspire_timer"},"color":"aqua"}]

# ===== v0.7.67 追加：本场抽中的怪池与组号 =====
tellraw @s [{"text":"--- 本场抽中的怪池 ---","color":"gold"}]
tellraw @s [{"text":"#POOL = ","color":"gray"},{"score":{"name":"#POOL","objective":"tspire_timer"},"color":"yellow"},{"text":"（0=简单池 1=困难池）","color":"dark_gray"}]
tellraw @s [{"text":"#ELITE = ","color":"gray"},{"score":{"name":"#ELITE","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"#LAST_POOL = ","color":"gray"},{"score":{"name":"#LAST_POOL","objective":"tspire_timer"},"color":"aqua"},{"text":"（0=简单 1=困难，出怪时写入）","color":"dark_gray"}]
tellraw @s [{"text":"#LAST_GRP  = ","color":"gray"},{"score":{"name":"#LAST_GRP","objective":"tspire_timer"},"color":"aqua"},{"text":"（组号数字；e 组记 1、h 组记 2）","color":"dark_gray"}]
tellraw @s [{"text":"#LAST_TAG  = ","color":"gray"},{"score":{"name":"#LAST_TAG","objective":"tspire_timer"},"color":"aqua"}]
tellraw @s [{"text":"例：#LAST_POOL=1 且 #LAST_GRP=6 → 本场抽中的是 floor<#FLOOR>_hard/h6","color":"gray"}]