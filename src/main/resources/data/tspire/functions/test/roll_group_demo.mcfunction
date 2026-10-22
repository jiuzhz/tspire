# ============================================================
# 抽组演示：验证「前两场简单池 / 第三场起困难池」+ 随机抽组
# 用法：找块空地 /function tspire:test/roll_group_demo
# ============================================================
# 会生成三拨怪：
#   左侧  第 1 场  -> 应来自【简单池】（3~5 人，普通僵尸/骷髅一类）
#   中间  第 3 场  -> 应来自【困难池】（人数更多，会出现卫道士/掠夺者）
#   右侧  第 3 场  -> 同上，但【抽到的组应和中间不同】（多跑几次看变化）
#
# 关键验证点：
#   1. 左侧明显比中间/右侧人少
#   2. 多执行几次，中间与右侧抽到的编队会变
#   3. 每只可装备单位都有匠魂武器 + 四件盔甲，材料各不相同
# ============================================================

kill @e[tag=tspire_mob]

scoreboard players set #FLOOR tspire_timer 1
scoreboard players set #ELITE tspire_timer 0

scoreboard players set #BATTLE tspire_timer 1
execute positioned ~-14 ~ ~ run function tspire:mobs/roll_group
tellraw @s [{"text":"[抽组] ","color":"gold"},{"text":"左侧 = 第 1 场，应为简单池。","color":"white"}]

scoreboard players set #BATTLE tspire_timer 3
execute positioned ~ ~ ~ run function tspire:mobs/roll_group
tellraw @s [{"text":"[抽组] ","color":"gold"},{"text":"中间 = 第 3 场，应为困难池。","color":"white"}]

execute positioned ~14 ~ ~ run function tspire:mobs/roll_group
tellraw @s [{"text":"[抽组] ","color":"gold"},{"text":"右侧 = 第 3 场，应与中间抽到不同的组。","color":"white"}]

tellraw @s [{"text":"再执行几次看随机性。清理：","color":"gray"},{"text":"/kill @e[tag=tspire_mob]","color":"yellow"}]
