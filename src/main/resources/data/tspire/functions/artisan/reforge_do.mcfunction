# ============================================================
# 重铸的第二步：按层抽材料 -> 成功才扣钱（设计文档 §3.1.2）
# ============================================================
# #REF = 1 表示真的重铸到了东西，才扣金币。
# 生成器：tools/gen-reforge.ps1 -> artisan/reforge_f{1,2,3}
# ============================================================

scoreboard players set #REF tspire_timer 0

execute if score #FLOOR tspire_timer matches 1 run function tspire:artisan/reforge_f1
execute if score #FLOOR tspire_timer matches 2 run function tspire:artisan/reforge_f2
execute if score #FLOOR tspire_timer matches 3 run function tspire:artisan/reforge_f3

execute if score #REF tspire_timer matches 1 run scoreboard players operation @s tspire_gold -= #CFG_REFORGE_COST tspire_config
execute if score #REF tspire_timer matches 1 run tellraw @s [{"text":"重铸完成，剩余金币 ","color":"green"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":" 金币","color":"gold"}]
execute if score #REF tspire_timer matches 1 run playsound minecraft:block.anvil.use master @s ~ ~ ~ 1 1.4

execute if score #REF tspire_timer matches 0 run tellraw @s [{"text":"重铸失败：主手没有可重铸的匠魂工具（先拿在手上）。","color":"red"}]
execute if score #REF tspire_timer matches 0 run playsound minecraft:block.anvil.land master @s ~ ~ ~ 0.6 0.8
