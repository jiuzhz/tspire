# 黏液 · 仔细翻找：−40% 生命（8 点；需要 ≥9 点才做得了）→ 1 枚黏液头颅 + 1 个本层材料池部件
# ============================================================
# 【v0.7.20 修复】守卫改成即时读取（原来读 tspire_hp，判据滞后会放行 → 扣死）；
#   并且**先置位再扣血**（连点两次不会扣两遍）。生命不足时撤回选择。
#   阈值：8 点伤害要求 #HP_H ≥ 18（= 9 点）→ 扣完至少剩 1 点。
# ============================================================
# 1) 先消费选择（防连点重复结算）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2
# 2) 即时读取真实生命
execute if score @s tspire_my_choice matches 2 run function tspire:hp/read
# 3) 生命不够 → 撤回选择 + 提示
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches ..17 run scoreboard players set @s tspire_my_choice 0
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches ..17 run tellraw @s [{"text":"[黏液] ","color":"green","bold":true},{"text":"血量太低（把手伸进去翻找会没命）—— 换别的选项吧。","color":"red"}]
# 4) 生命够 → 结算
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 18.. run damage @s 8 minecraft:magic
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 18.. run loot give @s loot tspire:mystery/slime_skull
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 18.. if score #FLOOR tspire_timer matches 1 run loot give @s loot tspire:rewards/part_f1
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 18.. if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:rewards/part_f2
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 18.. if score #FLOOR tspire_timer matches 3.. run loot give @s loot tspire:rewards/part_f3
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 18.. run tellraw @s [{"text":"[黏液] ","color":"green","bold":true},{"text":"你把手伸进黏液里翻找 —— 摸到一枚黏液头颅和一个部件，代价是 40% 生命（8 点）。","color":"gold"}]
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 18.. as @s at @s run playsound minecraft:block.slime_block.break master @s ~ ~ ~ 1 0.7
