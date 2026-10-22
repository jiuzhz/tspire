# 抢劫 · 寻找：只记录选择，真正的判定在 mystery/finish（要看全队）
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[抢劫] ","color":"red","bold":true},{"text":"你蹲下去开始翻找 —— 如果所有人都留下来，它们就会扑上来。","color":"yellow"}]
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1