# ============================================================
# 钴蓝决斗者【破釜】· 每 15 秒随机获得一种强化（原【崩刃】）
# ============================================================
# 玩家指定（v0.7.2 调时长）：每 15 秒，随机获得 6 秒速度 II / 9 秒抗性提升 / 6 秒力量，
#   每种都要有提示。
# 掷骰：均匀 1..3（用 tspire:roll/d3→d2 链，每档条件概率 1/3）。
#   · 抗性提升 = 抗性提升 I（amplifier 0）
#   · 力量     = 力量 I（amplifier 0）
#   （"速度 2" 玩家写明了等级，另两个没写，按 1 级算。）
# ============================================================

scoreboard players set #DUE_C1 tspire_timer 0

# 均匀掷 1..3
scoreboard players set #ALLIN tspire_timer 0
execute if score #ALLIN tspire_timer matches 0 if predicate tspire:roll/d3 run scoreboard players set #ALLIN tspire_timer 3
execute if score #ALLIN tspire_timer matches 0 if predicate tspire:roll/d2 run scoreboard players set #ALLIN tspire_timer 2
execute if score #ALLIN tspire_timer matches 0 run scoreboard players set #ALLIN tspire_timer 1

# --- 1 速度 II 8 秒 ---
execute if score #ALLIN tspire_timer matches 1 run effect give @e[tag=tspire_boss_duelist,limit=1] minecraft:speed 6 1 true
execute if score #ALLIN tspire_timer matches 1 run title @a[team=tspire_party] actionbar {"text":"【破釜】决斗者获得了速度 II（6 秒）！","color":"aqua","bold":true}
execute if score #ALLIN tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"[钴蓝决斗者] ","color":"aqua","bold":true},{"text":"破釜 · 速度","color":"gold","bold":true},{"text":"获得速度 II，持续 6 秒 —— 它会追得很凶。","color":"yellow"}]

# --- 2 抗性提升 I 12 秒 ---
execute if score #ALLIN tspire_timer matches 2 run effect give @e[tag=tspire_boss_duelist,limit=1] minecraft:resistance 9 0 true
execute if score #ALLIN tspire_timer matches 2 run title @a[team=tspire_party] actionbar {"text":"【破釜】决斗者获得了抗性提升（9 秒）！","color":"white","bold":true}
execute if score #ALLIN tspire_timer matches 2 run tellraw @a[team=tspire_party] [{"text":"[钴蓝决斗者] ","color":"aqua","bold":true},{"text":"破釜 · 抗性提升","color":"gold","bold":true},{"text":"获得抗性提升 I，持续 9 秒 —— 这段时间输出打折。","color":"yellow"}]

# --- 3 力量 I 6 秒 ---
execute if score #ALLIN tspire_timer matches 3 run effect give @e[tag=tspire_boss_duelist,limit=1] minecraft:strength 6 0 true
execute if score #ALLIN tspire_timer matches 3 run title @a[team=tspire_party] actionbar {"text":"【破釜】决斗者获得了力量（6 秒）！","color":"red","bold":true}
execute if score #ALLIN tspire_timer matches 3 run tellraw @a[team=tspire_party] [{"text":"[钴蓝决斗者] ","color":"aqua","bold":true},{"text":"破釜 · 力量","color":"gold","bold":true},{"text":"获得力量 I，持续 6 秒 —— 别硬接。","color":"yellow"}]

# 共同表现
execute at @e[tag=tspire_boss_duelist,limit=1] run particle minecraft:enchant ~ ~1 ~ 0.8 1 0.8 0.5 30 force
execute at @e[tag=tspire_boss_duelist,limit=1] run particle minecraft:crit ~ ~1 ~ 0.6 0.8 0.6 0.3 20 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.player.attack.crit master @s ~ ~ ~ 1 1.3
