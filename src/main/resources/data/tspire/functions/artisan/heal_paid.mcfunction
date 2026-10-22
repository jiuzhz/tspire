# 花金币在工匠节点再回 **最大生命的 25%**（20 点上限 → 5 点，最高不超过满血）
# 执行者 = 玩家。
# ============================================================
# 【v0.6.28 语义修正】同 artisan/heal_free：是"回复最大生命的 25%"，
#   所以高血量的玩家也要吃满这一份，不能因为 #HP0 高就一点都不给。
#
# 【v0.7.20 修复】旧版用「instant_health II（+8）→ damage 3」凑 +5，
#   那个 −3 依赖 tspire_hp 旧值判断 → "回血反而掉血"。现在**只加不减**：
#     instant_health I（+4）+ 生命恢复 3 秒（约 +1）≈ +5 点。
# ============================================================
function tspire:artisan/heal_cost
scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players operation #TMP tspire_timer -= @s tspire_heal_cost
execute if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"金币不足，本次回血需要 ","color":"red"},{"score":{"name":"@s","objective":"tspire_heal_cost"},"color":"gold"},{"text":" 金币。","color":"red"}]

scoreboard players set #PAIDOK tspire_timer 0
execute if score #TMP tspire_timer matches 0.. run scoreboard players set #PAIDOK tspire_timer 1

execute if score #PAIDOK tspire_timer matches 1 run scoreboard players operation @s tspire_gold -= @s tspire_heal_cost
execute if score #PAIDOK tspire_timer matches 1 run scoreboard players add @s tspire_heals 1
execute if score #PAIDOK tspire_timer matches 1 run effect give @s minecraft:instant_health 1 0 true
execute if score #PAIDOK tspire_timer matches 1 run effect give @s minecraft:regeneration 3 0 true
execute if score #PAIDOK tspire_timer matches 1 run tellraw @s [{"text":"已回复最大生命的 25%（约 5 点）。剩余金币 ","color":"green"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]
execute if score #PAIDOK tspire_timer matches 1 run playsound minecraft:block.beacon.activate master @s ~ ~ ~ 0.8 1.4
