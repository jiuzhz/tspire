# ============================================================
# 织影巫师【暗影帷幕】· 隐身结束后的 2 秒发光（v0.6.52 新增）
# ============================================================
# 由 boss/shadowweaver 在 #WEA_GLOW 递减到 1 的那一 tick 调用
#   （101 置入 → 递减 100 次 → 隐身 5 秒刚好结束）。
# 作用：给 Boss 2 秒发光 —— 玩家能借这 2 秒把它找回来，
#   也就是"隐身逃走后必须现形一下"的节奏，避免它带着隐身继续偷袭。
# 注意：发光只在**这一次**触发，不会每 tick 重复
#   （判断写在 `matches 1` 上，而不是 `matches 0`）。
# ============================================================

effect give @e[tag=tspire_boss_shadowweaver,limit=1] minecraft:glowing 2 0 true
execute at @e[tag=tspire_boss_shadowweaver,limit=1] run particle minecraft:glow ~ ~1 ~ 0.8 0.8 0.8 0.05 30 force
execute at @e[tag=tspire_boss_shadowweaver,limit=1] run particle minecraft:end_rod ~ ~1 ~ 0.6 0.6 0.6 0.02 15 force
title @a[team=tspire_party] actionbar {"text":"【暗影帷幕】它现形了 —— 只有 2 秒！","color":"yellow","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.evoker.prepare_summon master @s ~ ~ ~ 1 1.6
