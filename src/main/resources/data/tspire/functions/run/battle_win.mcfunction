# ============================================================
# 战斗胜利结算
# ============================================================

scoreboard players set #BATTLE_ACTIVE tspire_timer 0

# 兜底清理（唤魔者/织影巫师这类会持续召唤，可能留下残留）
kill @e[tag=tspire_mob]
# v0.6.51: also clear the 裂颅者 volley arrows (they used to linger until vanilla despawn)
kill @e[tag=tspire_arrow]
# v0.6.58：熔核暴君现在用**真火焰方块**，必须把整个房间范围的 fire 清掉
#   （`air replace minecraft:fire` 只动火焰，地板与其它方块不受影响）。
execute in tspire:tower at @e[tag=tspire_node_current,limit=1] run fill ~-8 ~-1 ~-8 ~8 ~4 ~8 minecraft:air replace minecraft:fire
# v0.6.57：熔核暴君的火焰标记与护体岩浆怪（否则残留会影响下一场）
kill @e[tag=tspire_lava]
kill @e[tag=tspire_fz1]
kill @e[tag=tspire_fz2]
kill @e[tag=tspire_fz3]
kill @e[tag=tspire_fz4]
kill @e[tag=tspire_fz5]
kill @e[tag=tspire_mcube]

# 【v0.6.30】淬火者【燃烧蓄能】如果在燃烧阶段被打死，火焰会留在房间里 —— 这里统一收摊
function tspire:boss/quencher_zone_end

# 【v0.7.26】Boss 战音乐收摊（战斗胜利就掐掉；#MUSIC_BOSS 归零后常态 BGM 才重新倒数）
function tspire:music/boss_stop

# 开门
function tspire:terrain/unlock

# 即时反馈
title @a[team=tspire_party] actionbar {"text":"战斗胜利","color":"green","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.player.levelup master @s ~ ~ ~ 0.8 1

# 发奖励（§3.3）：rewards/battle → 按层抽 battle_random_f1/f2/f3（权重 298 部件 / 348 水晶 / 151 装备 / 191 特殊 / 6 远古 / 6 投掷）
function tspire:rewards/battle
execute if score #TUTOR_MODE tspire_timer matches 1 run tellraw @a[tag=tspire_tutorial] [{"text":"[教程 · 战斗奖励] ","color":"aqua"},{"text":"金币和随机奖励已发放；聊天栏中的三个部件只能选一个，选好后再去绿色商人房。","color":"white"}]

# 复活阵亡队员（§13.5：战后免费复活，只保留部分生命）
function tspire:party/revive

# 完成当前节点并解锁下一行（在竞技场演示里没有 current 节点，会自动空跑）
function tspire:map/complete_node
