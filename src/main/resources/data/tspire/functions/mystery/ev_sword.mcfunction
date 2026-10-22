# ============================================================
# 神秘事件：石中剑（**仅第 1 层** —— 由 mystery/pick_f1 抽取）
# ============================================================
#   · 拔剑：受到**最大生命值 75%** 的伤害（玩家最大生命 20 → 15 点）；**生命不够（≤15）拔不动**；
#          成功 → 获得一把**三级材料池**的匠魂剑
#   · 不拔剑：回复 **25% 生命**（≈5 点：instant_health I = 4 点 + regeneration 3 秒补约 1 点）
# 选择 id：1 = 拔剑，2 = 不拔剑
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 3
title @a[team=tspire_party] title {"text":"石 中 剑","color":"white","bold":true}
title @a[team=tspire_party] subtitle {"text":"石堆里插着一把尘封的大剑","color":"gray"}
# v0.7.2（玩家要求）：**血量不足不允许选择** —— 菜单就按每人当前血量分流：
#   高血量：可点的 [拔剑] + [不拔剑]；低血量：灰色不可点的 [拔剑] + 仍可点的 [不拔剑]。
#   （handlers 里还有第二道防线，见 sword_pull。）
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches 16.. run tellraw @s [{"text":"  [拔剑] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 51"},"hoverEvent":{"action":"show_text","contents":"后果：受到最大生命值 75% 的伤害（15 点）；生命不高于 15 点时拔不动。成功则获得一把三级材料池的剑"}},{"text":"      [不拔剑，转身离开] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 52"},"hoverEvent":{"action":"show_text","contents":"后果：回复 25% 生命（约 5 点）"}}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches ..15 run tellraw @s [{"text":"  [拔剑] 生命不足（需要高于 15 点）—— 这一项你选不了，请选 [不拔剑] ","color":"dark_gray"},{"text":"      [不拔剑，转身离开] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 52"},"hoverEvent":{"action":"show_text","contents":"后果：回复 25% 生命（约 5 点）"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute at @e[tag=tspire_node_current,limit=1] run particle minecraft:crit ~ ~1 ~ 1 0.5 1 0.05 20 force
