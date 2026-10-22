# 第 3 层 Boss：铭刻者（幻术师）—— 最终 Boss
# 数值见设计文档 §13.5；机制见 §7.6
# 幻术师在 1.20.1 不自然生成，只能 summon / 刷怪蛋产生 —— 本方案正是用 summon

# 【v0.7.27】Boss 场地装饰（玩家手搭；锚点 = 房间中心，必须先铺再召唤）
# 【v0.7.73 玩家要求】场地**自己锚定节点**，写法与战斗房装饰一致：
#   in tspire:tower as @e[tspire_node_current] at @s → 与"谁调用我、玩家在哪"完全无关。
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s positioned ~ ~ ~ run function tspire:deco/boss_inscriber
kill @e[tag=tspire_boss]
# v0.7.10（玩家要求）：第 3 层 Boss 血量**随人数缩放**，但整条曲线都比原来低：
#   1 人 400 / 2 人 500 / 3 人及以上 600（原 500 / 600 / 750）。
execute if score #PARTY_SIZE tspire_timer matches ..1 run summon minecraft:illusioner ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_inscriber","tspire_mob_new","tspire_gear"],CustomName:'"铭刻者"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:400},{Name:"minecraft:generic.attack_damage",Base:7},{Name:"minecraft:generic.armor",Base:12}],Health:400f}
execute if score #PARTY_SIZE tspire_timer matches 2 run summon minecraft:illusioner ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_inscriber","tspire_mob_new","tspire_gear"],CustomName:'"铭刻者"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:500},{Name:"minecraft:generic.attack_damage",Base:7},{Name:"minecraft:generic.armor",Base:12}],Health:500f}
execute if score #PARTY_SIZE tspire_timer matches 3.. run summon minecraft:illusioner ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_inscriber","tspire_mob_new","tspire_gear"],CustomName:'"铭刻者"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:600},{Name:"minecraft:generic.attack_damage",Base:7},{Name:"minecraft:generic.armor",Base:12}],Health:600f}

execute if score #PARTY_SIZE tspire_timer matches ..1 run scoreboard players set #MAXHP tspire_timer 400
execute if score #PARTY_SIZE tspire_timer matches 2 run scoreboard players set #MAXHP tspire_timer 500
execute if score #PARTY_SIZE tspire_timer matches 3.. run scoreboard players set #MAXHP tspire_timer 600
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
# v0.7.20（玩家要求）：三层 BOSS 的装备与武器改从 **3 级材料池**抽取
#   （普通三层怪仍用 3~4 级；只有 BOSS 走这套 boss_* 表）
function tspire:mobs/equip_boss_f3
tag @e[tag=tspire_mob_new] remove tspire_mob_new

# v0.6.56（玩家要求）：幻术师只拿**原版弓**。
#   mobs/equip 会给它塞匠魂武器，这里直接覆盖成普通弓。
item replace entity @e[tag=tspire_boss_inscriber] weapon.mainhand with minecraft:bow

title @a[team=tspire_party] title {"text":"铭刻者","color":"dark_red","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ender_dragon.growl master @s ~ ~ ~ 1 1

# 抽取链短路标记：没有这一句，pick_floorN 会把三个候选依次全部生成
scoreboard players set #PICKED tspire_timer 1

# 【v0.6.40 / v0.6.56】计数器与状态复位：生命值跟踪 + 时间铭刻/铭刻逆流/遗忘蚀刻的冷却（旧的铭刻重写与强化剥离已被取代）
# 【v0.6.41】#INS_STATE_T 已删除（那个 8 秒收尾计时器会被 6 秒重掷清零、永远到不了 160）
scoreboard players set @e[tag=tspire_boss_inscriber] tspire_boss_hp 0
scoreboard players set #INS_C1 tspire_timer 0
scoreboard players set #INS_C2 tspire_timer 0
scoreboard players set #INS_C3 tspire_timer 0
scoreboard players set #INS_C4 tspire_timer 0
scoreboard players set #INS_LOOK tspire_timer 0
scoreboard players set #INS_HIT tspire_timer 0
scoreboard players set #INS_LAST tspire_timer 0
scoreboard players set #INS_N tspire_timer 0
# 【v0.7.74 按诊断数据修正】节点坐标 (0.5, 96, -387.5) 与场地中心本应重合；
#   原来的固定偏移 -3（把场地中心放到节点以北 3 格）是旧注释里"场地中心偏南 3 格"的遗留，
#   而实测中心混凝土相对抓取原点就是 (0,-1,0)（即已居中）→ 偏移应为 0。
#   沼泽猎手另计：它的中心混凝土是 (0,-1,1)，故保留 -1 抵消那 1 格源偏心。
