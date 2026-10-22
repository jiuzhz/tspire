# ============================================================
# 开始一局的主体（由 run/start 在确认可以开局后调用）
# ============================================================
# 两步构筑（设计文档 §2.1）：
#   步骤一  护甲：4 个部位 × 3 种套装，**同一次界面里各选一件**
#   步骤二  武器：五件里选两件
# 两者都在塔内的「构筑间」完成，界面用可点击聊天（§13.6 的容器 GUI 版见 gui/pick_armor）。
#
# 【为什么不在这里传送】塔里这时还是空的。tp 进去玩家会直接掉进虚空，
#   一秒后再建地面已经来不及了。所以拆成两拍（见 tick/second）：
#     #PICK_STAGE = 1  只做 forceload，开始建场景
#     #PICK_STAGE = 2  地面好了，才把全队送进构筑间并弹菜单
# ============================================================

# 开始构筑前就关闭本局指令反馈，避免开局准备过程刷出函数调试信息。
execute if score #CFG_HIDE_FEEDBACK tspire_config matches 1 run gamerule sendCommandFeedback false
function tspire:map/runtime/cancel

# 1) 前置：确保在线玩家都在队伍里
# v0.6.59（玩家要求）：开局清理上一局的显示数据。
#   `tspire_hud_gold` 是按"分数持有者"显示的，离线玩家会一直挂着上一局的金币，
#   所以先 reset * 抹掉所有持有者（在线的人下一 tick 会被 tick/player 重新写回来）。
scoreboard players reset * tspire_hud_gold
# 队伍人数按**当前在线**队员重算（离线不计入，Boss 血量才不会按旧人数算）
scoreboard players set #PARTY_SIZE tspire_timer 0
# 【v0.7.26】音乐计时器：开局没有 Boss 曲；常态 BGM 60 秒后先来一首（之后 8~10 分钟一首）
scoreboard players set #MUSIC_BOSS tspire_timer 0
scoreboard players set #MUSIC_T tspire_timer 0
scoreboard players set #MUSIC_AMB tspire_timer 60
# 【v0.7.31】Boss 战标记归零（进 Boss 房时置 1，结算时消费掉）
scoreboard players set #BOSS_BATTLE tspire_timer 0
execute unless entity @s[team=tspire_party] run function tspire:load/join
execute store result score #PARTY_SIZE tspire_timer if entity @a[team=tspire_party]

# 2) 重置每名队员的本局状态
scoreboard players add #RUN_ID tspire_timer 1
function tspire:mystery/event_cap_reset
execute as @a[team=tspire_party] run function tspire:run/reset_player

# 3) 先清空背包（把上一局的残留、外面的杂物一并清掉），再发物资
clear @a[team=tspire_party]

# 4) 发放开局物资（§2.4）
scoreboard players set @a[team=tspire_party] tspire_phase 1
function tspire:run/give_kit

# 5) 本局计数归零
scoreboard players set #FLOOR tspire_timer 1
scoreboard players set #BATTLE tspire_timer 0
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #BATTLE_TIMER tspire_timer 0
scoreboard players set #BOSS_TIMER tspire_timer 0
scoreboard players set #ELITE tspire_timer 0
scoreboard players set #RUN_STARTED tspire_timer 0
scoreboard players set #FORCE_END tspire_timer 0
# 构筑阶段先收起 HUD，begin_run 里再打开
bossbar set tspire_hud visible false

# 5) 塔的区块常驻加载（远端 fill 才不会静默失败），但不传送
# A forced restart may be launched while party members stand inside the old
# tower. Hold those players above the three floor volumes during staged reset.
execute in tspire:tower run fill -4 200 6 4 200 14 minecraft:bedrock
execute in tspire:tower run fill -4 201 6 4 203 6 minecraft:barrier
execute in tspire:tower run fill -4 201 14 4 203 14 minecraft:barrier
execute in tspire:tower run fill -4 201 7 -4 203 13 minecraft:barrier
execute in tspire:tower run fill 4 201 7 4 203 13 minecraft:barrier
execute in tspire:tower as @a[team=tspire_party] run tp @s 0 201 10
execute in tspire:tower unless entity @e[tag=tspire_anchor] run summon minecraft:marker 0 64 0 {Tags:["tspire_anchor"]}
# map/prepare/start loads this region one chunk row per tick.

scoreboard players set #MAP_RETRIES tspire_timer 0
scoreboard players set #PICK_STAGE tspire_timer 1
schedule clear tspire:run/next_floor_build
schedule clear tspire:run/next_floor_finish
schedule clear tspire:map/build_row_1
schedule clear tspire:map/build_row_2
schedule clear tspire:map/build_row_3
schedule clear tspire:map/build_row_4
schedule clear tspire:map/build_row_5
schedule clear tspire:map/build_row_6
schedule clear tspire:map/build_row_7
schedule clear tspire:map/build_row_8
schedule clear tspire:map/build_row_9
schedule clear tspire:map/build_row_10
schedule clear tspire:map/build_row_11
schedule clear tspire:map/build_row_12
schedule clear tspire:map/build_row_13
schedule clear tspire:map/build_row_14
schedule clear tspire:map/build_row_15
schedule clear tspire:map/build_row_16
scoreboard players set @a[team=tspire_party] tspire_phase 2

tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"正在准备构筑间……","color":"gray"}]

# 【v0.7.52 玩家要求 / 同时修「精英房瞬间通关」】开局清一次场内实体。
#   为什么：商人 NPC / 援兵铁傀儡 / 掉落物 / 经验球 / 残留召唤物都会计入**出怪上限**；
#   上限被占满时战斗会「一只怪都不生成」，而胜利判据（1 秒无怪即胜）立刻成立 → 房间瞬间完成。
#   刻意不动的：盔甲架 / 展示框 / 画 —— 那些是玩家手搭装饰的组成部分（伪装者的道具架另有专门清理）。
execute in tspire:tower run kill @e[type=minecraft:item]
execute in tspire:tower run kill @e[type=minecraft:experience_orb]
execute in tspire:tower run kill @e[type=minecraft:villager]
execute in tspire:tower run kill @e[type=minecraft:iron_golem]
execute in tspire:tower run kill @e[type=minecraft:snow_golem]
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_ally]
execute in tspire:tower run kill @e[tag=tspire_boss]
