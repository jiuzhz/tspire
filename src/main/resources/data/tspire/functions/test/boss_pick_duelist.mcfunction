# Boss 单挑：钴蓝决斗者（第 2 层）
# 用法：/function tspire:test/boss_pick_duelist
scoreboard players set #FLOOR tspire_timer 2
scoreboard players set #TESTBOSS tspire_timer 4
function tspire:test/boss_arena_setup

tellraw @s [{"text":"[Boss 单挑] ","color":"gold"},{"text":"已开出 ","color":"yellow"},{"text":"钴蓝决斗者","color":"red","bold":true},{"text":"（第 2 层）。","color":"yellow"}]
tellraw @s [{"text":"清理：","color":"gray"},{"text":"/function tspire:test/boss_pick","color":"gray"}]
