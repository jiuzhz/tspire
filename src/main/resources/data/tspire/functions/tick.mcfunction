# ============================================================
# 匠魂尖塔 - 每 tick 主循环
# 约定（设计文档 §13.12）：不做全实体遍历，只按计分板与 marker 驱动
# ============================================================

# --- 1 秒节拍（20 tick） ---
scoreboard players add #TICK_1S tspire_timer 1
execute unless score #TUTOR_BUSY tspire_timer matches 1 as @a[tag=tspire_tutorial] run function tspire:tutorial/recover
execute if score #TICK_1S tspire_timer matches 20.. run function tspire:tick/second

# --- 普通玩家聊天菜单：trigger 命令无需 OP 权限 ---
scoreboard players enable @a tspire_click
execute as @a[scores={tspire_click=1..}] at @s run function tspire:ui/dispatch

# --- 玩家级每 tick（玩家在哪就在哪跑） ---
execute if score #RUN_STARTED tspire_timer matches 1 as @a[team=tspire_party,scores={tspire_phase=5}] at @s run function tspire:tick/player

# --- 塔维度内的逻辑 ---
# 必须显式 execute in，否则战斗/Boss 的实体选择器会跑到主世界去找，永远找不到
execute in tspire:tower run function tspire:tick/tower
