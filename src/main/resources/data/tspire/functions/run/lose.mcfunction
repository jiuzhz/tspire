# ============================================================
# 全队阵亡 -> 本局失败（§13.5 的多人分支 / 单人局下等于"你一死就结束"）
# ============================================================
# 单人局说明：没有队友能替你打完，所以阵亡即失败。
# 想改成"阵亡后原地复活继续"的话，改 party/revive_self 并去掉这里的判负。
# ============================================================

scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #BOSS_ACTIVE tspire_timer 0

execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_boss]

# 把旁观者放回生存，方便重开
execute as @a[team=tspire_party] run gamemode survival @s
scoreboard players set @a[team=tspire_party] tspire_phase 6
scoreboard players set @a[team=tspire_party] tspire_dead 0
scoreboard players set #RUN_STARTED tspire_timer 0
scoreboard players set #PICK_STAGE tspire_timer 0
bossbar set tspire_hud visible false

execute unless score #FORCE_END tspire_timer matches 1 run title @a[team=tspire_party] title {"text":"全军覆没","color":"red","bold":true}
execute if score #FORCE_END tspire_timer matches 1 run title @a[team=tspire_party] title {"text":"本局失败","color":"red","bold":true}
execute unless score #FORCE_END tspire_timer matches 1 run title @a[team=tspire_party] subtitle {"text":"本局结束","color":"gray"}
execute if score #FORCE_END tspire_timer matches 1 run title @a[team=tspire_party] subtitle {"text":"主动结束","color":"gray"}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.wither.death master @s ~ ~ ~ 0.7 1

# 结算界面
scoreboard players set #RESULT tspire_timer 0
function tspire:run/summary
execute if score #TUTOR_MODE tspire_timer matches 1 as @a[tag=tspire_tutorial] run function tspire:tutorial/exit
execute if score #TUTOR_MODE tspire_timer matches 1 unless entity @a[tag=tspire_tutorial] run function tspire:tutorial/cleanup

# 结算文字已发送，再退出队伍；下一局须主动加入。
scoreboard players set @a[team=tspire_party] tspire_deaths 0
tag @a[tag=tspire_revive_pending] remove tspire_revive_pending
team leave @a[team=tspire_party]

