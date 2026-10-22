# Fallback if every event in the current floor pool has already appeared twice.
scoreboard players set #MYST_EV tspire_timer 25
title @a[team=tspire_party] title {"text":"寂静房间","color":"gray"}
tellraw @a[team=tspire_party] [{"text":"[神秘事件] ","color":"light_purple"},{"text":"这一层的神秘事件都已遇见两次。房间里暂时风平浪静。","color":"gray"}]
scoreboard players set @a[team=tspire_party,scores={tspire_dead=0}] tspire_my_choice 1
