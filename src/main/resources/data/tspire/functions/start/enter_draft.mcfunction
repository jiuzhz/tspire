# ============================================================
# 开局构筑第二步：地面已经好了 -> 把全队送进构筑间，每人各弹一份自己的菜单
# ============================================================
# 由 tick/second 在 #PICK_STAGE == 2 时调用。
#
# 菜单是 chat 界面，必须**以每名玩家为执行者**发出去：
# tick/second 是从函数标签（服务器身份）跑起来的，那里没有 @s，
# 直接 tellraw @s 什么都不会发生 —— 这就是之前"开局构筑没生效"的原因之一。
#
# 【v0.6.23 每人一份自己的方案】
#   抽选结果不再放在全局 #LOADOUT，而是每人各抽一份（@s tspire_draft_l）。
#   箱子还是那一个（Lock、共享），所以"取货前先把箱子换成**你自己**那份"
#   这一步放在 run/apick_* 与 run/wpick_* 里（starter/own_fill）。
# ============================================================

effect give @a[team=tspire_party] minecraft:instant_health 1 9 true
tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"green"},{"text":"全队已回满血。","color":"white"}]
scoreboard players set #PICK_STAGE tspire_timer 3

function tspire:run/enter_tower

# 1) 每人各抽自己的方案
execute as @a[team=tspire_party] run function tspire:starter/roll

# 2) 先把地下暂存箱按"队里第一名"的方案备好；真正取货时按每人的方案重摆
execute unless score #TUTOR_MODE tspire_timer matches 1 in tspire:tower at @e[tag=tspire_anchor] positioned ~ ~-2 ~0 as @a[team=tspire_party,limit=1] run function tspire:starter/own_fill
execute if score #TUTOR_MODE tspire_timer matches 1 in tspire:tower positioned -120 62 24 as @a[tag=tspire_tutorial,limit=1] run function tspire:starter/own_fill

# 3) 每人弹自己的护甲菜单
execute as @a[team=tspire_party] run function tspire:start/open_armor_menu

tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"构筑间已就绪：先选四个部位的护甲，再六选二挑武器。","color":"white"},{"text":"","color":"gray"}]
execute if score #TUTOR_MODE tspire_timer matches 1 run tellraw @a[tag=tspire_tutorial] [{"text":"[教程 · 构筑] ","color":"aqua"},{"text":"四个护甲部位各选一件，然后从武器候选中选两件。确认武器后才会进入教程路线；选择期间可以查看物品属性。","color":"white"}]
