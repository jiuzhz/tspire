# ============================================================
# 修复装备（设计文档 §3.1.2）：花金币把**全部**装备与物品栏里的工具修满
# ============================================================
# 【v0.6.27 三处调整（玩家要求）】
#   1. 修复范围从"六个装备槽"扩大到**整个物品栏**（container.0..35），
#      这样背包里的备用工具也能一起修。
#   2. 每修复一次额外给 32 支箭。
#   3. 价格递增：基础 #CFG_REPAIR_COST，每修一次 + #CFG_REPAIR_COST_STEP（默认 5），
#      本局内累加 —— 实际价格由 artisan/repair_cost 算到 @s tspire_repair_cost。
#
# 实现方式：item modifier `tspire:repair` 就是一条 `minecraft:set_damage`
# 且 `damage: 1.0`（= 剩余耐久 100%）。对没有耐久字段的物品是空操作，所以
# 对整包物品栏用一遍是安全的。
# ============================================================

# 先把本次价格算出来（菜单里也会算，这里再算一次保证用的是最新值）
function tspire:artisan/repair_cost

scoreboard players operation #TMP tspire_timer = @s tspire_gold
scoreboard players operation #TMP tspire_timer -= @s tspire_repair_cost

execute if score #TMP tspire_timer matches ..-1 run tellraw @s [{"text":"金币不足，本次修复需要 ","color":"red"},{"score":{"name":"@s","objective":"tspire_repair_cost"},"color":"gold"},{"text":" 金币。","color":"red"}]
execute if score #TMP tspire_timer matches 0.. run function tspire:artisan/repair_do
