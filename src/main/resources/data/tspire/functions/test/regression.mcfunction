# ============================================================
# 一键回归自检（v0.7.35）
# ============================================================
# 用法：游戏里随时执行
#   /function tspire:test/regression
#
# 它把最近出过问题、以及"出问题就会卡死"的那些不变量逐条查一遍，
# 只读不改（唯一写入的是几个假玩家分数），结果直接打在聊天栏：
#   [PASS] / [FAIL] / [WARN]
# 末尾给出 通过 / 失败 计数。
#
# 出问题时：把聊天栏这几行截图发我即可定位。
# ============================================================

scoreboard players set #REG_PASS tspire_timer 0
scoreboard players set #REG_FAIL tspire_timer 0
scoreboard players set #REG_WARN tspire_timer 0
tellraw @s [{"text":"===== 匠魂尖塔 · 回归自检 =====","color":"gold","bold":true}]

# ------------------------------------------------------------------
# [1] #FLOOR 合法
# ------------------------------------------------------------------
scoreboard players set #REG_OK tspire_timer 0
execute if score #FLOOR tspire_timer matches 1..3 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"#FLOOR 合法（1..3）","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"#FLOOR 非法，当前 = ","color":"gray"},{"score":{"name":"#FLOOR","objective":"tspire_timer"},"color":"yellow"},{"text":"（应为 1..3）","color":"gray"}]

# ------------------------------------------------------------------
# [2] 塔锚点存在（所有地形/房间都以它为基准）
# ------------------------------------------------------------------
scoreboard players set #REG_OK tspire_timer 0
execute in tspire:tower if entity @e[tag=tspire_anchor] run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"塔锚点 tspire_anchor 存在","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"塔锚点丢失 —— 用 /function tspire:test/floor_advance 或重开一局重建","color":"gray"}]

# ------------------------------------------------------------------
# [3] 节点标记存在（本层地图已建）
# ------------------------------------------------------------------
scoreboard players set #REG_N tspire_timer 0
execute as @e[tag=tspire_node] run scoreboard players add #REG_N tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_N tspire_timer matches 1.. run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"节点标记存在，共 ","color":"gray"},{"score":{"name":"#REG_N","objective":"tspire_timer"},"color":"white"},{"text":" 个","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"本层没有任何节点标记 —— 地图没建起来（重开一局）","color":"gray"}]

# ------------------------------------------------------------------
# [4] tspire_node_current 最多 1 个（多于 1 个会导致传送/结算挑错房间）
# ------------------------------------------------------------------
scoreboard players set #REG_N tspire_timer 0
execute as @e[tag=tspire_node_current] run scoreboard players add #REG_N tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_N tspire_timer matches ..1 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"current 节点唯一（0 或 1）","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"有 ","color":"gray"},{"score":{"name":"#REG_N","objective":"tspire_timer"},"color":"yellow"},{"text":" 个 current 节点（多于 1 会把玩家随机传送）","color":"gray"}]

# ------------------------------------------------------------------
# [5] 节点状态自洽：不能同时带 locked 与 avail
# ------------------------------------------------------------------
scoreboard players set #REG_OK tspire_timer 0
execute unless entity @e[tag=tspire_node_locked,tag=tspire_node_avail] run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"节点状态自洽（无 locked+avail 并存）","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"有节点同时带 locked 与 avail（门的状态会和标记打架）","color":"gray"}]

# ------------------------------------------------------------------
# [6] 核心不变量（待办 #38）：已打过的行，下一行至少要有一个开着
# ------------------------------------------------------------------
scoreboard players set #REG_TMP tspire_timer 0
execute if entity @e[tag=tspire_node_done,tag=tspire_row1] unless entity @e[tag=tspire_node_avail,tag=tspire_row2] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row2] unless entity @e[tag=tspire_node_avail,tag=tspire_row3] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row3] unless entity @e[tag=tspire_node_avail,tag=tspire_row4] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row4] unless entity @e[tag=tspire_node_avail,tag=tspire_row5] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row5] unless entity @e[tag=tspire_node_avail,tag=tspire_row6] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row6] unless entity @e[tag=tspire_node_avail,tag=tspire_row7] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row7] unless entity @e[tag=tspire_node_avail,tag=tspire_row8] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row8] unless entity @e[tag=tspire_node_avail,tag=tspire_row9] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row9] unless entity @e[tag=tspire_node_avail,tag=tspire_row10] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row10] unless entity @e[tag=tspire_node_avail,tag=tspire_row11] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row11] unless entity @e[tag=tspire_node_avail,tag=tspire_row12] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row12] unless entity @e[tag=tspire_node_avail,tag=tspire_row13] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row13] unless entity @e[tag=tspire_node_avail,tag=tspire_row14] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row14] unless entity @e[tag=tspire_node_avail,tag=tspire_row15] run scoreboard players add #REG_TMP tspire_timer 1
execute if entity @e[tag=tspire_node_done,tag=tspire_row15] unless entity @e[tag=tspire_node_avail,tag=tspire_row16] run scoreboard players add #REG_TMP tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_TMP tspire_timer matches 0 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"已打过的行，下一行都还有开着的房间","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"有 ","color":"gray"},{"score":{"name":"#REG_TMP","objective":"tspire_timer"},"color":"yellow"},{"text":" 处「上一行打完了、下一行全封着」→ 执行 /function tspire:map/runtime/unlock_next 立刻解开","color":"gray"}]

# ------------------------------------------------------------------
# [7] Boss 战标记合法（0/1）
# ------------------------------------------------------------------
scoreboard players set #REG_OK tspire_timer 0
execute if score #BOSS_BATTLE tspire_timer matches 0..1 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"Boss 战标记 #BOSS_BATTLE 合法","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"#BOSS_BATTLE 非法（Boss 战结算会重复推进楼层）","color":"gray"}]

# ------------------------------------------------------------------
# [8] 场上 Boss 数量 <= 1
# ------------------------------------------------------------------
scoreboard players set #REG_N tspire_timer 0
execute as @e[tag=tspire_boss] run scoreboard players add #REG_N tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_N tspire_timer matches ..1 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"场上 Boss 数量正常（0 或 1）","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"场上同时有 ","color":"gray"},{"score":{"name":"#REG_N","objective":"tspire_timer"},"color":"yellow"},{"text":" 只 Boss（会互相打架/机制错乱）","color":"gray"}]

# ------------------------------------------------------------------
# [9] #PARTY_SIZE 与实际队员数一致（人数缩放靠它）
# ------------------------------------------------------------------
scoreboard players set #REG_N tspire_timer 0
execute as @a[team=tspire_party] run scoreboard players add #REG_N tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #PARTY_SIZE tspire_timer = #REG_N tspire_timer run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"#PARTY_SIZE 与实际队员数一致","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"#PARTY_SIZE=","color":"gray"},{"score":{"name":"#PARTY_SIZE","objective":"tspire_timer"},"color":"yellow"},{"text":" 但实际有 ","color":"gray"},{"score":{"name":"#REG_N","objective":"tspire_timer"},"color":"yellow"},{"text":" 名队员（怪物/Boss 血量会按错的人数缩放）","color":"gray"}]

# ------------------------------------------------------------------
# [10] 抽奖次数在合理范围（抽奖机每次进房应清零）
# ------------------------------------------------------------------
scoreboard players set #REG_TMP tspire_timer 0
execute as @a[team=tspire_party,scores={tspire_gacha=31..}] run scoreboard players add #REG_TMP tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_TMP tspire_timer matches 0 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"抽奖次数正常（无人超过 30 次）","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"有 ","color":"gray"},{"score":{"name":"#REG_TMP","objective":"tspire_timer"},"color":"yellow"},{"text":" 人抽奖次数 >30（进新抽奖机房间应清零；旧值可用 /scoreboard players set <玩家> tspire_gacha 0 修正）","color":"gray"}]

# ------------------------------------------------------------------
# [11] tspire_shop 标记最多 1 个（多条会抢供货）
# ------------------------------------------------------------------
scoreboard players set #REG_N tspire_timer 0
execute in tspire:tower as @e[tag=tspire_shop] run scoreboard players add #REG_N tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_N tspire_timer matches ..1 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"商店柜台标记正常（0 或 1）","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"有 ","color":"gray"},{"score":{"name":"#REG_N","objective":"tspire_timer"},"color":"yellow"},{"text":" 个 tspire_shop 标记（陈年旧标记会抢供货 → 用 test/shop_probe 细查）","color":"gray"}]

# ------------------------------------------------------------------
# [12] 音乐模式标记合法（逐人，0/1）
# ------------------------------------------------------------------
scoreboard players set #REG_TMP tspire_timer 0
execute as @a[team=tspire_party,scores={tspire_music_rp=2..}] run scoreboard players add #REG_TMP tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_TMP tspire_timer matches 0 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"音乐模式标记合法（逐人 0/1）","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"有人的 tspire_music_rp 不是 0/1","color":"gray"}]

# ------------------------------------------------------------------
# [13] 阵亡标记与实际生命一致
# ------------------------------------------------------------------
scoreboard players set #REG_TMP tspire_timer 0
execute as @a[team=tspire_party,scores={tspire_dead=0,tspire_hp=..0}] run scoreboard players add #REG_TMP tspire_timer 1
execute as @a[team=tspire_party,scores={tspire_dead=1,tspire_hp=1..}] run scoreboard players add #REG_TMP tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_TMP tspire_timer matches 0 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"阵亡标记与血量一致","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_FAIL tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [FAIL] ","color":"red"},{"text":"有 ","color":"gray"},{"score":{"name":"#REG_TMP","objective":"tspire_timer"},"color":"yellow"},{"text":" 人「血量与阵亡标记对不上」（复活/结算可能出错）","color":"gray"}]

# ------------------------------------------------------------------
# [14] 当前房间里没有掉落物残留（WARN，不算失败 —— 玩家自己丢的东西也算）
# ------------------------------------------------------------------
scoreboard players set #REG_N tspire_timer 0
execute at @e[tag=tspire_node_current,limit=1] as @e[type=minecraft:item,distance=..9] run scoreboard players add #REG_N tspire_timer 1
scoreboard players set #REG_OK tspire_timer 0
execute if score #REG_N tspire_timer matches 0 run scoreboard players set #REG_OK tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run scoreboard players add #REG_PASS tspire_timer 1
execute if score #REG_OK tspire_timer matches 1 run tellraw @s [{"text":"  [PASS] ","color":"green"},{"text":"当前房间内没有掉落物","color":"gray"}]
execute if score #REG_OK tspire_timer matches 0 run scoreboard players add #REG_WARN tspire_timer 1
execute if score #REG_OK tspire_timer matches 0 run tellraw @s [{"text":"  [WARN] ","color":"yellow"},{"text":"当前房间有 ","color":"gray"},{"score":{"name":"#REG_N","objective":"tspire_timer"},"color":"yellow"},{"text":" 个掉落物（若是上一次事件/装饰残留，说明清房间没跑干净）","color":"gray"}]

# ------------------------------------------------------------------
# 汇总
# ------------------------------------------------------------------
tellraw @s [{"text":"----- 结果 -----","color":"gold"}]
tellraw @s [{"text":"  通过 ","color":"green"},{"score":{"name":"#REG_PASS","objective":"tspire_timer"},"color":"green"},{"text":"   失败 ","color":"red"},{"score":{"name":"#REG_FAIL","objective":"tspire_timer"},"color":"red"},{"text":"   警告 ","color":"yellow"},{"score":{"name":"#REG_WARN","objective":"tspire_timer"},"color":"yellow"}]
execute if score #REG_FAIL tspire_timer matches 0 run tellraw @s [{"text":"  全部通过 —— 没发现已知类型的故障。","color":"green"}]
execute if score #REG_FAIL tspire_timer matches 1.. run tellraw @s [{"text":"  有失败项：把上面标 [FAIL] 的行发我，或按提示里的指令先脱困。","color":"red"}]
