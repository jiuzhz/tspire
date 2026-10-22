# ============================================================
# 神秘事件 · 房间道具（v0.7.5 / 待办 #33）
# ============================================================
# 以前事件只有"文字 + 可点选项"，玩家描述里提到的箱子 / 冶炼炉 / 石堆 / 三座雕像 / 柜台…
#   一个都没有。这里按 #MYST_EV 在**当前节点**周围摆一套简陋但认得出的道具。
# 位置都避开正中（节点中心留给地砖）与南北门洞（z ±8/±9）。房间半宽 7。
# 由 mystery/roll_event 在抽到事件后调用。
# ============================================================

# 通用：先清掉上一轮可能留下的道具（同层重进 / 重开）
execute at @e[tag=tspire_node_current,limit=1] run fill ~-6 ~ ~-6 ~6 ~3 ~6 minecraft:air replace minecraft:chest
execute at @e[tag=tspire_node_current,limit=1] run fill ~-6 ~ ~-6 ~6 ~3 ~6 minecraft:air replace minecraft:barrel
execute at @e[tag=tspire_node_current,limit=1] run fill ~-6 ~ ~-6 ~6 ~3 ~6 minecraft:air replace minecraft:brewing_stand
execute at @e[tag=tspire_node_current,limit=1] run fill ~-6 ~ ~-6 ~6 ~3 ~6 minecraft:air replace minecraft:cauldron
execute at @e[tag=tspire_node_current,limit=1] run kill @e[tag=tspire_prop]
execute at @e[tag=tspire_node_current,limit=1] run kill @e[type=minecraft:armor_stand,distance=..8]
# v0.7.10 BUG：原来这里写的是 `fill ... air replace minecraft:armor_stand` ——
#   armor_stand 是**实体**不是方块，命令在**加载期**就解析失败：
#   "Whilst parsing command on line 15: Unknown block type ... armor_stand"
#   → **整个 props 函数加载失败** → v0.7.5 加的所有神秘事件道具一个都没摆出来。
#   清理实体改用 kill（见上两行）。

# 1 贪婪：两口金币箱 + 散落金块
execute if score #MYST_EV tspire_timer matches 1 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~ ~-3 minecraft:chest
execute if score #MYST_EV tspire_timer matches 1 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~ ~-3 minecraft:chest
execute if score #MYST_EV tspire_timer matches 1 at @e[tag=tspire_node_current,limit=1] run setblock ~-3 ~ ~3 minecraft:gold_block
execute if score #MYST_EV tspire_timer matches 1 at @e[tag=tspire_node_current,limit=1] run setblock ~3 ~ ~3 minecraft:gold_block

# 2 重铸：冶炼炉 / 铁砧
execute if score #MYST_EV tspire_timer matches 2 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~ ~-3 minecraft:blast_furnace
execute if score #MYST_EV tspire_timer matches 2 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~ ~-1 minecraft:anvil
execute if score #MYST_EV tspire_timer matches 2 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~ ~-3 minecraft:grindstone

# 3 石中剑：石堆 + 一把插着的剑
execute if score #MYST_EV tspire_timer matches 3 at @e[tag=tspire_node_current,limit=1] run fill ~-1 ~ ~-2 ~1 ~1 ~0 minecraft:stone replace minecraft:air
execute if score #MYST_EV tspire_timer matches 3 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~1 ~-2 minecraft:iron_bars

# 4 赐福：三座雕像（红=生命 / 橙=工匠 / 紫=战斗）
execute if score #MYST_EV tspire_timer matches 4 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~ ~-4 minecraft:red_concrete
execute if score #MYST_EV tspire_timer matches 4 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~1 ~-4 minecraft:red_concrete
execute if score #MYST_EV tspire_timer matches 4 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~ ~-4 minecraft:orange_concrete
execute if score #MYST_EV tspire_timer matches 4 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~1 ~-4 minecraft:orange_concrete
execute if score #MYST_EV tspire_timer matches 4 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~ ~-4 minecraft:purple_concrete
execute if score #MYST_EV tspire_timer matches 4 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~1 ~-4 minecraft:purple_concrete

# 5 诅咒雕像：黑石像 + 灵魂灯笼
execute if score #MYST_EV tspire_timer matches 5 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~ ~-4 minecraft:blackstone
execute if score #MYST_EV tspire_timer matches 5 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~1 ~-4 minecraft:blackstone
execute if score #MYST_EV tspire_timer matches 5 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~1 ~-4 minecraft:soul_lantern
execute if score #MYST_EV tspire_timer matches 5 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~1 ~-4 minecraft:soul_lantern

# 6 伪装者：一圈黏液块 + 几个"戴头颅的村民"位置用绿色方块示意
execute if score #MYST_EV tspire_timer matches 6 at @e[tag=tspire_node_current,limit=1] run fill ~-3 ~ ~-3 ~3 ~0 ~3 minecraft:slime_block replace minecraft:air
execute if score #MYST_EV tspire_timer matches 6 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~1 ~-2 minecraft:green_wool
execute if score #MYST_EV tspire_timer matches 6 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~1 ~-2 minecraft:green_wool

# 7 共鸣：紫水晶簇一圈
execute if score #MYST_EV tspire_timer matches 7 at @e[tag=tspire_node_current,limit=1] run setblock ~-3 ~ ~-3 minecraft:amethyst_block
execute if score #MYST_EV tspire_timer matches 7 at @e[tag=tspire_node_current,limit=1] run setblock ~-3 ~1 ~-3 minecraft:amethyst_cluster
execute if score #MYST_EV tspire_timer matches 7 at @e[tag=tspire_node_current,limit=1] run setblock ~3 ~ ~-3 minecraft:amethyst_block
execute if score #MYST_EV tspire_timer matches 7 at @e[tag=tspire_node_current,limit=1] run setblock ~3 ~1 ~-3 minecraft:amethyst_cluster
execute if score #MYST_EV tspire_timer matches 7 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~1 ~-3 minecraft:amethyst_cluster

# 8 抢劫：木桶与箱子
execute if score #MYST_EV tspire_timer matches 8 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~ ~-3 minecraft:barrel
execute if score #MYST_EV tspire_timer matches 8 at @e[tag=tspire_node_current,limit=1] run setblock ~-2 ~ ~-3 minecraft:barrel
execute if score #MYST_EV tspire_timer matches 8 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~ ~-3 minecraft:chest

# 9 药房：柜台（石英）+ 酿造台 + 炼药锅
execute if score #MYST_EV tspire_timer matches 9 at @e[tag=tspire_node_current,limit=1] run fill ~-4 ~ ~-3 ~4 ~ ~-3 minecraft:smooth_quartz replace minecraft:air
execute if score #MYST_EV tspire_timer matches 9 at @e[tag=tspire_node_current,limit=1] run setblock ~-1 ~1 ~-4 minecraft:brewing_stand
execute if score #MYST_EV tspire_timer matches 9 at @e[tag=tspire_node_current,limit=1] run setblock ~2 ~1 ~-4 minecraft:cauldron

# 10 黏液：满地黏液块
execute if score #MYST_EV tspire_timer matches 10 at @e[tag=tspire_node_current,limit=1] run fill ~-4 ~ ~-4 ~4 ~0 ~4 minecraft:slime_block replace minecraft:air

# 12 抽奖机：一台旧机器（讲台 + 铁块 + 红石灯）
execute if score #MYST_EV tspire_timer matches 12 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~ ~-4 minecraft:lectern
execute if score #MYST_EV tspire_timer matches 12 at @e[tag=tspire_node_current,limit=1] run setblock ~-2 ~ ~-4 minecraft:iron_block
execute if score #MYST_EV tspire_timer matches 12 at @e[tag=tspire_node_current,limit=1] run setblock ~2 ~ ~-4 minecraft:redstone_lamp

# 13 生命本源：一棵把房间遮住的大树
execute if score #MYST_EV tspire_timer matches 13 at @e[tag=tspire_node_current,limit=1] run fill ~-1 ~ ~-1 ~1 ~2 ~1 minecraft:oak_log replace minecraft:air
execute if score #MYST_EV tspire_timer matches 13 at @e[tag=tspire_node_current,limit=1] run fill ~-5 ~3 ~-5 ~5 ~4 ~5 minecraft:oak_leaves replace minecraft:air
execute if score #MYST_EV tspire_timer matches 13 at @e[tag=tspire_node_current,limit=1] run fill ~-6 ~4 ~-6 ~6 ~5 ~6 minecraft:azalea_leaves replace minecraft:air

# 14 黏液收藏家：黏液块堆 + 一个"坐着的人"
execute if score #MYST_EV tspire_timer matches 14 at @e[tag=tspire_node_current,limit=1] run fill ~-4 ~ ~-3 ~4 ~0 ~-1 minecraft:slime_block replace minecraft:air
execute if score #MYST_EV tspire_timer matches 14 at @e[tag=tspire_node_current,limit=1] run summon minecraft:armor_stand ~ ~1 ~-4 {Tags:["tspire_prop"],NoGravity:1b,Invulnerable:1b,PersistenceRequired:1b}

# 15 疯狂：漆黑一片 —— 只有几盏灵魂灯笼
execute if score #MYST_EV tspire_timer matches 15 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~1 ~-4 minecraft:soul_lantern
execute if score #MYST_EV tspire_timer matches 15 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~1 ~-4 minecraft:soul_lantern
execute if score #MYST_EV tspire_timer matches 15 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~ ~-4 minecraft:sculk

# 16 援兵：商人讲台 + 铁块（铁傀儡站位）
execute if score #MYST_EV tspire_timer matches 16 at @e[tag=tspire_node_current,limit=1] run setblock ~-4 ~ ~-4 minecraft:lectern
execute if score #MYST_EV tspire_timer matches 16 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~ ~-4 minecraft:iron_block
execute if score #MYST_EV tspire_timer matches 16 at @e[tag=tspire_node_current,limit=1] run setblock ~4 ~1 ~-4 minecraft:iron_block

# 17 海龟：一小片水（就是"把它推进去"的那摊水）
execute if score #MYST_EV tspire_timer matches 17 at @e[tag=tspire_node_current,limit=1] run fill ~-3 ~ ~-3 ~3 ~ ~3 minecraft:water replace minecraft:air
execute if score #MYST_EV tspire_timer matches 17 at @e[tag=tspire_node_current,limit=1] run setblock ~ ~1 ~-4 minecraft:turtle_egg

# 11 传统派：一个穿原版装备的"人"（盔甲架 + 铁甲 + 木剑）
execute if score #MYST_EV tspire_timer matches 11 at @e[tag=tspire_node_current,limit=1] run summon minecraft:armor_stand ~ ~ ~-4 {Tags:["tspire_prop"],NoGravity:1b,Invulnerable:1b,PersistenceRequired:1b}
execute if score #MYST_EV tspire_timer matches 11 at @e[tag=tspire_node_current,limit=1] run setblock ~-3 ~ ~-4 minecraft:iron_block
execute if score #MYST_EV tspire_timer matches 11 at @e[tag=tspire_node_current,limit=1] run setblock ~3 ~ ~-4 minecraft:stone