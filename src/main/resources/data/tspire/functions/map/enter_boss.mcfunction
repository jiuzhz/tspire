# Boss 节点（§7.6：每层 3 个候选，随机抽 1 个）
execute as @e[tag=tspire_node_avail,tag=tspire_type_boss,distance=..3,limit=1,sort=nearest] run tag @s add tspire_node_current
execute as @e[tag=tspire_node_current] run tag @s remove tspire_node_avail

function tspire:run/battle_start
# 【v0.7.71 修"场地/ BOSS 跟着玩家位置跑"】原本是在**玩家上下文**里调用 boss/spawn，
#   而各 spawn 文件里用的是相对坐标（场地 `positioned ~ ~ ~-3`、BOSS 本体 `~ ~ ~-9`），
#   于是"玩家飞高一格，场地就高一格"。现在**锚定到当前 BOSS 节点**再调用 —— 
#   场地与 BOSS 的位置从此与玩家无关（与 arena_spawn_now 的测试路径一致）。
execute at @e[tag=tspire_node_current,limit=1] run function tspire:boss/spawn
# 【v0.7.26】Boss 战音乐：一层 mellohi / 二层 13 / 三层 pigstep（原版唱片，不需要资源包）
function tspire:music/boss_start
# 【v0.7.31】打上"这局是 Boss 战"的标记：结算时靠它推进楼层，
#   不再依赖"结算那一刻 current 还挂在 Boss 节点上"（那是"打完 Boss 不传送"的成因）
scoreboard players set #BOSS_BATTLE tspire_timer 1
