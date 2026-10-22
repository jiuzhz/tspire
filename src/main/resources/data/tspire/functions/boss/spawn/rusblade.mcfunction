# 第 1 层 Boss：锈刃督军（僵尸）
# 数值见设计文档 §13.5；机制见 §7.6

# 【v0.7.26】Boss 场地装饰（玩家手搭；锚点 = 房间中心，必须先铺再召唤）
# 【v0.7.73 玩家要求】场地**自己锚定节点**，写法与战斗房装饰一致：
#   in tspire:tower as @e[tspire_node_current] at @s → 与"谁调用我、玩家在哪"完全无关。
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s positioned ~ ~ ~ run function tspire:deco/boss_rusblade
kill @e[tag=tspire_boss]
# v0.6.59（玩家要求）：Boss 血量随**队伍人数**缩放（1 人 / 2 人 / 3 人及以上）。
#   200 / 250 / 300  —— `Base:max_health` 无法在生成后改（/attribute 已被本项目禁用），
#   所以只能按人数选一条 summon 来执行。#PARTY_SIZE 由 run/start_run 开局按在线队员重算。
execute if score #PARTY_SIZE tspire_timer matches ..1 run summon minecraft:zombie ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_rusblade","tspire_mob_new","tspire_gear"],CustomName:'"锈刃督军"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:200},{Name:"minecraft:generic.attack_damage",Base:5},{Name:"minecraft:generic.armor",Base:4}],Health:200f}
execute if score #PARTY_SIZE tspire_timer matches 2 run summon minecraft:zombie ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_rusblade","tspire_mob_new","tspire_gear"],CustomName:'"锈刃督军"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:250},{Name:"minecraft:generic.attack_damage",Base:5},{Name:"minecraft:generic.armor",Base:4}],Health:250f}
execute if score #PARTY_SIZE tspire_timer matches 3.. run summon minecraft:zombie ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_rusblade","tspire_mob_new","tspire_gear"],CustomName:'"锈刃督军"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:300},{Name:"minecraft:generic.attack_damage",Base:5},{Name:"minecraft:generic.armor",Base:4}],Health:300f}

# 本场最大血量与四个百分比门槛（供 % 型机制用分数比较）
execute if score #PARTY_SIZE tspire_timer matches ..1 run scoreboard players set #MAXHP tspire_timer 200
execute if score #PARTY_SIZE tspire_timer matches 2 run scoreboard players set #MAXHP tspire_timer 250
execute if score #PARTY_SIZE tspire_timer matches 3.. run scoreboard players set #MAXHP tspire_timer 300
scoreboard players set #C2 tspire_timer 2
scoreboard players set #C3 tspire_timer 3
scoreboard players set #C4 tspire_timer 4
scoreboard players set #C5 tspire_timer 5
scoreboard players operation #TH_75 tspire_timer = #MAXHP tspire_timer
scoreboard players operation #TH_75 tspire_timer *= #C3 tspire_timer
scoreboard players operation #TH_75 tspire_timer /= #C4 tspire_timer
scoreboard players operation #TH_HALF tspire_timer = #MAXHP tspire_timer
scoreboard players operation #TH_HALF tspire_timer /= #C2 tspire_timer
scoreboard players operation #TH_40 tspire_timer = #MAXHP tspire_timer
scoreboard players operation #TH_40 tspire_timer *= #C2 tspire_timer
scoreboard players operation #TH_40 tspire_timer /= #C5 tspire_timer
scoreboard players operation #TH_25 tspire_timer = #MAXHP tspire_timer
scoreboard players operation #TH_25 tspire_timer /= #C2 tspire_timer
scoreboard players operation #TH_25 tspire_timer /= #C2 tspire_timer

scoreboard players set #BOSS_TIMER tspire_timer 0
function tspire:mobs/equip
execute as @e[tag=tspire_boss_rusblade,tag=tspire_mob_new] run loot replace entity @s weapon.mainhand loot tspire:mob_gear/boss_weapon_rusblade
tag @e[tag=tspire_mob_new] remove tspire_mob_new

# 【v0.6.32】三机制重做的状态初始化：生命值跟踪 + 三个专用冷却 + 破甲重击状态
scoreboard players set @e[tag=tspire_boss_rusblade] tspire_boss_hp 0
scoreboard players set #RUS_C1 tspire_timer 0
scoreboard players set #RUS_C2 tspire_timer 0
scoreboard players set #RUS_C3 tspire_timer 0
scoreboard players set #RUS_DOUBLE tspire_timer 0
scoreboard players set #RUS_SMASH tspire_timer 0
scoreboard players set #RUS_SMASH_T tspire_timer 0

title @a[team=tspire_party] title {"text":"锈刃督军","color":"red","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ender_dragon.growl master @s ~ ~ ~ 1 1

# 抽取链短路标记：没有这一句，pick_floorN 会把三个候选依次全部生成
scoreboard players set #PICKED tspire_timer 1
# 【v0.7.74 按诊断数据修正】节点坐标 (0.5, 96, -387.5) 与场地中心本应重合；
#   原来的固定偏移 -3（把场地中心放到节点以北 3 格）是旧注释里"场地中心偏南 3 格"的遗留，
#   而实测中心混凝土相对抓取原点就是 (0,-1,0)（即已居中）→ 偏移应为 0。
#   沼泽猎手另计：它的中心混凝土是 (0,-1,1)，故保留 -1 抵消那 1 格源偏心。
