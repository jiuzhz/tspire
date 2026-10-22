# Boss 单挑：裂颅者（第 2 层）
# 用法：/function tspire:test/boss_pick_skullcrusher
scoreboard players set #FLOOR tspire_timer 2
scoreboard players set #TESTBOSS tspire_timer 5
function tspire:test/boss_arena_setup

tellraw @s [{"text":"[Boss 单挑] ","color":"gold"},{"text":"已开出 ","color":"yellow"},{"text":"裂颅者","color":"red","bold":true},{"text":"（第 2 层）。","color":"yellow"}]
tellraw @s [{"text":"清理：","color":"gray"},{"text":"/function tspire:test/boss_pick","color":"gray"}]
