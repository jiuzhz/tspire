# ============================================================
# Boss 机制诊断（打 Boss 时随时运行）
# 用法：/function tspire:test/boss_probe
# ============================================================
# 作用：把"机制该触发却没触发"要用到的每一个量都打出来 ——
#   · 每只 Boss 是否存在、它的真实 Health、以及**同步后的 tspire_boss_hp**
#     （如果两者差很多，说明同步没跑，那么所有血量门都会失效）
#   · 各机制的冷却/标记假玩家当前值（是否有分数、到没到阈值）
#   · 每名玩家的泥沼状态（tspire_mud_t / imm / in）
# 这样一眼就能看出是"血量没同步"、"分数没初始化"还是"位置判定不成立"。
# ============================================================

tellraw @s [{"text":"========== Boss 机制诊断 ==========","color":"gold","bold":true}]

# --- 每只 Boss：Health vs 计分板 ---
execute if entity @e[tag=tspire_boss_quencher] as @e[tag=tspire_boss_quencher,limit=1] run tellraw @s [{"text":"[淬火者] Health=","color":"gray"},{"nbt":"Health","entity":"@s","color":"red"},{"text":"  tspire_boss_hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_boss_hp"},"color":"yellow"}]
execute if entity @e[tag=tspire_boss_rusblade] as @e[tag=tspire_boss_rusblade,limit=1] run tellraw @s [{"text":"[锈刃督军] Health=","color":"gray"},{"nbt":"Health","entity":"@s","color":"red"},{"text":"  tspire_boss_hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_boss_hp"},"color":"yellow"}]
execute if entity @e[tag=tspire_boss_mirehunter] as @e[tag=tspire_boss_mirehunter,limit=1] run tellraw @s [{"text":"[沼泽猎手] Health=","color":"gray"},{"nbt":"Health","entity":"@s","color":"red"},{"text":"  tspire_boss_hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_boss_hp"},"color":"yellow"}]
execute if entity @e[tag=tspire_boss_skullcrusher] as @e[tag=tspire_boss_skullcrusher,limit=1] run tellraw @s [{"text":"[裂颅者] Health=","color":"gray"},{"nbt":"Health","entity":"@s","color":"red"},{"text":"  tspire_boss_hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_boss_hp"},"color":"yellow"}]
execute if entity @e[tag=tspire_boss_duelist] as @e[tag=tspire_boss_duelist,limit=1] run tellraw @s [{"text":"[钴蓝决斗者] Health=","color":"gray"},{"nbt":"Health","entity":"@s","color":"red"},{"text":"  tspire_boss_hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_boss_hp"},"color":"yellow"}]
execute if entity @e[tag=tspire_boss_shadowweaver] as @e[tag=tspire_boss_shadowweaver,limit=1] run tellraw @s [{"text":"[织影巫师] Health=","color":"gray"},{"nbt":"Health","entity":"@s","color":"red"},{"text":"  tspire_boss_hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_boss_hp"},"color":"yellow"}]
execute if entity @e[tag=tspire_boss_inscriber] as @e[tag=tspire_boss_inscriber,limit=1] run tellraw @s [{"text":"[铭刻者] Health=","color":"gray"},{"nbt":"Health","entity":"@s","color":"red"},{"text":"  tspire_boss_hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_boss_hp"},"color":"yellow"}]
execute if entity @e[tag=tspire_boss_moltenlord] as @e[tag=tspire_boss_moltenlord,limit=1] run tellraw @s [{"text":"[熔核暴君] Health=","color":"gray"},{"nbt":"Health","entity":"@s","color":"red"},{"text":"  tspire_boss_hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_boss_hp"},"color":"yellow"}]

tellraw @s [{"text":"--- 冷却 / 标记假玩家（没显示分数 = 从未被赋值）---","color":"gray"}]
tellraw @s [{"text":"淬火者 灰烬重生 #QUENCH_REV=","color":"gray"},{"score":{"name":"#QUENCH_REV","objective":"tspire_timer"},"color":"yellow"},{"text":"  燃烧 #QUENCH_CD=","color":"gray"},{"score":{"name":"#QUENCH_CD","objective":"tspire_timer"},"color":"yellow"},{"text":"  #QZ=","color":"gray"},{"score":{"name":"#QZ","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"锈刃督军 #RUS_C1=","color":"gray"},{"score":{"name":"#RUS_C1","objective":"tspire_timer"},"color":"yellow"},{"text":" #RUS_C2=","color":"gray"},{"score":{"name":"#RUS_C2","objective":"tspire_timer"},"color":"yellow"},{"text":" #RUS_C3=","color":"gray"},{"score":{"name":"#RUS_C3","objective":"tspire_timer"},"color":"yellow"},{"text":" #RUS_DOUBLE=","color":"gray"},{"score":{"name":"#RUS_DOUBLE","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"沼泽猎手 #MIRE_C1=","color":"gray"},{"score":{"name":"#MIRE_C1","objective":"tspire_timer"},"color":"yellow"},{"text":" #MIRE_C2=","color":"gray"},{"score":{"name":"#MIRE_C2","objective":"tspire_timer"},"color":"yellow"},{"text":" #MIRE_C3=","color":"gray"},{"score":{"name":"#MIRE_C3","objective":"tspire_timer"},"color":"yellow"},{"text":" #MUD_T=","color":"gray"},{"score":{"name":"#MUD_T","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"裂颅者 #SKU_C2=","color":"gray"},{"score":{"name":"#SKU_C2","objective":"tspire_timer"},"color":"yellow"},{"text":" #SKU_C3=","color":"gray"},{"score":{"name":"#SKU_C3","objective":"tspire_timer"},"color":"yellow"}]
execute in tspire:tower store result score #MUD_N tspire_timer if entity @e[tag=tspire_mud]
tellraw @s [{"text":"场上 marker：tspire_mud=","color":"gray"},{"score":{"name":"#MUD_N","objective":"tspire_timer"},"color":"aqua"},{"text":"（>0 说明泥沼已生成）　tspire_spike2=","color":"gray"},{"score":{"name":"#SKU_N","objective":"tspire_timer"},"color":"aqua"}]
execute in tspire:tower store result score #SKU_N tspire_timer if entity @e[tag=tspire_spike2]

tellraw @s [{"text":"--- 逐玩家泥沼状态 ---","color":"gray"}]
execute as @a[team=tspire_party] run tellraw @s [{"selector":"@s"},{"text":"  mud_t=","color":"gray"},{"score":{"name":"@s","objective":"tspire_mud_t"},"color":"yellow"},{"text":"  imm=","color":"gray"},{"score":{"name":"@s","objective":"tspire_mud_imm"},"color":"yellow"},{"text":"  in=","color":"gray"},{"score":{"name":"@s","objective":"tspire_mud_in"},"color":"yellow"},{"text":"  hp=","color":"gray"},{"score":{"name":"@s","objective":"tspire_hp"},"color":"red"},{"text":"  dead=","color":"gray"},{"score":{"name":"@s","objective":"tspire_dead"},"color":"red"}]

tellraw @s [{"text":"--- 铭刻者【铭刻逆流】窗口 / 织影巫师【暗影帷幕】 ---","color":"gray"}]
tellraw @s [{"text":"#INS_LOOK=","color":"gray"},{"score":{"name":"#INS_LOOK","objective":"tspire_timer"},"color":"yellow"},{"text":"（>0 = 窗口进行中）  #INS_HIT=","color":"gray"},{"score":{"name":"#INS_HIT","objective":"tspire_timer"},"color":"yellow"},{"text":"（0 未受伤 / 1 待结算 / 2 已结算）  #INS_LAST=","color":"gray"},{"score":{"name":"#INS_LAST","objective":"tspire_timer"},"color":"yellow"},{"text":"  #INS_NOW=","color":"gray"},{"score":{"name":"#INS_NOW","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"#INS_C2=","color":"gray"},{"score":{"name":"#INS_C2","objective":"tspire_timer"},"color":"yellow"},{"text":"（到 760 触发逆流）  #WEA_C2=","color":"gray"},{"score":{"name":"#WEA_C2","objective":"tspire_timer"},"color":"yellow"},{"text":"（到 400 触发帷幕）  #WEA_GLOW=","color":"gray"},{"score":{"name":"#WEA_GLOW","objective":"tspire_timer"},"color":"yellow"}]
execute as @a[team=tspire_party] run tellraw @s [{"selector":"@s"},{"text":"  身上效果：","color":"gray"},{"nbt":"active_effects","entity":"@s","color":"aqua"}]

tellraw @s [{"text":"提示：Health 与 tspire_boss_hp 不一致 = 血量同步没跑（所有血量门都会失效）。","color":"dark_gray"}]
tellraw @s [{"text":"提示：mud_t 一直是 0 但人站在泥里 = distance 判定位置错了（缺 at @s）。","color":"dark_gray"}]
