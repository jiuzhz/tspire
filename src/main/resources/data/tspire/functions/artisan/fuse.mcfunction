# ============================================================
# 融合（设计文档 §3.1.2，v0.6.35 新增）
# ============================================================
# 主手 + 副手各一枚部件 → 消耗两者，得到与主手同类型、材料档位按规则算出的部件：
#   同档 → 升一档（4+4 → 4）；不同档 → 取较高的那一档。30 金币，每个工匠节点限一次。
# 执行者 = 玩家（由工匠菜单的 tellraw clickEvent 调用）。
#
# 生成器：tools/gen-rewards.ps1 第 6.6 节
#   artisan/fuse_read  —— 读主手 #PIDX / 副手 #PIDX2（部件序号，0 = 不是部件）
#   artisan/fuse_check —— 该部件在目标层有没有材料池（#FUSE_OK）
#   artisan/fuse_give  —— 真的发放（loot give）
# ============================================================

scoreboard players set #PIDX tspire_timer 0
scoreboard players set #PIDX2 tspire_timer 0
scoreboard players set #FUSE_T tspire_timer 0
scoreboard players set #FUSE_OK tspire_timer 0

# 门 1：本节点是否已经融合过
execute if score @s tspire_fuse_used matches 1.. run tellraw @s [{"text":"这个工匠节点已经融合过了。","color":"red"}]

# 门 2：双手都必须是部件
execute if score @s tspire_fuse_used matches 0 run function tspire:artisan/fuse_read
execute if score @s tspire_fuse_used matches 0 if score #PIDX tspire_timer matches 0 run tellraw @s [{"text":"融合失败：主手需要持有一枚部件。","color":"red"}]
execute if score @s tspire_fuse_used matches 0 if score #PIDX tspire_timer matches 1.. if score #PIDX2 tspire_timer matches 0 run tellraw @s [{"text":"融合失败：副手也需要持有一枚部件。","color":"red"}]

# 门 3（v0.7.10 玩家裁定，回退 v0.7.5/v0.7.9 的"必须同档"）：
#   **不同档也能融合**，只是不会升档 —— 产物取两枚中较高的那一档；
#   两枚同档才会升一档（两个 2 级 → 3 级）；两枚 4 级只能出 4 级。
#   这里只拦"材料不在本作档位表里"（-1 / -2）的情况：那时算不出产物档位。
scoreboard players set #FUSE_MT tspire_timer -1
scoreboard players set #FUSE_OT tspire_timer -2
scoreboard players set #FUSE_SAME tspire_timer 0
scoreboard players set #FUSE_HI tspire_timer -1
execute if score @s tspire_fuse_used matches 0 if score #PIDX tspire_timer matches 1.. if score #PIDX2 tspire_timer matches 1.. run function tspire:artisan/fuse_tier
execute if score @s tspire_fuse_used matches 0 if score #PIDX tspire_timer matches 1.. if score #PIDX2 tspire_timer matches 1.. unless score #FUSE_MT tspire_timer matches 0.. run tellraw @s [{"text":"融合失败：主手这枚部件的材料不在本作的档位表里（其他模组的材料？），没法判断产物档位。","color":"red"}]
execute if score @s tspire_fuse_used matches 0 if score #PIDX tspire_timer matches 1.. if score #PIDX2 tspire_timer matches 1.. if score #FUSE_MT tspire_timer matches 0.. unless score #FUSE_OT tspire_timer matches 0.. run tellraw @s [{"text":"融合失败：副手这枚部件的材料不在本作的档位表里（其他模组的材料？），没法判断产物档位。","color":"red"}]

# 门 4：金币
execute if score @s tspire_fuse_used matches 0 if score #PIDX tspire_timer matches 1.. if score #PIDX2 tspire_timer matches 1.. if score #FUSE_T tspire_timer matches 1.. unless score @s tspire_gold matches 30.. run tellraw @s [{"text":"融合失败：金币不足（需要 30 金币）。","color":"red"}]

# 门 5：进入正式流程（材料能识别 + 有产物档位 + 金币足够）
execute if score @s tspire_fuse_used matches 0 if score #PIDX tspire_timer matches 1.. if score #PIDX2 tspire_timer matches 1.. if score #FUSE_MT tspire_timer matches 0.. if score #FUSE_OT tspire_timer matches 0.. if score #FUSE_T tspire_timer matches 1.. if score @s tspire_gold matches 30.. run function tspire:artisan/fuse_do
