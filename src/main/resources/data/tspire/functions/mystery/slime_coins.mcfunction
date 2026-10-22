# 黏液 · 收集金币：−20% 生命（4 点；需要 ≥5 点才做得了）→ +37 金币
# ============================================================
# 【v0.7.20 修复】守卫改成即时读取（原来读 tspire_hp，判据滞后会放行 → 扣死）；
#   并且**先置位再扣血**（连点两次不会扣两遍）。生命不足时撤回选择。
#   阈值：4 点伤害要求 #HP_H ≥ 10（= 5 点）→ 扣完至少剩 1 点。
# ============================================================
# 1) 先消费选择（防连点重复结算）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
# 2) 即时读取真实生命
execute if score @s tspire_my_choice matches 1 run function tspire:hp/read
# 3) 生命不够 → 撤回选择 + 提示
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches ..9 run scoreboard players set @s tspire_my_choice 0
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches ..9 run tellraw @s [{"text":"[黏液] ","color":"green","bold":true},{"text":"血量太低（这么趟进去会没命）—— 换别的选项吧。","color":"red"}]
# 4) 生命够 → 结算
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 10.. run damage @s 4 minecraft:magic
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 10.. run scoreboard players add @s tspire_gold 37
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 10.. run tellraw @s [{"text":"[黏液] ","color":"green","bold":true},{"text":"你趟过黏液，捞起一把金币 —— +37 金币，代价是 20% 生命（4 点）。","color":"yellow"}]
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 10.. as @s at @s run playsound minecraft:entity.player.splash master @s ~ ~ ~ 1 0.8
