# ============================================================
# 淬火者【燃烧蓄能】—— 状态机（每 tick，由 boss/tick 调用）
# ============================================================
# #QZ  0 = 空闲  1 = 前摇（2 秒）  2 = 燃烧（3 秒）
# #QZ_T 当前阶段已经过了多少 tick
# 圆心 = tspire_firez marker —— 【v0.6.31】每名玩家各一个，位置只在发动瞬间取一次，
#        之后整个技能都围绕这些固定圆心，玩家跑开也不会跟着走。
# ============================================================

# ---------- 阶段 1：前摇 2 秒 ----------
execute if score #QZ tspire_timer matches 1 run scoreboard players add #QZ_T tspire_timer 1
execute if score #QZ tspire_timer matches 1 as @e[tag=tspire_firez] at @s run function tspire:boss/ring5
execute if score #QZ tspire_timer matches 1 run title @a[team=tspire_party] actionbar {"text":"⚠ 【燃烧蓄能】2 秒后此处起火 —— 离开圈内！","color":"yellow","bold":true}
execute if score #QZ tspire_timer matches 1 if score #QZ_T tspire_timer matches 40.. run function tspire:boss/quencher_zone_ignite

# ---------- 阶段 2：燃烧 3 秒（粒子 2 秒 + 伤害 3 秒） ----------
execute if score #QZ tspire_timer matches 2 run scoreboard players add #QZ_T tspire_timer 1
execute if score #QZ tspire_timer matches 2 run tag @a[team=tspire_party] remove tspire_burn_hit
execute if score #QZ tspire_timer matches 2 as @e[tag=tspire_firez] at @s run function tspire:boss/quencher_zone_burn
execute if score #QZ tspire_timer matches 2 if score #QZ_T tspire_timer matches 60.. run function tspire:boss/quencher_zone_end
