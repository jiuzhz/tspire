# 海龟 · 嘲笑：获得「绿皮王八的诅咒」（神龟药水）
execute if score @s tspire_my_choice matches 0 run give @s minecraft:potion{Potion:"minecraft:turtle_master",display:{Name:'{"text":"绿皮王八的诅咒","italic":false,"color":"green"}'}} 1
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[海龟] ","color":"green","bold":true},{"text":"你笑了。它气鼓鼓地塞给你一瓶药：「那你替我喝了吧。」","color":"dark_green"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.turtle.hurt master @s ~ ~ ~ 1 0.8
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2
