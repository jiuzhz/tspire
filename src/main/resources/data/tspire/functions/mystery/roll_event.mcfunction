# ============================================================
# 神秘事件：抽取（80% 分支，由 map/enter_mystery 调用）
# ============================================================
# **每层可用的事件池（玩家指定，含分层限制）**
#   第 1 层 18 个，第 2 层 19 个，第 3 层 15 个。
# 池内**等概率**：掷 1..N（N = 本层池大小）再按 pick_f<层> 派发。
# 进入事件前：把每个人的选择清零，并打开 #MYST_ACTIVE（门禁在 mystery/tick）。
# ============================================================

scoreboard players set #MYST_ACTIVE tspire_timer 1
kill @e[tag=tspire_event_pig]
scoreboard players set #MYST_EV tspire_timer 0
# 注意：#MYST_REROLL 由 mystery/do_reroll 在取用后立刻清零（一次性请求）；
#       重掷**次数**记在 #MYST_REROLL_N 上，结算时（mystery/finish）一起归零。
scoreboard players set @a[team=tspire_party] tspire_my_choice 0

# 【v0.7 多人保险】把还堵在走廊 / 上一个房间的队友拉进神秘房间。
#   与 run/battle_start 的"拉队友进竞技场"同一套做法：以当前节点为中心，
#   距离 > 8 格（房间半宽 7）就挪到中心北侧 2 格。
#   不做这一步的话，那些队员做不了选择 → mystery/tick 的"全队都选完"永远不成立
#   → 门永远不开，全队卡死在房间里。
execute as @a[team=tspire_party,scores={tspire_dead=0}] at @e[tag=tspire_node_current,limit=1] if entity @s[distance=8..200] run tp @s ~ ~ ~2

# 【v0.7.4 关键修复】**事件开始就把房间封上**（与 run/battle_start 同一套做法）。
#   为什么必须封：神秘房在"全队选完"之前**不会** complete_node，下一行仍是 locked、门是封死的；
#   而本节点是 current，refresh_doors 会把它的**南北门都开着** ——
#   于是玩家（或落后的队友）能在选完之前从北门走出去，走进一条"下一间进不去"的死走廊；
#   更糟的是只要有人还没选，门就永远不会开 → 整局卡死（玩家实测）。
function tspire:terrain/lock

kill @e[tag=tspire_event_draw]
execute if score #FLOOR tspire_timer matches 1 run function tspire:mystery/available_f1
execute if score #FLOOR tspire_timer matches 2 run function tspire:mystery/available_f2
execute if score #FLOOR tspire_timer matches 3 run function tspire:mystery/available_f3
scoreboard players set #ROLL tspire_timer 0
execute if entity @e[tag=tspire_event_draw] store result score #ROLL tspire_timer run scoreboard players get @e[tag=tspire_event_draw,sort=random,limit=1] tspire_brslot
kill @e[tag=tspire_event_draw]

execute if score #FLOOR tspire_timer matches 1 run function tspire:mystery/pick_f1
execute if score #FLOOR tspire_timer matches 2 run function tspire:mystery/pick_f2
execute if score #FLOOR tspire_timer matches 3 run function tspire:mystery/pick_f3
execute if score #MYST_EV tspire_timer matches 0 run function tspire:mystery/ev_quiet
function tspire:mystery/event_cap_count

# v0.7.5（待办 #33）：抽到事件后按 #MYST_EV 摆房间道具（贪婪的箱子 / 赐福的三座雕像…）
# 【v0.7.34 修"共鸣房里出现上一次事件的紫水晶碎片"】
#   进事件先**把整个房间清一遍**：
#     · 方块：整箱 fill 成空气 → 上一次事件留下的道具（`props` 放的紫水晶块/晶簇、箱子、炼药锅…）
#       一律消失；随后 props 摆新道具、deco/mys_apply 再铺玩家手搭的完整装饰
#       （玩家装饰覆盖整个 15×15×6，地板也在内，所以清空不会留下坑）。
#     · 实体：掉落物与经验球。**关键** —— 玩家敲掉紫水晶晶簇掉出来的"紫水晶碎片"是**物品实体**，
#       任何 fill 都清不掉它，所以必须显式 kill。
#   范围用 ±7（房间半宽）与 y -1..4，**不含南北门洞（z ±8/±9）**，所以不会破坏门。
execute at @e[tag=tspire_node_current,limit=1] run fill ~-7 ~-1 ~-7 ~7 ~4 ~7 minecraft:air
execute at @e[tag=tspire_node_current,limit=1] run kill @e[type=minecraft:item,distance=..9]
execute at @e[tag=tspire_node_current,limit=1] run kill @e[type=minecraft:experience_orb,distance=..9]
# 【v0.7.38】实体装饰也要清：盔甲架/展示框（半径 14 才能覆盖被顶到屏障上方的那些）
execute at @e[tag=tspire_node_current,limit=1] run kill @e[type=minecraft:armor_stand,distance=..14]
execute at @e[tag=tspire_node_current,limit=1] run kill @e[type=tconstruct:armor_stand,distance=..14]
execute at @e[tag=tspire_node_current,limit=1] run kill @e[type=minecraft:item_frame,distance=..14]
execute at @e[tag=tspire_node_current,limit=1] run kill @e[type=minecraft:glow_item_frame,distance=..14]

function tspire:mystery/props

# 玩家手搭的神秘事件房装饰（tools/gen-deco.js → deco/mys_*，22 个事件一一对应）。
#   必须放在 props **之后**：props 会先清一遍房间再摆那套粗糙道具，玩家搭的版本要覆盖它。
#   锚点同样是当前节点标记（房间中心、地板行走层）。事件函数不按坐标读写道具，所以覆盖是安全的。
execute at @e[tag=tspire_node_current,limit=1] run function tspire:deco/mys_apply
execute if score #MYST_EV tspire_timer matches 24 at @e[tag=tspire_node_current,limit=1] run function tspire:deco/mys_bridge
execute if score #MYST_EV tspire_timer matches 25 at @e[tag=tspire_node_current,limit=1] run function tspire:deco/mys_bridge
execute if score #MYST_EV tspire_timer matches 20 run function tspire:mystery/pigs_spawn
