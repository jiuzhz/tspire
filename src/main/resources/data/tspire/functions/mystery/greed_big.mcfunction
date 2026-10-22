# 贪婪 · 大金币箱（受诅咒）：固定 12 点伤害 + 110 金币
# ============================================================
# 【v0.7.20 修复】血量守卫改成即时读取（原来读 tspire_hp，判据滞后会放行 → 扣死）；
#   并且**先置位再扣血**（连点两次不会扣两遍）。生命不足时撤回选择并让玩家去点小箱子。
#   阈值：12 点伤害要求 #HP_H ≥ 26（= 13 点）→ 扣完至少剩 1 点。
# ============================================================
# 1) 先消费选择（防连点重复结算）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2
# 2) 即时读取真实生命
execute if score @s tspire_my_choice matches 2 run function tspire:hp/read
# 3) 生命不够 → 撤回选择 + 提示
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches ..25 run tellraw @s [{"text":"[贪婪] ","color":"gold","bold":true},{"text":"血量太低（这个箱子会要了你的命）—— 换小箱子吧。","color":"red"}]
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches ..25 as @s at @s run playsound minecraft:block.chest.locked master @s ~ ~ ~ 1 0.6
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches ..25 run scoreboard players set @s tspire_my_choice 0
# 4) 生命够 → 结算（扣 12 点，+110 金币）
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 26.. run damage @s 12 minecraft:magic
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 26.. run scoreboard players add @s tspire_gold 110
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 26.. run tellraw @s [{"text":"[贪婪] ","color":"gold","bold":true},{"text":"诅咒在你手上炸开 —— 生命 -12，金币 +110（现在 ","color":"red"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":" 金币）。","color":"red"}]
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 26.. as @s at @s run playsound minecraft:entity.wither.hurt master @s ~ ~ ~ 1 0.7
