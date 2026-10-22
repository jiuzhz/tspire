# ============================================================
# 战斗结束后复活所有阵亡队员（由 run/battle_win 调用）
# ============================================================

execute as @a[team=tspire_party,scores={tspire_dead=1..}] run function tspire:party/revive_self
