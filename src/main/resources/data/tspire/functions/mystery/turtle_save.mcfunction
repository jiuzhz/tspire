# 海龟 · 解救：50 金币 → 「化身！绿皮王八！」海龟鳞甲（副手 +5 护甲 / −15% 移速）
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players remove #TMP tspire_timer 50
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"[海龟] ","color":"green","bold":true},{"text":"你连 50 都不肯给……它失望地缩回了壳里。","color":"red"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players remove @s tspire_gold 50
# 【v0.7.10 BUG】原来写的是 minecraft:turtle_scute —— 1.20.1 **没有**这个 id（正确 id 是
#   minecraft:scute，海龟鳞甲）。写错 id 会让**整个函数在加载期就失败**
#   （"Whilst parsing command on line 6: Unknown item"）→ 海龟事件**第一个选项完全点不动**
#   （玩家反馈"选第一选项不能用"），而且第二选项也一起失效。
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run give @s minecraft:scute{display:{Name:'{"text":"化身！绿皮王八！","italic":false,"color":"green"}',Lore:['{"text":"拿在副手时：+5 护甲值、-15% 移动速度","color":"gray"}']},AttributeModifiers:[{AttributeName:"minecraft:generic.armor",Name:"苟",Amount:5,Operation:0,Slot:"offhand",UUID:[I;8,1,1,1]},{AttributeName:"minecraft:generic.movement_speed",Name:"龟速",Amount:-0.15,Operation:2,Slot:"offhand",UUID:[I;8,1,1,2]}]} 1
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run tellraw @s [{"text":"[海龟] ","color":"green","bold":true},{"text":"你把它推进水里 —— 它回头看了你一眼，留下一片鳞甲。","color":"green"}]
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. as @s at @s run playsound minecraft:entity.turtle.shamble master @s ~ ~ ~ 1 1.2
execute if score @s tspire_my_choice matches 0 if score #TMP tspire_timer matches 0.. run scoreboard players set @s tspire_my_choice 1
