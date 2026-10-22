# 走进节点后按类型分流（执行者 = 玩家）
# 全部用 tag 选节点，不读 marker NBT —— 读 NBT 要 data get，会刷命令反馈
#
# 顺序很重要：**先**统一标记当前节点（顺便锁掉同层其余可选节点，实现路线选择），
# 再按类型分流。各 enter_* 里的重复标记是幂等的，留着是为了让 test/* 能单独调用。

# 0) 【v0.6.22 关键修正】先把**所有**旧的 tspire_node_current 清掉。
#    工匠/商人节点是可复用的，玩家第二次走进去时 map/enter_service 会重新打上
#    tspire_node_current，但**离开时从来不清** —— 于是走进战斗房间后，
#    场上同时有两个 current：上一个工匠节点 + 当前战斗节点。
#    battle_start 里"把队友拉进竞技场"用的是 @e[tag=tspire_node_current,limit=1]，
#    结果把人传送回了**上一层的工匠节点**（实测就是"打到第三行被传回第二行工匠"）。
#    这里强制保证同一时刻只有一个 current。
tag @e[tag=tspire_node_current] remove tspire_node_current
kill @e[tag=tspire_event_pig]

# 1) 标记当前节点 + 锁掉同层其余（路线选择在这里生效）
execute as @e[tag=tspire_node_avail,distance=..3,limit=1,sort=nearest] run function tspire:map/node_begin

# 【v0.7.2 玩家要求】进入**任何**下一个房间时，把全队都拉进房间。
#   以前只有战斗房（run/battle_start）和神秘房（mystery/roll_event）会拉人，
#   结果"第一个进门的人开打/开事件，后面的人还堵在走廊里"，商店/工匠/宝箱房
#   更是各走各的。现在统一在这里做：以刚标记好的当前节点为中心，
#   距离 > 8 格（房间半宽 7）的存活队友挪到中心北侧 2 格。
#   之所以可以直接用 @e[tag=tspire_node_current,limit=1]：本函数第 0 步刚把所有
#   旧的 current 清掉了，此刻唯一带该标签的就是这个新房间。
execute as @a[team=tspire_party,scores={tspire_dead=0}] at @e[tag=tspire_node_current,limit=1] if entity @s[distance=8..200] run tp @s ~ ~ ~2

# 【v0.7 赐福 · 生命之神】每进入一个房间：10 秒生命恢复
execute if score @s tspire_bless_life matches 1 run effect give @s minecraft:regeneration 10 0 true
# 【v0.7 诅咒雕像】每进入一个房间：额外 12 金币
execute as @a[team=tspire_party,scores={tspire_dead=0,tspire_curse_greed=1}] run scoreboard players add @s tspire_gold 12
# 寄生诅咒只在普通战斗、精英战斗和 BOSS 节点入场时扣血。
execute if entity @e[tag=tspire_node_current,tag=tspire_type_combat,distance=..3,limit=1] as @a[team=tspire_party,tag=tspire_parasite,scores={tspire_dead=0}] if score @s tspire_para_run = #RUN_ID tspire_timer run damage @s 2 minecraft:magic
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite,distance=..3,limit=1] as @a[team=tspire_party,tag=tspire_parasite,scores={tspire_dead=0}] if score @s tspire_para_run = #RUN_ID tspire_timer run damage @s 2 minecraft:magic
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss,distance=..3,limit=1] as @a[team=tspire_party,tag=tspire_parasite,scores={tspire_dead=0}] if score @s tspire_para_run = #RUN_ID tspire_timer run damage @s 2 minecraft:magic

# 2) 记录本节点是不是精英（给 mobs/roll_group 用）
scoreboard players set #ELITE tspire_timer 0
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite,distance=..3,limit=1] run scoreboard players set #ELITE tspire_timer 1

# 3) 按类型分流
execute if entity @e[tag=tspire_node_current,tag=tspire_type_combat,distance=..3,limit=1] run function tspire:map/enter_combat
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite,distance=..3,limit=1] run function tspire:map/enter_combat
execute if entity @e[tag=tspire_node_current,tag=tspire_type_artisan,distance=..3,limit=1] run function tspire:map/enter_artisan
execute if entity @e[tag=tspire_node_current,tag=tspire_type_chest,distance=..3,limit=1] run function tspire:map/enter_chest
execute if entity @e[tag=tspire_node_current,tag=tspire_type_merchant,distance=..3,limit=1] run function tspire:map/enter_merchant
execute if entity @e[tag=tspire_node_current,tag=tspire_type_mystery,distance=..3,limit=1] run function tspire:map/enter_mystery
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss,distance=..3,limit=1] unless score #TUTOR_MODE tspire_timer matches 1 run function tspire:map/enter_boss
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss,distance=..3,limit=1] if score #TUTOR_MODE tspire_timer matches 1 run function tspire:tutorial/finish
