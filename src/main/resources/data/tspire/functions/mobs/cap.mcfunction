# ============================================================
# 计算场上敌人上限 #MOB_CAP 与当前数量 #MOB_COUNT（设计文档 §13.4 / §13.12）
# ============================================================
# 上限 = max(#CFG_MOB_CAP_BASE, #CFG_MOB_CAP_PER_PLAYER × 队伍人数)
#
# 关于刷屏：`if entity` 作为 execute 的**条件**（不带 run）不产生命令反馈，
#           所以 `execute store result ... if entity` 这种写法是安静的。
#           会刷 "Test passed" 的是带 run 的形式
#           `execute store result ... run execute if entity ...`，不要用那种。
# ============================================================

# 队伍人数（用 add 计数，静默）
scoreboard players set #PARTY_SIZE tspire_timer 0
execute as @a[team=tspire_party] run scoreboard players add #PARTY_SIZE tspire_timer 1

# 上限
scoreboard players operation #MOB_CAP tspire_timer = #PARTY_SIZE tspire_timer
scoreboard players operation #MOB_CAP tspire_timer *= #CFG_MOB_CAP_PER_PLAYER tspire_config
execute if score #MOB_CAP tspire_timer < #CFG_MOB_CAP_BASE tspire_config run scoreboard players operation #MOB_CAP tspire_timer = #CFG_MOB_CAP_BASE tspire_config

# 当前数量（只在塔维度里数）
scoreboard players set #MOB_COUNT tspire_timer 0
execute in tspire:tower store result score #MOB_COUNT tspire_timer if entity @e[tag=tspire_mob]
