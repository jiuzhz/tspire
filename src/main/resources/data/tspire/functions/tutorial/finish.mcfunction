# Boss room is the final teaching stop. No boss is spawned and no floor is advanced.
tag @e[tag=tspire_node_current,tag=tspire_type_boss] add tspire_node_done
tellraw @s [{"text":"[教程 4/4 · BOSS] ","color":"dark_red"},{"text":"正式对局需要击败每层 BOSS；教程在入场时直接完成，不会生成 BOSS。","color":"white"}]
tellraw @s [{"text":"[新手教程] ","color":"aqua"},{"text":"教程完成！你已经体验了正式构筑、战斗奖励、商人和工匠节点。剩余金币：","color":"white"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]
function tspire:tutorial/exit
