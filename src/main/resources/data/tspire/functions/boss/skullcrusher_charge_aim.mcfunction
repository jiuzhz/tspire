# ============================================================
# 裂颅者【战术突进】· 2 秒前摇（#SKU_C2 = 280..319）
# ============================================================
# 玩家要求：前摇必须整整 2 秒，且**这 2 秒里 Boss 要一直朝向最近的玩家**；
#   前摇期间**只在落点位置**出粒子（不再在 Boss 身上出）。
# 落点：从 Boss 沿"朝向最近玩家"的方向 5 格处（^ ^ ^5）。每 tick 重算一次，
#   所以 Boss 转向时落点也跟着走 —— 玩家能看着地上的光圈判断该往哪躲。
# Boss 被缓慢按住（amplifier 6），不会边追边蓄力。
# ============================================================

# 1) 每 tick 转向最近的玩家（tp 到自己当前位置 = 只改朝向）
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s facing entity @p[team=tspire_party,sort=nearest,scores={tspire_dead=0}] feet run tp @s ~ ~ ~

# 2) 按住它
effect give @e[tag=tspire_boss_skullcrusher,limit=1] minecraft:slowness 1 6 true

# 3) 落点：清掉上一 tick 的标记，再按当前朝向放一个新的
# 【v0.7.10 玩家反馈"有概率把自己冲出场外"】两处修正：
#   a) 末尾加 `rotated ~ 0` —— 落点**只用水平朝向**，俯仰角归零。原来 `facing entity … feet`
#      会把落点抬高/压低（玩家站高/站低时带上仰角），Boss 就被 tp 到别的 Y 上。
#   b) 落点若离房间中心超过 6 格（玩家贴着墙站时"沿你方向 5 格"会穿到墙外），
#      就把这次冲刺改成"玩家朝房间中心方向 3 格"的安全落点（与泥沼现身同一套做法），
#      保证 Boss 永远落在场景内。
kill @e[tag=tspire_skull_dash]
execute as @e[tag=tspire_boss_skullcrusher,limit=1] at @s facing entity @p[team=tspire_party,sort=nearest,scores={tspire_dead=0}] feet rotated ~ 0 run summon minecraft:marker ^ ^ ^5 {Tags:["tspire_skull_dash"]}
execute as @e[tag=tspire_skull_dash] at @s unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1,distance=..6] run kill @e[tag=tspire_skull_dash]
execute unless entity @e[tag=tspire_skull_dash] at @e[tag=tspire_boss_skullcrusher,limit=1] as @p[team=tspire_party,sort=nearest,scores={tspire_dead=0}] at @s facing entity @e[tag=tspire_node_current,limit=1] feet rotated ~ 0 run summon minecraft:marker ^ ^ ^3 {Tags:["tspire_skull_dash"]}

# 4) 只在落点出粒子（明显一点：地面圈 + 上升火星）
execute as @e[tag=tspire_skull_dash] at @s run particle minecraft:crit ~ ~0.2 ~ 1.2 0.05 1.2 0.02 20 force
execute as @e[tag=tspire_skull_dash] at @s run particle minecraft:end_rod ~ ~0.4 ~ 0.6 0.05 0.6 0.01 10 force
execute as @e[tag=tspire_skull_dash] at @s run particle minecraft:enchanted_hit ~ ~0.5 ~ 0.8 0.1 0.8 0.02 12 force

# 5) 预告（actionbar 每 tick 刷新，不刷屏；最后 10 tick 变红）
execute if score #SKU_C2 tspire_timer matches 280..309 run title @a[team=tspire_party] actionbar {"text":"⚠ 【战术突进】蓄力中 —— 地上光圈就是落点！","color":"yellow","bold":true}
execute if score #SKU_C2 tspire_timer matches 310..319 run title @a[team=tspire_party] actionbar {"text":"⚠ 【战术突进】即将扑过来！","color":"red","bold":true}
execute if score #SKU_C2 tspire_timer matches 280 as @a[team=tspire_party] at @s run playsound minecraft:entity.pillager.ambient master @s ~ ~ ~ 1.2 0.7
