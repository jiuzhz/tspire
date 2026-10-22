# 按层随机抽一个 Boss
# 前置：#FLOOR 已设好；调用位置在 Boss 节点附近

execute if score #FLOOR tspire_timer matches 1 run function tspire:boss/pick_floor1
execute if score #FLOOR tspire_timer matches 2 run function tspire:boss/pick_floor2
execute if score #FLOOR tspire_timer matches 3 run function tspire:boss/pick_floor3
function tspire:mobs/equip_boss_armor
function tspire:mystery/pig_bless_apply
