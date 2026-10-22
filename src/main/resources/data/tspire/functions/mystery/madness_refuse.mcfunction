# 疯狂 · 拒绝：扣 25% 生命（5 点）
# ============================================================
# 【v0.7.20 修复】不可拒绝的惩罚，原来直接 `damage @s 5`，生命 ≤5 点时会打死人。
#   现在即时读取真实生命：≥6 点才扣 5 点；不足 6 点时你"死死捂住耳朵"本身就够惨了，不掉血。
# ============================================================
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2
execute if score @s tspire_my_choice matches 2 run function tspire:hp/read
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 12.. run damage @s 5 minecraft:magic
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches 12.. run tellraw @s [{"text":"[疯狂] ","color":"dark_purple","bold":true},{"text":"你死死捂住耳朵 —— 低语撕扯着你的意识（−25% 生命，5 点）。","color":"red"}]
execute if score @s tspire_my_choice matches 2 if score #HP_H tspire_timer matches ..11 run tellraw @s [{"text":"[疯狂] ","color":"dark_purple","bold":true},{"text":"你死死捂住耳朵 —— 低语没能再撕开什么（生命太低，这次没扣）。","color":"yellow"}]
execute if score @s tspire_my_choice matches 2 as @s at @s run playsound minecraft:entity.player.hurt master @s ~ ~ ~ 1 1
