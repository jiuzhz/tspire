# Fixed hall preparation: floor 1, batch 50/58.
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~0 ~ run fill ~-6 ~-1 ~-180 ~6 ~-1 ~-180 minecraft:sea_lantern
schedule function tspire:map/prepare/f1_51 1t replace
