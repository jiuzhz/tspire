# 重铸结算：60% 本层材料池 / 40% 更高一层（第 3 层没有更高 → 仍本层）。
# 只有真的重铸到了（artisan/reforge_f<N> 会置 #REF=1）才扣金币。
# #MREF_F = 这次用哪一层的材料池（不动 #FLOOR —— 它只能由 run/start_run 与 run/floor_advance 改）。
function tspire:util/roll_d5
scoreboard players operation #MREF_F tspire_timer = #FLOOR tspire_timer
execute if score #FLOOR tspire_timer matches 1..2 if score #ROLL tspire_timer matches 1..2 run scoreboard players add #MREF_F tspire_timer 1
scoreboard players set #REF tspire_timer 0
execute if score #MREF_F tspire_timer matches 1 run function tspire:artisan/reforge_f1
execute if score #MREF_F tspire_timer matches 2 run function tspire:artisan/reforge_f2
execute if score #MREF_F tspire_timer matches 3 run function tspire:artisan/reforge_f3
execute if score #REF tspire_timer matches 1 run scoreboard players remove @s tspire_gold 40
execute if score #REF tspire_timer matches 1 run scoreboard players set @s tspire_my_choice 1
execute if score #REF tspire_timer matches 1 run tellraw @s [{"text":"[重铸] ","color":"aqua","bold":true},{"text":"炉火把工具吞进去又吐了出来 —— 材料重新排布完毕（-40 金币，剩 ","color":"green"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":" 金币）。","color":"green"}]
execute if score #REF tspire_timer matches 1 as @s at @s run playsound minecraft:block.anvil.use master @s ~ ~ ~ 1 1.2
execute if score #REF tspire_timer matches 1 run tellraw @s [{"text":"  [再花 40 金币重铸一次] ","color":"gold","bold":true,"clickEvent":{"action":"run_command","value":"/trigger tspire_click set 39"},"hoverEvent":{"action":"show_text","contents":"后果：再扣 40 金币重掷一次（离开这个房间后按钮失效）"}}]
execute if score #REF tspire_timer matches 0 run tellraw @s [{"text":"[重铸] ","color":"red"},{"text":"炉子毫无反应：主手要先握着一件匠魂工具。","color":"red"}]