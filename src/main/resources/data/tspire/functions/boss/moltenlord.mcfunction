# ============================================================
# 熔核暴君 · 三机制（血量随人数 400/500/600，见 boss/spawn/moltenlord）
# ============================================================
# 1) 【熔火地脉】每 10 秒：**2 秒前摇**（自身缓慢 10 两秒，只画预警不点火）→ 前摇结束的那一
#    拍才在 Boss 脚下点燃 3×3 真火焰并持续 5 秒；**HP ≤ 50%（`#TH_HALF`）时范围变 5×5**。
#    （火焰用**真火焰方块**实现（v0.6.58 玩家要求；此前是纯粒子，为的是不烧掉落物）。
#      清理：`fill … air replace minecraft:fire`，只清火焰、不动地板。）
# 2) 【凋零剑压】重做：场地内生成 **3 只无 AI、30 血的烈焰人**（固定在几个点位、附近有黑色特效），
#    同时 BOSS 获得**抗性提升 III**；每死一只，抗性等级 -1（粒子也随等级减少）；
#    场上没有岩浆怪后，**40 秒**再触发。
# 3) 【熔核爆发】重做：HP ≤ **50%（`#TH_HALF`）** 时每 **30 秒**（技能释放的 15 秒不计入冷却 → 实际 45 秒）：
#    把 BOSS 传送回场地中心 → 获得 **15 秒缓慢 10** → 期间每 **2 秒**在每名玩家脚下生成 3×3 火焰
#    （沿用淬火者【燃烧蓄能】的取位逻辑：发动瞬间取一次位置，不跟随），
#    火焰生成前有粒子预警，火焰持续 **5 秒**。
# ============================================================

# ---------- 0) 阶段门（v0.6.60 / 待办 #27）：把 #BNOW 与 #TH_* 比成 0/1 分数 ----------
#   选择器里没法比较两个分数（`scores={tspire_boss_hp=..300}` 只能是字面量），
#   所以先算成 #ML_WIDE / #ML_BURST 两个标志位，下游只读标志位。
scoreboard players set #ML_WIDE tspire_timer 0
scoreboard players set #ML_BURST tspire_timer 0
# v0.7.19（玩家规格）：地脉的大圈门从 60%（#TH_60）改成 **50%（#TH_HALF）**
execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer run scoreboard players set #ML_WIDE tspire_timer 1
# v0.7.19：锁从 85% 改成 50%（玩家规格）——本来 HP 一掉到 85% 就会开始爆发
execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer run scoreboard players set #ML_BURST tspire_timer 1

# ---------- 1) 【熔火地脉】每 10 秒（200 tick）----------
scoreboard players add #ML_C1 tspire_timer 1
execute if score #ML_C1 tspire_timer matches 200.. run function tspire:boss/moltenlord_lava
execute if score #MLZ tspire_timer matches 1.. run function tspire:boss/moltenlord_lava_zone

# ---------- 2) 【凋零剑压】3 只岩浆怪 + 抗性分级 ----------
# 没有岩浆怪时走 40 秒重召冷却；有岩浆怪时逐 tick 盯死亡数
execute if entity @e[tag=tspire_boss_moltenlord] unless entity @e[tag=tspire_mcube] run scoreboard players add #ML_C2 tspire_timer 1
execute if score #ML_C2 tspire_timer matches 800.. run function tspire:boss/moltenlord_cubes
execute if entity @e[tag=tspire_mcube] run function tspire:boss/moltenlord_cube_watch
# v0.7.19：护体单位全没了（或还没召）时，把抗性彻底摘掉 —— 兜底，
#   免得某一次 cube_watch 没跑到而把 5 秒抗性续在那里。
execute if entity @e[tag=tspire_boss_moltenlord] unless entity @e[tag=tspire_mcube] unless score #MLZ2 tspire_timer matches 1.. run effect clear @e[tag=tspire_boss_moltenlord,limit=1] minecraft:resistance

# ---------- 3) 【熔核爆发】HP ≤ 50%（#TH_HALF），冷却 30 秒（技能期间暂停计数）----------
execute if score #MLZ2 tspire_timer matches 0 run scoreboard players add #ML_C3 tspire_timer 1
execute if score #ML_BURST tspire_timer matches 1 if score #ML_C3 tspire_timer matches 600.. run function tspire:boss/moltenlord_burst
execute if score #MLZ2 tspire_timer matches 1.. run function tspire:boss/moltenlord_burst_fire
