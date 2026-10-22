# 工匠节点（设计文档 §3.1）
# 恢复生命 + 摆出一套匠魂工作方块；修复/部件替换/安装强化全部走原生 UI

execute as @e[tag=tspire_node_avail,tag=tspire_type_artisan,distance=..3,limit=1,sort=nearest] run tag @s add tspire_node_current
execute as @e[tag=tspire_node_current] run tag @s remove tspire_node_avail

# 建工作台（在节点位置）
# 【v0.6.25】只建一次：重进同一个工匠房间不再重摆方块，避免"走到监测点方块刷新"。
execute unless entity @e[tag=tspire_node_current,tag=tspire_node_built] at @e[tag=tspire_node_current] run function tspire:map/build_workshop
execute unless entity @e[tag=tspire_node_current,tag=tspire_node_built] at @e[tag=tspire_node_current] run function tspire:deco/artisan_fuel
tag @e[tag=tspire_node_current] add tspire_node_built

# 燃料储罐只在首次建房时清空；重复触发工匠提示不能再动玩家后来放入的燃料。

# 【v0.7.39 修「告示牌文字没写进去」】告示牌也放到「只建一次」的闸门**外面**，每次进房重写一遍。
#   原因：装饰整体是建一次就锁住的（tspire_node_built），所以**后加**的告示牌在"已经建好的房间"里
#   永远不出现 —— 玩家实测报的就是这个。牌子是静态内容，重写完全无害；
#   冶炼炉 / 箱子的 NBT **不在这个文件里**（那些重写会把玩家放进去的东西刷掉）。
execute at @e[tag=tspire_node_current] run function tspire:deco/artisan_signs

# 【v0.6.28】不再往部件制造台塞金质模具（玩家不要），改成工作台旁边的箱子里备好
#   木制模具 + 毒液瓶，见 map/build_workshop。
# execute at @e[tag=tspire_node_current] positioned ~-1 ~ ~-2 unless data block ~ ~ ~ Items[{Slot:0b}] as @a[team=tspire_party] run function tspire:artisan/put_cast

# 【v0.6.28】共鸣 / 融合改成**每个工匠节点**各限一次（原来整局限一次）：
#   用当前节点 marker 的 z 坐标当钥匙，换一个工匠节点就重置这两个标记。
execute if entity @e[tag=tspire_node_current,limit=1] store result score #CRAFTZ tspire_timer run data get entity @e[tag=tspire_node_current,limit=1] Pos[2] 1
execute unless score @s tspire_craft_node = #CRAFTZ tspire_timer run scoreboard players set @s tspire_resonate_used 0
execute unless score @s tspire_craft_node = #CRAFTZ tspire_timer run scoreboard players set @s tspire_fuse_used 0
execute unless score @s tspire_craft_node = #CRAFTZ tspire_timer run scoreboard players operation @s tspire_craft_node = #CRAFTZ tspire_timer

# 回血：【v0.6.26 调整】免费只回 45%（9 点）。
#   旧版是 instant_health amplifier 4 = 64 点，等于必满血，玩家反馈"回血太高"。
#   想要更多就在菜单里花 #CFG_ARTISAN_HEAL_PAID_COST 金币再回 25%。
# 【v0.6.27】必须是**一圈** `as @a`（snapshot 已并入 heal_free 内部），
#   否则 #HP0 会被队里别人的血量覆盖，低血的人反而一点都回不上。
scoreboard players set #HEAL_ME tspire_timer 0
execute unless score @s tspire_heal_node = #CRAFTZ tspire_timer run scoreboard players set #HEAL_ME tspire_timer 1
execute as @a[team=tspire_party] run function tspire:artisan/heal_once

# 【v0.6.31】节点提示改成**只发给触发的那名玩家**（原来 @a[team] 会让队友也收到一遍）
execute if score #HEAL_ME tspire_timer matches 1 run tellraw @s [{"text":"[工匠节点] ","color":"gold"},{"text":"已回复最大生命的 45%。","color":"white"},{"text":"（想再回 25% 可在菜单里花金币）","color":"gray"}]
execute if score #HEAL_ME tspire_timer matches 0 run tellraw @s [{"text":"[工匠节点] ","color":"gray"},{"text":"这个节点已经免费回过血了（每个工匠节点只回一次）。","color":"dark_gray"}]
tellraw @s [{"text":"  工作台已备好：","color":"gray"},{"text":"工匠砧  部件制造台  强化调配台(用水晶)  工作站(合成)  4 台工匠站  整套冶炼炉  旁边的箱子(模具/毒液瓶/水晶/海绵)","color":"aqua"}]
playsound minecraft:block.anvil.use master @s ~ ~ ~ 0.8 1

# 弹出「重铸」菜单（面向触发节点的这名玩家）
function tspire:artisan/menu
execute if score #TUTOR_MODE tspire_timer matches 1 run function tspire:tutorial/artisan_hint

# 服务节点：完成之后仍然可以再进来用（见 map/enter_service）
tag @e[tag=tspire_node_current] add tspire_node_reusable

# 【只在第一次进来时结算】重进服务节点如果又跑一遍 complete_node，
# runtime/unlock_next 会把**已经过去的行**重新解锁 —— 表现为"下一行可选门里混进了上一行的房间"。
execute unless entity @e[tag=tspire_node_current,tag=tspire_node_done] run function tspire:map/complete_node
