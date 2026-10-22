# Boss 单挑：锈刃督军（第 1 层）
# 用法：/function tspire:test/boss_pick_rusblade
scoreboard players set #FLOOR tspire_timer 1
scoreboard players set #TESTBOSS tspire_timer 2
function tspire:test/boss_arena_setup

tellraw @s [{"text":"[Boss 单挑] ","color":"gold"},{"text":"已开出 ","color":"yellow"},{"text":"锈刃督军","color":"red","bold":true},{"text":"（第 1 层）。","color":"yellow"}]
tellraw @s [{"text":"清理：","color":"gray"},{"text":"/function tspire:test/boss_pick","color":"gray"}]
