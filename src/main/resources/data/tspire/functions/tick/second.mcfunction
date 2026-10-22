# 匠魂尖塔 - 1 秒节拍
# 由 tspire:tick 在第 20 tick 触发，执行后归零

scoreboard players set #TICK_1S tspire_timer 0
execute if score #TUTOR_BUSY tspire_timer matches 1 run function tspire:tutorial/tick

# --- 开局构筑（两拍，见 start/build 与 start/enter_draft）---
# 第 1 拍：区块加载好了，刷新整座塔并建第 1 层（不碰玩家）
execute if score #PICK_STAGE tspire_timer matches 1 run function tspire:start/build
execute if score #PICK_STAGE tspire_timer matches 8 if score #MAP_RESTART tspire_timer matches 1 if score #MAP_BUILDING tspire_timer matches 0 run function tspire:map/prepare/start
execute if score #PICK_STAGE tspire_timer matches 8 if score #MAP_READY1 tspire_timer matches 1 if score #MAP_USED tspire_timer matches 0 run function tspire:start/build_ready
# 第 2 拍：地面有了，把全队送进构筑间并弹护甲菜单
execute if score #PICK_STAGE tspire_timer matches 2 run function tspire:start/enter_draft

# --- 构筑准备卡住的看门狗 ---
# 【v0.7.59】构筑阶段正常会在 1->2->3 一拍内走完；停在中间超过 5 秒 = 出问题了，提醒玩家重进。
execute unless score #PICK_STAGE tspire_timer matches 1..2 unless score #PICK_STAGE tspire_timer matches 9 run scoreboard players set #PICK_WAIT tspire_timer 0
execute if score #PICK_STAGE tspire_timer matches 1..2 run scoreboard players add #PICK_WAIT tspire_timer 1
execute if score #PICK_STAGE tspire_timer matches 9 run scoreboard players add #PICK_WAIT tspire_timer 1
execute if score #PICK_STAGE tspire_timer matches 9 if score #PICK_WAIT tspire_timer matches 10 run tellraw @a[team=tspire_party] {"text":"[匠魂尖塔] 随机地图仍在逐行生成，请稍候。","color":"yellow"}
execute if score #PICK_STAGE tspire_timer matches 9 if score #PICK_WAIT tspire_timer matches 30 run function tspire:start/recover_map
execute if score #PICK_WAIT tspire_timer matches 5 run tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"构筑准备似乎卡住了 —— 请重新进入构筑间再试一次（若反复出现，请联系服主）。","color":"yellow"}]
execute if score #PICK_WAIT tspire_timer matches 30 run tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"仍然卡住。请把 /function tspire:test/start_check 的输出发给我。","color":"red"}]

# 新玩家通过开始游戏或中途加入按钮入队。

# --- 本局计时（结算界面用）---
execute if score #RUN_STARTED tspire_timer matches 1 run scoreboard players add @a[team=tspire_party] tspire_time 1
# 【v0.7.35】本层用时（换层时结算进 tspire_t1/t2/t3）
execute if score #RUN_STARTED tspire_timer matches 1 run scoreboard players add @a[team=tspire_party] tspire_fltime 1

# --- 援兵铁傀儡跟随（v0.7.7）---
execute if entity @e[tag=tspire_ally] run function tspire:ally/tick

# --- 商人：丢到商人 NPC 旁边的匠魂物品自动出售（v0.6.28）---
# 只在商人 NPC 附近才判定，且只收 merchant/sell_drop 价格表里的物品。
# 【v0.7.57 修"丢下不收购"】★ 真凶：这一行原来还带 `if score #RUN_STARTED tspire_timer matches 1`，
#   探针实测该计分板为 0 → **整条丢售分支从未执行**（日志里 sell_drop 触发 0 次）。
#   商人 NPC 只在局内生成，这个门槛本来就多余 → 已去掉。
# 【v0.7.10 玩家反馈"丢弃出售有概率失效"】范围 4 → **6 格**：物品落地会弹、会滑，
#   4 格在柜台前经常刚好够不着；再叠加"每秒只扫一次"，就表现成"有时收了有时没收"。
execute in tspire:tower as @e[type=minecraft:item] at @s if entity @e[tag=tspire_merchant_npc,distance=..6] run function tspire:merchant/sell_drop

# --- v0.7.10：怪物与 BOSS 一律不许捡东西 ---
#   原版骷髅会捡起地上的原版弓、僵尸/猪灵会穿上掉落的盔甲（包括带"末影清扫"的部件，
#   那会让它们被自己的装备打飞/掉出场地）。每 20 tick 覆盖一次，成本可忽略。
execute in tspire:tower as @e[tag=tspire_mob,tag=!tspire_ally] run data merge entity @s {CanPickUpLoot:0b}

# --- v0.7.11（玩家反馈）：骷髅家族手上残留的原版武器 ---
#   它们在 /summon 时就自带弓 / 石剑；mobs/equip 会替换主手，但万一那一步没生效，
#   原版武器会一直留在手上。这里每秒纠正一次（只碰这三种、且只碰"原版武器"）。
# v0.7.14 BUG：这里原来用 `execute if items` —— 那是 **1.20.5+** 的语法，1.20.1 里不存在，
#   `tick/second` 会**整个函数加载失败**（每秒节拍连同开局状态机一起停摆 -> 卡在"准备构筑间"）。
#   改用 NBT 选择器判定怪物的主手（HandItems[0]；列表必须写满两项）。
execute in tspire:tower as @e[tag=tspire_mob,type=minecraft:skeleton,nbt={HandItems:[{id:"minecraft:bow"},{}]},tag=!tspire_noweapon] run function tspire:mobs/fix_vanilla_weapon
execute in tspire:tower as @e[tag=tspire_mob,type=minecraft:stray,nbt={HandItems:[{id:"minecraft:bow"},{}]},tag=!tspire_noweapon] run function tspire:mobs/fix_vanilla_weapon
execute in tspire:tower as @e[tag=tspire_mob,type=minecraft:wither_skeleton,nbt={HandItems:[{id:"minecraft:stone_sword"},{}]},tag=!tspire_noweapon] run function tspire:mobs/fix_vanilla_weapon

# --- v0.7.22（玩家要求）：一层的**简单怪池不拿武器** ---
#   上面那条强制纠正会把"自带原版弓的骷髅"换成匠魂武器 —— 对 `tspire_noweapon`
#   的怪（一层简单池）必须反过来：**每秒把主手清空**，让它只剩原版基础攻击力。
execute in tspire:tower as @e[tag=tspire_mob,tag=tspire_noweapon] run item replace entity @s weapon.mainhand with minecraft:air

# --- v0.7.26 音乐：Boss 曲按曲长重播 + 塔内常态 BGM 的间隔计时 ---
function tspire:music/tick

# --- 重生点保活（v0.6.24）---
# /spawnpoint 在自定义维度里不总生效，而且重登 / 换维度后也可能丢。
# 每秒按当前层重设一次，确保阵亡后至少是在**这一层**的起点复活，而不是主世界。
# 【v0.6.60】Boss 单挑测试场（test/boss_arena_setup 立的 tspire_test_node）期间跳过：
#   测试场永远建在第 1 层高度（y=64），而 #FLOOR 可能是 2 或 3 —— 不跳过的话会把
#   重生点改成 y=96 / y=128 的构筑间，那些层根本没建出来，一死就掉进虚空。
execute if score #RUN_STARTED tspire_timer matches 1 in tspire:tower unless entity @e[tag=tspire_test_node] if score #FLOOR tspire_timer matches 1 as @a[team=tspire_party] run spawnpoint @s 0 64 0
execute if score #RUN_STARTED tspire_timer matches 1 in tspire:tower unless entity @e[tag=tspire_test_node] if score #FLOOR tspire_timer matches 2 as @a[team=tspire_party] run spawnpoint @s 0 96 0
execute if score #RUN_STARTED tspire_timer matches 1 in tspire:tower unless entity @e[tag=tspire_test_node] if score #FLOOR tspire_timer matches 3 as @a[team=tspire_party] run spawnpoint @s 0 128 0

# --- 阵亡旁观者跟队（v0.6.24）---
# 旁观的人如果身边 16 格内没有活着的队友（例如刚被重生点丢到奇怪的地方），
# 就把他拉到队伍身边，避免旁观时飘出地图。
execute as @a[team=tspire_party,scores={tspire_dead=1..}] at @s if score #RUN_STARTED tspire_timer matches 1 unless entity @a[team=tspire_party,scores={tspire_dead=0},nbt={Dimension:"tspire:tower"},distance=..16] run function tspire:party/gather

# --- 商人 NPC 面向最近的玩家（NoAI 不会自己转头，靠 tp 的 facing 转）---
execute in tspire:tower as @e[tag=tspire_merchant_npc] at @s if entity @p[distance=..48] run tp @s ~ ~ ~ facing entity @p


# --- HUD 刷新（每 5 秒，只在本局进行中）---
scoreboard players add #TICK_HUD tspire_timer 1
execute if score #TICK_HUD tspire_timer matches 5.. if score #RUN_STARTED tspire_timer matches 1 if entity @a[team=tspire_party] run function tspire:tick/hud

# 【v0.7.58 玩家要求】岩浆怪分裂后"算不清"的修复。
#   问题：岩浆怪死亡会分裂，而**分裂体不带任何 tag** —— 胜利判定是「场上没有 tspire_mob」，
#   于是房间明明还有分裂体，判定却认为已清空（或反之，永远打不完）。
#   做法：每秒把当前房间里没带标签的岩浆怪补上 tspire_mob / tspire_mob_new → 分裂体也算数。
# 分裂体的标签已移到 tick/tower，在 battle_tick 判胜前每 tick 补齐。

# 【v0.7.58】BOSS 血条：每秒同步一次（有 BOSS 时显示，没有就隐藏）
execute if entity @e[tag=tspire_boss] run function tspire:boss/bar
execute unless entity @e[tag=tspire_boss] run bossbar set tspire:boss visible false
