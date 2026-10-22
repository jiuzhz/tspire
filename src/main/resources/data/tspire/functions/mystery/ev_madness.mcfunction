# ============================================================
# 神秘事件：疯狂（三层均可能出现，v0.7.7 新增）
# ============================================================
#   房间漆黑一片，只有不知来源的喃喃低语，让人疯狂。
#   · 接受疯狂：扣除 10 点生命并失去 10 点最大生命，获得「疯狂低语」（+30% 攻击伤害）【v0.7.22 25%→30%】
#   · 拒绝：扣除 25% 生命（20 点上限 → 5 点）
# 选择 id：1 = 接受，2 = 拒绝
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 15
title @a[team=tspire_party] title {"text":"疯 狂","color":"dark_purple","bold":true}
title @a[team=tspire_party] subtitle {"text":"漆黑一片，低语从四面八方涌来","color":"dark_gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"疯狂：","color":"dark_purple","bold":true},{"text":"「……听我们说……听我们说……」低语在你耳边绕来绕去。","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [接受疯狂：扣 10 点生命，获得「疯狂低语」] ","color":"dark_purple","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 25"},"hoverEvent":{"action":"show_text","contents":"岩浆膏：拿在副手 −10 最大生命、+30% 攻击伤害"}}]
tellraw @a[team=tspire_party] [{"text":"  [拒绝：−25% 生命] ","color":"red","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 26"},"hoverEvent":{"action":"show_text","contents":"捂住耳朵：扣 5 点生命"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.enderman.stare master @s ~ ~ ~ 1 0.6
