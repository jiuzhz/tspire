# ============================================================
# 沼泽猎手【泥沼】· 10 秒到点：清场
# ============================================================
# 由 boss/mirehunter_mud_check 在 #MUD_T >= 201 时调用。
# 清掉三片泥沼 marker 并复位计时；玩家的 tspire_mud_t 在下次布泥沼前
# 由 mud_check 的"不在泥里就清零"规则自然归零，这里不必强清。
# ============================================================

kill @e[tag=tspire_mud]
scoreboard players set #MUD_T tspire_timer 0

execute as @a[team=tspire_party] at @s run particle minecraft:item_slime ~ ~0.3 ~ 1 0.2 1 0.02 15 force
tellraw @a[team=tspire_party] [{"text":"[沼泽猎手] ","color":"gray"},{"text":"泥沼消退。","color":"dark_green"}]
