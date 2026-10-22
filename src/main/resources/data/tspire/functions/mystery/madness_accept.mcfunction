# 疯狂 · 接受：获得「疯狂低语」（岩浆膏：副手 −10 最大生命 / +30% 攻击伤害）
# 【v0.7.22 玩家要求】攻击伤害加成 25% → 30%；"扣除 10 点生命"改为**直接伤害**（v0.7.44），最大生命也同时 −10
#   （Operation:2 = 乘算加成；同一件物品上的 -10 max_health 就是那 10 点代价）。
# 【v0.7.44 玩家要求】接受疯狂要**真的扣 10 点生命**（原来只靠副手 -10 最大生命实现，玩家反映"没扣"）
#   血量不足时（<13）不扣，避免直接扣死；这一条必须先于 give 跑。
execute if score @s tspire_my_choice matches 0 if score #HP_H tspire_timer matches 25.. run damage @s 10 minecraft:generic
execute if score @s tspire_my_choice matches 0 run give @s minecraft:magma_cream{display:{Name:'{"text":"疯狂低语","italic":false,"color":"dark_purple"}',Lore:['{"text":"拿在副手时：-10 最大生命值、+30% 攻击伤害","color":"gray"}']},AttributeModifiers:[{AttributeName:"minecraft:generic.max_health",Name:"低语啃噬",Amount:-10,Operation:0,Slot:"offhand",UUID:[I;9,1,1,1]},{AttributeName:"minecraft:generic.attack_damage",Name:"疯狂",Amount:0.3,Operation:2,Slot:"offhand",UUID:[I;9,1,1,2]}]} 1
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[疯狂] ","color":"dark_purple","bold":true},{"text":"你让低语住了进来 —— 手里多了一团温热的岩浆膏，它在你耳边不停地说话。","color":"dark_purple"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:entity.elder_guardian.curse master @s ~ ~ ~ 1 0.7
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 1
