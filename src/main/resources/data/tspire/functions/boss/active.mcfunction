# ============================================================
# Boss 主动技能（设计文档 §7.6）
# 20 tick = 1 秒；同一时间场上只有一个 Boss，所以共用 #BOSS_TIMER，触发后归零
# ============================================================
# 【v0.6.26 提示强化】每个技能：actionbar 大字 + 专属音效；危险技能额外发聊天栏。
# 【v0.6.27 前摇】玩家要求"所有 BOSS 技能增加 2 秒前摇，前摇期间 BOSS 获得减速，
#   技能范围边缘出现粒子"。
#   做法：每个技能的触发阈值 T 之前 40 tick（= 2 秒）开一个**前摇窗口** T-40..T-1：
#     · actionbar 打「准备中」大字，让玩家知道要来了
#     · 给 Boss slowness（每 tick 刷新，窗口内一直减速）
#     · 在技能半径的边缘画 4 个粒子点（东西南北），把范围"画"出来
#   窗口结束后原来的效果行照旧触发（阈值 T..）。
#   粒子用 end_rod（明亮、显眼），半径按各技能的实际范围写死。
# ============================================================

function tspire:mobs/cap

# --- 淬火者：【烈焰环】每 6 秒，半径 8 ---
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 160..199 run title @a[team=tspire_party] actionbar {"text":"⚠ 【烈焰环】准备中 —— 快离开 8 格范围！","color":"yellow","bold":true}
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 160..199 run effect give @e[tag=tspire_boss_quencher] minecraft:slowness 3 2 true
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 160..199 at @e[tag=tspire_boss_quencher] run particle minecraft:end_rod ~8 ~1 ~ 0 0 0 0 1 force
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 160..199 at @e[tag=tspire_boss_quencher] run particle minecraft:end_rod ~-8 ~1 ~ 0 0 0 0 1 force
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 160..199 at @e[tag=tspire_boss_quencher] run particle minecraft:end_rod ~ ~1 ~8 0 0 0 0 1 force
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 160..199 at @e[tag=tspire_boss_quencher] run particle minecraft:end_rod ~ ~1 ~-8 0 0 0 0 1 force
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 200.. run title @a[team=tspire_party] actionbar {"text":"【烈焰环】淬火者释放范围灼烧 —— 快拉开距离！","color":"red","bold":true}
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 200.. as @a[team=tspire_party] at @s run playsound minecraft:entity.blaze.shoot master @s ~ ~ ~ 1 0.7
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 200.. run tellraw @a[team=tspire_party] [{"text":"[淬火者] ","color":"red","bold":true},{"text":"烈焰环！","color":"gold","bold":true},{"text":"8 格内会持续灼烧，先退开再打。","color":"yellow"}]
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 200.. at @e[tag=tspire_boss_quencher] run particle minecraft:flame ~ ~ ~ 4 1 4 0.05 60 force
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 200.. run execute at @e[tag=tspire_boss_quencher] run effect give @a[team=tspire_party,distance=..8] minecraft:instant_damage 1 0 true
execute if entity @e[tag=tspire_boss_quencher] if score #BOSS_TIMER tspire_timer matches 200.. run scoreboard players set #BOSS_TIMER tspire_timer 0



# --- 钴蓝决斗者：【疾风连击】已删除（v0.6.51） ---
# 玩家在 v0.6.50 把【疾风连击】整条换成了【死斗】（被动贴身流血），但这里旧的
# 7 行一直没删，于是决斗者实际有**四条**机制在跑（死斗 2s + 疾风连击 4s + 破釜 15s + 嘶吼 16s）。
# 而且原来的实现用的是 `minecraft:haste` —— 1.20.1 的 haste **只影响挖掘速度、不影响攻速**，
# 所以"攻速暴涨"这句话本身也不成立。整块删除，决斗者的机制现在只有
# boss/duelist 里的三个（死斗 / 破釜 / 决斗嘶吼）。

# --- 裂颅者：【三连射】每 8 秒（v0.6.48：3 秒 → 8 秒，前摇窗口 120..159） ---
execute if entity @e[tag=tspire_boss_skullcrusher] if score #BOSS_TIMER tspire_timer matches 120..159 run title @a[team=tspire_party] actionbar {"text":"⚠ 【三连射】准备中 —— Boss 即将进入强攻！","color":"yellow","bold":true}
execute if entity @e[tag=tspire_boss_skullcrusher] if score #BOSS_TIMER tspire_timer matches 120..159 run effect give @e[tag=tspire_boss_skullcrusher] minecraft:slowness 3 2 true
execute if entity @e[tag=tspire_boss_skullcrusher] if score #BOSS_TIMER tspire_timer matches 160.. run title @a[team=tspire_party] actionbar {"text":"【三连射】裂颅者进入强攻状态！","color":"gold","bold":true}
execute if entity @e[tag=tspire_boss_skullcrusher] if score #BOSS_TIMER tspire_timer matches 160.. as @a[team=tspire_party] at @s run playsound minecraft:entity.arrow.shoot master @s ~ ~ ~ 1 0.8
execute if entity @e[tag=tspire_boss_skullcrusher] if score #BOSS_TIMER tspire_timer matches 160.. run effect give @e[tag=tspire_boss_skullcrusher] minecraft:strength 2 0 true
# v0.6.50: really fire the three-arrow fan (see boss/skullcrusher_volley)
execute if entity @e[tag=tspire_boss_skullcrusher] if score #BOSS_TIMER tspire_timer matches 160.. run function tspire:boss/skullcrusher_volley
execute if entity @e[tag=tspire_boss_skullcrusher] if score #BOSS_TIMER tspire_timer matches 160.. run scoreboard players set #BOSS_TIMER tspire_timer 0

# --- 织影巫师：【唤鬼】每 14 秒（v0.6.52：15 秒 → 14 秒），恼鬼只有 5 点血 ---
execute if entity @e[tag=tspire_boss_shadowweaver] if score #BOSS_TIMER tspire_timer matches 240..279 run title @a[team=tspire_party] actionbar {"text":"⚠ 【唤鬼】准备中 —— 恼鬼即将出现！","color":"yellow","bold":true}
execute if entity @e[tag=tspire_boss_shadowweaver] if score #BOSS_TIMER tspire_timer matches 240..279 run effect give @e[tag=tspire_boss_shadowweaver] minecraft:slowness 3 2 true
execute if entity @e[tag=tspire_boss_shadowweaver] if score #BOSS_TIMER tspire_timer matches 280.. run title @a[team=tspire_party] actionbar {"text":"【唤鬼】织影巫师召出了恼鬼！","color":"dark_purple","bold":true}
execute if entity @e[tag=tspire_boss_shadowweaver] if score #BOSS_TIMER tspire_timer matches 280.. as @a[team=tspire_party] at @s run playsound minecraft:entity.vex.charge master @s ~ ~ ~ 1 0.7
execute if entity @e[tag=tspire_boss_shadowweaver] if score #BOSS_TIMER tspire_timer matches 280.. run execute at @e[tag=tspire_boss_shadowweaver] if score #MOB_COUNT tspire_timer < #MOB_CAP tspire_timer run summon minecraft:vex ~2 ~ ~ {Tags:["tspire_mob"],PersistenceRequired:1b,Health:5f,Attributes:[{Name:"minecraft:generic.max_health",Base:5}]}
execute if entity @e[tag=tspire_boss_shadowweaver] if score #BOSS_TIMER tspire_timer matches 280.. run execute at @e[tag=tspire_boss_shadowweaver] if score #MOB_COUNT tspire_timer < #MOB_CAP tspire_timer run summon minecraft:vex ~-2 ~ ~ {Tags:["tspire_mob"],PersistenceRequired:1b,Health:5f,Attributes:[{Name:"minecraft:generic.max_health",Base:5}]}
execute if entity @e[tag=tspire_boss_shadowweaver] if score #BOSS_TIMER tspire_timer matches 280.. run execute at @e[tag=tspire_boss_shadowweaver] if score #MOB_COUNT tspire_timer < #MOB_CAP tspire_timer run summon minecraft:vex ~ ~ ~2 {Tags:["tspire_mob"],PersistenceRequired:1b,Health:5f,Attributes:[{Name:"minecraft:generic.max_health",Base:5}]}
execute if entity @e[tag=tspire_boss_shadowweaver] if score #BOSS_TIMER tspire_timer matches 280.. run scoreboard players set #BOSS_TIMER tspire_timer 0

# --- 铭刻者：【镜像分身】已删除（v0.6.56 换成【时间铭刻】，见 boss/inscriber*）---

# --- 熔核暴君：【熔火地脉】已移出本文件（v0.6.57 重做为 boss/moltenlord_lava*）---

# --- 重铸之王：【金铸壁垒】旧模块已删除（v0.7.1）---
# 这 7 行是 v0.6.36 期的旧实现（无条件每 16 秒给**抗性提升 IV 5 秒**，actionbar「重铸之王获得抗性提升！」）。
# v0.6.61 重做后，【金铸壁垒】已整体搬到 `boss/recastking`（阶段门 #TH_75 + #RK_C2 860 = 43 秒：
# 推人 + 自身缓慢 10 / 抗性 I 8 秒 + 8 秒伤害结算），但本文件里这份旧块**一直没删** ——
# 于是重铸之王实际有**四条**机制在跑，并且每 16 秒白拿一次抗性 IV（比设计强得多）。
# 与 v0.6.51 删掉决斗者遗留【疾风连击】是同一类事故，故整块删除。
# --- 锈刃督军 ---
# 【v0.6.32 重做】三机制（威压 15s / 亡者征召 12s 残血 2→3 只 / 破甲重击 28s）已整体搬到
# tspire:boss/rusblade，由 boss/tick 每 tick 调用，这里不再放它的技能行。
# --- 沼泽猎手 ---
# 【v0.6.34 重做】泥沼（被动）/ 标枪投掷 7s 半径 5 / 淤泥附身，已整体搬到
# tspire:boss/mirehunter，由 boss/tick 每 tick 调用，这里不再放它的技能行。