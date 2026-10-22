# ============================================================
# 按上限决定要不要出一批怪（由 run/battle_start 调用）
# ============================================================
# 已经到上限就不刷，避免长战斗（尤其唤魔者/织影巫师持续召唤）把实体堆爆。
# 批内数量不拆开算 —— 上限是"批次闸门"，不是精确配额。
# ============================================================

function tspire:mobs/cap

execute if score #MOB_COUNT tspire_timer < #MOB_CAP tspire_timer in tspire:tower run function tspire:mobs/roll_group

execute if score #MOB_COUNT tspire_timer >= #MOB_CAP tspire_timer run tellraw @a[team=tspire_party] [{"text":"[尖塔] ","color":"gold"},{"text":"场上敌人已达上限（","color":"gray"},{"score":{"name":"#MOB_COUNT","objective":"tspire_timer"},"color":"yellow"},{"text":" / ","color":"gray"},{"score":{"name":"#MOB_CAP","objective":"tspire_timer"},"color":"yellow"},{"text":"），本批敌人没有刷新。","color":"gray"}]
