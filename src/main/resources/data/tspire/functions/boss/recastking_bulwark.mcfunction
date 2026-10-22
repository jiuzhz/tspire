# 【金铸壁垒】发动：8 格内玩家水平外推 4 格 + 虚弱/缓慢；自身缓慢 10 + 虚弱 V 六秒；
#   随后开 6 秒观察窗口，窗口结束由 recastking_bulwark_end 结算。
scoreboard players set #RK_C2 tspire_timer 0
scoreboard players set #RK_LOOK tspire_timer 120
scoreboard players set #RK_DMG tspire_timer 0
scoreboard players set #RK_LAST tspire_timer 0

# 水平外推：新文件 recastking_push 逐人处理（v0.6.61 起是任意方向的水平外推，Y 不变）
execute at @e[tag=tspire_boss_recastking,limit=1] as @a[team=tspire_party,distance=..8,scores={tspire_dead=0}] run function tspire:boss/recastking_push

# v0.7.19: 外推之后同样夹一次位置（同一个"贴墙被推出房间"的问题）
function tspire:boss/push_clamp

# 被击退者的减益
execute at @e[tag=tspire_boss_recastking,limit=1] as @a[team=tspire_party,distance=..12,scores={tspire_dead=0}] run effect give @s minecraft:weakness 4 0 true
execute at @e[tag=tspire_boss_recastking,limit=1] as @a[team=tspire_party,distance=..12,scores={tspire_dead=0}] run effect give @s minecraft:slowness 4 1 true

# 自身的防御姿态
# v0.7.19（玩家实测"打超过 8 血却判成伤害不足 8"，玩家裁定：**保留抗性提升 II，判定改成"血量掉 6 点"**）：
#   · 观察窗口算的就是 BOSS 的**血量损失**，抗性 IV（−40%）照旧保留 —— 也就是说
#     "打满 6 点"现在是**实打实的 6 点血量**（抗性 IV 下，外面需要打出更多伤害）。
#   · 取血改成半颗心精度（scale 2，阈值 12），原来每次不足 1 点的损失会被直接截掉。
#   · 同时按玩家要求加**虚弱 V 6 秒**：缩起来的这 6 秒它几乎打不出伤害。
effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:slowness 6 9 true
effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:weakness 6 4 true
effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:resistance 6 3 true

execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:enchanted_hit ~ ~1 ~ 3 0.5 3 0.1 60 force
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:crit ~ ~1 ~ 2 0.5 2 0.2 40 force
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:block minecraft:gold_block ~ ~1 ~ 3 1 3 0.08 90 force
execute at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:totem_of_undying ~ ~1 ~ 2.5 1 2.5 0.04 45 force
execute as @a[team=tspire_party] at @s run playsound minecraft:block.anvil.land master @s ~ ~ ~ 1.4 0.6
title @a[team=tspire_party] title {"text":"金铸壁垒！","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"打满 6 点伤害即可立刻压住它 —— 否则它会召援兵","color":"red"}
tellraw @a[team=tspire_party] [{"text":"[重铸之王] ","color":"gold","bold":true},{"text":"金铸壁垒！","color":"red","bold":true},{"text":"8 格内的人被水平推开、虚弱 + 缓慢 II；它进入 6 秒防御姿态（缓慢 10、虚弱 V、抗性提升 IV）：打掉 6 点生命即可立刻打穿壁垒，否则会召唤 2 名随机卫兵。","color":"yellow"}]
