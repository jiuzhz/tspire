# 开下一场战斗（战斗序号自动 +1）
# 第 1~2 场走简单池，第 3 场起自动切困难池（§7.4）
function tspire:run/battle_start

execute store result score #TMP_B tspire_timer run scoreboard players get #BATTLE tspire_timer
tellraw @s [{"text":"[战斗演示] ","color":"gold"},{"text":"已开第 ","color":"white"},{"score":{"name":"#TMP_B","objective":"tspire_timer"},"color":"yellow"},{"text":" 场（序号 ≥3 时为困难池）","color":"white"}]
