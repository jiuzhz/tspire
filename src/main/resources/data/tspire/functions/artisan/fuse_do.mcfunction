# ============================================================
# 融合 · 正式流程（v0.6.35）
# ============================================================
# 目标材料池（v0.7.10 玩家裁定）：#FUSE_T 由 artisan/fuse_tier 算好 ——
#   同档 → 输入档位 + 1（4 + 4 封顶在 4）；不同档 → 两枚中较高的那一档。
# 只有当该部件在目标档位确实存在材料（#FUSE_OK = 1）时才消耗双手。
# ============================================================

function tspire:artisan/fuse_check

execute if score #FUSE_OK tspire_timer matches 0 run tellraw @s [{"text":"融合失败：这枚部件没有更高一档的材料可用（比如护甲板没有 tier 1 材料）。","color":"red"}]

execute if score #FUSE_OK tspire_timer matches 1 run scoreboard players remove @s tspire_gold 30
execute if score #FUSE_OK tspire_timer matches 1 run scoreboard players set @s tspire_fuse_used 1
execute if score #FUSE_OK tspire_timer matches 1 run item replace entity @s weapon.mainhand with air
execute if score #FUSE_OK tspire_timer matches 1 run item replace entity @s weapon.offhand with air
execute if score #FUSE_OK tspire_timer matches 1 run function tspire:artisan/fuse_give
execute if score #FUSE_OK tspire_timer matches 1 run tellraw @s [{"text":"融合成功！两枚部件已消耗。剩余金币：","color":"green"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]
execute if score #FUSE_OK tspire_timer matches 1 run playsound minecraft:block.beacon.activate master @s ~ ~ ~ 1.0 1.8
execute if score #FUSE_OK tspire_timer matches 1 run particle minecraft:enchant ~ ~1 ~ 0.6 0.6 0.6 0.5 30
