# ============================================================
# 工匠节点：共鸣 —— 花金币随机获得一种强化水晶（每个工匠节点限一次）
# ============================================================
# 【v0.6.27 新机制】玩家要求："新增共鸣选项，可以随机获得一种强化水晶，
#   消耗30金币，仅限一次"。
# 【v0.6.28 起】改为"每个工匠节点各限一次"（换一个工匠节点即重置，
#   由 map/enter_artisan 用节点 z 当钥匙清零 `tspire_resonate_used`）。
# 【v0.6.43 文案修正】下面的失败提示还写着"每局只能用一次"，已改成"每个工匠节点"。
# 水晶池就是 tspire:rewards/crystal（v0.6.26 已把采掘类强化剔除）。
# 执行者 = 玩家。
# ============================================================

execute if score @s tspire_resonate_used matches 1 run tellraw @s [{"text":"共鸣每个工匠节点只能用一次（下一个工匠节点会刷新）。","color":"red"}]

scoreboard players set #RESOK tspire_timer 0
execute if score @s tspire_resonate_used matches 0 if score @s tspire_gold matches 30.. run scoreboard players set #RESOK tspire_timer 1
execute if score @s tspire_resonate_used matches 0 if score @s tspire_gold matches ..29 run tellraw @s [{"text":"金币不足（共鸣需要 30 金币）。","color":"red"}]

execute if score #RESOK tspire_timer matches 1 run scoreboard players set @s tspire_resonate_used 1
execute if score #RESOK tspire_timer matches 1 run scoreboard players remove @s tspire_gold 30
execute if score #RESOK tspire_timer matches 1 run loot give @s loot tspire:rewards/crystal
execute if score #RESOK tspire_timer matches 1 run tellraw @s [{"text":"共鸣完成：获得一枚强化水晶。剩余金币 ","color":"green"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]
execute if score #RESOK tspire_timer matches 1 run playsound minecraft:block.amethyst_block.chime master @s ~ ~ ~ 1 1.2
