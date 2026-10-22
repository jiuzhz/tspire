# Eligible events receive one marker each; random marker = uniform among eligible events.
execute if score #ME_1 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 1
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_2 tspire_timer matches ..1 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 2
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_5 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 3
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_6 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 4
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_7 tspire_timer matches ..1 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 5
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_8 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 6
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_9 tspire_timer matches ..2 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 7
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_10 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 8
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_13 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 9
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_12 tspire_timer matches ..1 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 10
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_15 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 11
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_16 tspire_timer matches ..1 unless score #PARTY_SIZE tspire_timer matches 3.. run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 12
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_17 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 13
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_18 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 14
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_19 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 15
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_20 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 16
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_21 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 17
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_23 tspire_timer matches ..0 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 18
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
execute if score #ME_24 tspire_timer matches ..1 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}
execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot 19
tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new
