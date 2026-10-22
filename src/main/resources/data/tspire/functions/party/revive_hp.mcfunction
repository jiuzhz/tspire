effect give @s minecraft:instant_health 1 10 true
function tspire:hp/read
execute if score #CFG_REVIVE_HP_PERCENT tspire_config matches ..25 if score #HP_H tspire_timer matches 32.. run damage @s 15 minecraft:magic
execute if score #CFG_REVIVE_HP_PERCENT tspire_config matches 26..50 if score #HP_H tspire_timer matches 22.. run damage @s 10 minecraft:magic
execute if score #CFG_REVIVE_HP_PERCENT tspire_config matches 51..75 if score #HP_H tspire_timer matches 12.. run damage @s 5 minecraft:magic
