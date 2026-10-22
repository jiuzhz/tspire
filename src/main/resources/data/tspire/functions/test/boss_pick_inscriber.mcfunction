# Boss 单挑：铭刻者（第 3 层）
# 用法：/function tspire:test/boss_pick_inscriber
scoreboard players set #FLOOR tspire_timer 3
scoreboard players set #TESTBOSS tspire_timer 7
function tspire:test/boss_arena_setup

tellraw @s [{"text":"[Boss 单挑] ","color":"gold"},{"text":"已开出 ","color":"yellow"},{"text":"铭刻者","color":"red","bold":true},{"text":"（第 3 层）。","color":"yellow"}]
tellraw @s [{"text":"清理：","color":"gray"},{"text":"/function tspire:test/boss_pick","color":"gray"}]
