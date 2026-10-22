# 生命本源 · 留下来：−75% 生命（20 点上限 → 15 点，需要 ≥16 点）→ 「躯体化生命球」
# ============================================================
# 【v0.7.20 修复】玩家报"这里扣血直接扣死"。三个问题一起堵：
#   1) 血量守卫读的是 tspire_hp（health 判据，只在被显示时同步）—— 判据偏高就放行，
#      实际血很低也照扣 15 点 → 扣死。现在改成 `function tspire:hp/read`
#      **即时读取**这一刻的真实生命（半心精度）。
#   2) **先置位再扣血**：旧版把 `tspire_my_choice` 放到最后才置位，连点两次按钮会在同一
#      拍里跑两遍 → 扣两次 15 点 = 必死。现在一进来就先消费掉这次选择。
#   3) 生命不够时**撤回选择**（置回 0）并把树推开，玩家还能选另一个选项。
#   阈值：15 点伤害要求 #HP_H ≥ 32（= 16 点）→ 扣完至少剩 1 点。
# ============================================================
# 1) 先消费选择（防连点重复结算）
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
# 2) 即时读取真实生命
execute if score @s tspire_my_choice matches 1 run function tspire:hp/read
# 3) 生命不够 → 撤回选择 + 推开
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches ..31 run scoreboard players set @s tspire_my_choice 0
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches ..31 run tellraw @s [{"text":"[生命本源] ","color":"green","bold":true},{"text":"你的生命撑不住这场共鸣（需要 16 点以上）—— 树轻轻把你推开了。","color":"red"}]
# 4) 生命够 → 结算（扣 15 点，拿球）
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 32.. run damage @s 15 minecraft:magic
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 32.. run give @s minecraft:slime_ball{display:{Name:'{"text":"躯体化生命球","italic":false,"color":"green"}',Lore:['{"text":"拿在副手时：+10 最大生命值、-5% 移动速度","color":"gray"}']},AttributeModifiers:[{AttributeName:"minecraft:generic.max_health",Name:"躯体化生命",Amount:10,Operation:0,Slot:"offhand",UUID:[I;7,7,7,1]},{AttributeName:"minecraft:generic.movement_speed",Name:"沉重",Amount:-0.05,Operation:2,Slot:"offhand",UUID:[I;7,7,7,2]}]} 1
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 32.. run tellraw @s [{"text":"[生命本源] ","color":"green","bold":true},{"text":"树把一部分生命交给你 —— 你失去了 75% 的生命，但手里多了一枚温热的黏液球。","color":"green"}]
execute if score @s tspire_my_choice matches 1 if score #HP_H tspire_timer matches 32.. as @s at @s run playsound minecraft:block.beacon.activate master @s ~ ~ ~ 1 1.6
