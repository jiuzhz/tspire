# 【燃烧蓄能】收摊：销毁圆心 marker（纯粒子版没有方块要清）—— 执行者不限

execute in tspire:tower run kill @e[tag=tspire_firez]
scoreboard players set #QZ tspire_timer 0
scoreboard players set #QZ_T tspire_timer 0

title @a[team=tspire_party] actionbar {"text":"火焰消散了","color":"gray"}
