# 进入下一层：重置战斗计数、重建地图、把全队传到新层的起点

# 【v0.7.35 结算数据】换层时把"本层用时"存进对应槽，再清零本层计时
#   （此时 #FLOOR 已经是**新**层号，所以 #FLOOR=2 存的是刚打完的一层）
execute if score #FLOOR tspire_timer matches 2 as @a[team=tspire_party] run scoreboard players operation @s tspire_t1 = @s tspire_fltime
execute if score #FLOOR tspire_timer matches 3 as @a[team=tspire_party] run scoreboard players operation @s tspire_t2 = @s tspire_fltime
execute as @a[team=tspire_party] run scoreboard players set @s tspire_fltime 0
scoreboard players set #BATTLE tspire_timer 0
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #BATTLE_TIMER tspire_timer 0
scoreboard players set #BOSS_TIMER tspire_timer 0
scoreboard players set #ELITE tspire_timer 0
# v0.7.7：换层时清掉援兵铁傀儡（它属于上一层）
# 【v0.7.44 玩家要求】援兵铁傀儡**不再跨层被杀** —— 原来这里有一行 kill，
#   结果"援兵给完、上一层就没了"。现在改成跟着队伍一起上二层（下面 tp 那几行会带上它们）。

execute as @a[team=tspire_party] run function tspire:run/enter_floor_self

# 清掉上一层的残留（在塔维度里清）
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_boss]

# 下一刻独立建图，避免 Boss 结算与整层建图共用同一条命令链，截断后面的传送。
schedule function tspire:run/next_floor_build 1t replace
