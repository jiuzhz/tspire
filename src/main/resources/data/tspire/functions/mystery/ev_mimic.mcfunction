# ============================================================
# 神秘事件：伪装者（**仅第 2~3 层** —— pick_f2 / pick_f3）
# ============================================================
#   · 加入：随机获得一个**黏液头颅**（`tconstruct:slime_helmet`，**无视材料池**、**排除末影头颅**）
#   · 不加入：回复 10% 生命（≈2 点：regeneration 5 秒）
# 选择 id：1 = 加入，2 = 不加入
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 6
title @a[team=tspire_party] title {"text":"伪 装 者","color":"green","bold":true}
title @a[team=tspire_party] subtitle {"text":"一群戴着黏液头颅的村民，念念有词","color":"dark_green"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"伪装者：","color":"green","bold":true},{"text":"一群村民静静地站成一圈，全都戴着半透明的黏液头颅，胸口随着同一句话起伏：『只有伪装才能活下去。』","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [加入他们] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 27"},"hoverEvent":{"action":"show_text","contents":"后果：随机获得一个黏液头颅（任意种类，但不会是末影头颅）"}},{"text":"      [不加入，转身离开] ","color":"yellow","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 28"},"hoverEvent":{"action":"show_text","contents":"后果：回复 10% 生命（约 2 点）"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.villager.ambient master @s ~ ~ ~ 1 1