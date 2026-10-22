# Runtime draw: 15 independent slot rolls, each uniform on 1..16.
scoreboard players set @s tspire_shop_f 2
scoreboard players set @s tspire_shop_l 1
scoreboard players set @s tspire_shop_anc 0
execute if predicate tspire:roll/d20 run scoreboard players set @s tspire_shop_anc 1
scoreboard players set @s tspire_shop_spec 0
execute unless predicate tspire:roll/d10 run function tspire:shop/pick_special
scoreboard players set @s tspire_s0 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s0 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s0 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s0 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s0 8
scoreboard players set @s tspire_buy0 0
scoreboard players set @s tspire_s1 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s1 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s1 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s1 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s1 8
scoreboard players set @s tspire_buy1 0
scoreboard players set @s tspire_s2 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s2 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s2 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s2 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s2 8
scoreboard players set @s tspire_buy2 0
scoreboard players set @s tspire_s3 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s3 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s3 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s3 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s3 8
scoreboard players set @s tspire_buy3 0
scoreboard players set @s tspire_s4 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s4 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s4 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s4 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s4 8
scoreboard players set @s tspire_buy4 0
scoreboard players set @s tspire_s5 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s5 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s5 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s5 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s5 8
scoreboard players set @s tspire_buy5 0
scoreboard players set @s tspire_s6 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s6 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s6 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s6 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s6 8
scoreboard players set @s tspire_buy6 0
scoreboard players set @s tspire_s7 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s7 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s7 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s7 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s7 8
scoreboard players set @s tspire_buy7 0
scoreboard players set @s tspire_s8 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s8 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s8 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s8 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s8 8
scoreboard players set @s tspire_buy8 0
scoreboard players set @s tspire_s9 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s9 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s9 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s9 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s9 8
scoreboard players set @s tspire_buy9 0
scoreboard players set @s tspire_s10 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s10 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s10 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s10 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s10 8
scoreboard players set @s tspire_buy10 0
scoreboard players set @s tspire_s11 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s11 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s11 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s11 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s11 8
scoreboard players set @s tspire_buy11 0
scoreboard players set @s tspire_s12 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s12 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s12 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s12 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s12 8
scoreboard players set @s tspire_buy12 0
scoreboard players set @s tspire_s13 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s13 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s13 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s13 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s13 8
scoreboard players set @s tspire_buy13 0
scoreboard players set @s tspire_s14 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s14 1
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s14 2
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s14 4
execute if predicate tspire:roll/d2 run scoreboard players add @s tspire_s14 8
scoreboard players set @s tspire_buy14 0
function tspire:shop/pick_sales
