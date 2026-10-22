# ============================================================
# 怪物伤害探针（v0.7.21 新增；v0.7.21b 修正判读说明）
# ============================================================
# 用途：玩家反馈"怪一刀秒人"，需要看清**每一只怪的伤害是怎么来的**。
# 用法：站在战斗房里执行 /function tspire:test/damage_probe
#   · 只把结果发给执行者（临时标签 tspire_dmg_probe），不刷给队友
#   · 逐只 tspire_mob 打印：实体 id / 攻击力属性（Base + 所有 Modifiers）/
#     主手物品 id / 主手材料 tic_materials / 手上强化 tic_modifiers /
#     **武器算出来的数值 tic_stats** / 身上效果 ActiveEffects
#   · 再打印执行者自己的护甲与生命，方便对照"一刀掉多少"
#
# ★ 判读要点（v0.7.21b 修正，之前这里写错过一次）★
#   **匠魂近战武器的伤害加成会出现在持有者的 attack_damage 总属性里。** 旧版说明把它误判成受击钩子。
#   Base 只显示原始属性；完整值请用 test/aim_damage 读取。
# ============================================================
tag @s add tspire_dmg_probe
tellraw @s [{"text":"=== 怪物伤害探针 ===","color":"gold","bold":true}]
tellraw @s [{"text":"[你] 护甲:","color":"yellow"},{"nbt":"Attributes[{Name:\"minecraft:generic.armor\"}]","entity":"@s","color":"aqua"},{"text":"  生命:","color":"yellow"},{"nbt":"Health","entity":"@s","color":"red"}]
tellraw @s [{"text":"⚠ 此处展示的是 NBT 基础值，不是完整攻击属性；包含匠魂武器的当前总攻击请用 /function tspire:test/aim_damage。","color":"red"}]

execute as @e[tag=tspire_mob] run tellraw @a[tag=tspire_dmg_probe] [{"text":"[怪] ","color":"gray"},{"nbt":"id","entity":"@s","color":"white"},{"text":"  原版攻击力:","color":"yellow"},{"nbt":"Attributes[{Name:\"minecraft:generic.attack_damage\"}]","entity":"@s","color":"aqua"}]
execute as @e[tag=tspire_mob] run tellraw @a[tag=tspire_dmg_probe] [{"text":"     主手:","color":"gray"},{"nbt":"HandItems[0].id","entity":"@s","color":"white"},{"text":"  材料:","color":"gray"},{"nbt":"HandItems[0].tag.tic_materials","entity":"@s","color":"green"},{"text":"  强化:","color":"gray"},{"nbt":"HandItems[0].tag.tic_modifiers","entity":"@s","color":"dark_green"}]
execute as @e[tag=tspire_mob] run tellraw @a[tag=tspire_dmg_probe] [{"text":"     ★武器数值:","color":"gold"},{"nbt":"HandItems[0].tag.tic_stats","entity":"@s","color":"gold"},{"text":"  效果:","color":"gray"},{"nbt":"ActiveEffects","entity":"@s","color":"light_purple"}]

tellraw @s [{"text":"对照档位看设计文档 §7.10（一层武器 0..1 / 二层 1..2 / 三层 2..3；护甲各高一级；三层 BOSS 武器 3 级）。","color":"dark_gray"}]
tag @s remove tspire_dmg_probe

