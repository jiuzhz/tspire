# ============================================================
# 击退夹取（v0.7.19，玩家反馈"【战术突进】把玩家冲出场地/墙里"）
# ============================================================
# 为什么需要它：
#   【战术突进】水平推 5 格、【金铸壁垒】水平推 4 格，原注释假设"房间半径 7、推 5 格不会穿墙"
#   —— 但当玩家**贴着墙**、而 BOSS 在同一侧时，"从玩家位置沿 Boss→玩家方向推 5 格"就是
#   直接把人送进墙里、甚至推出房间。水平（pitch 归零）只保证不上下飞，管不住水平越界。
# 做法（对全队存活玩家，幂等）：
#   1) 3D 距离房间中心 > 14 的人打上 tspire_clamped；
#   2) 拉到房间中心（中心那块地砖永远是空的，且一定在场景内）；
#   3) 再朝"远离中心"的方向挪 2 格，避免所有人叠在正中、也避免卡在方块里。
#   —— 落点由场景几何决定，不依赖 BOSS 位置，所以两个 BOSS 共用这一个函数。
# 调用者：boss/skullcrusher_charge（推完人之后）、boss/recastking_bulwark（同上）。
# ============================================================

tag @a[team=tspire_party,scores={tspire_dead=0}] remove tspire_clamped
execute as @a[team=tspire_party,scores={tspire_dead=0}] at @s unless entity @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1,distance=..14] run tag @s add tspire_clamped
execute as @a[tag=tspire_clamped] run tp @s @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1]
execute as @a[tag=tspire_clamped] at @s facing entity @e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1] feet rotated ~ 0 run tp @s ^ ^ ^-2
execute as @a[tag=tspire_clamped] at @s run particle minecraft:cloud ~ ~0.3 ~ 0.4 0.3 0.4 0.05 15 force
execute as @a[tag=tspire_clamped] at @s run playsound minecraft:block.beacon.deactivate master @s ~ ~ ~ 1 1.4
execute as @a[tag=tspire_clamped] run title @s actionbar {"text":"被撞飞出去了 —— 已把你拉回场地内","color":"yellow"}
tag @a[tag=tspire_clamped] remove tspire_clamped
