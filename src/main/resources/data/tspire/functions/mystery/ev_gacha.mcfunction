# ============================================================
# 神秘事件：自助抽奖机（三层均可能出现）
# ============================================================
#   花 15 金币抽一次，可反复抽。奖池（1..100，见 gacha_pull）：
#     5 金 17% / 10 金 15% / 15 金 10% / 随机强化水晶 10% / 30 金 5% / 受到 4 点伤害 5% /
#     随机本层部件 10% / 随机本层工具装备 10% / 随机特殊奖励 10% / 随机下一层部件 4% /
#     60 金 2% / 不死图腾 1% / 附魔金苹果 1%
#   抽到第 5 / 10 / 15 / 20 次时会依次上瘾：速度 10 秒 → 缓慢 180 秒 → 缓慢 II 360 秒 → 缓慢 II + 失明 360 秒。
# 选择 id：1 = 不抽了（抽奖本身不占用选择，所以可以一直抽）
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 12
# 【v0.7.34 修"抽奖机没有清除次数"】
#   `tspire_gacha`（抽奖次数）以前**只有 run/reset_player 里那一处重置** —— 也就是只在"开新一局"时清零，
#   同一局里进第二个抽奖机房间时次数会接着累加（上瘾惩罚 5/10/15/20 次一档，等于一进门就已经重度上瘾）。
#   现在**每次事件开始**都给全队清零，与"每间房独立计算"的设计一致。
scoreboard players set @a[team=tspire_party] tspire_gacha 0
title @a[team=tspire_party] title {"text":"自 助 抽 奖 机","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"一台贴着「15 金币一次」的旧机器","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"抽奖机：","color":"gold","bold":true},{"text":"投 15 金币抽一次 —— 想抽几次都行，不过它好像会让人上瘾。","color":"yellow"}]
function tspire:mystery/gacha_open
execute as @a[team=tspire_party] at @s run playsound minecraft:block.note_block.bell master @s ~ ~ ~ 1 1.2
