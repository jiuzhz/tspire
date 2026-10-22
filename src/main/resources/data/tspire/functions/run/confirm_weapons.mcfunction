# 确认武器选择（六选二）：正好 2 件才放行（执行者 = 玩家）
# ============================================================
# 【v0.6.20 多人修正】只有**全队都选完**才开跑。
#   原来是一句 `if score @s tspire_wcount matches 2 run function begin_run`：
#   多人局里第一个人选完，全队就被拖进主循环（begin_run 会置 phase 5 并开 HUD），
#   剩下的人构筑被腰斩、手上只有护甲没有武器。
# ============================================================

execute unless score @s tspire_wcount matches 2 run tellraw @s [{"text":"需要正好选 2 件武器。","color":"red"}]

# 统计还没选完的人数（把自己也算进去）
scoreboard players set #PICK_LEFT tspire_timer 0
execute as @a[team=tspire_party] unless score @s tspire_wcount matches 2 run scoreboard players add #PICK_LEFT tspire_timer 1

execute if score @s tspire_wcount matches 2 if score #PICK_LEFT tspire_timer matches 1.. run tellraw @s [{"text":"你的武器选好了，等其他队友选完就开局。","color":"yellow"}]
execute if score @s tspire_wcount matches 2 if score #PICK_LEFT tspire_timer matches 0 unless score #RUN_STARTED tspire_timer matches 1 run function tspire:run/begin_run
