# First-floor hand-built lobby, batch 90/90.
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~25 ~23 ~-6 ~25 ~23 ~-6 minecraft:mangrove_leaves[distance=4,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~23 ~24 ~-10 ~23 ~24 ~-10 minecraft:vine[east=false,north=false,south=true,up=false,west=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~23 ~24 ~-9 ~23 ~24 ~-9 minecraft:mangrove_leaves[distance=4,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~25 ~24 ~-9 ~25 ~24 ~-9 minecraft:mangrove_leaves[distance=4,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~26 ~24 ~-9 ~26 ~24 ~-9 minecraft:mangrove_leaves[distance=5,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~22 ~24 ~-8 ~22 ~24 ~-8 minecraft:mangrove_leaves[distance=4,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~23 ~24 ~-8 ~23 ~24 ~-8 minecraft:mangrove_leaves[distance=3,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~24 ~24 ~-8 ~24 ~24 ~-8 minecraft:vine[east=true,north=false,south=false,up=false,west=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~25 ~24 ~-8 ~25 ~24 ~-8 minecraft:mangrove_leaves[distance=3,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~26 ~24 ~-8 ~26 ~24 ~-8 minecraft:mangrove_leaves[distance=4,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~22 ~24 ~-7 ~22 ~24 ~-7 minecraft:mangrove_leaves[distance=5,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~24 ~24 ~-7 ~24 ~24 ~-7 minecraft:vine[east=true,north=false,south=false,up=false,west=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~25 ~24 ~-7 ~25 ~24 ~-7 minecraft:mangrove_leaves[distance=4,persistent=false,waterlogged=false]
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run fill ~23 ~24 ~-6 ~23 ~24 ~-6 minecraft:mangrove_leaves[distance=5,persistent=false,waterlogged=false]
scoreboard players set #MAP_READY1 tspire_timer 1
schedule function tspire:map/prepare/f2_1 1t replace
