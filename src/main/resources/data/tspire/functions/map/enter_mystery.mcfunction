# ============================================================
# 神秘节点（v0.7 新增，设计文档 §3.1.1 / §3.5）
# ============================================================
# 玩家规格：进入神秘节点时掷一次
#   15% → 这个房间其实是**商人节点**（直接转交 map/enter_merchant）
#    5% → 这个房间其实是**宝箱节点**（直接转交 map/enter_chest）
#   80% → 触发一个**神秘事件**（从"本层可用的神秘事件池"里均匀抽 1 个）
# 神秘事件里**每人独立选择**，且**全队都做出选择后房间才解锁**（见 mystery/tick）。
# ============================================================

# 标记当前节点（与其它 enter_* 一致：node_begin 已经把同层其余节点锁死）
execute as @e[tag=tspire_node_avail,tag=tspire_type_mystery,distance=..3,limit=1,sort=nearest] run tag @s add tspire_node_current
execute as @e[tag=tspire_node_current] run tag @s remove tspire_node_avail

# 均匀掷 1..20（util/roll_d20）→ 1..2 = 15% 商人 / 4 = 5% 宝箱 / 5..20 = 80% 事件
# v0.7.9：一次神秘节点 = 一次全新的重掷预算（老存档里可能留着上一间的计数）
scoreboard players set #MYST_REROLL tspire_timer 0
scoreboard players set #MYST_REROLL_N tspire_timer 0

function tspire:util/roll_d20
execute if score #ROLL tspire_timer matches 1..2 run function tspire:map/enter_mystery_merchant
execute if score #ROLL tspire_timer matches 3 run function tspire:map/enter_mystery_chest
execute if score #ROLL tspire_timer matches 4..5 run function tspire:map/enter_mystery_combat
execute if score #ROLL tspire_timer matches 6..20 run function tspire:mystery/roll_event