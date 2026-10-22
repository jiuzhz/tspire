# 【金铸壁垒】结算：累计伤害 ≥6（= #RK_DMG 12，半颗心单位）→ 压制它（v0.7.10 起打满就**立刻**结算）；
#   <8（窗口撑满）→ 它召 2 只随机卫兵并补力量
scoreboard players set #RK_LOOK tspire_timer 0

# --- 打满 6 点：BOSS 进入 5 秒缓慢 II + 8 秒虚弱 ---
execute if score #RK_DMG tspire_timer matches 12.. run effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:slowness 5 1 true
execute if score #RK_DMG tspire_timer matches 12.. run effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:weakness 8 0 true
execute if score #RK_DMG tspire_timer matches 12.. at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:block minecraft:gold_block ~ ~1 ~ 2.5 1 2.5 0.2 110 force
execute if score #RK_DMG tspire_timer matches 12.. at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:crit ~ ~1 ~ 2 1 2 0.15 70 force
execute if score #RK_DMG tspire_timer matches 12.. as @a[team=tspire_party] at @s run playsound minecraft:block.glass.break master @s ~ ~ ~ 1.4 0.6
execute if score #RK_DMG tspire_timer matches 12.. as @a[team=tspire_party] at @s run playsound minecraft:block.anvil.destroy master @s ~ ~ ~ 0.8 1.2
execute if score #RK_DMG tspire_timer matches 12.. run title @a[team=tspire_party] actionbar {"text":"【金铸壁垒】被打穿：它虚弱了 —— 趁现在！","color":"green","bold":true}
execute if score #RK_DMG tspire_timer matches 12.. run tellraw @a[team=tspire_party] [{"text":"[重铸之王] ","color":"gold","bold":true},{"text":"壁垒被打穿！","color":"green","bold":true},{"text":"它获得缓慢 II 5 秒与虚弱 8 秒。","color":"yellow"}]

# --- 不足 6 点：召唤 2 只 50 血随机卫兵（金剑或原版弩）+ 自身力量 5 秒 ---
execute if score #RK_DMG tspire_timer matches ..11 at @e[tag=tspire_boss_recastking,limit=1] positioned ~3 ~ ~ run function tspire:boss/recastking_guard_roll
execute if score #RK_DMG tspire_timer matches ..11 at @e[tag=tspire_boss_recastking,limit=1] positioned ~-3 ~ ~ run function tspire:boss/recastking_guard_roll
execute if score #RK_DMG tspire_timer matches ..11 run effect give @e[tag=tspire_boss_recastking,limit=1] minecraft:strength 5 0 true
execute if score #RK_DMG tspire_timer matches ..11 at @e[tag=tspire_boss_recastking,limit=1] run particle minecraft:angry_villager ~ ~1 ~ 2 0.6 2 0.05 35 force
execute if score #RK_DMG tspire_timer matches ..11 run title @a[team=tspire_party] actionbar {"text":"【金铸壁垒】没能打穿：它召来了 2 只随机卫兵！","color":"red","bold":true}
execute if score #RK_DMG tspire_timer matches ..11 run tellraw @a[team=tspire_party] [{"text":"[重铸之王] ","color":"gold","bold":true},{"text":"金铸壁垒成型！","color":"red","bold":true},{"text":"伤害不够 —— 它召来 2 名随机卫兵（金剑猪灵蛮兵或弩手猪灵）并强化了自身。","color":"yellow"}]
execute if score #RK_DMG tspire_timer matches ..11 as @a[team=tspire_party] at @s run playsound minecraft:entity.piglin_brute.ambient master @s ~ ~ ~ 1.2 0.7
