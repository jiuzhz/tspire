# ============================================================
# 匠魂尖塔 (Tinkers' Spire) - 初始化
# 执行时机：数据包 load 标签（/reload 与开服）
# 幂等：所有命令都可重复执行，不覆盖已有进度
#
# 说明：scoreboard objectives add / team add / bossbar add 在对象已存在时
#       会向日志报一条 "already exists" 错误，这是正常现象，不影响功能。
#       保留 remove+add 模式是为了让 bossbar 每次 reload 都回到干净状态。
# ============================================================

# ---------- 计分板 ----------
scoreboard objectives add tspire_gold dummy {"text":"金币"}
scoreboard objectives add tspire_phase dummy {"text":"游戏阶段"}
scoreboard objectives add tspire_layer dummy {"text":"当前层数"}
scoreboard objectives add tspire_battle dummy {"text":"本层战斗序号"}
scoreboard objectives add tspire_ready dummy {"text":"本步已就绪"}
scoreboard objectives add tspire_my_choice dummy {"text":"神秘事件选择"}
scoreboard objectives add tspire_br1 dummy
scoreboard objectives add tspire_br2 dummy
scoreboard objectives add tspire_br3 dummy
scoreboard objectives add tspire_brslot dummy
scoreboard objectives add tspire_brid1 dummy
scoreboard objectives add tspire_brid2 dummy
scoreboard objectives add tspire_brid3 dummy
scoreboard objectives add tspire_pig_run dummy
scoreboard objectives add tspire_para_run dummy
scoreboard objectives add tspire_bless_life dummy {"text":"赐福·生命之神"}
scoreboard objectives add tspire_bless_artisan dummy {"text":"赐福·工匠之神"}
scoreboard objectives add tspire_bless_war dummy {"text":"赐福·战斗之神"}
scoreboard objectives add tspire_curse_greed dummy {"text":"诅咒雕像·贪婪"}
scoreboard objectives add tspire_curse_cd dummy {"text":"诅咒雕像·凋零冷却"}
scoreboard objectives add tspire_click trigger {"text":"尖塔菜单"}
scoreboard objectives add tspire_logout minecraft.custom:minecraft.leave_game
scoreboard objectives add tspire_seenout dummy
scoreboard objectives add tspire_timer dummy {"text":"通用计时器"}
scoreboard objectives add tspire_boss_timer dummy {"text":"Boss机制计时"}
function tspire:mystery/event_cap_init
# Boss 生命值（health 判据，原版自动同步）—— 淬火者【灰烬重生】靠它判定濒死
scoreboard objectives add tspire_boss_hp health {"text":"Boss生命"}
scoreboard objectives add tspire_mob_count dummy {"text":"场上敌人计数"}
scoreboard objectives add tspire_dead dummy {"text":"阵亡标记"}
scoreboard objectives add tspire_gacha dummy {"text":"抽奖次数"}
# health 判据：原版会自动把玩家生命值同步进这个计分板，无需任何命令（也就没有命令反馈刷屏）
scoreboard objectives add tspire_hp health {"text":"生命"}
# 【v0.6.44】HUD（玩家要求）：左边侧栏显示金币，按 TAB 的玩家列表显示血量。
#   侧栏用新计分板 tspire_hud_gold（特意加 _gold，避免和 bossbar 的 tspire_hud 混淆），
#   每 tick 由 tick/player 把 @s tspire_gold 抄进去，所以每人看到的是自己的金币。
#   tspire_hp 是 health 判据计分板，挂到列表显示后会自动跟随血量。
scoreboard objectives add tspire_hud_gold dummy {"text":"金币"}
scoreboard objectives setdisplay sidebar tspire_hud_gold
scoreboard objectives setdisplay list tspire_hp
# deathCount：原版自动累加，用来可靠地捕捉"阵亡"这一瞬间
# （doImmediateRespawn 会让玩家瞬间满血复活，比血量的写法会漏掉）
scoreboard objectives add tspire_deaths deathCount {"text":"阵亡次数"}
# 开局构筑的每名玩家选择标记（0/1）与已选武器数
scoreboard objectives add tspire_arm0 dummy {"text":"已选头盔"}
scoreboard objectives add tspire_arm1 dummy {"text":"已选胸甲"}
scoreboard objectives add tspire_arm2 dummy {"text":"已选护腿"}
scoreboard objectives add tspire_arm3 dummy {"text":"已选靴子"}
scoreboard objectives add tspire_wcount dummy {"text":"已选武器数"}
scoreboard objectives add tspire_service dummy {"text":"在服务节点内"}
scoreboard objectives add tspire_w0 dummy {"text":"已选武器一"}
scoreboard objectives add tspire_w1 dummy {"text":"已选武器二"}
scoreboard objectives add tspire_w2 dummy {"text":"已选武器三"}
scoreboard objectives add tspire_w3 dummy {"text":"已选武器四"}
scoreboard objectives add tspire_w4 dummy {"text":"已选武器五"}
# 三选一奖励：每名玩家是否已经领过本次奖励（0/1），以及他抽到的候选组编号（1..4）
scoreboard objectives add tspire_offer dummy {"text":"已领奖励"}
scoreboard objectives add tspire_ov dummy {"text":"候选组"}
# v0.7.14: the reward floor the three-choose-one menu was printed with (offer_parts stores it,
#   offer_take_* reads it). It is an OBJECTIVE, not a score on tspire_timer -- the commands
#   referencing it failed to PARSE ("unknown scoreboard objective") until it was declared here,
#   which made rewards/offer_take_0/1/2 fail to load, so clicking a candidate did nothing.
scoreboard objectives add tspire_offer_f dummy {"text":"奖励层"}
# 【v0.6.29】三选一：菜单时记下的"这份奖励依据哪件装备"（Pass A 的 #SRC 存到玩家身上），
# 领奖只读它，避免玩家中途换装备导致给的东西和菜单不一致
scoreboard objectives add tspire_src dummy {"text":"奖励来源"}
# 开局构筑：每名玩家**自己那份**抽选方案（1..6），不再全队共用 #LOADOUT
scoreboard objectives add tspire_draft_l dummy {"text":"构筑方案"}
# 结算界面统计：本局用时（秒）与已通过节点数
scoreboard objectives add tspire_time dummy {"text":"用时"}
scoreboard objectives add tspire_nodes dummy {"text":"通过节点"}
scoreboard objectives add tspire_death_total dummy {"text":"本局阵亡"}
# 可调参数专用（见 config/defaults.mcfunction）
scoreboard objectives add tspire_config dummy {"text":"可调参数"}
# 商人货架：每名玩家一份**自己的**货架（floor + loadout 1..8）与购买标记
# 【v0.6.21】原来 #SHOP_F / #SHOP_L 是全局假玩家 —— 全队共用一份货架，
#   谁先买走某格别人就买不到了。现在改成挂在玩家身上。
scoreboard objectives add tspire_shop_f dummy {"text":"货架层"}
scoreboard objectives add tspire_shop_l dummy {"text":"货架编号"}
scoreboard objectives add tspire_sale_a dummy
scoreboard objectives add tspire_sale_b dummy
scoreboard objectives add tspire_buy0 dummy {"text":"已买1"}
scoreboard objectives add tspire_buy1 dummy {"text":"已买2"}
scoreboard objectives add tspire_buy2 dummy {"text":"已买3"}
scoreboard objectives add tspire_buy3 dummy {"text":"已买4"}
scoreboard objectives add tspire_buy4 dummy {"text":"已买5"}
scoreboard objectives add tspire_buy5 dummy {"text":"已买6"}
scoreboard objectives add tspire_buy6 dummy {"text":"已买7"}
scoreboard objectives add tspire_buy7 dummy {"text":"已买8"}
scoreboard objectives add tspire_buy8 dummy {"text":"已买9"}
scoreboard objectives add tspire_buy9 dummy {"text":"已买10"}
scoreboard objectives add tspire_buy10 dummy {"text":"已买11"}
scoreboard objectives add tspire_buy11 dummy {"text":"已买12"}
scoreboard objectives add tspire_buy12 dummy {"text":"已买13"}
scoreboard objectives add tspire_buy13 dummy {"text":"已买14"}
scoreboard objectives add tspire_buy14 dummy {"text":"已买15"}
# 【v0.7.35】逐人音乐开关：0/未设 = 原版唱片，1 = 资源包曲子（/function tspire:music/rp_on|off）
scoreboard objectives add tspire_music_rp dummy {"text":"音乐:资源包"}
scoreboard objectives add tspire_tutorial dummy {"text":"新手教程"}
scoreboard objectives add tspire_tut_mode dummy {"text":"教程原模式"}
# 【v0.7.35】每层用时（tspire_fltime = 当前层计时；tspire_t1..t3 = 各层最终用时，结算界面用）
scoreboard objectives add tspire_fltime dummy {"text":"本层用时"}
scoreboard objectives add tspire_t1 dummy {"text":"一层用时"}
scoreboard objectives add tspire_t2 dummy {"text":"二层用时"}
scoreboard objectives add tspire_t3 dummy {"text":"三层用时"}
# 【v0.7.35】购买次数（结算界面用）
scoreboard objectives add tspire_bought dummy {"text":"购买次数"}
# 【v0.6.27】货架"属于哪个节点"的钥匙（用节点 marker 的 z 坐标取整）：
#   换到别的商人节点要重抽，回到同一个节点则保持原样。
scoreboard objectives add tspire_shop_node dummy {"text":"货架节点"}
# 工匠节点的"融合 / 共鸣"每局各限一次
scoreboard objectives add tspire_fuse_used dummy {"text":"已融合"}
scoreboard objectives add tspire_resonate_used dummy {"text":"已共鸣"}
# 工匠节点修复：本局已修复次数 / 本次价格（价格递增，见 artisan/repair_cost）
scoreboard objectives add tspire_repairs dummy {"text":"修复次数"}
scoreboard objectives add tspire_repair_cost dummy {"text":"修复价格"}
scoreboard objectives add tspire_heals dummy {"text":"付费回血次数"}
scoreboard objectives add tspire_heal_cost dummy {"text":"回血价格"}
# 【v0.6.28】工匠节点"当前节点"钥匙（节点 marker 的 z），用来让共鸣/融合逐节点限一次
scoreboard objectives add tspire_craft_node dummy {"text":"工匠节点"}
scoreboard objectives add tspire_mire_in dummy {"text":"陷在泥沼"}
# 【v0.6.44】沼泽猎手【泥沼】的三个逐人计分板
scoreboard objectives add tspire_mud_t dummy {"text":"泥沼计时"}
scoreboard objectives add tspire_mud_imm dummy {"text":"泥沼免疫"}
scoreboard objectives add tspire_mud_in dummy {"text":"泥沼内"}
# v0.6.46: 每个工匠节点只免费回血一次用的节点钥匙
scoreboard objectives add tspire_heal_node dummy {"text":"已回血的工匠节点"}
# v0.6.54: per-player "health last tick" for the duelist bleed check
scoreboard objectives add tspire_dm_hp dummy {"text":"死斗血量记录"}
# v0.6.55: per-player 10s cooldown for the duelist bleed
scoreboard objectives add tspire_dm_cd dummy {"text":"死斗冷却"}
scoreboard objectives add tspire_food_timer dummy {"text":"饱和剩余时间"}

# ---------- 队伍（多人核心；单人局即 n = 1） ----------
team add tspire_party {"text":"尖塔队伍"}
team modify tspire_party friendlyFire false
team modify tspire_party color gold
team modify tspire_party prefix [{"text":"[尖塔] ","color":"gold"}]

# ---------- 游戏规则 ----------
gamerule naturalRegeneration false
gamerule doMobSpawning false
gamerule doMobLoot false
gamerule mobGriefing false
gamerule keepInventory true
gamerule announceAdvancements false
gamerule doDaylightCycle false
gamerule doWeatherCycle false
gamerule doImmediateRespawn true

# ---------- 常量 / 可调参数 ----------
# 所有可调数值集中在一个文件里，方便个人修改（改完 /reload 即生效）
function tspire:config/defaults

# ---------- 运行状态 ----------
# 【v0.6.18】这里**不再**清零 #RUN_STARTED / #PICK_STAGE。
#   原来每次 /reload 都会清零，等于"中途退出/重载就把本局悄悄掐死"：
#   塔、节点、装备、分数都还在，只有主循环的开关被关掉了。
#   现在这两个值只在 run/start_run（开新局）与 run/force_start（强制重开）里改，
#   所以 /reload 之后可以直接接着打完本局（§13.2 中断恢复）。
#   想彻底重开用：/function tspire:run/force_start

# ---------- HUD（bossbar 只创建一次，tick 只更新） ----------
bossbar remove tspire_hud
bossbar add tspire_hud {"text":"尖塔"}
bossbar set tspire_hud color yellow
bossbar set tspire_hud style notched_10
bossbar set tspire_hud max 20
# 默认隐藏，run/begin_run 开局时再显示；一局结束（win/lose）重新隐藏
bossbar set tspire_hud visible false
bossbar remove tspire:boss
bossbar add tspire:boss {"text":"BOSS"}
bossbar set tspire:boss color red
bossbar set tspire:boss style progress
bossbar set tspire:boss max 1000
bossbar set tspire:boss visible false

# ---------- 开局：把在线玩家纳入队伍并进入 idle ----------
scoreboard objectives add tspire_s0 dummy
scoreboard objectives add tspire_s1 dummy
scoreboard objectives add tspire_s2 dummy
scoreboard objectives add tspire_s3 dummy
scoreboard objectives add tspire_s4 dummy
scoreboard objectives add tspire_s5 dummy
scoreboard objectives add tspire_s6 dummy
scoreboard objectives add tspire_s7 dummy
scoreboard objectives add tspire_s8 dummy
scoreboard objectives add tspire_s9 dummy
scoreboard objectives add tspire_s10 dummy
scoreboard objectives add tspire_s11 dummy
scoreboard objectives add tspire_s12 dummy
scoreboard objectives add tspire_s13 dummy
scoreboard objectives add tspire_s14 dummy
scoreboard objectives add tspire_shop_anc dummy

scoreboard objectives add tspire_shop_spec dummy
# Finished runs used to leave PICK_STAGE=4 behind; treat that as idle on reload.
execute unless score #RUN_STARTED tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 4 run scoreboard players set #PICK_STAGE tspire_timer 0
execute unless score #RUN_STARTED tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 9 run function tspire:start/recover_map
execute unless score #MAP_SCHEMA tspire_timer matches 3 unless score #RUN_STARTED tspire_timer matches 1 unless score #PICK_STAGE tspire_timer matches 1.. in tspire:tower unless entity @a[team=tspire_party] run function tspire:map/prepare/start
execute unless score #RUN_STARTED tspire_timer matches 1 unless score #PICK_STAGE tspire_timer matches 1.. run team empty tspire_party
execute as @a[team=tspire_party] run function tspire:load/join

execute unless score #RUN_STARTED tspire_timer matches 1 unless score #PICK_STAGE tspire_timer matches 1.. run tellraw @a[tag=!tspire_tutorial] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"数据包已加载。是否加入尖塔队伍？ ","color":"white"},{"text":"[加入尖塔队伍]","color":"yellow","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 105"},"hoverEvent":{"action":"show_text","contents":"加入后可由任一队员点击开始游戏"}}]
execute unless score #RUN_STARTED tspire_timer matches 1 unless score #PICK_STAGE tspire_timer matches 1.. run tellraw @a[tag=!tspire_tutorial] [{"text":"[新手教程] ","color":"aqua"},{"text":"教程会按正式开局清空背包并进入构筑。 ","color":"white"},{"text":"[开始教程]","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 107"}},{"text":"  "},{"text":"[跳过教程，加入队伍]","color":"yellow","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 105"}}]
execute if score #TUTOR_BUSY tspire_timer matches 1 run tellraw @a[tag=tspire_tutorial] [{"text":"[新手教程] ","color":"aqua"},{"text":"教程仍在进行。 ","color":"white"},{"text":"[退出教程]","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 108"}}]
execute if score #RUN_STARTED tspire_timer matches 1 as @a[team=!tspire_party] run tellraw @s [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"已有一局正在进行。 ","color":"white"},{"text":"[加入这一局]","color":"yellow","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 69"},"hoverEvent":{"action":"show_text","contents":"传送到队伍身边并补发当前层装备"}},{"text":"  "},{"text":"[强制重开]","color":"yellow","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 106"},"hoverEvent":{"action":"show_text","contents":"清除当前进度，让已加入队伍的玩家重新构筑"}}]
execute if score #RUN_STARTED tspire_timer matches 1 as @a[team=tspire_party] run tellraw @s [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"已在进行中的尖塔队伍里。","color":"green"},{"text":"  "},{"text":"[强制重开]","color":"yellow","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 106"},"hoverEvent":{"action":"show_text","contents":"清除本局进度并重新构筑"}}]
execute if score #RUN_STARTED tspire_timer matches 1 unless score #TUTOR_MODE tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"[强制结束本局]","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 110"},"hoverEvent":{"action":"show_text","contents":"判定本局失败，清空装备并返回主世界"}}]
execute unless score #RUN_STARTED tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 3 unless score #TUTOR_MODE tspire_timer matches 1 run tellraw @a [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"正在选择构筑装备。 ","color":"yellow"},{"text":"[强制重开]","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 106"}}]
execute unless score #RUN_STARTED tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 3 unless score #TUTOR_MODE tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"[强制结束本局]","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 110"},"hoverEvent":{"action":"show_text","contents":"判定本局失败，清空装备并返回主世界"}}]
execute unless score #RUN_STARTED tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 3 if score #TUTOR_MODE tspire_timer matches 1 run tellraw @a[tag=tspire_tutorial] [{"text":"[新手教程] ","color":"aqua"},{"text":"正在选择构筑装备。 ","color":"yellow"},{"text":"[重新开始教程]","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 109"}}]
execute unless score #RUN_STARTED tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 1.. unless score #PICK_STAGE tspire_timer matches 3 run tellraw @a [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"构筑间正在准备，请稍候。","color":"yellow"}]


