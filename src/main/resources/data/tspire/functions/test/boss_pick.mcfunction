# ============================================================
# Boss 单挑菜单（玩家要求：直接在 BOSS 场地挑战指定的某一只）
# 用法：/function tspire:test/boss_pick
# ============================================================
# 点名字即可：会先把你送进尖塔、清干净场地、再指定生成那一只 Boss，
# 并把它所在层的 #FLOOR 设好（装备与奖励都按那一层算）。
# 也可以直接调用：/function tspire:test/boss_pick_<id>
# ============================================================

tellraw @s [{"text":"========== Boss 单挑 ==========","color":"gold","bold":true}]
tellraw @s [{"text":"第 1 层：","color":"gray"}]
tellraw @s [{"text":"  [淬火者]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_quencher"},"hoverEvent":{"action":"show_text","contents":"直接开战：淬火者"}}]
tellraw @s [{"text":"  [锈刃督军]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_rusblade"},"hoverEvent":{"action":"show_text","contents":"直接开战：锈刃督军"}}]
tellraw @s [{"text":"  [沼泽猎手]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_mirehunter"},"hoverEvent":{"action":"show_text","contents":"直接开战：沼泽猎手"}}]
tellraw @s [{"text":"第 2 层：","color":"gray"}]
tellraw @s [{"text":"  [钴蓝决斗者]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_duelist"},"hoverEvent":{"action":"show_text","contents":"直接开战：钴蓝决斗者"}}]
tellraw @s [{"text":"  [裂颅者]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_skullcrusher"},"hoverEvent":{"action":"show_text","contents":"直接开战：裂颅者"}}]
tellraw @s [{"text":"  [织影巫师]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_shadowweaver"},"hoverEvent":{"action":"show_text","contents":"直接开战：织影巫师"}}]
tellraw @s [{"text":"第 3 层：","color":"gray"}]
tellraw @s [{"text":"  [铭刻者]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_inscriber"},"hoverEvent":{"action":"show_text","contents":"直接开战：铭刻者"}}]
tellraw @s [{"text":"  [熔核暴君]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_moltenlord"},"hoverEvent":{"action":"show_text","contents":"直接开战：熔核暴君"}}]
tellraw @s [{"text":"  [重铸之王]","color":"red","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_pick_recastking"},"hoverEvent":{"action":"show_text","contents":"直接开战：重铸之王"}}]
tellraw @s [{"text":"诊断：","color":"gray"},{"text":"/function tspire:test/boss_probe","color":"yellow","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_probe"},"hoverEvent":{"action":"show_text","contents":"打印 8 只 Boss 的血量与各机制冷却"}}]
tellraw @s [{"text":"场地自检：","color":"gray"},{"text":"/function tspire:test/boss_arena_check","color":"yellow","clickEvent":{"action":"run_command","value":"/function tspire:test/boss_arena_check"},"hoverEvent":{"action":"show_text","contents":"检查测试场地板/墙/节点 marker 与战斗开关（被传进构筑间、摔死时先跑这个）"}}]
tellraw @s [{"text":"========== 选择一只 ==========","color":"gold","bold":true}]
