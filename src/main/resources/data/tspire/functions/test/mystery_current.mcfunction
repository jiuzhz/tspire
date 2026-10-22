# Print the currently selected mystery event. Run as a player.
execute if score #MYST_EV tspire_timer matches 0 run tellraw @s {"text":"[神秘事件诊断] 当前没有成功选出事件（编号 0）。请先 /reload，再在房间内运行 /function tspire:mystery/roll_event 恢复。","color":"red"}
execute if score #MYST_EV tspire_timer matches 1 run tellraw @s {"text":"[神秘事件诊断] 1：贪婪","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 2 run tellraw @s {"text":"[神秘事件诊断] 2：重铸","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 3 run tellraw @s {"text":"[神秘事件诊断] 3：石中剑","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 4 run tellraw @s {"text":"[神秘事件诊断] 4：赐福","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 5 run tellraw @s {"text":"[神秘事件诊断] 5：诅咒雕像","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 6 run tellraw @s {"text":"[神秘事件诊断] 6：伪装者","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 7 run tellraw @s {"text":"[神秘事件诊断] 7：共鸣","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 8 run tellraw @s {"text":"[神秘事件诊断] 8：抢劫","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 9 run tellraw @s {"text":"[神秘事件诊断] 9：药房","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 10 run tellraw @s {"text":"[神秘事件诊断] 10：黏液","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 11 run tellraw @s {"text":"[神秘事件诊断] 11：传统派","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 12 run tellraw @s {"text":"[神秘事件诊断] 12：自助抽奖机","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 13 run tellraw @s {"text":"[神秘事件诊断] 13：生命本源","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 14 run tellraw @s {"text":"[神秘事件诊断] 14：黏液收藏家","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 15 run tellraw @s {"text":"[神秘事件诊断] 15：疯狂","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 16 run tellraw @s {"text":"[神秘事件诊断] 16：援兵","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 17 run tellraw @s {"text":"[神秘事件诊断] 17：海龟","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 18 run tellraw @s {"text":"[神秘事件诊断] 18：巫女","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 19 run tellraw @s {"text":"[神秘事件诊断] 19：奶酪","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 20 run tellraw @s {"text":"[神秘事件诊断] 20：猪！","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 21 run tellraw @s {"text":"[神秘事件诊断] 21：饥饿","color":"aqua"}
execute if score #MYST_EV tspire_timer matches 22 run tellraw @s {"text":"[神秘事件诊断] 22：藏宝图","color":"aqua"}
