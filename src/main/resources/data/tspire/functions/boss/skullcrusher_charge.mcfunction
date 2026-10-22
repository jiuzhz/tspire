# ============================================================
# 裂颅者【战术突进】· 结算（#SKU_C2 到 320 时调用）
# ============================================================
# 流程：Boss 传送到前摇里放好的落点 marker（tspire_skull_dash）
#   → 落点 4 格内的玩家：**水平**击退 5 格（见 skullcrusher_kb）+ 4 点伤害
#     + 虚弱 + 缓慢 II
#   → 落点半径 4 的粒子爆发 + 音效 + 提示。
# ============================================================

scoreboard players set #SKU_C2 tspire_timer 0

# --- 1) 落到落点（没有 marker 就原地不动）---
execute as @e[tag=tspire_boss_skullcrusher,limit=1] run tp @s @e[tag=tspire_skull_dash,limit=1]
execute at @e[tag=tspire_boss_skullcrusher,limit=1] run particle minecraft:cloud ~ ~0.3 ~ 0.8 0.3 0.8 0.05 30 force
execute at @e[tag=tspire_boss_skullcrusher,limit=1] run particle minecraft:crit ~ ~1 ~ 1 1 1 0.2 40 force
# v0.7.19: BOSS 自己也要夹 —— 落点万一贴墙，落地后再检查一次（离房间中心 > 6 就拉回中心）
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1,distance=..6] run tp @s @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1]
kill @e[tag=tspire_skull_dash]

# --- 2) 逐人算水平击退（在 skullcrusher_kb 里做，执行者 = 玩家）---
execute at @e[tag=tspire_boss_skullcrusher,limit=1] as @a[team=tspire_party,distance=..4,scores={tspire_dead=0}] run function tspire:boss/skullcrusher_kb

# v0.7.19（玩家反馈：被【战术突进】冲出场地/冲进墙里）：推完人立刻夹一次位置。
#   水平击退只管"不上下飞"，管不住"贴墙时被推出房间" —— 由 push_clamp 把人拉回来。
function tspire:boss/push_clamp

# --- 3) 伤害与效果 ---
execute at @e[tag=tspire_boss_skullcrusher,limit=1] as @a[team=tspire_party,distance=..4,scores={tspire_dead=0}] run damage @s 4 minecraft:mob_attack
execute at @e[tag=tspire_boss_skullcrusher,limit=1] as @a[team=tspire_party,distance=..4,scores={tspire_dead=0}] run effect give @s minecraft:weakness 5 0 true
execute at @e[tag=tspire_boss_skullcrusher,limit=1] as @a[team=tspire_party,distance=..4,scores={tspire_dead=0}] run effect give @s minecraft:slowness 5 1 true

# --- 4) 表现 + 提示 ---
execute at @e[tag=tspire_boss_skullcrusher,limit=1] run particle minecraft:enchanted_hit ~ ~1 ~ 4 0.3 4 0.1 60 force
execute at @e[tag=tspire_boss_skullcrusher,limit=1] run particle minecraft:large_smoke ~ ~0.5 ~ 3 0.2 3 0.05 30 force
execute at @e[tag=tspire_boss_skullcrusher,limit=1] run particle minecraft:block minecraft:stone ~ ~0.3 ~ 3 0.4 3 0.2 70 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ravager.roar master @s ~ ~ ~ 1.2 0.9
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.player.attack.knockback master @s ~ ~ ~ 1 1.2
title @a[team=tspire_party] actionbar {"text":"【战术突进】被撞飞 5 格 —— 还有虚弱 + 缓慢 II！","color":"red","bold":true}
tellraw @a[team=tspire_party] [{"text":"[裂颅者] ","color":"red","bold":true},{"text":"战术突进！","color":"gold","bold":true},{"text":"落点 4 格内会被水平击退 5 格、受 4 点伤害，并获得虚弱与缓慢 II。","color":"yellow"}]
