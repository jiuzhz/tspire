# ============================================================
# 构筑完毕，正式开始爬塔（由 run/confirm_weapons 调用）
# ============================================================
# 第 1 层的场景在 start/prep 里已经建好了，这里只负责推进状态机。
# ============================================================

scoreboard players set #PICK_STAGE tspire_timer 4
scoreboard players set #RUN_STARTED tspire_timer 1

scoreboard players set @a[team=tspire_party] tspire_phase 5

# v0.7.18 BUG FIX（玩家反馈"上一局的赐福带进了下一局"）：赐福的三个标记从来没有归零过，
#   于是【赐福】选的"生命 / 工匠 / 战斗之神"会一直生效到下一局。开局这里统一清零。
scoreboard players set @a[team=tspire_party] tspire_bless_life 0
scoreboard players set @a[team=tspire_party] tspire_bless_artisan 0
scoreboard players set @a[team=tspire_party] tspire_bless_war 0

# HUD 打开，并立刻刷一次（不用等 5 秒节拍）
bossbar set tspire_hud visible true
scoreboard players set #TICK_HUD tspire_timer 4
function tspire:tick/hud

title @a[team=tspire_party] title {"text":"第 1 层 · 腐林","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"往北走，进入第一个节点","color":"gray"}
execute as @a[team=tspire_party] at @s run playsound minecraft:block.beacon.activate master @s ~ ~ ~ 1 1

tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"一局开始。","color":"white"},{"text":"往北走进节点；同一个房间里只能选一条路。","color":"gray"}]

# 告诉玩家房间正中那块彩色地砖代表什么
tellraw @a[team=tspire_party] [{"text":"节点颜色：","color":"gray"},{"text":"红=战斗","color":"red"},{"text":"　"},{"text":"紫=精英","color":"light_purple"},{"text":"　"},{"text":"青=神秘","color":"aqua"},{"text":"　"},{"text":"橙=工匠","color":"gold"},{"text":"　"},{"text":"黄=宝箱","color":"yellow"},{"text":"　"},{"text":"绿=商人","color":"green"},{"text":"　"},{"text":"黑=Boss","color":"dark_gray"}]
tellraw @a[team=tspire_party] [{"text":"每层只能沿一条路线走：走进一个房间后，同一行其余的房门会被封死。","color":"gray"}]
execute if score #TUTOR_MODE tspire_timer matches 1 run function tspire:tutorial/after_build
