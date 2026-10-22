# ============================================================
# 节点地图演示
# 用法：/function tspire:test/map_demo
# 会自动把你送进尖塔维度并生成第 1 层
# ============================================================
# 房间地砖颜色：
#   红色 = 战斗   紫色 = 精英   橙色 = 工匠
#   黄色 = 宝箱   绿色 = 商人   黑色 = Boss
#
# 路线规则（设计文档 §3.1 / §3.5.5）：
#   第 1 行的节点一开始全部可进入；
#   **走进其中一个之后，同一行其余节点立刻锁死**（一行只能选一条路）；
#   完成该节点后，只解锁它**相邻的子节点**（下一行 c-1 / c / c+1 列）。
#   第 6 行任意节点完成后开放 Boss 房。
#
# 注意：必须**先传送再建场景**。fill / setblock 在未加载的区块里会静默失败，
#       所以这里也走和 run/start 一样的两拍流程（置 #PICK_STAGE=1，由 tick/second 建）。
# ============================================================

execute in tspire:tower run kill @e[tag=tspire_node]
scoreboard players set #FLOOR tspire_timer 1
scoreboard players set #BATTLE tspire_timer 0
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #BATTLE_TIMER tspire_timer 0
scoreboard players set #BOSS_TIMER tspire_timer 0
scoreboard players set #ELITE tspire_timer 0
scoreboard players set #RUN_STARTED tspire_timer 0

# 不要在这里传送：塔里还是空的，tp 进去会掉进虚空。
# 先常驻加载区块、置 #PICK_STAGE=1，由 tick/second 分两拍建场景再送人进去。
execute in tspire:tower unless entity @e[tag=tspire_anchor] run summon minecraft:marker 0 64 0 {Tags:["tspire_anchor"]}
execute in tspire:tower run forceload add -48 -416 48 32
scoreboard players set #PICK_STAGE tspire_timer 1

tellraw @s [{"text":"[地图演示] ","color":"gold"},{"text":"正在生成第 1 层……","color":"white"}]
tellraw @s [{"text":"颜色：","color":"gray"},{"text":"红=战斗 紫=精英 橙=工匠 黄=宝箱 绿=商人 黑=Boss","color":"yellow"}]
tellraw @s [{"text":"回主世界：","color":"gray"},{"text":"/execute in minecraft:overworld tp @s 0 100 0","color":"yellow"}]
tellraw @s [{"text":"回主世界：","color":"gray"},{"text":"/execute in minecraft:run tp @s 0 100 0","color":"yellow"}]