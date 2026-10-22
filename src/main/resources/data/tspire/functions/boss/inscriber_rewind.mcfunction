# 铭刻者【铭刻逆流】—— 每 47 秒（v0.7.89）
#   传送 BOSS 到场地中央 → 自身缓慢 10 八秒 → 所有玩家缓慢 II 八秒
#   随后开一个 8 秒观察窗口（#INS_LOOK = 160..1，v0.7.2 由 200 改成真 8 秒）：
#     · BOSS **一受伤就立刻**结算（不等窗口走完）
#     · 撑满窗口没受伤 → 回复 16 点血（v0.7.10）
# 传送用"以房间中心为原点 + 方向 0..7 × 距离 3/6"的安全选点法，绝不落在场地外或墙里。

scoreboard players set #INS_C2 tspire_timer 0
scoreboard players set #INS_LOOK tspire_timer 160
scoreboard players set #INS_DMG tspire_timer 0
scoreboard players set #INS_HIT tspire_timer 0

# v0.7.2（配合"一受伤就立刻结算"）：把基准血量重置成**此刻**的血量。
#   否则 #INS_LAST 还留着上一轮窗口的值 —— 窗口之间被打掉的血会被误判成
#   "窗口内受伤"，开局第一 tick 就直接触发反噬。
execute store result score #INS_LAST tspire_timer run data get entity @e[tag=tspire_boss_inscriber,limit=1] Health 1

# 【v0.7.10 玩家要求】每次传送后，在本体脚下留一圈黑粒子，**始终跟随本体移动，持续 30 秒**。
#   做法：放一个 marker（tspire_ins_aura）挂在 BOSS 位置，由 boss/inscriber_aura 每 tick
#   把它挪到 BOSS 脚下并出粒子；#INS_AURA 数到 600 tick（30 秒）就 kill 掉。
kill @e[tag=tspire_ins_aura]
execute at @e[tag=tspire_boss_inscriber,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["tspire_ins_aura"]}
scoreboard players set #INS_AURA tspire_timer 0

# 传送到场地中央（房间中心 marker 的位置；v0.7.19 抬高 1 格落点，与熔核爆发的处理一致，
#   免得落点正好卡在地板里导致"传了却没回中心"）
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run tp @e[tag=tspire_boss_inscriber,limit=1] ~ ~1 ~
effect give @e[tag=tspire_boss_inscriber,limit=1] minecraft:slowness 8 9 true
effect give @a[team=tspire_party,scores={tspire_dead=0}] minecraft:slowness 8 1 true

execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:sculk_soul ~ ~1 ~ 2 1 2 0.05 60 force
execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:enchant ~ ~1 ~ 1.5 1 1.5 0.3 40 force
execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:reverse_portal ~ ~1 ~ 2 1 2 0.08 60 force
execute as @a[team=tspire_party] at @s run playsound minecraft:block.beacon.deactivate master @s ~ ~ ~ 1.2 0.6
title @a[team=tspire_party] title {"text":"铭刻逆流！","color":"dark_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"8 秒内必须打到它 —— 一打到就立刻反噬","color":"red"}
tellraw @a[team=tspire_party] [{"text":"[铭刻者] ","color":"light_purple","bold":true},{"text":"铭刻逆流！","color":"gold","bold":true},{"text":"它回到场地中央、全场被缓慢 II 定住 8 秒；这 8 秒内打到它就会**立刻**触发反噬（全场失明 + 它随机传送），一直打不到它才会回血。","color":"yellow"}]
