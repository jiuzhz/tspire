# ============================================================
# 神秘事件：黏液收藏家（**仅第 3 层**）
# ============================================================
#   房间里坐着一位自称"黏液收藏家"的人：「你找到过黏液头颅吗？」
#   · 奉上黏液头颅（**主手必须拿着 `tconstruct:slime_helmet`**）→ 随机获得一把
#     **全是骑士史莱姆**做成的工具 / 装备（`mystery/knightslime_tool`）
#   · 不给：受到 20% 生命的伤害（20 点上限 → 4 点）
# 选择 id：1 = 奉上，2 = 不给
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 14
title @a[team=tspire_party] title {"text":"黏液收藏家","color":"green","bold":true}
title @a[team=tspire_party] subtitle {"text":"一个被黏液包裹的人，眼睛发亮","color":"dark_green"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"黏液收藏家：","color":"green","bold":true},{"text":"「你……找到过黏液头颅吗？给我看看，我给你好东西。」","color":"yellow"}]
# 主手没有黏液头颅时不给可点按钮
execute as @a[team=tspire_party,scores={tspire_dead=0},nbt={SelectedItem:{id:"tconstruct:slime_helmet"}}] run tellraw @s [{"text":"  [奉上黏液头颅 → 骑士史莱姆工具 / 装备] ","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 15"},"hoverEvent":{"action":"show_text","contents":"交出主手的黏液头颅，换一件全骑士史莱姆的工具或装备"}}]
execute as @a[team=tspire_party,scores={tspire_dead=0}] unless entity @s[nbt={SelectedItem:{id:"tconstruct:slime_helmet"}}] run tellraw @s [{"text":"  [奉上黏液头颅] 需要主手拿着一个黏液头颅（","color":"dark_gray"},{"text":"tconstruct:slime_helmet","color":"dark_gray"},{"text":"）—— 现在选不了","color":"dark_gray"}]
tellraw @a[team=tspire_party] [{"text":"  [不给] ","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 16"},"hoverEvent":{"action":"show_text","contents":"拒绝他：受到 20% 生命的伤害"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.villager.ambient master @s ~ ~ ~ 1 0.8
