# 只穿盔甲不发武器 —— 给唤魔者这类「法术型、不该拿武器」的 Boss 用
# 复用现有的盔甲战利品表，按 #FLOOR 分支

execute if score #FLOOR tspire_timer matches 1 run function tspire:mobs/equip_armor_only_f1
execute if score #FLOOR tspire_timer matches 2 run function tspire:mobs/equip_armor_only_f2
execute if score #FLOOR tspire_timer matches 3 run function tspire:mobs/equip_armor_only_f3
