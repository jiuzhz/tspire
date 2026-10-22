# 抽奖机按钮（只发给**执行者本人**）—— 由 gacha_pull / gacha_stop 调用，@s = 点击者。
# 【v0.7.10 BUG】v0.7.9 为了让"事件开始时的开屏"能发出按钮，把这里改成了 `as @a … tellraw @s`，
#   结果**别人点抽奖也会在我屏幕上重印一遍菜单**（玩家反馈"没有做多人过滤"）。
#   现在拆成两个入口：本文件 = 本人（@s）；mystery/gacha_open = 事件开始时给每个人各发一份。
tellraw @s [{"text":"  [抽一次：15 金币] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 64"},"hoverEvent":{"action":"show_text","contents":"花 15 金币抽一次，可以一直抽"}}]
tellraw @s [{"text":"  [不抽了] ","color":"gray","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 65"},"hoverEvent":{"action":"show_text","contents":"离开抽奖机（无事发生）"}}]
tellraw @s [{"text":"  已抽次数：","color":"gray"},{"score":{"name":"@s","objective":"tspire_gacha"},"color":"yellow"},{"text":"　（5 次加速 / 10 次缓慢 / 15 次缓慢 II / 20 次再加失明）","color":"dark_gray"}]
