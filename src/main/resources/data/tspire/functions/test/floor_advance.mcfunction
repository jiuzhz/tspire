# ============================================================
# 直接推进到下一层（v0.7.4 新增）—— 方便打通关 / 跳过卡住的楼层
# ============================================================
# 用法：/function tspire:test/floor_advance
#   · 第 1 / 2 层：调 run/floor_advance → 建下一层并把全队送过去；
#   · 第 3 层：等于通关（run/win）。
# 想看通关界面也可以直接 /function tspire:run/win。
# ============================================================

execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_boss]
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #MYST_ACTIVE tspire_timer 0
function tspire:run/floor_advance
tellraw @s [{"text":"[修复] ","color":"gold","bold":true},{"text":"已推进楼层（到第 3 层之后再推进就是通关）。","color":"green"}]
