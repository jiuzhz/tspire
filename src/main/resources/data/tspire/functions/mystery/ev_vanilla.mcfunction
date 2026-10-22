# ============================================================
# 神秘事件：传统派（**仅第 3 层** —— v0.7.6 起，由 pick_f3 抽取）
# ============================================================
#   房间里坐着身穿**原版装备与武器**的人，笑着说"匠魂武器太复杂了，要不要来点简单的？"
#   · 试点装备：头盔换成「原版精神」海龟壳（保护 IV / 耐久 III / 绑定诅咒）
#   · 试点武器：获得「原版精神」**铁剑**（锋利 V / 耐久 III / 消失诅咒）
#   · 放弃：无事发生
# 选择 id：1 = 试点装备，2 = 试点武器，3 = 放弃
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 11
title @a[team=tspire_party] title {"text":"传 统 派","color":"gold","bold":true}
title @a[team=tspire_party] subtitle {"text":"一个穿着原版盔甲的人朝你招手","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"传统派：","color":"gold","bold":true},{"text":"「匠魂武器太复杂了，要不要来点简单的？」","color":"yellow"}]
tellraw @a[team=tspire_party] [{"text":"  [试点装备：换成「原版精神」海龟壳（保护 IV / 耐久 III / 绑定诅咒）] ","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 57"},"hoverEvent":{"action":"show_text","contents":"头盔被替换成附魔海龟壳；注意绑定诅咒穿上就脱不掉"}}]
tellraw @a[team=tspire_party] [{"text":"  [试点武器：获得「原版精神」铁剑（锋利 V / 耐久 III / 消失诅咒）] ","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 58"},"hoverEvent":{"action":"show_text","contents":"背包获得一把附魔铁剑；注意消失诅咒死亡即毁"}}]
tellraw @a[team=tspire_party] [{"text":"  [放弃：什么都不发生] ","color":"gray","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 59"},"hoverEvent":{"action":"show_text","contents":"笑笑走开"}}]
tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.villager.trade master @s ~ ~ ~ 1 1
