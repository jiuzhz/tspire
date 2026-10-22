# ============================================================
# 把执行者传送到"队伍所在处"（执行者 = 玩家）
# ============================================================
# 用途：阵亡切旁观、复活、以及"人跑出塔维度"时的兜底拉回。
#
# 优先级：
#   1) 还活着的队友（旁观时跟着能打的人）
#   2) 任何队友（全队阵亡时）
#   3) 当前节点 marker
#   4) 塔锚点（最后兜底）
#
# 实现要点：要用 marker 当中转，因为选择器没法简单排除"执行者自己"，
# 所以先给自己打个 tag，再从队友里挑（tag=!tspire_gather_self）。
# ============================================================

tag @s add tspire_gather_self
execute in tspire:tower run kill @e[tag=tspire_gather_pt]

# 1) 活着的、且在塔里的队友
execute in tspire:tower as @a[team=tspire_party,tag=!tspire_gather_self,scores={tspire_dead=0},nbt={Dimension:"tspire:tower"},limit=1] at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_gather_pt"]}
# 2) 任何在塔里的队友
execute in tspire:tower unless entity @e[tag=tspire_gather_pt] as @a[team=tspire_party,tag=!tspire_gather_self,nbt={Dimension:"tspire:tower"},limit=1] at @s run summon minecraft:marker ~ ~ ~ {Tags:["tspire_gather_pt"]}
# 3) 当前节点
execute in tspire:tower unless entity @e[tag=tspire_gather_pt] at @e[tag=tspire_node_current,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["tspire_gather_pt"]}
# 4) 锚点
execute in tspire:tower unless entity @e[tag=tspire_gather_pt] at @e[tag=tspire_anchor,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["tspire_gather_pt"]}

# 传送 + 收尾
execute in tspire:tower if entity @e[tag=tspire_gather_pt] run tp @s @e[tag=tspire_gather_pt,limit=1]
execute in tspire:tower run kill @e[tag=tspire_gather_pt]
tag @s remove tspire_gather_self
