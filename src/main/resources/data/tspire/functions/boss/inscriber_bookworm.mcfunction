# 铭刻者【时间书虫】—— v0.7.2：**HP ≤ 50% 后**每 10 秒生成 **2 只**蠹虫（血量门在 boss/inscriber 里）
# 蠹虫带 tspire_mob 标签（会被战斗结算与"Boss 死后清场"一起处理）。

# 历史：v0.6.62 曾修掉一个写死的 `..375`（"750 血时代"的 50%）。
# v0.7.2 玩家要求：整条机制改成**血量门触发**，并且**去掉"残血多召一只"** ——
#   所以这里不再需要任何血量判断，血量门由 boss/inscriber 统一把关。
scoreboard players set #INS_C3 tspire_timer 0

# 固定 2 只（v0.7.2：不再"残血多召一只"）
execute at @e[tag=tspire_boss_inscriber,limit=1] run summon minecraft:silverfish ~2 ~ ~ {Tags:["tspire_mob"],PersistenceRequired:1b}
execute at @e[tag=tspire_boss_inscriber,limit=1] run summon minecraft:silverfish ~-2 ~ ~ {Tags:["tspire_mob"],PersistenceRequired:1b}

execute at @e[tag=tspire_boss_inscriber,limit=1] run particle minecraft:enchanted_hit ~ ~0.5 ~ 1 0.3 1 0.05 20 force
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.silverfish.ambient master @s ~ ~ ~ 1 1.2
title @a[team=tspire_party] actionbar {"text":"【时间书虫】残血暴走 —— 蠹虫钻出来了","color":"dark_purple","bold":true}
