# ============================================================
# 玩家阵亡（由 tick/player 依据 deathCount 判据触发，执行者 = 阵亡者）
# ============================================================
# 设计（§13.5 + 用户决定）：阵亡 -> 旁观，战斗结束后自动复活，只保留部分生命。
# 用 deathCount 而不是每 tick 比对血量：doImmediateRespawn 会让玩家瞬间满血复活，
# 血量判据很容易漏掉死亡这一瞬间。
# ============================================================

scoreboard players set @s tspire_deaths 0
# 结算界面用的"本局阵亡次数"（tspire_deaths 是会被清零的一次性触发器，不能当计数用）
scoreboard players add @s tspire_death_total 1
scoreboard players set @s tspire_dead 1

gamemode spectator @s
effect clear @s

# 【v0.6.24】旁观时立刻跟到队友身边。
# 不这么做的话：doImmediateRespawn 会先把人塞到重生点，而 /spawnpoint 在自定义
# 维度里不总生效（MC-240812），实测会**掉回主世界**；就算生效也会落在层起点，
# 离队友很远、看不到战况。
function tspire:party/gather

title @s title {"text":"你倒下了","color":"red","bold":true}
title @s subtitle {"text":"战斗结束后自动复活","color":"gray"}
playsound minecraft:entity.player.death master @s ~ ~ ~ 1 1

tellraw @a[team=tspire_party] [{"text":"[尖塔] ","color":"gold"},{"selector":"@s","color":"red"},{"text":" 倒下了，正在旁观。","color":"gray"}]

# 全队阵亡 -> 本局失败
execute unless entity @a[team=tspire_party,scores={tspire_dead=0}] run function tspire:run/lose
