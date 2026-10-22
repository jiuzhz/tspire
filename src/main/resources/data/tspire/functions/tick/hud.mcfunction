# ============================================================
# 匠魂尖塔 - HUD 刷新（每 5 秒一次，只在本局进行中）
# 设计文档 §13.7：bossbar 显示 层数 / 金币 / 生命
# ============================================================
# 【刷屏问题的修法】旧版用
#     execute store result score #TMP_HP tspire_timer run data get entity @s Health
# 取血量，再配合每秒调用，聊天栏会被命令反馈刷屏。
# 现在改成：
#   1. 血量**不取数**，直接读原版 health 判据：`tspire_hp` 由原版自动同步，0 条命令；
#   2. 层数 / 金币用 `scoreboard players operation` 搬运，这条命令本身不产生任何输出；
#   3. 只在 #RUN_STARTED == 1 且队里有人时跑，且每 5 秒才一次。
#
# 【为什么 bossbar 名字里用 @a[...] 选择器而不是 #HUD_FLOOR】
#   score 组件里如果写的是**字面名字**，聊天/标题里会渲染成「名字: 数值」；
#   写**选择器**时只渲染数值。商人那句「购买成功，剩余金币 X」已验证过这一点。
# ============================================================

# 把"队里第一名"的层数 / 金币 / 生命搬进 HUD 专用假玩家（operation 不产生输出）
scoreboard players operation #HUD_FLOOR tspire_timer = @a[team=tspire_party,limit=1] tspire_layer
scoreboard players operation #HUD_GOLD tspire_timer = @a[team=tspire_party,limit=1] tspire_gold
scoreboard players operation #HUD_HP tspire_timer = @a[team=tspire_party,limit=1] tspire_hp

# bossbar：血条 = 生命（max 20 = 10 颗心）
# 【必须在这里 visible true】tspire:load 每次 /reload 都会 bossbar remove + add
# 并把 visible 设成 false；如果不在刷新时重新打开，中途 reload 回来 HUD 就
# 一直不显示，直到下一次 run/begin_run —— 那正好破坏了我们想要的"中断恢复"。
bossbar set tspire_hud visible true
bossbar set tspire_hud max 20
execute store result bossbar tspire_hud value run scoreboard players get #HUD_HP tspire_timer

# bossbar 标题
bossbar set tspire_hud name [{"text":"尖塔 · 第 "},{"score":{"name":"@a[team=tspire_party,limit=1]","objective":"tspire_layer"}},{"text":" 层 · 金币 "},{"score":{"name":"@a[team=tspire_party,limit=1]","objective":"tspire_gold"}},{"text":" · 生命 "},{"score":{"name":"@a[team=tspire_party,limit=1]","objective":"tspire_hp"}},{"text":"/20"}]

# 复位节拍
scoreboard players set #TICK_HUD tspire_timer 0
