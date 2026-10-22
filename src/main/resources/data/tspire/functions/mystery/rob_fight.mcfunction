# 抢劫 · 全员都选寻找 → 打一场**困难怪池**的战斗
# 【怎么走困难池】#ELITE = 1 会让 mobs/roll_group 直接选 hard 池（设计文档 §7.4）。
# 战斗胜利后 run/battle_win 会照常发奖励并调用 map/complete_node —— 所以这里不要再 complete_node。
scoreboard players set #ELITE tspire_timer 1
tellraw @a[team=tspire_party] [{"text":"[抢劫] ","color":"red","bold":true},{"text":"所有人都留了下来 —— 阴影里的东西终于扑了上来！","color":"red"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ravager.roar master @s ~ ~ ~ 1 0.9
function tspire:run/battle_start