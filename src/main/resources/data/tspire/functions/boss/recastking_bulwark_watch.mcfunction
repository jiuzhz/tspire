# 【金铸壁垒】· 6 秒观察窗口（每 tick，只在 #RK_LOOK ≥ 1 时调用）
# 逐 tick 用血量差累计 BOSS 受到的伤害到 #RK_DMG（以**半颗心**为单位：12 = 6 点）；
# 判定口径 = **BOSS 血量掉 6 点**（姿态期它的抗性提升 IV 保留，所以外面要打出更多输出）；
# 窗口归零时按 ≥8 / <8 分支。
# v0.7.19：scale 从 1 改成 2 —— 原来每次不足 1 点的血量损失会被直接截掉，
#   小刀/持续伤害几乎算不进去。改完阈值跟着 ×2（6 点 = 12）。
execute store result score #RK_NOW tspire_timer run data get entity @e[tag=tspire_boss_recastking,limit=1] Health 2
execute if score #RK_NOW tspire_timer < #RK_LAST tspire_timer run scoreboard players operation #RK_TMP tspire_timer = #RK_LAST tspire_timer
execute if score #RK_NOW tspire_timer < #RK_LAST tspire_timer run scoreboard players operation #RK_TMP tspire_timer -= #RK_NOW tspire_timer
execute if score #RK_NOW tspire_timer < #RK_LAST tspire_timer run scoreboard players operation #RK_DMG tspire_timer += #RK_TMP tspire_timer
scoreboard players operation #RK_LAST tspire_timer = #RK_NOW tspire_timer

execute if score #RK_LOOK tspire_timer matches 1.. run title @a[team=tspire_party] actionbar {"text":"【金铸壁垒】防御姿态中 —— 打满 6 点伤害可压住它","color":"gold","bold":true}

# 【v0.7.10 玩家要求】打满 6 点就**立刻结算**（与铭刻者【铭刻逆流】同一套做法），
#   不再等 8 秒窗口走完 —— 否则"打穿了还要站着等"手感很怪。
execute if score #RK_DMG tspire_timer matches 12.. run function tspire:boss/recastking_bulwark_end
execute if score #RK_DMG tspire_timer matches 12.. run scoreboard players set #RK_LOOK tspire_timer 0

execute if score #RK_LOOK tspire_timer matches 1.. run scoreboard players remove #RK_LOOK tspire_timer 1
# 注意：上面"打满即结算"那一拍已经把 #RK_LOOK 清零了，本行必须排除它，
#   否则同一 tick 会把 bulwark_end 跑第二遍（多召 2 只猪灵蛮兵）。
execute if score #RK_LOOK tspire_timer matches 0 if score #RK_DMG tspire_timer matches ..11 run function tspire:boss/recastking_bulwark_end
