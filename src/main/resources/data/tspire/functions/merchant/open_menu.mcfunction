# Runtime per-player menu; each line follows its separately rolled slot.
execute unless score @s tspire_sale_a matches 0..10 run function tspire:shop/pick_sales
execute unless score @s tspire_sale_b matches 0..10 run function tspire:shop/pick_sales
tellraw @s [{"text":"========== 商人货架 ==========","color":"gold","bold":true}]
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s0_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s0_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s0_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s1_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s1_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s1_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s2_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s2_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s2_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s3_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s3_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s3_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s4_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s4_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s4_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s5_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s5_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s5_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s6_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s6_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s6_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s7_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s7_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s7_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s8_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s8_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s8_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s9_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s9_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s9_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s10_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s10_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s10_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s11_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s11_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s11_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s12_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s12_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s12_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s13_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s13_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s13_menu
execute if score @s tspire_shop_f matches 1 run function tspire:shop/f1_s14_menu
execute if score @s tspire_shop_f matches 2 run function tspire:shop/f2_s14_menu
execute if score @s tspire_shop_f matches 3 run function tspire:shop/f3_s14_menu
tellraw @s [{"text":"也可以直接把要卖的东西丢到商人旁边，他会自动收购。","color":"dark_gray"}]
tellraw @s [{"text":"[出售] 卖出手中的匠魂物品","color":"green","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 6"},"hoverEvent":{"action":"show_text","contents":"部件按材料 6/10/14/18；水晶按类别 9/11/13/15；装备按最高材料 16/30/42/50；远古工具 40"}}]
tellraw @s [{"text":"当前金币：","color":"gray"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]
tellraw @s [{"text":"==============================","color":"gold","bold":true}]
