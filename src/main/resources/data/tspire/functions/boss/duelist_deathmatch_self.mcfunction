# ============================================================
# 钴蓝决斗者【死斗】· v0.6.55 按玩家掉血判定（执行者 = 玩家）
# ============================================================
# 玩家最终规格：**玩家血量降低** 且 **3 格内有 BOSS** → 该玩家流血 3 秒；
#   触发后 **10 秒内**不再触发（逐人冷却）。
# 实现：逐 tick 用 `data get` 读自己的 Health 与上一 tick 比较（1.20.1 没有命中事件）。
# 分数：@s tspire_dm_hp（上一 tick 血量）、@s tspire_dm_cd（冷却剩余 tick，200 = 10 秒）。
# ============================================================

execute store result score #DM_PNOW tspire_timer run data get entity @s Health 1

# 兜底初始化（中途进队的人没有分数，选择器就匹配不上）
scoreboard players add @s tspire_dm_hp 0
scoreboard players add @s tspire_dm_cd 0

# 冷却递减
execute if score @s tspire_dm_cd matches 1.. run scoreboard players remove @s tspire_dm_cd 1

# 掉血 + 3 格内有 BOSS + 不在冷却 → 流血 3 秒并进入 10 秒冷却
execute if score #DM_PNOW tspire_timer < @s tspire_dm_hp if entity @e[tag=tspire_boss_duelist,distance=..3] if score @s tspire_dm_cd matches 0 run effect give @s tconstruct:bleeding 3 0 true
execute if score #DM_PNOW tspire_timer < @s tspire_dm_hp if entity @e[tag=tspire_boss_duelist,distance=..3] if score @s tspire_dm_cd matches 0 run scoreboard players set @s tspire_dm_cd 200
execute if score #DM_PNOW tspire_timer < @s tspire_dm_hp if entity @e[tag=tspire_boss_duelist,distance=..3] if score @s tspire_dm_cd matches 200 run title @s actionbar {"text":"【死斗】近身受伤 —— 流血 3 秒（10 秒内不会再触发）","color":"dark_red","bold":true}
execute if score #DM_PNOW tspire_timer < @s tspire_dm_hp if entity @e[tag=tspire_boss_duelist,distance=..3] if score @s tspire_dm_cd matches 200 at @s run particle minecraft:enchanted_hit ~ ~1 ~ 0.5 0.6 0.5 0.08 12 force

# 记录本 tick 血量
scoreboard players operation @s tspire_dm_hp = #DM_PNOW tspire_timer
