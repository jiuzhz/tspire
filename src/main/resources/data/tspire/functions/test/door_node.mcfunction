# 打印单个节点（执行者 = 节点 marker，执行位置 = 节点）—— 由 test/door_check 调用
# 只发给打了 tspire_door_probe 的那名玩家

tellraw @a[tag=tspire_door_probe] [{"text":"· ","color":"gray"},{"nbt":"Pos","entity":"@s","color":"white"}]

execute if entity @s[tag=tspire_node_avail] run tellraw @a[tag=tspire_door_probe] [{"text":"   avail 可选（门应开）","color":"green"}]
execute if entity @s[tag=tspire_node_current] run tellraw @a[tag=tspire_door_probe] [{"text":"   current 当前（门应开）","color":"aqua"}]
execute if entity @s[tag=tspire_node_locked] run tellraw @a[tag=tspire_door_probe] [{"text":"   locked 本行被放弃（门应封）","color":"red"}]
execute if entity @s[tag=tspire_node_done] run tellraw @a[tag=tspire_door_probe] [{"text":"   done 已通过（门应封）","color":"dark_gray"}]
execute if entity @s[tag=tspire_node_reusable] run tellraw @a[tag=tspire_door_probe] [{"text":"   reusable 服务节点（可反复进）","color":"gold"}]

execute if block ~ ~ ~-9 minecraft:air tellraw @a[tag=tspire_door_probe] [{"text":"   北门 = 空气（开）","color":"green"}]
execute if block ~ ~ ~-9 minecraft:run tellraw @a[tag=tspire_door_probe] [{"text":"   北门 = 空气（开）","color":"green"}]
execute if block ~ ~ ~-9 minecraft:polished_blackstone_bricks tellraw @a[tag=tspire_door_probe] [{"text":"   北门 = 封条石（已封）","color":"red"}]
execute if block ~ ~ ~-9 minecraft:run tellraw @a[tag=tspire_door_probe] [{"text":"   北门 = 封条石（已封）","color":"red"}]
execute if block ~ ~ ~-9 minecraft:barrier tellraw @a[tag=tspire_door_probe] [{"text":"   北门 = 屏障（战斗临时封）","color":"gold"}]
execute if block ~ ~ ~-9 minecraft:run tellraw @a[tag=tspire_door_probe] [{"text":"   北门 = 屏障（战斗临时封）","color":"gold"}]
execute if block ~ ~ ~-9 minecraft:deepslate tellraw @a[tag=tspire_door_probe] [{"text":"   北门 = 深板岩（被岩体堵着／没有门）","color":"yellow"}]
execute if block ~ ~ ~-9 minecraft:run tellraw @a[tag=tspire_door_probe] [{"text":"   北门 = 深板岩（被岩体堵着／没有门）","color":"yellow"}]

execute if block ~ ~ ~9 minecraft:air tellraw @a[tag=tspire_door_probe] [{"text":"   南门 = 空气（开）","color":"green"}]
execute if block ~ ~ ~9 minecraft:run tellraw @a[tag=tspire_door_probe] [{"text":"   南门 = 空气（开）","color":"green"}]
execute if block ~ ~ ~9 minecraft:polished_blackstone_bricks tellraw @a[tag=tspire_door_probe] [{"text":"   南门 = 封条石（已封）","color":"red"}]
execute if block ~ ~ ~9 minecraft:run tellraw @a[tag=tspire_door_probe] [{"text":"   南门 = 封条石（已封）","color":"red"}]
execute if block ~ ~ ~9 minecraft:barrier tellraw @a[tag=tspire_door_probe] [{"text":"   南门 = 屏障（战斗临时封）","color":"gold"}]
execute if block ~ ~ ~9 minecraft:run tellraw @a[tag=tspire_door_probe] [{"text":"   南门 = 屏障（战斗临时封）","color":"gold"}]
execute if block ~ ~ ~9 minecraft:deepslate tellraw @a[tag=tspire_door_probe] [{"text":"   南门 = 深板岩（被岩体堵着／没有门）","color":"yellow"}]
execute if block ~ ~ ~9 minecraft:run tellraw @a[tag=tspire_door_probe] [{"text":"   南门 = 深板岩（被岩体堵着／没有门）","color":"yellow"}]