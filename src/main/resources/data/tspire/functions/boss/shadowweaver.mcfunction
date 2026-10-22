# ============================================================
# 织影巫师 · 三机制（v0.6.52 复核）
# ============================================================
# 底怪 = **唤魔者**（v0.6.53 玩家拍板：保留原版行为，只清原版召唤的恼鬼），
# 三个机制全部由脚本驱动：
#   【唤鬼】在 boss/active 里（共享 #BOSS_TIMER，**14 秒**，恼鬼 5 点血）
#   #WEA_C1   → 【尖牙阵】每 **10 秒**（200 tick）
#   #WEA_C2   → 【暗影帷幕】HP ≤ **200** 时每 **20 秒**（400 tick）
#   #WEA_GLOW → 隐身结束后的 2 秒发光收尾计时器
# 由 boss/tick 每 tick 调用（仅当织影巫师存活）。
# ============================================================

# ---------- 底怪是唤魔者时：清掉原版 AI 召唤的恼鬼（v0.6.53 最终方案）----------
# 唤魔者的三种法术写死在 AI 里，1.20.1 无法只关掉"召唤恼鬼"这一种。
# 最终采用：**保留唤魔者及其原版行为**，只把原版召唤出来的恼鬼清掉。
# `tag=!tspire_mob` 是关键 —— 我们【唤鬼】/【暗影帷幕】召的恼鬼在 summon 的 NBT 里
# 就带了 `Tags:["tspire_mob"]`，所以**不会误伤自己的机制**；原版恼鬼没有标签，会被清掉。
# （底怪是卫道士时这条匹配不到任何实体，等于空操作。）
# 注：原版尖牙法术**仍然会放**（保留原版行为的代价）；我们自己的【尖牙阵】也照常。
execute if score #CFG_WEAVER_KEEP_EVOKER tspire_config matches 1.. run kill @e[type=minecraft:vex,tag=!tspire_mob]

# ---------- 【尖牙阵】每 10 秒 ----------
scoreboard players add #WEA_C1 tspire_timer 1
execute if score #WEA_C1 tspire_timer matches 200.. run function tspire:boss/shadowweaver_fangs

# ---------- 【暗影帷幕】HP ≤ 200 时每 20 秒 ----------
scoreboard players add #WEA_C2 tspire_timer 1
execute if score #BNOW tspire_timer <= #TH_40 tspire_timer if score #WEA_C2 tspire_timer matches 400.. run function tspire:boss/shadowweaver_veil

# ---------- 隐身结束后的发光收尾 ----------
# veil 把 #WEA_GLOW 置 101（隐身 5 秒 = 100 tick），逐 tick 递减；
# 减到 1 的那一 tick 正好是隐身刚结束 → 给 2 秒发光。
# ⚠️ 顺序要紧：先判 1（触发一次），再递减。若改成 `matches 0` 判断，会**每 tick**都触发。
execute if score #WEA_GLOW tspire_timer matches 1 run function tspire:boss/shadowweaver_glow
execute if score #WEA_GLOW tspire_timer matches 1.. run scoreboard players remove #WEA_GLOW tspire_timer 1
