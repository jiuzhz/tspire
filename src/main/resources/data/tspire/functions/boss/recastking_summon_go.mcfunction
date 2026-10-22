# 【王权征召】2 秒后结算：场上**没有任何守卫**（tag=tspire_guard，不分种类）→ 召 1 只
#   并给它抗性提升 IV 十秒；有守卫 → 回满它们的血 + 给它们力量 十秒（绝不再叠加召唤）。
scoreboard players set #RK_ARM2 tspire_timer 0

# v0.7.19（玩家实测"有守卫还接着召"）：
#   原来写的是 `execute store result score #RK_G tspire_timer if entity @e[…]` —— 条件不成立时
#   store **根本不写入**，分数会留着上一轮的旧值（可能是 0，于是有守卫也照召）；
#   而且判定只认 piglin_brute 一种。现在先清零再置 1，判定改成"任意带 tspire_guard 的单位"。
scoreboard players set #RK_G tspire_timer 0
execute if entity @e[tag=tspire_guard] run scoreboard players set #RK_G tspire_timer 1

# --- 没有守卫：召唤 1 名 50 血（同【金铸壁垒】）+ 抗性提升 IV 10 秒 ---
#   除了 #RK_G，行内再挂一次 `unless entity`：双保险，只要场上还有守卫就绝不召唤。
execute if score #RK_G tspire_timer matches 0 unless entity @e[tag=tspire_guard] at @e[tag=tspire_boss_recastking,limit=1] positioned ~2 ~ ~ run function tspire:boss/recastking_guard_roll
execute if score #RK_G tspire_timer matches 0 run effect give @e[tag=tspire_guard] minecraft:resistance 10 3 true
execute if score #RK_G tspire_timer matches 0 at @e[tag=tspire_guard,limit=1] run particle minecraft:totem_of_undying ~ ~1 ~ 0.8 0.8 0.8 0.05 45 force
execute if score #RK_G tspire_timer matches 0 run title @a[team=tspire_party] actionbar {"text":"【王权征召】它召来 1 只随机卫兵，并给了它抗性提升 IV","color":"gold","bold":true}
execute if score #RK_G tspire_timer matches 0 run tellraw @a[team=tspire_party] [{"text":"[重铸之王] ","color":"gold","bold":true},{"text":"王权征召：","color":"red","bold":true},{"text":"场上没有卫队，它召来 1 只随机卫兵并赐予抗性提升 IV 10 秒。","color":"yellow"}]

# --- 有守卫：回满它们的血 + 力量 10 秒 ---
execute if score #RK_G tspire_timer matches 1.. as @e[tag=tspire_guard] run data merge entity @s {Health:50f}
execute if score #RK_G tspire_timer matches 1.. run effect give @e[tag=tspire_guard] minecraft:strength 10 0 true
execute if score #RK_G tspire_timer matches 1.. at @e[tag=tspire_guard] run particle minecraft:block minecraft:gold_block ~ ~1 ~ 0.6 0.6 0.6 0.05 20 force
execute if score #RK_G tspire_timer matches 1.. at @e[tag=tspire_guard] run particle minecraft:happy_villager ~ ~1 ~ 0.6 0.8 0.6 0.02 22 force
execute if score #RK_G tspire_timer matches 1.. run title @a[team=tspire_party] actionbar {"text":"【王权征召】它回满了所有守卫的血，并赐予力量","color":"gold","bold":true}
execute if score #RK_G tspire_timer matches 1.. run tellraw @a[team=tspire_party] [{"text":"[重铸之王] ","color":"gold","bold":true},{"text":"王权征召：","color":"red","bold":true},{"text":"所有随机卫兵被回满血量并获得力量 10 秒。","color":"yellow"}]
