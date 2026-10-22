# 匠魂尖塔 - 单玩家每 tick（执行者 = 玩家）
# 保持极轻：不放全实体遍历，只做状态相关的即时判定

# Reconnect correction: compare leave-game statistics only once per new login.
# Manual mode changes during a continuous session remain untouched.
execute unless score @s tspire_seenout matches 0.. if score @s tspire_logout matches 0.. run scoreboard players operation @s tspire_seenout = @s tspire_logout
execute unless score @s tspire_seenout matches 0.. run scoreboard players set @s tspire_seenout 0
execute if score @s tspire_logout > @s tspire_seenout if score #RUN_STARTED tspire_timer matches 1 if score @s tspire_phase matches 5 if score @s tspire_dead matches 0 run gamemode adventure @s
execute if score @s tspire_logout > @s tspire_seenout run scoreboard players operation @s tspire_seenout = @s tspire_logout

# --- 阵亡检测（§13.5）---

execute if score @s tspire_food_timer matches 1.. run effect give @s minecraft:saturation 1 0 true
execute if score @s tspire_food_timer matches 1.. run scoreboard players remove @s tspire_food_timer 1
# deathCount 判据由原版自动累加，捕捉到就清零并进入阵亡流程
execute if score @s tspire_deaths matches 1.. run function tspire:party/die

# --- 阵亡期间保持旁观 ---
# 只在这一条成立时才会执行：正常情况下 party/die 已经切成旁观，
# 只有玩家复活时游戏模式被重置回去才会补一刀，不会每 tick 刷命令。
execute if score @s tspire_dead matches 1.. unless entity @s[gamemode=spectator] run gamemode spectator @s

# --- 诅咒雕像：生命超过 20 时触发 ---
execute if score @s tspire_curse_greed matches 1 run function tspire:mystery/curse_tick

# --- 节点接近检测（§3.1 / §13.8）---
# 阵亡（旁观）时不触发新节点
execute if score @s tspire_dead matches 0 run function tspire:map/player_check

# --- 出图兜底（v0.6.24）---
# 本局进行中、却**不在塔维度**（最典型的就是阵亡后跑到主世界重生点），
# 立刻拉回队友身边。`/spawnpoint` 在自定义维度里并不总生效（见 MC-240812），
# 所以这里不依赖重生点，直接兜底，保证玩家永远不会被踢出这张图。
execute if score #RUN_STARTED tspire_timer matches 1 if score @s tspire_phase matches 5 unless entity @s[nbt={Dimension:"tspire:tower"}] run function tspire:party/gather

# 【v0.6.44】HUD：把本玩家的金币镜像到侧栏计分板（每人看到自己的）
scoreboard players operation @s tspire_hud_gold = @s tspire_gold
