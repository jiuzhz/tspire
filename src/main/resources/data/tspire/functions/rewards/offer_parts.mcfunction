# ============================================================
# 材料部件三选一（§3.3 第一类奖励 / §13.6 容器 GUI）
# ============================================================
# 【v0.6.22 重做：候选变成"看得见的具体物品"】
#   之前的候选是运行时按手持工具随机抽的，聊天菜单只能写「候选 1/2/3」，
#   玩家在选之前根本不知道有什么 —— 实测反馈就是"看不到奖励是什么"。
#   现在按 (手持工具 × 层 × 变体) **预生成**了 4 组具体候选
#   （rewards/offer_f<层>，见 tools/gen-rewards.ps1），菜单里直接写清
#   部件名与材料名。每名玩家各抽一个变体（@s tspire_ov），
#   所以两个人看到的候选不一样，各领各的。
#
#   箱子仍然锁着放在房间正中，但**只是视觉标志**（奖励走聊天菜单，
#   箱子里不再装东西，也就不存在"手快全拿"的问题）。
#
# 【领取】点菜单里的「候选 N」→ rewards/offer_take_N（N=0/1/2）：
#   置 #OFFER_SLOT=N 后再跑一次 offer_f<层>，这次不打印菜单、直接 give 那一件。
# ============================================================

# 收起上一次的宝箱（offer_clear 自带塔维度上下文）
function tspire:rewards/offer_clear

# 在房间正中放一只锁住的箱子当视觉标志
execute in tspire:tower run function tspire:rewards/offer_open

# 每个人各抽一个候选变体，然后打印"属于他自己的"菜单
# 【v0.6.44】三选一同样用 #REW_F（BOSS 房取更高一层）；这里重算一次，
#   保证宝箱房等其它入口直接调用本函数时也有值。
scoreboard players operation #REW_F tspire_timer = #FLOOR tspire_timer
execute if entity @e[tag=tspire_node_current,tag=tspire_type_boss] run scoreboard players add #REW_F tspire_timer 1
execute if score #REW_F tspire_timer matches 4.. run scoreboard players set #REW_F tspire_timer 3

scoreboard players set @a[team=tspire_party] tspire_offer 0
scoreboard players set #OFFER_SLOT tspire_timer 0

# v0.7.12 BUG FIX（玩家反馈"选的候选和给的物品不一样"）：菜单按 **#REW_F** 打印、
#   offer_take_N 原来按 **#FLOOR** 派发，BOSS 房里差一层 -> 两张表不同。
#   v0.7.16：领取端改为**用同一套算法现算 #REW_F**（不再新建计分板来存它 —— 新计分板在
#   解析期还不存在，会让 handlers 加载失败）。这里保持先算好 #REW_F，菜单就用它打印。
execute as @a[team=tspire_party] run function tspire:rewards/offer_variant
execute as @a[team=tspire_party] run function tspire:rewards/offer_sources
tellraw @a[team=tspire_party] [{"text":"[战斗奖励] ","color":"gold","bold":true},{"text":"以下三件奖励只能选择一件；点击对应候选领取。每位玩家各有自己的选项。","color":"yellow"}]
execute if score #REW_F tspire_timer matches 1 as @a[team=tspire_party] run function tspire:rewards/offer_f1
execute if score #REW_F tspire_timer matches 2 as @a[team=tspire_party] run function tspire:rewards/offer_f2
execute if score #REW_F tspire_timer matches 3 as @a[team=tspire_party] run function tspire:rewards/offer_f3
