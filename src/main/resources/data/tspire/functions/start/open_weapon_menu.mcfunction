# ============================================================
# 弹出武器菜单（六选二）
# ============================================================
# 执行者 = 玩家。先把每名玩家已选的武器数刷新到 tspire_wcount，
# 菜单与「确认开始」都读这个计分板（不能用一个全局 #变量，
# 否则多人时所有人的已选数会混在一起）。
#
# 【v0.6.23 每人一份】菜单按 @s tspire_draft_l 分支，各看各的那份（原来按全局 #LOADOUT）。
# ============================================================

scoreboard players set @s tspire_wcount 0
execute if score @s tspire_w0 matches 1 run scoreboard players add @s tspire_wcount 1
execute if score @s tspire_w1 matches 1 run scoreboard players add @s tspire_wcount 1
execute if score @s tspire_w2 matches 1 run scoreboard players add @s tspire_wcount 1
execute if score @s tspire_w3 matches 1 run scoreboard players add @s tspire_wcount 1
execute if score @s tspire_w4 matches 1 run scoreboard players add @s tspire_wcount 1

function tspire:starter/own_weapon_menu
