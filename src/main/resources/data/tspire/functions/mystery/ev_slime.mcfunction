# ============================================================
# 神秘事件：黏液（**仅第 1~2 层** —— pick_f1 / pick_f2）
# ============================================================
#   房间里塞满了黏液，走过去会掉金币，但黏液里似乎藏着东西（玩家描述）。
#   · 收集金币：−20% 生命值 → +37 金币
#   · 仔细翻找：−40% 生命值 → 1 枚黏液头颅（同伪装者）+ 1 个本层材料池部件
#   · 直接离开：−40 金币（不足则扣到 0）
# 选择 id：1 = 收集金币，2 = 仔细翻找，3 = 直接离开
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 10
title @a[team=tspire_party] title {"text":"黏 液","color":"green","bold":true}
title @a[team=tspire_party] subtitle {"text":"房间被黏液填满，踩上去就在往下沉","color":"dark_green"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"黏液：","color":"green","bold":true},{"text":"黏稠的一整间，走过去会损失些金币；但细看，黏液里似乎藏着一些好东西。","color":"yellow"}]
# v0.7.2（玩家要求）：血量不足时**不给可点按钮**（灰色说明，明确告诉你换别的）
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches 5.. run tellraw @s [{"text":"  [收集金币：−20% 生命 → +37 金币] ","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 48"},"hoverEvent":{"action":"show_text","contents":"硬趟过去捞金币：生命 -20%（4 点）"}}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches ..4 run tellraw @s [{"text":"  [收集金币] 生命不足（需要高于 4 点，你现在 ","color":"dark_gray"},{"score":{"name":"@s","objective":"tspire_hp"},"color":"dark_gray"},{"text":" 点）—— 选不了","color":"dark_gray"}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches 9.. run tellraw @s [{"text":"  [仔细翻找：−40% 生命 → 黏液头颅 + 本层部件] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 49"},"hoverEvent":{"action":"show_text","contents":"把手伸进黏液里翻：生命 -40%（8 点），换 1 枚黏液头颅与 1 个本层材料部件"}}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] if score @s tspire_hp matches ..8 run tellraw @s [{"text":"  [仔细翻找] 生命不足（需要高于 8 点，你现在 ","color":"dark_gray"},{"score":{"name":"@s","objective":"tspire_hp"},"color":"dark_gray"},{"text":" 点）—— 选不了","color":"dark_gray"}]
tellraw @a[team=tspire_party] [{"text":"  [直接离开：−40 金币] ","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 50"},"hoverEvent":{"action":"show_text","contents":"绕开黏液走人：失去 40 金币（不足则扣到 0）"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.slime_block.step master @s ~ ~ ~ 1 0.8
