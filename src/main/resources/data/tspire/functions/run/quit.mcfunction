# Move across dimensions explicitly before looking for a safe surface.
# spreadplayers alone may choose a position without changing the player's dimension.
scoreboard players set #RETURN_OK tspire_timer 0
execute in minecraft:overworld run tp @s 0 256 0
execute store success score #RETURN_OK tspire_timer in minecraft:overworld run spreadplayers 0 0 0 512 false @s
execute if score #RETURN_OK tspire_timer matches 1 if entity @s[gamemode=spectator] run gamemode survival @s
execute if score #RETURN_OK tspire_timer matches 1 run effect clear @s
execute if score #RETURN_OK tspire_timer matches 1 run scoreboard players set @s tspire_phase 0
execute if score #RETURN_OK tspire_timer matches 1 run scoreboard players set @s tspire_dead 0
execute if score #RETURN_OK tspire_timer matches 1 in minecraft:overworld at @s run spawnpoint @s ~ ~ ~
execute if score #RETURN_OK tspire_timer matches 1 run team leave @s
execute if score #RETURN_OK tspire_timer matches 1 run tellraw @s [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"已回到主世界的安全地面。","color":"white"}]
execute if score #RETURN_OK tspire_timer matches 0 run tellraw @s [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"未找到安全落点，退出已取消；请联系管理员。","color":"red"}]
execute if score #RETURN_OK tspire_timer matches 1 at @s run playsound minecraft:entity.enderman.teleport master @s ~ ~ ~ 1 1
