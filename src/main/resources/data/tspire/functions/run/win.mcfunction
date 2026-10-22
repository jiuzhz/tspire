# 通关：第 3 层最终 Boss 被击败
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #BOSS_ACTIVE tspire_timer 0
scoreboard players set #RUN_STARTED tspire_timer 0
scoreboard players set #PICK_STAGE tspire_timer 0
scoreboard players set @a[team=tspire_party] tspire_phase 6
bossbar set tspire_hud visible false
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_boss]
# 收掉还挂着的奖励箱
# 【v0.7.35】通关：把第三层用时也存上，结算界面会读
execute as @a[team=tspire_party] run scoreboard players operation @s tspire_t3 = @s tspire_fltime
function tspire:rewards/offer_clear
# 【v0.7.26】通关也把 Boss 音乐收掉
function tspire:music/boss_stop

title @a[team=tspire_party] title {"text":"通关！","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"三层塔已被攻克","color":"yellow"}
execute as @a[team=tspire_party] at @s run playsound minecraft:ui.toast.challenge_complete master @s ~ ~ ~ 1 1

# 结算界面
scoreboard players set #RESULT tspire_timer 1
function tspire:run/summary

# 结算文字已发送，再退出队伍；下一局须主动加入。
scoreboard players set @a[team=tspire_party] tspire_deaths 0
tag @a[tag=tspire_revive_pending] remove tspire_revive_pending
team leave @a[team=tspire_party]

