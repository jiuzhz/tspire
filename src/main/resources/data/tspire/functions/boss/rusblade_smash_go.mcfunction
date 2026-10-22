# 锈刃督军【破甲重击】第二段 —— 第一段的缓慢结束后（3 秒）结算
# 速度 II + 力量 各 5 秒

scoreboard players set #RUS_SMASH tspire_timer 0
scoreboard players set #RUS_SMASH_T tspire_timer 0

effect give @e[tag=tspire_boss_rusblade,limit=1] minecraft:speed 5 2 true
effect give @e[tag=tspire_boss_rusblade,limit=1] minecraft:strength 5 0 true
# v0.6.54（玩家要求）：3 秒前摇结束后追加**抗性提升**（抗性提升 I，5 秒，与速度/力量同长）
effect give @e[tag=tspire_boss_rusblade,limit=1] minecraft:resistance 5 0 true

title @a[team=tspire_party] actionbar {"text":"【破甲重击】督军爆发 —— 速度 III + 力量 + 抗性提升，拉开距离！","color":"red","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.ravager.attack master @s ~ ~ ~ 1 0.6
execute as @a[team=tspire_party] at @s run playsound minecraft:block.anvil.land master @s ~ ~ ~ 0.9 0.8
