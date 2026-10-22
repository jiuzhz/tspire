# ============================================================
# 失明 / 黑暗 自测（v0.7.2 新增）
# ============================================================
# 玩家反馈"看不见失明效果"。失明是**客户端渲染的雾效**（视野收拢 + 变暗），
# 而光影包 / 雾效 mod / 某些资源包会**整个接管雾的渲染**，把原版的失明雾盖掉 ——
# 这种情况数据包无能为力（服务端效果确实加上了）。
# 这条指令给你 **10 秒失明 + 10 秒黑暗**，用来一眼分清责任方：
#   · 画面明显变暗/雾收拢  -> 你的客户端能看到失明，那之前没感觉就是"时机 + 时长太短"；
#   · 完全没变化          -> 是客户端渲染（光影/雾效）的问题，不是数据包。
# 同时会把你自己身上**真实存在的效果列表**打出来（服务端证据）。
# 用法：/function tspire:test/effect_check
# ============================================================

effect give @s minecraft:blindness 10 0 true
effect give @s minecraft:darkness 10 0 true
execute as @s at @s run playsound minecraft:entity.warden.nearby_close master @s ~ ~ ~ 1 1
title @s title {"text":"失明自测：10 秒","color":"dark_purple","bold":true}
title @s subtitle {"text":"如果画面完全没变暗，就是客户端把失明雾盖掉了","color":"gray"}
tellraw @s [{"text":"[自测] ","color":"gold","bold":true},{"text":"已给你 10 秒失明 + 10 秒黑暗。","color":"yellow"}]
tellraw @s [{"text":"  画面变暗了 -> 客户端没问题（之前只是 2 秒太短/没触发）；完全没变 -> 是光影/雾效 mod 盖掉了原版失明雾。","color":"gray"}]
tellraw @s [{"text":"  服务端证据（你身上现在的效果）：","color":"gray"},{"nbt":"active_effects","entity":"@s","color":"aqua"}]
tellraw @s [{"text":"  （上面若能看到 minecraft:blindness，说明效果**确实加上了**，问题在渲染端。）","color":"dark_gray"}]
