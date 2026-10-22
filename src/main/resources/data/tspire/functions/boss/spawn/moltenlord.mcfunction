# 第 3 层 Boss：熔核暴君（凋灵骷髅）
# 数值见设计文档 §13.5；机制见 §7.6

# 【v0.7.27】Boss 场地装饰（玩家手搭；锚点 = 房间中心，必须先铺再召唤）
# 【v0.7.73 玩家要求】场地**自己锚定节点**，写法与战斗房装饰一致：
#   in tspire:tower as @e[tspire_node_current] at @s → 与"谁调用我、玩家在哪"完全无关。
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s positioned ~ ~ ~ run function tspire:deco/boss_moltenlord
# 【v0.7.62 玩家实测】熔核暴君场地偏东北一格（东=+X、北=-Z）→ 装饰整体往西南挪：x-1, z+1

kill @e[tag=tspire_boss]
# v0.7.10（玩家要求）：第 3 层 Boss 血量**随人数缩放**，但整条曲线都比原来低：
#   1 人 400 / 2 人 500 / 3 人及以上 600（原 500 / 600 / 750）。
execute if score #PARTY_SIZE tspire_timer matches ..1 run summon minecraft:wither_skeleton ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_moltenlord","tspire_mob_new","tspire_gear"],CustomName:'"熔核暴君"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:400},{Name:"minecraft:generic.attack_damage",Base:7},{Name:"minecraft:generic.armor",Base:12}],Health:400f}
execute if score #PARTY_SIZE tspire_timer matches 2 run summon minecraft:wither_skeleton ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_moltenlord","tspire_mob_new","tspire_gear"],CustomName:'"熔核暴君"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:500},{Name:"minecraft:generic.attack_damage",Base:7},{Name:"minecraft:generic.armor",Base:12}],Health:500f}
execute if score #PARTY_SIZE tspire_timer matches 3.. run summon minecraft:wither_skeleton ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_moltenlord","tspire_mob_new","tspire_gear"],CustomName:'"熔核暴君"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:600},{Name:"minecraft:generic.attack_damage",Base:7},{Name:"minecraft:generic.armor",Base:12}],Health:600f}

execute if score #PARTY_SIZE tspire_timer matches ..1 run scoreboard players set #MAXHP tspire_timer 400
execute if score #PARTY_SIZE tspire_timer matches 2 run scoreboard players set #MAXHP tspire_timer 500
execute if score #PARTY_SIZE tspire_timer matches 3.. run scoreboard players set #MAXHP tspire_timer 600
scoreboard players set #C2 tspire_timer 2
scoreboard players set #C3 tspire_timer 3
scoreboard players set #C4 tspire_timer 4
scoreboard players set #C5 tspire_timer 5
# v0.6.60：熔核暴君的两个阶段门改成百分比，需要 17 / 20 这两个常数
scoreboard players set #C17 tspire_timer 17
scoreboard players set #C20 tspire_timer 20
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
# 【v0.6.60 待办 #27 结案】熔核暴君原来用**绝对血量** 300 / 425 当阶段门，而这两个数
#   是按"1 人局 500 血"定的 → 1 人局是 60% / 85%，2 人局 50% / 71%，3 人局 40% / 57%，
#   同一天里百分比会变。现在改成随人数缩放的分数门：
#     #TH_60 = 最大血量的 60%（240 / 300 / 360）→ 【熔火地脉】范围 3×3 → 5×5
#     #TH_85 = 最大血量的 85%（340 / 425 / 510）→ 【熔核爆发】开始释放
scoreboard players operation #TH_60 tspire_timer = #MAXHP tspire_timer
scoreboard players operation #TH_60 tspire_timer *= #C3 tspire_timer
scoreboard players operation #TH_60 tspire_timer /= #C5 tspire_timer
scoreboard players operation #TH_85 tspire_timer = #MAXHP tspire_timer
scoreboard players operation #TH_85 tspire_timer *= #C17 tspire_timer
scoreboard players operation #TH_85 tspire_timer /= #C20 tspire_timer

scoreboard players set #BOSS_TIMER tspire_timer 0
# v0.7.20（玩家要求）：三层 BOSS 的装备与武器改从 **3 级材料池**抽取
#   （普通三层怪仍用 3~4 级；只有 BOSS 走这套 boss_* 表）
function tspire:mobs/equip_boss_f3
execute as @e[tag=tspire_boss_moltenlord,tag=tspire_mob_new] run loot replace entity @s weapon.mainhand loot tspire:mob_gear/boss_weapon_moltenlord
tag @e[tag=tspire_mob_new] remove tspire_mob_new

title @a[team=tspire_party] title {"text":"熔核暴君","color":"dark_red","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ender_dragon.growl master @s ~ ~ ~ 1 1

# 抽取链短路标记：没有这一句，pick_floorN 会把三个候选依次全部生成
scoreboard players set #PICKED tspire_timer 1

# 【v0.6.42】补齐三机制之 2、3：生命值跟踪 + 凋零剑压冷却 + 过载状态/自损计时
scoreboard players set @e[tag=tspire_boss_moltenlord] tspire_boss_hp 0
# v0.6.57 三机制计数器（熔火地脉 / 凋零剑压 / 熔核爆发）
scoreboard players set #ML_C1 tspire_timer 0
scoreboard players set #MLZ tspire_timer 0
scoreboard players set #MLZ_T tspire_timer 0
scoreboard players set #ML_C2 tspire_timer 0
scoreboard players set #ML_RES tspire_timer 0
scoreboard players set #ML_CUBES tspire_timer 0
scoreboard players set #ML_NOW tspire_timer 0
scoreboard players set #ML_C3 tspire_timer 0
scoreboard players set #MLZ2 tspire_timer 0
scoreboard players set #MLZ2_T tspire_timer 0
# 清掉上一场的残留（火焰标记 / 岩浆怪）
kill @e[tag=tspire_lava]
kill @e[tag=tspire_fz1]
kill @e[tag=tspire_fz2]
kill @e[tag=tspire_fz3]
kill @e[tag=tspire_fz4]
kill @e[tag=tspire_fz5]
kill @e[tag=tspire_mcube]
scoreboard players set #MOL_C1 tspire_timer 0
scoreboard players set #MOL_OVER tspire_timer 0
scoreboard players set #MOL_BURN_T tspire_timer 0
# 【v0.7.74 按诊断数据修正】节点坐标 (0.5, 96, -387.5) 与场地中心本应重合；
#   原来的固定偏移 -3（把场地中心放到节点以北 3 格）是旧注释里"场地中心偏南 3 格"的遗留，
#   而实测中心混凝土相对抓取原点就是 (0,-1,0)（即已居中）→ 偏移应为 0。
#   沼泽猎手另计：它的中心混凝土是 (0,-1,1)，故保留 -1 抵消那 1 格源偏心。
