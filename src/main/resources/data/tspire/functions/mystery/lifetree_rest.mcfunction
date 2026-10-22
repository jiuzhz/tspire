# 生命本源 · 简单休息：回复 25% 生命（20 点上限 → 5 点，约 +5）
# ============================================================
# 【v0.7.20 修复】（玩家报"生命本源出现扣血直接扣死 / 回血反而掉血"）
#   旧写法是「instant_health II（+8）→ 再 damage 3 抹掉多出来的 3 点」。
#   那个 −3 是**无条件**打的：玩家生命本来就低时，"回血"这一步只有 +8 是确定的，
#   而 −3 会立刻结算 —— 生命 ≤3 点的玩家直接被这一下打死。
#   现在改成**只加不减**：instant_health I（+4）+ 生命恢复 3 秒（约 +1）≈ +5 点。
#   治疗永远会被原版按生命上限截断，所以这条路径**在数学上不可能掉血**。
# ============================================================
execute if score @s tspire_my_choice matches 0 run effect give @s minecraft:instant_health 1 0 true
execute if score @s tspire_my_choice matches 0 run effect give @s minecraft:regeneration 3 0 true
execute if score @s tspire_my_choice matches 0 run tellraw @s [{"text":"[生命本源] ","color":"green","bold":true},{"text":"你在树下坐了一会儿，伤口愈合了一些（+25% 生命，约 5 点）。","color":"aqua"}]
execute if score @s tspire_my_choice matches 0 as @s at @s run playsound minecraft:block.azalea.place master @s ~ ~ ~ 1 1.2
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 2
