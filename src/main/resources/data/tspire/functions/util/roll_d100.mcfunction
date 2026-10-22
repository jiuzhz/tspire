# ============================================================
# 均匀掷 1..100：掷两次 d10，`#ROLL = (#R1 - 1) * 10 + #R2`
# ============================================================
# 为什么这样做：谓词链只有 d2..d20，做不出 1/100 的等概率；
# 两次 d10 组合等价于精确的 1..100 均匀分布（100 种等概率结果）。

scoreboard players set #R10 tspire_timer 10
function tspire:util/roll_d10
scoreboard players operation #R1 tspire_timer = #ROLL tspire_timer
function tspire:util/roll_d10
scoreboard players operation #R2 tspire_timer = #ROLL tspire_timer
scoreboard players operation #ROLL tspire_timer = #R1 tspire_timer
scoreboard players remove #ROLL tspire_timer 1
scoreboard players operation #ROLL tspire_timer *= #R10 tspire_timer
scoreboard players operation #ROLL tspire_timer += #R2 tspire_timer
