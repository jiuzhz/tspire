# 第 2 层 Boss：织影巫师
# ============================================================
# 【v0.6.53 最终方案（玩家拍板）】织影巫师保留**唤魔者**底怪，
#   由 boss/shadowweaver 每 tick 清掉**原版 AI 召唤的**恼鬼
#   （`kill @e[type=minecraft:vex,tag=!tspire_mob]`，不会误伤我们自己的恼鬼）。
#   #CFG_WEAVER_KEEP_EVOKER：1（默认）= 唤魔者；0 = 卫道士。
#   已放弃的替代方案（代码已删）：封印 SpellTicks、NoAI + 脚本 AI。
#   它的三个机制（唤鬼 / 尖牙阵 / 暗影帷幕）全部是我们脚本驱动的，不受影响。
# ============================================================
# 数值见设计文档 §13.5；机制见 §7.6

# 【v0.7.27】Boss 场地装饰（玩家手搭；锚点 = 房间中心，必须先铺再召唤）
# 【v0.7.73 玩家要求】场地**自己锚定节点**，写法与战斗房装饰一致：
#   in tspire:tower as @e[tspire_node_current] at @s → 与"谁调用我、玩家在哪"完全无关。
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s positioned ~ ~ ~ run function tspire:deco/boss_shadowweaver
kill @e[tag=tspire_boss]

# v0.6.59（玩家要求）：Boss 血量随**队伍人数**缩放：350 / 450 / 500（1 / 2 / 3+ 人）。
#   `Base:max_health` 生成后改不了（/attribute 在本项目禁用），所以按人数选一条 summon。
# v0.7.1 修复：这两组 summon 原来**不互斥** —— 卫道士三条无条件 + 唤魔者一条只看
#   #CFG_WEAVER_KEEP_EVOKER，于是默认配置下**同一次生成会刷出两只 Boss**（两只都带
#   tspire_boss_shadowweaver，血量门与击杀判定全乱）。现在两组**按配置二选一**：
#   #CFG_WEAVER_KEEP_EVOKER=1（默认）→ 唤魔者；=0 → 卫道士。两组都按人数缩放到 350/450/500，
#   这样 #MAXHP 与 #TH_* 阈值对两种底怪都成立（旧唤魔者那条恒 500，1 人局阈值会算错）。
execute if score #CFG_WEAVER_KEEP_EVOKER tspire_config matches 0 if score #PARTY_SIZE tspire_timer matches ..1 run summon minecraft:vindicator ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_shadowweaver","tspire_mob_new","tspire_gear"],CustomName:'"织影巫师"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:350},{Name:"minecraft:generic.attack_damage",Base:6},{Name:"minecraft:generic.armor",Base:8}],Health:350f}
execute if score #CFG_WEAVER_KEEP_EVOKER tspire_config matches 0 if score #PARTY_SIZE tspire_timer matches 2 run summon minecraft:vindicator ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_shadowweaver","tspire_mob_new","tspire_gear"],CustomName:'"织影巫师"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:450},{Name:"minecraft:generic.attack_damage",Base:6},{Name:"minecraft:generic.armor",Base:8}],Health:450f}
execute if score #CFG_WEAVER_KEEP_EVOKER tspire_config matches 0 if score #PARTY_SIZE tspire_timer matches 3.. run summon minecraft:vindicator ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_shadowweaver","tspire_mob_new","tspire_gear"],CustomName:'"织影巫师"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:500},{Name:"minecraft:generic.attack_damage",Base:6},{Name:"minecraft:generic.armor",Base:8}],Health:500f}

execute if score #PARTY_SIZE tspire_timer matches ..1 run scoreboard players set #MAXHP tspire_timer 350
execute if score #PARTY_SIZE tspire_timer matches 2 run scoreboard players set #MAXHP tspire_timer 450
execute if score #PARTY_SIZE tspire_timer matches 3.. run scoreboard players set #MAXHP tspire_timer 500
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

#   NoAI 让原版 AI 彻底停摆 → 永远不会召恼鬼；转向/走位/暗影箭全由脚本驱动。
# --- 唤魔者（默认；原版恼鬼由 boss/shadowweaver 每 tick 清掉）---
# v0.7.1 修复：原来只有一条**恒定 500 血**的唤魔者 summon，而上面的 #MAXHP 是按人数写的
#   350/450/500 —— 1~2 人局里 #TH_* 阈值会与实际血量对不上（残血门提前/延后触发）。
#   现在同样按人数选一条。
execute if score #CFG_WEAVER_KEEP_EVOKER tspire_config matches 1.. if score #PARTY_SIZE tspire_timer matches ..1 run summon minecraft:evoker ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_shadowweaver","tspire_mob_new","tspire_gear"],CustomName:'"织影巫师"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:350},{Name:"minecraft:generic.attack_damage",Base:6},{Name:"minecraft:generic.armor",Base:8}],Health:350f}
execute if score #CFG_WEAVER_KEEP_EVOKER tspire_config matches 1.. if score #PARTY_SIZE tspire_timer matches 2 run summon minecraft:evoker ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_shadowweaver","tspire_mob_new","tspire_gear"],CustomName:'"织影巫师"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:450},{Name:"minecraft:generic.attack_damage",Base:6},{Name:"minecraft:generic.armor",Base:8}],Health:450f}
execute if score #CFG_WEAVER_KEEP_EVOKER tspire_config matches 1.. if score #PARTY_SIZE tspire_timer matches 3.. run summon minecraft:evoker ~ ~ ~-9 {Tags:["tspire_mob","tspire_boss","tspire_boss_shadowweaver","tspire_mob_new","tspire_gear"],CustomName:'"织影巫师"',CustomNameVisible:1b,PersistenceRequired:1b,Attributes:[{Name:"minecraft:generic.max_health",Base:500},{Name:"minecraft:generic.attack_damage",Base:6},{Name:"minecraft:generic.armor",Base:8}],Health:500f}

scoreboard players set #BOSS_TIMER tspire_timer 0
function tspire:mobs/equip_armor_only
tag @e[tag=tspire_mob_new] remove tspire_mob_new

title @a[team=tspire_party] title {"text":"织影巫师","color":"red","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ender_dragon.growl master @s ~ ~ ~ 1 1

# 抽取链短路标记：没有这一句，pick_floorN 会把三个候选依次全部生成
scoreboard players set #PICKED tspire_timer 1

# 生命值跟踪 + 尖牙阵/暗影帷幕/发光计时器
scoreboard players set @e[tag=tspire_boss_shadowweaver] tspire_boss_hp 0
scoreboard players set #WEA_C1 tspire_timer 0
scoreboard players set #WEA_VEIL tspire_timer 0
scoreboard players set #WEA_C2 tspire_timer 0
scoreboard players set #WEA_GLOW tspire_timer 0
# 清掉可能残留在场上的原版尖牙（换底怪前后都安全）
kill @e[type=minecraft:evoker_fangs]
# 【v0.7.74 按诊断数据修正】节点坐标 (0.5, 96, -387.5) 与场地中心本应重合；
#   原来的固定偏移 -3（把场地中心放到节点以北 3 格）是旧注释里"场地中心偏南 3 格"的遗留，
#   而实测中心混凝土相对抓取原点就是 (0,-1,0)（即已居中）→ 偏移应为 0。
#   沼泽猎手另计：它的中心混凝土是 (0,-1,1)，故保留 -1 抵消那 1 格源偏心。
