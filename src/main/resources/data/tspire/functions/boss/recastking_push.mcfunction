# ============================================================
# 重铸之王【金铸壁垒】 · 水平外推 4 格（执行者 = 玩家，位置 = 玩家）
# ============================================================
# 【v0.6.62 待办 #28 结案：真·任意方向的水平外推】
#   旧实现把"玩家相对 Boss"的位移拆成 dx / dz，**谁大就沿谁推** —— Y 一定不变是优点，
#   代价是**斜向退化成轴向**（贴着 45° 站也会被往正 X / 正 Z 推出去）。
#   现在改用"朝向载体"：
#     1) 在 Boss 脚下放一个临时 marker，再 tp @s ~ ~ ~ facing entity <玩家> feet 把它转向该玩家；
#     2) rotated ~ 0 把 marker 的**俯仰角强制归零**，再沿它的朝向把玩家推 4 格。
#   于是推进方向 = 「Boss → 玩家」的**水平**方向（任意角度都精确），**Y 分量恒为 0**：
#   既不会像  tp @s ^ ^ ^-4 那样被俯仰角带出竖直分量把人顶飞出图，也不再退化成轴向。
#   房间半径 7、Boss 在房内，4 格位移不会穿进墙里。
# ============================================================

# 给受害者打标签：下一步执行者会切换成 marker，得靠标签才指得回玩家
tag @s add tspire_kb_victim

# Boss 脚下放朝向用 marker，并让它面朝该玩家（feet 会把高度差算进去，稍后抹平）
kill @e[tag=tspire_kb_rot]
execute at @e[tag=tspire_boss_recastking,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["tspire_kb_rot"]}
execute as @e[tag=tspire_kb_rot,limit=1] at @s run tp @s ~ ~ ~ facing entity @e[tag=tspire_kb_victim,limit=1] feet

# 沿 marker 的水平朝向推 4 格（pitch 已归零 → Y 一定不变）
execute at @s rotated as @e[tag=tspire_kb_rot,limit=1] rotated ~ 0 run tp @s ^ ^ ^4

# 收尾
kill @e[tag=tspire_kb_rot]
tag @s remove tspire_kb_victim

# 表现：脚下云粒子
execute at @s run particle minecraft:cloud ~ ~0.2 ~ 0.5 0.2 0.5 0.05 12 force
