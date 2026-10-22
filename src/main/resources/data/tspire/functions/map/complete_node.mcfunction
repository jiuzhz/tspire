# 完成当前节点：标记已完成；如果是 Boss 节点则推进楼层；然后解锁下一行
# 注意顺序：先判定 Boss（此时 tspire_node_current 还在），再清除 current 标记

tag @e[tag=tspire_node_current] add tspire_node_done
# 结算寄生恢复也只针对战斗、精英和 BOSS 节点。
execute if entity @e[tag=tspire_node_current,tag=tspire_type_combat,limit=1] as @a[team=tspire_party,tag=tspire_parasite,scores={tspire_dead=0}] if score @s tspire_para_run = #RUN_ID tspire_timer run effect give @s minecraft:instant_health 1 0 true
execute if entity @e[tag=tspire_node_current,tag=tspire_type_elite,limit=1] as @a[team=tspire_party,tag=tspire_parasite,scores={tspire_dead=0}] if score @s tspire_para_run = #RUN_ID tspire_timer run effect give @s minecraft:instant_health 1 0 true
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss,limit=1] as @a[team=tspire_party,tag=tspire_parasite,scores={tspire_dead=0}] if score @s tspire_para_run = #RUN_ID tspire_timer run effect give @s minecraft:instant_health 1 0 true
execute as @a[team=tspire_party,tag=tspire_parasite_pending] if score @s tspire_para_run = #RUN_ID tspire_timer run tag @s add tspire_parasite
tag @a[team=tspire_party,tag=tspire_parasite_pending] remove tspire_parasite_pending

# 【v0.7.31 修 "打完 Boss 有时不传送到下一层"】
#   原来只有一条判据：`execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss]`。
#   问题在于它要求**结算这一刻** current 还稳稳挂在 Boss 节点上 ——
#   玩家在结算前阵亡重生、或走远导致 current 被换掉时，这一条就不成立，
#   于是 battle_win 照常发奖励、却没人推进楼层（表现正是"打完 Boss 没传送"）。
#   现在改成：进 Boss 房时（map/enter_boss）就打一个 #BOSS_BATTLE 标记，
#   结算时**只看这个标记**；原来的 current 判据留作兜底。
#   两条判据用 #BOSS_ADV 汇总 → 同一次结算最多推进一层，绝不会重复推进。
scoreboard players set #BOSS_ADV tspire_timer 0
execute if score #BOSS_BATTLE tspire_timer matches 1 run scoreboard players set #BOSS_ADV tspire_timer 1
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] run scoreboard players set #BOSS_ADV tspire_timer 1
scoreboard players set #BOSS_BATTLE tspire_timer 0
execute if score #BOSS_ADV tspire_timer matches 1 run function tspire:run/floor_advance

# 【v0.6.25】这里**故意不摘 current**：结算完玩家还站在这个房间里，
# 立刻摘掉的话 refresh_doors 会把这个房间门一起封上，人就被关在里面了。
# 让它保持 current（门开着、能走出去）；等玩家踏进下一个节点时，
# map/enter 会统一清掉旧 current，那时这个房间才会被彻底封死。
# tag @e[tag=tspire_node_current] remove tspire_node_current   ← 不要恢复这一行

# 【v0.7 赐福 · 工匠之神】每完成一个房间：额外 1 个本层材料池的部件
execute as @a[team=tspire_party,scores={tspire_bless_artisan=1}] if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:rewards/part_f1
execute as @a[team=tspire_party,scores={tspire_bless_artisan=1}] if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:rewards/part_f2
execute as @a[team=tspire_party,scores={tspire_bless_artisan=1}] if score #FLOOR tspire_timer matches 3 run loot give @s loot tspire:rewards/part_f3

function tspire:map/runtime/unlock_next

# 结算界面用的节点计数（"通过节点"）
execute if score #RUN_STARTED tspire_timer matches 1 run scoreboard players add @a[team=tspire_party] tspire_nodes 1


# 【v0.7.51 玩家要求】伪装者事件（#MYST_EV = 6）结束后，**道具盔甲架要消失**。
#   严格限定条件：当前节点必须是**神秘房**且事件号=6 —— 否则会在别的房间误杀装饰用的盔甲架。
# 【v0.7.77 修"伪装者架没清掉"】原来守卫是 #MYST_EV = 6，但结算时该计分板可能已被重置 → 守卫不成立。
#   改成给道具打标签（tspire_mimic_stand），结算时**按标签清**，与事件号无关。
execute at @e[tag=tspire_node_current,limit=1] run kill @e[tag=tspire_mimic_stand,distance=..16]
