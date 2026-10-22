# Boss 单挑：沼泽猎手（第 1 层）
# 用法：/function tspire:test/boss_pick_mirehunter
scoreboard players set #FLOOR tspire_timer 1
scoreboard players set #TESTBOSS tspire_timer 3
function tspire:test/boss_arena_setup

tellraw @s [{"text":"[Boss 单挑] ","color":"gold"},{"text":"已开出 ","color":"yellow"},{"text":"沼泽猎手","color":"red","bold":true},{"text":"（第 1 层）。","color":"yellow"}]
tellraw @s [{"text":"清理：","color":"gray"},{"text":"/function tspire:test/boss_pick","color":"gray"}]
