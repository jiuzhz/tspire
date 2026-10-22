# 诅咒雕像 · 不触碰：5 点伤害 + 35 金币（一次性）
# ============================================================
# 【v0.7.20 修复】不可拒绝的惩罚，原来直接 `damage @s 5`，生命 ≤5 点时会打死人。
#   现在即时读取真实生命：≥6 点才扣 5 点；不足 6 点只拿金币、不掉血（金币照给，事件照结束）。
# ============================================================
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2
execute if score @s tspire_my_choice matches 2 run function tspire:hp/read
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 12.. as @s run damage @s 5 minecraft:magic
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 12.. run tellraw @s [{"text":"[诅咒雕像] ","color":"green","bold":true},{"text":"你只抓走台上那点金币 —— 雕像震了一下，碎石擦过你的手（-5 生命，+35 金币）。","color":"green"}]
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches ..11 run tellraw @s [{"text":"[诅咒雕像] ","color":"green","bold":true},{"text":"你只抓走台上那点金币 —— 碎石落下来时你闪开了（生命太低，这次没扣，+35 金币）。","color":"yellow"}]
execute if score @s tspire_my_choice matches 2 run scoreboard players add @s tspire_gold 35
