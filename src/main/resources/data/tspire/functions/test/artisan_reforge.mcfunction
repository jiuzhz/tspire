# ============================================================
# 重铸 Demo —— 不用真的走到工匠节点
# ============================================================
# 发 200 金币 + 把主手换成一把随机匠魂武器，然后弹出工匠菜单。
# 点「[重铸]」应该看到材料被换掉、金币 -30（默认价），
# 而工具的强化 / 升级 / 耐久不变。
#
# 用法：
#   /function tspire:test/artisan_reforge
#   /scoreboard players set #FLOOR tspire_timer 3     再跑一次换第 3 层材料池
# ============================================================

scoreboard players set @s tspire_gold 200
execute unless score #FLOOR tspire_timer matches 1..3 run scoreboard players set #FLOOR tspire_timer 1

execute if score #FLOOR tspire_timer matches 1 run loot replace entity @s weapon.mainhand loot tspire:mob_gear/weapon_f1
execute if score #FLOOR tspire_timer matches 2 run loot replace entity @s weapon.mainhand loot tspire:mob_gear/weapon_f2
execute if score #FLOOR tspire_timer matches 3 run loot replace entity @s weapon.mainhand loot tspire:mob_gear/weapon_f3

tellraw @s [{"text":"[Demo] ","color":"gold"},{"text":"主手已换成随机匠魂武器，金币 200，材料池 = 第 ","color":"white"},{"score":{"name":"#FLOOR","objective":"tspire_timer"},"color":"yellow"},{"text":" 层。","color":"white"}]
tellraw @s [{"text":"  点下面的「重铸」看材料是否被重抽（强化/升级/耐久应保持不变）。","color":"gray"}]

function tspire:artisan/menu
