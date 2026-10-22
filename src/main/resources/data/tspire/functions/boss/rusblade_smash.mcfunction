# 锈刃督军【破甲重击】第一段 —— 每 28 秒
# Boss 先给自己上缓慢 10（3 秒），3 秒后再上速度 II + 力量 5 秒（见 rusblade_smash_go）

scoreboard players set #RUS_C3 tspire_timer 0
scoreboard players set #RUS_SMASH tspire_timer 1
scoreboard players set #RUS_SMASH_T tspire_timer 0

effect give @e[tag=tspire_boss_rusblade,limit=1] minecraft:slowness 3 9 true

title @a[team=tspire_party] actionbar {"text":"【破甲重击】督军蓄力中（被拖住了 3 秒）—— 趁现在打！","color":"gold","bold":true}
tellraw @a[team=tspire_party] [{"text":"[锈刃督军] ","color":"dark_red","bold":true},{"text":"破甲重击！","color":"gold","bold":true},{"text":"它先被缓慢 10 拖住 3 秒，随后会获得速度 III 与力量 —— 抓住这 3 秒的输出窗口。","color":"yellow"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.iron_golem.attack master @s ~ ~ ~ 1 0.7
