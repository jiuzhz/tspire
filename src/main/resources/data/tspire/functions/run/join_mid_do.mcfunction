# ============================================================
# 中途加入的实际流程（执行者 = 要加入的玩家）
# 由 run/join_mid 在 #RUN_STARTED == 1 时调用
# ============================================================

# 1) 记下队伍当前位置（**此时还没入队**）
execute in tspire:tower run kill @e[tag=tspire_joindest]
execute in tspire:tower as @a[team=tspire_party,nbt={Dimension:"tspire:tower"},limit=1] at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_joindest"]}

# 2) 入队 + 补齐本局状态
team join tspire_party @s
function tspire:run/reset_player
scoreboard players set @s tspire_phase 5
scoreboard players set @s tspire_dead 0
scoreboard players set @s tspire_deaths 0
scoreboard players set @s tspire_death_total 0
scoreboard players set @s tspire_service 0
scoreboard players set @s tspire_ready 0
scoreboard players set @s tspire_offer 0
scoreboard players set @s tspire_wcount 2
scoreboard players set @s tspire_time 0
scoreboard players set @s tspire_nodes 0
scoreboard players set @s tspire_para_run 0
scoreboard players set @s tspire_pig_run 0
# 层数跟上大部队；金币按开局标准补一份
scoreboard players operation @s tspire_layer = #FLOOR tspire_timer
scoreboard players operation @s tspire_gold = #CFG_START_GOLD tspire_config

# 3) 传送到队伍身边 + 冒险模式 + 重生点
execute in tspire:tower at @e[tag=tspire_joindest,limit=1] run tp @s ~ ~ ~
execute in tspire:tower at @e[tag=tspire_joindest,limit=1] run spawnpoint @s ~ ~ ~
execute in tspire:tower run gamemode adventure @s
execute in tspire:tower run kill @e[tag=tspire_joindest]

# 4) 补给：按当前层给一件武器 + 一套四件护甲（中途加入不会有开局构筑）
execute if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:mob_gear/weapon_f1
execute if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:mob_gear/weapon_f2
execute if score #FLOOR tspire_timer matches 3 run loot give @s loot tspire:mob_gear/weapon_f3
execute if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:mob_gear/head_f1
execute if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:mob_gear/chest_f1
execute if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:mob_gear/legs_f1
execute if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:mob_gear/feet_f1
execute if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:mob_gear/head_f2
execute if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:mob_gear/chest_f2
execute if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:mob_gear/legs_f2
execute if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:mob_gear/feet_f2
execute if score #FLOOR tspire_timer matches 3 run loot give @s loot tspire:mob_gear/head_f3
execute if score #FLOOR tspire_timer matches 3 run loot give @s loot tspire:mob_gear/chest_f3
execute if score #FLOOR tspire_timer matches 3 run loot give @s loot tspire:mob_gear/legs_f3
execute if score #FLOOR tspire_timer matches 3 run loot give @s loot tspire:mob_gear/feet_f3
give @s tconstruct:encyclopedia 1

tellraw @a[team=tspire_party] [{"text":"[尖塔] ","color":"gold"},{"selector":"@s","color":"yellow"},{"text":" 加入了这一局（已补发一套当前层装备）。","color":"white"}]
playsound minecraft:entity.player.levelup master @s ~ ~ ~ 1 1.4
