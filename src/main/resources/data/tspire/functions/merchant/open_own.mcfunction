# Runtime per-player shelf; this function is called at the merchant counter.
execute unless score @s tspire_shop_f = #FLOOR tspire_timer if score #FLOOR tspire_timer matches 1 run function tspire:shop/pick_f1
execute unless score @s tspire_shop_f = #FLOOR tspire_timer if score #FLOOR tspire_timer matches 2 run function tspire:shop/pick_f2
execute unless score @s tspire_shop_f = #FLOOR tspire_timer if score #FLOOR tspire_timer matches 3 run function tspire:shop/pick_f3
execute unless score @s tspire_sale_a matches 0..10 run function tspire:shop/pick_sales
execute unless score @s tspire_sale_b matches 0..10 run function tspire:shop/pick_sales
execute at @e[tag=tspire_shop] run setblock ~ ~ ~ minecraft:air
execute at @e[tag=tspire_shop] run setblock ~ ~-1 ~ minecraft:air
execute in tspire:tower run kill @e[tag=tspire_shop]
summon minecraft:marker ~ ~-2 ~ {Tags:["tspire_shop"]}
execute at @e[tag=tspire_shop] run setblock ~ ~ ~ minecraft:chest{Lock:"tspire_sealed"}
execute at @e[tag=tspire_shop] run setblock ~ ~-1 ~ minecraft:polished_andesite
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s0_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s1_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s2_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s3_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s4_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s5_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s6_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s7_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s8_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s9_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s10_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s11_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s12_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s13_fill
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s14_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s0_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s1_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s2_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s3_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s4_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s5_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s6_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s7_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s8_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s9_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s10_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s11_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s12_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s13_fill
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s14_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s0_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s1_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s2_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s3_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s4_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s5_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s6_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s7_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s8_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s9_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s10_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s11_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s12_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s13_fill
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s14_fill
