# ============================================================
# 每个工匠节点只免费回血一次（执行者 = 玩家）
# ============================================================
# 钥匙：@s tspire_heal_node 与 #CRAFTZ（当前工匠节点 marker 的 z 坐标）。
# 两者相同 = 这个节点已经回过血了 → 跳过；否则回血并记下钥匙。
# 由 map/enter_artisan 对每名队员各调用一次 —— 每人各自一份钥匙，互不影响。
# （工匠节点 tag 是 tspire_node_reusable，可以反复进出，所以必须靠这个钥匙去重。）

scoreboard players set #HEAL_SKIP tspire_timer 0
execute if score @s tspire_heal_node = #CRAFTZ tspire_timer run scoreboard players set #HEAL_SKIP tspire_timer 1
execute if score #HEAL_SKIP tspire_timer matches 0 run function tspire:artisan/heal_free
execute if score #HEAL_SKIP tspire_timer matches 0 run scoreboard players operation @s tspire_heal_node = #CRAFTZ tspire_timer
