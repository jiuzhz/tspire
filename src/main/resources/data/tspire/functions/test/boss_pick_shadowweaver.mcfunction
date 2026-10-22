# Boss 单挑：织影巫师（第 2 层）
# 用法：/function tspire:test/boss_pick_shadowweaver
scoreboard players set #FLOOR tspire_timer 2
scoreboard players set #TESTBOSS tspire_timer 6
function tspire:test/boss_arena_setup

tellraw @s [{"text":"[Boss 单挑] ","color":"gold"},{"text":"已开出 ","color":"yellow"},{"text":"织影巫师","color":"red","bold":true},{"text":"（第 2 层）。","color":"yellow"}]
tellraw @s [{"text":"清理：","color":"gray"},{"text":"/function tspire:test/boss_pick","color":"gray"}]
