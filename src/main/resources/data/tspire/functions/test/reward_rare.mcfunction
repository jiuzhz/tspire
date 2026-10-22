# ============================================================
# 稀有奖励抽样：把随机奖励池连抽 20 次（40 项），看稀有项能否出现
# 用法：/function tspire:test/reward_rare
# ============================================================
# 权重（每次 2 项）：部件 25% / 修补件 30% / 强化水晶 30%
#                  随机装备 10% / 远古工具 2.5% / 投掷工具 2.5%
#
# 40 项里期望值：
#   强化水晶 ≈ 12 个，远古工具 ≈ 1 个，投掷工具 ≈ 1 个
# 所以「一次抽样看不到远古工具」是正常的，这里抽 20 次专门看稀有项。
# ============================================================

scoreboard players set #FLOOR tspire_timer 1

loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1
loot give @s loot tspire:rewards/battle_random_f1

tellraw @s [{"text":"[稀有抽样] ","color":"gold"},{"text":"已抽 40 项。期望：水晶约 12 个，远古工具与投掷工具各约 1 个。","color":"white"}]
tellraw @s [{"text":"想清空背包：","color":"gray"},{"text":"/clear @s","color":"yellow"}]
