# ============================================================
# Boss 单挑 · 第 0 拍（v0.7.4：改成两拍流程）
# ============================================================
# 本函数只做"能立刻做完"的事：人数、清场、进塔、forceload、清旧测试标记，然后置 #ARENA=1；
#   真正的建层 / 传送 / 开战与生成 Boss 由 test/arena_tick 在**后续 tick** 完成（原因见那里）。
# 调用者必须**先设好 #FLOOR**（boss_pick_<id> 会做），并可设 #TESTBOSS 指定某一只（0 = 随机）。
# 自检：/function tspire:test/boss_arena_check　重建：/function tspire:test/boss_arena_rebuild
# ============================================================

scoreboard players set #PARTY_SIZE tspire_timer 0
execute as @a[team=tspire_party] run scoreboard players add #PARTY_SIZE tspire_timer 1

execute in tspire:tower run kill @e[tag=tspire_boss]
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_mire]
execute in tspire:tower run kill @e[tag=tspire_mud]
execute in tspire:tower run kill @e[type=minecraft:vex]
execute in tspire:tower run kill @e[tag=tspire_spike2]
execute in tspire:tower run kill @e[tag=tspire_skull_dash]
execute in tspire:tower run kill @e[tag=tspire_arrow]
execute in tspire:tower run kill @e[tag=tspire_firez]
execute in tspire:tower run kill @e[tag=tspire_lava]
execute in tspire:tower run kill @e[tag=tspire_guard]
execute in tspire:tower run kill @e[tag=tspire_tp_to]
execute in tspire:tower run kill @e[tag=tspire_kb_rot]
execute in tspire:tower run kill @e[tag=tspire_test_node]

function tspire:run/enter_tower
execute in tspire:tower run forceload add -48 -416 48 32

# 置 1：下一 tick 由 test/arena_tick 建层
scoreboard players set #ARENA tspire_timer 1
tellraw @s [{"text":"[测试] ","color":"gold"},{"text":"正在建真实 BOSS 房（两拍：下一 tick 建层，再下一 tick 生成 Boss）…","color":"yellow"}]
