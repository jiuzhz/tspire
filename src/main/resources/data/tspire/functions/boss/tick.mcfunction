# Boss 每 tick：计时 + 主动技能 + 阶段机制
# 由 tspire:tick 调用（仅当战斗进行中）
# 无回合制：全部按固定 tick 数（20 tick = 1 秒）触发，见设计文档 §7.6

scoreboard players add #BOSS_TIMER tspire_timer 1
function tspire:boss/active

# v0.6.48: sync every live boss's Health into tspire_boss_hp BY COMMAND (store result),
#   instead of trusting the `health` criteria objective to auto-update. Gates below read
#   this score, and because we write it ourselves it is always this tick's real value.
execute if entity @e[tag=tspire_boss_quencher] store result score @e[tag=tspire_boss_quencher] tspire_boss_hp run data get entity @e[tag=tspire_boss_quencher,limit=1] Health 1
execute if entity @e[tag=tspire_boss_rusblade] store result score @e[tag=tspire_boss_rusblade] tspire_boss_hp run data get entity @e[tag=tspire_boss_rusblade,limit=1] Health 1
execute if entity @e[tag=tspire_boss_skullcrusher] store result score @e[tag=tspire_boss_skullcrusher] tspire_boss_hp run data get entity @e[tag=tspire_boss_skullcrusher,limit=1] Health 1
execute if entity @e[tag=tspire_boss_shadowweaver] store result score @e[tag=tspire_boss_shadowweaver] tspire_boss_hp run data get entity @e[tag=tspire_boss_shadowweaver,limit=1] Health 1
execute if entity @e[tag=tspire_boss_duelist] store result score @e[tag=tspire_boss_duelist] tspire_boss_hp run data get entity @e[tag=tspire_boss_duelist,limit=1] Health 1
execute if entity @e[tag=tspire_boss_inscriber] store result score @e[tag=tspire_boss_inscriber] tspire_boss_hp run data get entity @e[tag=tspire_boss_inscriber,limit=1] Health 1
execute if entity @e[tag=tspire_boss_moltenlord] store result score @e[tag=tspire_boss_moltenlord] tspire_boss_hp run data get entity @e[tag=tspire_boss_moltenlord,limit=1] Health 1
execute if entity @e[tag=tspire_boss_mirehunter] store result score @e[tag=tspire_boss_mirehunter] tspire_boss_hp run data get entity @e[tag=tspire_boss_mirehunter,limit=1] Health 1
execute if entity @e[tag=tspire_boss_recastking] store result score @e[tag=tspire_boss_recastking] tspire_boss_hp run data get entity @e[tag=tspire_boss_recastking,limit=1] Health 1
# v0.6.59：另把当前 Boss 血量写成假玩家 #BNOW（% 型门槛要和随人数缩放的 #TH_* 比分数）
execute if entity @e[tag=tspire_boss] store result score #BNOW tspire_timer run data get entity @e[tag=tspire_boss,limit=1] Health 1

# 【v0.6.29】淬火者【灰烬重生】：首次濒死时复活一次（设计文档 §7.6 三机制之 3）。
# 【v0.6.44 修正】阈值从 20%（60）放宽到 **50%（150）**。
#   原窗口会被"一刀从 60 以上直接打死"跳过 —— 玩家报"灰烬重生没生效"。
#   50% 的窗口即使后期一刀 60~100 伤害也不会被跳过，触发才可靠。
# 【v0.6.60 重大修正】必须**先确认淬火者存在**再比 #BNOW / #TH_HALF！
#   起因（玩家实测）：打沼泽猎手打到半血时，聊天栏跳出了淬火者的【灰烬重生】。
#   根因：#BNOW 与 #TH_* 都是**全局**假玩家，由 boss/tick 每 tick 按"当前那只 Boss"写入，
#   而这一行原来只比分数、不问"当前 Boss 是谁"。打任何 Boss 掉到它自己的 50% 以下时，
#   #BNOW <= #TH_HALF 都成立 → 误触发淬火者的复活（还会白刷 2 只烈焰人）。
execute if entity @e[tag=tspire_boss_quencher] if score #BNOW tspire_timer <= #TH_10 tspire_timer if score #QUENCH_REV tspire_timer matches 0 run function tspire:boss/quencher_rebirth

# 【v0.6.30】淬火者【燃烧蓄能】：每 10 秒（200 tick）发动一次，状态机见 boss/quencher_zone。
#   只在发动瞬间取一次玩家位置；前摇 2 秒（粒子圈）→ 燃烧 3 秒（纯粒子，前 2 秒有火）。
#   纯粒子是刻意的：1.20.1 没有"点燃实体"指令，真实火焰还会烧掉掉落物。
execute if entity @e[tag=tspire_boss_quencher] run scoreboard players add #QUENCH_CD tspire_timer 1
execute if entity @e[tag=tspire_boss_quencher] if score #QUENCH_CD tspire_timer matches 200.. run function tspire:boss/quencher_charge
execute if score #QZ tspire_timer matches 1..2 run function tspire:boss/quencher_zone

# 【v0.6.32】锈刃督军三机制重做：威压 15s / 亡者征召 12s（残血 2→3 只）/ 破甲重击 24s（v0.6.44 改）
execute if entity @e[tag=tspire_boss_rusblade] run function tspire:boss/rusblade

# 【v0.6.36 / v0.6.48】裂颅者补机制：【战术突进】16s（前摇 2s）/ 【钉刺陷阱】12s
#   注意：陷阱**没有血量门** —— 玩家 v0.6.48 的新规格是"每 12 秒触发"，与血量无关。
#   （文档里"阶段机制 HP ≤ 35%"的旧描述已作废。）
# （【三连射】仍在 boss/active 里、共享 #BOSS_TIMER；v0.6.48 已把周期 3s → 8s）
execute if entity @e[tag=tspire_boss_skullcrusher] run function tspire:boss/skullcrusher

# 【v0.6.37】织影巫师补机制：【尖牙阵】10s / 【暗影帷幕】HP ≤ 50% 每 20s（v0.6.52 起）
# （【唤鬼】仍在 boss/active 里，共享 #BOSS_TIMER，未改动）
execute if entity @e[tag=tspire_boss_shadowweaver] run function tspire:boss/shadowweaver

# 【v0.6.38】钴蓝决斗者补机制：【破釜】15s 随机强化 / 【决斗嘶吼】HP ≤ 250 每 16s（v0.6.50 起；旧的【崩刃】/【玛玉灵回响】已删除）
# （【疾风连击】的旧块已在 v0.6.51 从 boss/active 删除，改由 boss/duelist 的死斗/破釜/嘶吼接管）
execute if entity @e[tag=tspire_boss_duelist] run function tspire:boss/duelist

# 【v0.6.40 / v0.7.19】铭刻者四机制：【时间铭刻】15s / 【铭刻逆流】51s（窗口 8s，受伤即结算，否则回 16 血）/ 【时间书虫】HP≤50% 每 10s / 【遗忘蚀刻】HP≤50% 每 73s（按人数分支）
# （【镜像分身】仍在 boss/active 里，共享 #BOSS_TIMER，未改动）
execute if entity @e[tag=tspire_boss_inscriber] run function tspire:boss/inscriber

# 【v0.6.42 / v0.7.19】熔核暴君补机制：【凋零剑压】3 只无 AI 烈焰人 + 抗性分级 / 【熔核爆发】HP≤50%（#TH_HALF，随人数缩放）每 30s
# （【熔火地脉】已移出 boss/active，改由 boss/moltenlord_lava* 实现）
execute if entity @e[tag=tspire_boss_moltenlord] run function tspire:boss/moltenlord
# v0.6.57：重铸之王三机制（再锻 / 金铸壁垒 / 王权征召）
execute if entity @e[tag=tspire_boss_recastking] run function tspire:boss/recastking

# 【v0.6.34 重做 / v0.6.60 调数值】沼泽猎手三机制：泥沼（主动 12s，半径 5，踩满 1.5 秒被定）/ 标枪投掷 7s（2s 前摇、半径 7、中毒 5 秒）/ 泥沼现身（HP≤50% 每 16s，落地给 5 格内玩家 8 秒缓慢 + 8 秒虚弱）
execute if entity @e[tag=tspire_boss_mirehunter] run function tspire:boss/mirehunter

function tspire:boss/phase
