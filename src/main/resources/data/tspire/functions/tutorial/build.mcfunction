# Fixed western route. Use the same room shells as the normal map.
# The strip is isolated from the generated tower (normal rooms end near X=-40).
fill -136 63 -96 -104 69 33 minecraft:deepslate_bricks
execute positioned -120 64 24 run function tspire:map/room_shell
execute positioned -120 64 0 run function tspire:map/room_shell
execute positioned -120 64 -24 run function tspire:map/room_shell
execute positioned -120 64 -48 run function tspire:map/room_shell
execute positioned -120 64 -80 run function tspire:map/room_boss
fill -121 64 32 -119 66 33 minecraft:deepslate_bricks
fill -121 64 10 -119 66 14 minecraft:air
fill -121 64 -17 -119 66 -7 minecraft:air
fill -121 64 -41 -119 66 -31 minecraft:air
fill -121 64 -66 -119 66 -55 minecraft:air
setblock -120 63 24 minecraft:polished_andesite
setblock -120 63 12 minecraft:sea_lantern
setblock -120 63 0 minecraft:red_concrete
setblock -120 63 -24 minecraft:emerald_block
setblock -120 63 -48 minecraft:orange_concrete
setblock -120 63 -80 minecraft:black_concrete
execute positioned -120 64 24 run function tspire:map/room_entry_lights
execute positioned -120 64 0 run function tspire:map/room_entry_lights
execute positioned -120 64 -24 run function tspire:map/room_entry_lights
execute positioned -120 64 -48 run function tspire:map/room_entry_lights
