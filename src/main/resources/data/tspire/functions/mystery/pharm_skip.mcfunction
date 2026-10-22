# 药房 · 不买：直接走人 —— 但要**掉 10% 生命**（20 点上限 → 2 点）
# ============================================================
# 【v0.7.20 修复】旧版：hp ≥ 3 扣 2 点，否则扣 1 点 —— 但那个"否则"包含**只有 1 点血**的人，
#   扣 1 点就是扣死。而且守卫读的是 tspire_hp（health 判据，只在被显示时同步）。
#   现在即时读取真实生命：≥3 点才扣 2 点（扣完至少剩 1 点）；≤2 点就空手走出去，不掉血。
# ============================================================
execute if score @s tspire_my_choice matches 0 run scoreboard players set @s tspire_my_choice 5
execute if score @s tspire_my_choice matches 5 run function tspire:hp/read
execute if score @s tspire_my_choice matches 5 if score #HP_H tspire_timer matches 6.. run damage @s 2 minecraft:magic
execute if score @s tspire_my_choice matches 5 if score #HP_H tspire_timer matches 6.. run tellraw @s [{"text":"[药房] ","color":"light_purple","bold":true},{"text":"你什么也没买就走了 —— 空手而归让你有点提不起劲（生命 -10%，2 点）。","color":"yellow"}]
execute if score @s tspire_my_choice matches 5 if score #HP_H tspire_timer matches ..5 run tellraw @s [{"text":"[药房] ","color":"light_purple","bold":true},{"text":"你什么也没买就走了 —— 好在身上这点血也没再少（生命太低，这次没扣）。","color":"yellow"}]
execute if score @s tspire_my_choice matches 5 as @s at @s run playsound minecraft:entity.villager.no master @s ~ ~ ~ 1 1
