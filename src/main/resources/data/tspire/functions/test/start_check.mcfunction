# ============================================================
# 开局链路自检（用法：/function tspire:test/start_check）
# ============================================================
# 卡住时跑这个，把每一项的状态打出来，直接告诉我哪一项不对。
# ============================================================

tellraw @s [{"text":"========== 开局链路自检 ==========","color":"gold","bold":true}]

tellraw @s [{"text":"你的 phase = ","color":"gray"},{"score":{"name":"@s","objective":"tspire_phase"},"color":"yellow"},{"text":"（5 = 在塔里跑主循环）","color":"dark_gray"}]
tellraw @s [{"text":"PICK_STAGE = ","color":"gray"},{"score":{"name":"#PICK_STAGE","objective":"tspire_timer"},"color":"yellow"},{"text":"（0 空闲 / 1 启动 / 8 大厅准备 / 9 地图逐行生成 / 2 待传送 / 3 构筑中 / 4 结束）","color":"dark_gray"}]
tellraw @s [{"text":"PICK_WAIT = ","color":"gray"},{"score":{"name":"#PICK_WAIT","objective":"tspire_timer"},"color":"yellow"},{"text":"（阶段 9 长时间不增长表示地图任务中断）","color":"dark_gray"}]
tellraw @s [{"text":"地图步骤 = ","color":"gray"},{"score":{"name":"#MAP_STEP","objective":"tspire_timer"},"color":"yellow"},{"text":"（1～15 布节点 / 16 统计 / 17 分配 / 21～36 建房）","color":"dark_gray"}]
tellraw @s [{"text":"地图节点数 = ","color":"gray"},{"score":{"name":"#MAP_N","objective":"tspire_timer"},"color":"yellow"},{"text":"；自动续建次数 = ","color":"gray"},{"score":{"name":"#MAP_RETRIES","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"大厅准备状态 = ","color":"gray"},{"score":{"name":"#MAP_BUILDING","objective":"tspire_timer"},"color":"yellow"},{"text":"；一层大厅就绪 = ","color":"gray"},{"score":{"name":"#MAP_READY1","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"RUN_STARTED = ","color":"gray"},{"score":{"name":"#RUN_STARTED","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"构筑方案（你自己那份）= ","color":"gray"},{"score":{"name":"@s","objective":"tspire_draft_l"},"color":"yellow"},{"text":"（0 = 从没抽过）","color":"dark_gray"}]
tellraw @s [{"text":"你在的维度：","color":"gray"}]
execute in tspire:tower if entity @s run tellraw @s [{"text":"  已在尖塔维度","color":"green"}]
execute unless entity @s[nbt={Dimension:"tspire:tower"}] run tellraw @s [{"text":"  不在尖塔维度（正常：构筑前应该已经进来了）","color":"yellow"}]

# 塔里的关键实体
execute in tspire:tower if entity @e[tag=tspire_anchor] run tellraw @s [{"text":"  anchor 锚点：存在","color":"green"}]
execute in tspire:tower unless entity @e[tag=tspire_anchor] run tellraw @s [{"text":"  anchor 锚点：**缺失**（说明 build_floor 没跑）","color":"red"}]
execute in tspire:tower if entity @e[tag=tspire_node] run tellraw @s [{"text":"  节点 marker：有","color":"green"}]
execute in tspire:tower unless entity @e[tag=tspire_node] run tellraw @s [{"text":"  节点 marker：**没有**（说明地图没抽/没建）","color":"red"}]
execute in tspire:tower if entity @e[tag=tspire_starter] run tellraw @s [{"text":"  构筑箱：存在","color":"green"}]
execute in tspire:tower unless entity @e[tag=tspire_starter] run tellraw @s [{"text":"  构筑箱：**没有**（说明 enter_draft 没跑）","color":"red"}]

tellraw @s [{"text":"如果上面有红的：点这里强制重开","color":"gold","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 106"},"hoverEvent":{"action":"show_text","contents":"清掉残留状态再走一遍开局"}}]
tellraw @s [{"text":"想看看结算界面长什么样：点这里预览","color":"gray","clickEvent":{"action":"run_command","value":"/function tspire:test/summary"},"hoverEvent":{"action":"show_text","contents":"用当前分数打印一遍本局结算"}}]
tellraw @s [{"text":"多人排查：点这里看全队状态","color":"gray","clickEvent":{"action":"run_command","value":"/function tspire:test/mp_check"},"hoverEvent":{"action":"show_text","contents":"打印每名队员的 phase / 金币 / 武器数 / 是否已领奖励"}}]
tellraw @s [{"text":"==================================","color":"gold","bold":true}]
