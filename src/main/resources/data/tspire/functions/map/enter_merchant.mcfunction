# 商人节点（设计文档 §3.2，货架归属见 §3.2.1）
#   - 15 个货架位逐格在进店时抽取；第 15 格远古工具概率 5%
#   - 具体商品候选已编译，组合在游戏运行时生成；聊天栏显示材料、阶级和价格
#   - 商品放在一个带 Lock 的箱子里（藏在地板下面一层），玩家打不开，只能通过
#     点击聊天栏购买
#   - 支持出售（tspire:merchant/sell），价格见菜单
#
# 【v0.6.15 两个修复】
#   1. **货架只抽一次**：同一层反复进出不重抽，只重开菜单 —— 之前可以反复刷新商品。
#      （v0.6.21 起改成"每人一份"，判据从节点标记换成 @s tspire_shop_f = #FLOOR）
#   2. **村民不再掉命名牌**：DeathLootTable 设成 minecraft:empty。
#
# 【v0.6.21 每人一份自己的货架】
#   货架编号挂在玩家身上，买过哪一格也挂在玩家身上（@s tspire_buy0..9）。
#   所以两个人看到的商品不一样，而且**每人每格都能各买一次**，
#   买走之后货架格**不再清空**（那只是你自己那份的陈列）。

# 标记当前节点
execute as @e[tag=tspire_node_avail,tag=tspire_type_merchant,distance=..3,limit=1,sort=nearest] run tag @s add tspire_node_current
execute as @e[tag=tspire_node_current] run tag @s remove tspire_node_avail

# 柜面：讲台 + 灯笼 + 商人 NPC
# 【v0.6.25】只建一次（tspire_node_built）。重进同一个商人房间不再重摆方块、
# 不再杀掉重召 NPC —— 实测反馈就是"多次到达监测点方块刷新"。
execute unless entity @e[tag=tspire_node_current,tag=tspire_node_built] at @e[tag=tspire_node_current] run function tspire:map/build_merchant_stall
tag @e[tag=tspire_node_current] add tspire_node_built

# #FLOOR 兜底为 1，方便 /function tspire:test/node_merchant 单独测试
execute unless score #FLOOR tspire_timer matches 1.. run scoreboard players set #FLOOR tspire_timer 1

# 货架：【v0.6.21 每人一份自己的货架】
#   15 格候选编号挂在玩家身上（@s tspire_s0..14 / tspire_shop_f），不再是全局 #SHOP_L。
#   所以两个人看到的商品不一样，而且**每人每格都能买一次**（@s tspire_buy0..14）。
#   第一次进这个房间、或者换层之后，才给执行者抽一份新的；
#   之后再走进来只是把"他自己那份"菜单重开一遍，商品与价格都不变。
# 【v0.6.22 修正】原来写的是 `unless score @s tspire_shop_f = #FLOOR` —— 少了第二个
# 计分板名，Brigadier 直接报 "Whilst parsing command on line 47"，**整个函数加载失败**，
# 表现就是"商人节点走进去没反应"。正确写法是 `= #FLOOR tspire_timer`。
# 【v0.6.27】货架归属改用"当前节点"当钥匙：
#   原来只用 `@s tspire_shop_f != #FLOOR` 判断 —— 玩家在**同一层**换一个商人节点
#   （或开新一局仍在第 1 层）时不会重抽，于是把上一处的货架和"已购买"标记一起带过来。
#   现在把当前节点 marker 的 z 坐标存进 @s tspire_shop_node：
#     换节点 -> 重抽货架 + 清空购买标记（pick_f<层> 里会清）
#     回到同一节点 -> 保持原样，不会刷新商品
#   （一行只能选一个节点，所以 z 足以区分节点）
execute if entity @e[tag=tspire_node_current,limit=1] store result score #NODEZ tspire_timer run data get entity @e[tag=tspire_node_current,limit=1] Pos[2] 1
execute unless score @s tspire_shop_node = #NODEZ tspire_timer if score #FLOOR tspire_timer matches 1 run function tspire:shop/pick_f1
execute unless score @s tspire_shop_node = #NODEZ tspire_timer if score #FLOOR tspire_timer matches 2 run function tspire:shop/pick_f2
execute unless score @s tspire_shop_node = #NODEZ tspire_timer if score #FLOOR tspire_timer matches 3 run function tspire:shop/pick_f3
execute unless score @s tspire_shop_node = #NODEZ tspire_timer run scoreboard players operation @s tspire_shop_node = #NODEZ tspire_timer

# 把自己那份货架摆到柜台上（柜面 = 当前节点），再弹自己的菜单
execute at @e[tag=tspire_node_current,limit=1] run function tspire:merchant/open_own
function tspire:merchant/menu
execute if score #TUTOR_MODE tspire_timer matches 1 run function tspire:tutorial/merchant_hint

# 【v0.6.21 已删除】这里原来会打 tag tspire_node_stocked 当作"这个节点已经抽过货架"。
# 货架改成挂在玩家身上之后，全代码库已经没有任何地方读它，属于死代码，已移除。

playsound minecraft:entity.villager.ambient master @s ~ ~ ~ 0.8 1
# 服务节点：完成之后仍然可以再进来用（见 map/enter_service）
tag @e[tag=tspire_node_current] add tspire_node_reusable

# 【只在第一次进来时结算】重进服务节点如果又跑一遍 complete_node，
# runtime/unlock_next 会把**已经过去的行**重新解锁 —— 表现为"下一行可选门里混进了上一行的房间"。
execute unless entity @e[tag=tspire_node_current,tag=tspire_node_done] run function tspire:map/complete_node
