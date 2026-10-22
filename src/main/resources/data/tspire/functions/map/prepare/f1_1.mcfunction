# Fixed hall preparation: floor 1, batch 1/58.
execute in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~0 ~ run fill ~-42 ~-3 ~34 ~42 ~8 ~5 minecraft:air
schedule function tspire:map/prepare/f1_2 1t replace
