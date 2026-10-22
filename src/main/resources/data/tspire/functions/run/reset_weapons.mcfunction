# 清空已选的两件武器，重新选（执行者 = 玩家）
# 需要按抽选方案清掉**具体物品**，所以按 @s tspire_draft_l 分支
# 【v0.6.23】原来按全局 #LOADOUT 分支 —— 多人时会把别人的方案当成自己的。
execute if score @s tspire_draft_l matches 1 run function tspire:starter/l1_clear_weapons
execute if score @s tspire_draft_l matches 2 run function tspire:starter/l2_clear_weapons
execute if score @s tspire_draft_l matches 3 run function tspire:starter/l3_clear_weapons
execute if score @s tspire_draft_l matches 4 run function tspire:starter/l4_clear_weapons
execute if score @s tspire_draft_l matches 5 run function tspire:starter/l5_clear_weapons
execute if score @s tspire_draft_l matches 6 run function tspire:starter/l6_clear_weapons
