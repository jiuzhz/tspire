# ============================================================
# 三层战斗房装饰 · 应用到「当前节点」（v0.7.21）
# ============================================================
# 玩家踏进三层的战斗 / 精英节点时，由 map/enter_combat 调用。
# 锚点 = tspire_node_current 标记（= 房间中心、地板行走层）。
# ============================================================
execute in tspire:tower as @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] at @s run function tspire:deco/pick_f3
