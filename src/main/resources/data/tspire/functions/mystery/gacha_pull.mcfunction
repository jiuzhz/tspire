# 抽奖一次：15 金币 → 1..100 → 结算；抽完重新打印按钮（可以继续抽）
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 15
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"[抽奖机] ","color":"gold","bold":true},{"text":"金币不够（需要 15）—— 可以去点 [不抽了]。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 as @s at @s run playsound minecraft:block.note_block.bass master @s ~ ~ ~ 1 0.8

execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 15
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run function tspire:util/roll_d100

# 1..17：5 金币
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 1..17 run scoreboard players add @s tspire_gold 5
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 1..17 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"+5 金币","color":"yellow"}]
# 18..32：10 金币
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 18..32 run scoreboard players add @s tspire_gold 10
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 18..32 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"+10 金币","color":"yellow"}]
# 33..42：15 金币
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 33..42 run scoreboard players add @s tspire_gold 15
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 33..42 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"+15 金币","color":"yellow"}]
# 43..52：随机强化水晶
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 43..52 run loot give @s loot tspire:rewards/crystal
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 43..52 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"随机强化水晶 ×1","color":"aqua"}]
# 53..57：30 金币
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 53..57 run scoreboard players add @s tspire_gold 30
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 53..57 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"+30 金币","color":"yellow"}]
# 58..62：受到 4 点伤害（v0.7.20：先**即时读取**真实生命；生命 ≤4 点时改成"漏电但没伤到你"，
#   原来无条件 damage 4 会把只剩一口气的人电死）
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 58..62 run function tspire:hp/read
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 58..62 if score #HP_H tspire_timer matches 10.. run damage @s 4 minecraft:magic
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 58..62 if score #HP_H tspire_timer matches 10.. run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"机器漏电了 —— 你被电了 4 点血。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 58..62 if score #HP_H tspire_timer matches ..9 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"机器漏电了 —— 火花擦过你的手，你只剩一口气，这次没伤到（生命太低，未扣血）。","color":"yellow"}]
# 63..72：随机本层部件
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 63..72 if score #FLOOR tspire_timer matches ..1 run loot give @s loot tspire:rewards/part_f1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 63..72 if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:rewards/part_f2
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 63..72 if score #FLOOR tspire_timer matches 3.. run loot give @s loot tspire:rewards/part_f3
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 63..72 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"本层材料部件 ×1","color":"green"}]
# 73..82：随机本层工具装备
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 73..82 if score #FLOOR tspire_timer matches ..1 run loot give @s loot tspire:rewards/gear_f1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 73..82 if score #FLOOR tspire_timer matches 2 run loot give @s loot tspire:rewards/gear_f2
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 73..82 if score #FLOOR tspire_timer matches 3.. run loot give @s loot tspire:rewards/gear_f3
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 73..82 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"本层工具 / 装备 ×1","color":"green"}]
# 83..92：随机特殊奖励
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 83..92 run function tspire:rewards/special_give
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 83..92 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"特殊奖励 ×1","color":"light_purple"}]
# 93..96：随机下一层部件
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 93..96 if score #FLOOR tspire_timer matches ..1 run loot give @s loot tspire:rewards/part_f2
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 93..96 if score #FLOOR tspire_timer matches 2.. run loot give @s loot tspire:rewards/part_f3
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 93..96 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"下一层材料部件 ×1","color":"green"}]
# 97..98：60 金币
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 97..98 run scoreboard players add @s tspire_gold 60
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 97..98 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"+60 金币！","color":"gold"}]
# 99：不死图腾
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 99 run give @s minecraft:totem_of_undying 1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 99 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"不死图腾 ×1！！","color":"gold","bold":true}]
# 100：附魔金苹果
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 100 run give @s minecraft:enchanted_golden_apple 1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. if score #ROLL tspire_timer matches 100 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"附魔金苹果 ×1！！","color":"gold","bold":true}]

# 上瘾：每抽一次 +1，第 5/10/15/20 次各上一次效果
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players add @s tspire_gacha 1
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 5 run effect give @s minecraft:speed 10 0 true
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 5 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"你有点上头了 —— 速度 10 秒！","color":"aqua"}]
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 10 run effect give @s minecraft:slowness 180 0 true
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 10 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"抽太多了 —— 头重脚轻：缓慢 180 秒。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 15 run effect give @s minecraft:slowness 360 1 true
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 15 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"你已经停不下来了 —— 缓慢 II 360 秒。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 20 run effect give @s minecraft:slowness 360 1 true
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 20 run effect give @s minecraft:blindness 360 0 true
execute if score @s tspire_my_choice matches 0 if score @s tspire_gacha matches 20 run tellraw @s [{"text":"[抽奖机] ","color":"gold"},{"text":"……眼睛也看不见了（缓慢 II + 失明 360 秒）。","color":"dark_red","bold":true}]

execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. as @s at @s run playsound minecraft:block.note_block.pling master @s ~ ~ ~ 1 1.4
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run function tspire:mystery/gacha_menu
