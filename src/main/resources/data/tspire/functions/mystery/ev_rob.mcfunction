# ============================================================
# 神秘事件：抢劫（**仅第 1~2 层** —— pick_f1 / pick_f2）
# ============================================================
# 房间里一片混乱：一群怪物刚把你的金币袋抢散。
#   · 寻找：留下翻找。**如果全队都选择寻找 → 打一场困难怪池的战斗**（胜利照常发战斗奖励）
#   · 放弃：扣 75 金币（不足则扣到 0）
# 选择 id：1 = 寻找，2 = 放弃   —— 结算在 mystery/finish 里做（要看全队的最终选择）
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 8
title @a[team=tspire_party] title {"text":"抢 劫","color":"red","bold":true}
title @a[team=tspire_party] subtitle {"text":"混乱中，你的金币袋被扯散了","color":"dark_red"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"抢劫：","color":"red","bold":true},{"text":"房间里一片狼藉 —— 几只怪物正把你散落的金币往阴影里拖。你听见同伴在喊，也听见它们压低的嘶吼。","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [寻找（全队都选才会打起来）] ","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 46"},"hoverEvent":{"action":"show_text","contents":"后果：如果全队都选寻找 → 打一场困难怪池的战斗，胜利照常获得战斗奖励；否则什么也拿不到"}},{"text":"      [放弃] ","color":"yellow","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 47"},"hoverEvent":{"action":"show_text","contents":"后果：扣 75 金币（不够就扣到 0）"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；所有人都选完后才结算）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.pillager.ambient master @s ~ ~ ~ 1 0.8