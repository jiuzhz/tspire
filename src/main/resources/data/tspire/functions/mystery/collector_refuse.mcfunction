# 黏液收藏家 · 不给：受到 20% 生命伤害（4 点）
# ============================================================
# 【v0.7.20 修复】这是**不可拒绝**的惩罚，原来直接 `damage @s 4`，生命 ≤4 点时会打死人。
#   现在先即时读取真实生命：≥5 点才扣 4 点（扣完至少剩 1 点）；不足 5 点时改成"收住手"，
#   只挨骂不掉血。选择照样消费掉（事件正常结束）。
# ============================================================
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2
execute if score @s tspire_my_choice matches 2 run function tspire:hp/read
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 10.. run damage @s 4 minecraft:magic
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 10.. run tellraw @s [{"text":"[收藏家] ","color":"green","bold":true},{"text":"「……真小气。」他一拳砸在你身上（−20% 生命，4 点）。","color":"red"}]
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches ..9 run tellraw @s [{"text":"[收藏家] ","color":"green","bold":true},{"text":"「……真小气。」他抬手要砸，看你只剩一口气又收住了（生命太低，这次没扣）。","color":"yellow"}]
execute if score @s tspire_my_choice matches 2 as @s at @s run playsound minecraft:entity.player.hurt master @s ~ ~ ~ 1 1
