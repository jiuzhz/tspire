# Read-only aim probe; targets tower combat mobs within 16 blocks.
tag @e[tag=tspire_probe_target] remove tspire_probe_target
scoreboard players set #AIM_STEP tspire_timer 0
execute anchored eyes positioned ^ ^ ^0.5 anchored feet run function tspire:test/aim_damage_ray
execute unless entity @e[tag=tspire_probe_target,limit=1] run tellraw @s {"text":"[伤害探针] 视线前方 16 格内没有找到尖塔战斗生物；请对准目标后重试。","color":"yellow"}
execute if entity @e[tag=tspire_probe_target,limit=1] run function tspire:test/aim_damage_report
tag @e[tag=tspire_probe_target] remove tspire_probe_target
