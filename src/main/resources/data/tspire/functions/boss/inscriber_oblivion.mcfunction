# 铭刻者【遗忘蚀刻】—— HP ≤ 50%（`#TH_HALF`，随人数 200 / 250 / 300）后每 65 秒（v0.7.89）
# 按**场上在场**的存活队员数分支（`tspire_dead=0`，且以房间中心为圆心、半径 16 格内）：
#   1 人  → 该玩家 8 秒黑暗 + 8 秒虚弱
#   2 人  → 所有玩家 10 秒黑暗 + 10 秒虚弱
#   3+ 人 → **一名**玩家（最近的）8 秒反重力（tconstruct:antigravity），
#           其他玩家 10 秒黑暗 + 10 秒虚弱
# 黑暗 = 原版 `minecraft:darkness`（玩家确认）。

scoreboard players set #INS_C4 tspire_timer 0
# v0.7.19 修复 + 玩家要求（口径改成"场上真正在场的队员"）：
#   ① 原来写的是 `execute store result score #INS_N tspire_timer if entity @a[team=tspire_party,…]`
#      —— `if entity` 的结果是 **0/1 布尔值**（"有没有人匹配"）而不是人数，且条件不成立时
#      store **根本不写入**（分数留旧值）；所以场上有 1 个活人 #INS_N 就恒为 1，
#      **1 人档永远触发、2 人档与 3+ 人档一次都跑不到**。
#      （真正的计数写法：让 `as` 对每名玩家各执行一次 add。）
#   ② 口径（玩家要求）：只数**在房间里真正在场**的存活队员 —— 以房间中心为圆心、半径 16 格。
#      这样"多人局打到只剩一个人"时他走的是 **1 人档（黑暗 8 秒 + 虚弱 8 秒）**，
#      **不会**再吃到 3+ 人档的反重力（反重力只有"场上真的有 3 个以上人"时才可能出现）。
#   ③ 锚点缺失（理论上不会发生）时退回"存活队员数"，避免整条机制哑火。
scoreboard players set #INS_N tspire_timer 0
execute in tspire:tower at @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] as @a[team=tspire_party,scores={tspire_dead=0},distance=..16] run scoreboard players add #INS_N tspire_timer 1
execute in tspire:tower unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable] as @a[team=tspire_party,scores={tspire_dead=0}] run scoreboard players add #INS_N tspire_timer 1

# --- 1 人 ---
execute if score #INS_N tspire_timer matches 1 as @a[team=tspire_party,scores={tspire_dead=0}] run effect give @s minecraft:darkness 8 0 true
execute if score #INS_N tspire_timer matches 1 as @a[team=tspire_party,scores={tspire_dead=0}] run effect give @s minecraft:weakness 8 0 true
execute if score #INS_N tspire_timer matches 1 at @e[tag=tspire_boss_inscriber,limit=1] run title @a[team=tspire_party] title {"text":"遗忘蚀刻","color":"dark_gray","bold":true}

# --- 2 人 ---
execute if score #INS_N tspire_timer matches 2 as @a[team=tspire_party,scores={tspire_dead=0}] run effect give @s minecraft:darkness 10 0 true
execute if score #INS_N tspire_timer matches 2 as @a[team=tspire_party,scores={tspire_dead=0}] run effect give @s minecraft:weakness 10 0 true
execute if score #INS_N tspire_timer matches 2 run title @a[team=tspire_party] title {"text":"遗忘蚀刻","color":"dark_gray","bold":true}

# --- 3 人及以上（**场上在场** ≥3 人）：一人反重力，其余黑暗 + 虚弱 ---
#   只剩 1~2 人时不会走这条（多人局打到只剩一个人 → 走上面 1 人档，吃黑暗 8 秒）
# v0.6.60 修正：旧写法用"离 Boss 1.5 格"反选"其他人"，一旦被选中的人离 Boss 超过 1.5 格，
#   他会**同时**吃到反重力与黑暗+虚弱。改成先给被选中者打临时 tag 再据此排除，语义精确。
scoreboard players set #INS_PICK tspire_timer 0
execute if score #INS_N tspire_timer matches 3.. at @e[tag=tspire_boss_inscriber,limit=1] as @p[team=tspire_party,sort=nearest,scores={tspire_dead=0}] run tag @s add tspire_oblivion_pick
execute if score #INS_N tspire_timer matches 3.. as @e[tag=tspire_oblivion_pick] run effect give @s tconstruct:antigravity 8 0 true
execute if score #INS_N tspire_timer matches 3.. as @e[tag=tspire_oblivion_pick] run title @s title {"text":"你被遗忘了！","color":"dark_gray","bold":true}
execute if score #INS_N tspire_timer matches 3.. as @a[team=tspire_party,scores={tspire_dead=0},tag=!tspire_oblivion_pick] run effect give @s minecraft:darkness 10 0 true
execute if score #INS_N tspire_timer matches 3.. as @a[team=tspire_party,scores={tspire_dead=0},tag=!tspire_oblivion_pick] run effect give @s minecraft:weakness 10 0 true
# 【v0.6.60 修正】摘 tag 必须放在"排除被选中者"的两行**之后**：原先写在前面，
#   被选中反重力的那位已经不带 tag，会**同时**吃到黑暗 + 虚弱。
execute if score #INS_N tspire_timer matches 3.. as @e[tag=tspire_oblivion_pick] run tag @s remove tspire_oblivion_pick
execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:squid_ink ~ ~1 ~ 2.5 1.5 2.5 0.08 80 force
execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:sculk_soul ~ ~1 ~ 2 1 2 0.05 40 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.wither.spawn master @s ~ ~ ~ 0.8 0.6
tellraw @a[team=tspire_party] [{"text":"[铭刻者] ","color":"light_purple","bold":true},{"text":"遗忘蚀刻！","color":"gold","bold":true},{"text":"名字被从书页上抹掉了 —— 黑暗与虚弱降临。","color":"yellow"}]
