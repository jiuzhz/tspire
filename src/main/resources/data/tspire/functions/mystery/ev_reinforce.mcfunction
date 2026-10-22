# ============================================================
# 神秘事件：援兵（v0.7.7 新增）
# **不限层数**：pick_f1 / pick_f2 / pick_f3 都含本事件（1/2/3 层都能抽到）。
# **仅 1~2 人时触发**：3 人及以上抽到就**重掷**（见 mystery/do_reroll）。
# ============================================================
#   一个商人站在他的铁傀儡旁边：「需要帮忙吗？」
#   · 体验款 75 金币：获得一只 **40 血**的铁傀儡（跟随你、不攻击玩家；v0.7.18 由 20 血提高）
#   · 包售后 200 金币：同上 + **6 个铁锭**（v0.7.18 由 5 个提高；修铁傀儡用）
#   · 不买：+1 金币（「这都买不起，算可怜你的了」）
# 选择 id：1 / 2 / 3
# ============================================================
function tspire:mystery/room_clear_chat
scoreboard players set #MYST_EV tspire_timer 16
# v0.7.8（玩家指定）：本事件**只在 1~2 人时触发**，3 人及以上**抽到就重掷**。
#   重掷交给 mystery/tick 在**下一个 tick** 做（见 mystery/do_reroll）——
#   若在这里直接再调 roll_event，内层会改掉 #ROLL，外层派发链会接着用新值再触发一次事件。
execute if score #PARTY_SIZE tspire_timer matches 3.. if score #MYST_REROLL_N tspire_timer matches ..2 run scoreboard players set #MYST_REROLL tspire_timer 1
execute if score #PARTY_SIZE tspire_timer matches 3.. if score #MYST_REROLL_N tspire_timer matches ..2 run title @a[team=tspire_party] actionbar {"text":"援兵只招待 1~2 人 —— 重新掷一次…","color":"gray"}
execute if score #PARTY_SIZE tspire_timer matches 3.. if score #MYST_REROLL_N tspire_timer matches 3.. run title @a[team=tspire_party] actionbar {"text":"援兵只招待 1~2 人 —— 重掷太多次了，换成别的…","color":"gray"}
execute if score #PARTY_SIZE tspire_timer matches 1..2 run title @a[team=tspire_party] title {"text":"援 兵","color":"gold","bold":true}
execute if score #PARTY_SIZE tspire_timer matches 1..2 run title @a[team=tspire_party] subtitle {"text":"商人身边站着一只沉默的铁傀儡","color":"gray"}
execute if score #PARTY_SIZE tspire_timer matches 1..2 run tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple","bold":true},{"text":"援兵：","color":"gold","bold":true},{"text":"「两位以上的客人我可照顾不过来 —— 不过你们人少，正好。要买点帮助吗？」","color":"yellow"}]
execute if score #PARTY_SIZE tspire_timer matches 1..2 run tellraw @a[team=tspire_party] [{"text":"  [体验款：75 金币 → 一只 40 血铁傀儡] ","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 41"},"hoverEvent":{"action":"show_text","contents":"铁傀儡会跟着你、帮你打怪，不会攻击玩家"}}]
execute if score #PARTY_SIZE tspire_timer matches 1..2 run tellraw @a[team=tspire_party] [{"text":"  [包售后：200 金币 → 铁傀儡 + 6 铁锭] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 42"},"hoverEvent":{"action":"show_text","contents":"铁傀儡 + 5 个铁锭（自己修它用）"}}]
execute if score #PARTY_SIZE tspire_timer matches 1..2 run tellraw @a[team=tspire_party] [{"text":"  [不买：+1 金币] ","color":"gray","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 43"},"hoverEvent":{"action":"show_text","contents":"他会可怜你一枚金币"}}]
execute if score #PARTY_SIZE tspire_timer matches 1..2 run tellraw @a[team=tspire_party] [{"text":"  （每人各自决定；全队都选完后房门才会打开）","color":"gray"}]
execute if score #PARTY_SIZE tspire_timer matches 1..2 as @a[team=tspire_party] at @s run playsound minecraft:entity.iron_golem.repair master @s ~ ~ ~ 1 0.9
