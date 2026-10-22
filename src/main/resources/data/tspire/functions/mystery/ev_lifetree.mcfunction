# ============================================================
# 神秘事件：生命本源（**仅第 1~2 层**）
# ============================================================
#   房间中央一棵生命之树，树叶把房间遮得严严实实，它在低语「留下来体会生命的力量」。
#   · 留下来：−75% 生命（20 点上限 → 15 点；**血量不足不能选**）→ 获得「躯体化生命球」
#     （黏液球：拿在副手时 +10 最大生命、−5% 移动速度）
#   · 简单休息：回复 25% 生命（5 点）
# 选择 id：1 = 留下来，2 = 简单休息
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 13
title @a[team=tspire_party] title {"text":"生 命 本 源","color":"green","bold":true}
title @a[team=tspire_party] subtitle {"text":"树叶遮蔽了整个房间，树在低声细语","color":"dark_green"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"生命本源：","color":"green","bold":true},{"text":"「留下来……体会生命的力量。」","color":"yellow"}]
# v0.7.5：血量不够就不给可点按钮（与石中剑/黏液一致）
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches 16.. run tellraw @s [{"text":"  [留下来：−75% 生命 → 躯体化生命球] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 23"},"hoverEvent":{"action":"show_text","contents":"扣 15 点生命，换一枚副手 +10 最大生命的黏液球（−5% 移速）"}}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches ..15 run tellraw @s [{"text":"  [留下来] 生命不足（需要高于 15 点，你现在 ","color":"dark_gray"},{"score":{"name":"@s","objective":"tspire_hp"},"color":"dark_gray"},{"text":" 点）—— 选不了","color":"dark_gray"}]
tellraw @a[team=tspire_party] [{"text":"  [简单休息：回复 25% 生命] ","color":"aqua","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 24"},"hoverEvent":{"action":"show_text","contents":"在树下坐一会儿：+5 点生命"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.azalea_leaves.break master @s ~ ~ ~ 1 0.7
