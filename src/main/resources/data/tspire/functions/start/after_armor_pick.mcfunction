# ============================================================
# 某件护甲选完之后（执行者 = 玩家）
# ============================================================
# 四个部位都选满了就进入武器选择，否则重新渲染护甲菜单
# （菜单里已选过的部位会变成灰色「[已选]」）。
# ============================================================

scoreboard players set #ARM_DONE tspire_timer 0
execute if score @s tspire_arm0 matches 1 if score @s tspire_arm1 matches 1 if score @s tspire_arm2 matches 1 if score @s tspire_arm3 matches 1 run scoreboard players set #ARM_DONE tspire_timer 1

execute if score #ARM_DONE tspire_timer matches 1 run function tspire:start/open_weapon_menu
execute if score #ARM_DONE tspire_timer matches 1 run tellraw @s [{"text":"护甲选完了，接下来选武器。","color":"green"}]

execute if score #ARM_DONE tspire_timer matches 0 run function tspire:start/open_armor_menu
