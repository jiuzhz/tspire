# ============================================================
# 生成当前层的节点地图 + 场景（设计文档 §3.1 / §3.5）
# 前置：#FLOOR 已设好（1..3）
#
# 【为什么要有专属维度】
#   猪灵在非下界维度 15 秒后必然僵尸化。1.20.1 的原版逻辑读的是
#   dimension_type 的 piglin_safe：下界为 true、主世界为 false。
#   所以塔必须跑在自己的维度里（data/tspire/dimension_type/tower.json
#   设了 piglin_safe: true），否则猪灵/猪灵蛮兵一律会变成僵尸猪灵。
#   顺带的好处：塔不会破坏主世界地形，玩家也能从主世界随时回来。
#
# 地形锚点：塔维度里的固定点 (0, 64, 0)。三层用 Y 轴 +0/+32/+64 错开。
#
# 生成顺序：
#   1. 清掉上一层的 marker
#   2. 固定大厅由 map/prepare 提前分批准备，本函数抽取运行时路线
#   3. 放节点 marker 与地砖，随后按行调度房间建造
#
# 注意：本函数必须在**玩家已经在塔维度里之后**调用，
#       否则目标区块没加载，fill / setblock 会静默失败（看起来"什么都没建"）。
#       调用方见 run/start_run 与 tick/second 的两段式流程。
# ============================================================

# 地形锚点（只在塔维度里存在一次）
execute in tspire:tower unless entity @e[tag=tspire_anchor] run summon minecraft:marker 0 64 0 {Tags:["tspire_anchor"]}

# 【关键】必须 `execute in tspire:tower`：本函数常从 tick/second（主世界身份）调用，
# 不加维度前缀的话 @e 是在主世界找，塔里的旧 marker 一个都清不掉，
# 新地图的 marker 就叠在旧的上，build_rooms 会给两套都挖房间 -> 一行出现 5~7 个房间。
execute in tspire:tower run kill @e[tag=tspire_node]
# 顺手清掉上一局的其他残留
execute in tspire:tower run kill @e[tag=tspire_starter]
execute in tspire:tower run kill @e[tag=tspire_shop]
execute in tspire:tower run kill @e[tag=tspire_offer]
execute in tspire:tower run kill @e[tag=tspire_merchant_npc]

# 固定大厅已由 map/prepare 在玩家到达本层前准备。
scoreboard players set #MAP_USED tspire_timer 1

# 每层使用运行时随机地图。
function tspire:map/runtime/cancel
function tspire:map/runtime/start
