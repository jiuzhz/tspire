# ============================================================
# 沼泽猎手【泥沼现身】（原【淤泥附身】，v0.6.44 按玩家要求重做）
# ============================================================
# 触发：HP ≤ 50%（`#TH_HALF`，随人数缩放：**200 / 250 / 300**，v0.7.10 血量曲线 400/500/600）时，每 **16 秒**一次
#   （冷却 `#MIRE_C3`，由 boss/mirehunter 计数到 **320** = 16 秒时调用）。
# 条件：存在一名队员在 Boss **8 格以外**（v0.7.10 玩家要求，原 12 格）→ 传送到那名玩家附近。
#
# ⚠️ 安全设计（玩家特别提醒：不要卡墙 / 不要出场景 / 不要贴太近）：
#   落点**不是**玩家身边，而是「玩家朝**房间中心**方向 3 格」处——
#   · 房间中心（`tspire_node_current`）一定在场景内，所以落点也在场景内，不会出图；
#   · 落点离玩家固定 3 格，不会贴脸；
#   · 由 12 格外的玩家出发、朝中心走 3 格，位置必然在房间内部，
#     不会落到墙里（墙在房间边界之外）。
#   实现：先在该处 summon 一个临时 marker，再把 Boss tp 过去，然后清掉 marker。
# ============================================================

scoreboard players set #MIRE_C3 tspire_timer 0

# 有 8 格以外的队员吗？（相对 Boss 的位置算，v0.7.10 起是 8 格）
execute at @e[tag=tspire_boss_mirehunter,limit=1] as @p[team=tspire_party,sort=nearest,distance=8..,scores={tspire_dead=0}] at @s facing entity @e[tag=tspire_node_current,limit=1] feet run summon minecraft:marker ^ ^ ^3 {Tags:["tspire_tp_to"]}

# 有落点才传送（没有 marker 时 tp 会失败，等于什么都没发生 —— 这正是我们要的）
execute as @e[tag=tspire_boss_mirehunter,limit=1] run tp @s @e[tag=tspire_tp_to,limit=1]

# 【v0.6.60 玩家要求】落地就压制：Boss **5 格内**的玩家 **8 秒缓慢 + 8 秒虚弱**。
#   判据是"落点 marker 还在" —— 只有真的传送了才结算；没传送（大家都在 12 格内）
#   时不该凭空给一圈 debuff。`at @e[tag=tspire_boss_mirehunter]` 让 distance 以
#   Boss（= 落点）为原点，所以 5 格是"它钻出来那一圈"。
execute if entity @e[tag=tspire_tp_to] at @e[tag=tspire_boss_mirehunter,limit=1] run effect give @a[team=tspire_party,distance=..5,scores={tspire_dead=0}] minecraft:slowness 8 0 true
execute if entity @e[tag=tspire_tp_to] at @e[tag=tspire_boss_mirehunter,limit=1] run effect give @a[team=tspire_party,distance=..5,scores={tspire_dead=0}] minecraft:weakness 8 0 true
execute if entity @e[tag=tspire_tp_to] at @e[tag=tspire_boss_mirehunter,limit=1] as @a[team=tspire_party,distance=..5,scores={tspire_dead=0}] run title @s actionbar {"text":"被泥浆糊住了 —— 缓慢 + 虚弱 8 秒","color":"dark_green","bold":true}
execute if entity @e[tag=tspire_tp_to] at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:item_slime ~ ~0.3 ~ 5 0.3 5 0.05 60 force
kill @e[tag=tspire_tp_to]

# 表现（只有真的传送了才有意义，但 marker 已清，这里直接用 Boss 位置）
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:item_slime ~ ~0.5 ~ 1 0.5 1 0.05 40 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:squid_ink ~ ~0.8 ~ 1 0.5 1 0.03 20 force
execute at @e[tag=tspire_boss_mirehunter,limit=1] run particle minecraft:sculk_soul ~ ~0.5 ~ 1 0.5 1 0.02 20 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.enderman.teleport master @s ~ ~ ~ 1.2 0.7
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.drowned.ambient master @s ~ ~ ~ 1 0.6
title @a[team=tspire_party] actionbar {"text":"【泥沼现身】沼泽猎手从泥里钻了出来！","color":"dark_green","bold":true}
tellraw @a[team=tspire_party] [{"text":"[沼泽猎手] ","color":"green","bold":true},{"text":"泥沼现身！","color":"gold","bold":true},{"text":"有人离它超过 8 格 —— 它顺着泥沼钻到了那名玩家附近，5 格内的人被泥浆糊住 8 秒（缓慢 + 虚弱）。","color":"yellow"}]
