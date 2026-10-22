# ============================================================
# 织影巫师【尖牙阵】—— 每 10 秒；在每名队员脚下布一圈尖牙，延迟 1 秒咬合
# ============================================================
# 用 9 个 `minecraft:evoker_fangs` 摆成 3×3（中心那枚就在队员脚下的方块里）：
#   - 咬合由原版 `Warmup:20`（20 tick = 1 秒）实现，不需要自己做延迟；
#   - 站在中心不动必被咬（6 点），往外挪 1 格仍可能被邻格咬到，
#     挪出 2 格以上就能躲开 —— "延迟 1 秒咬合"因此是**可躲的**；
#   - 单次伤害不高（原版尖牙 6 点），威胁在于密集触发与配合恼鬼。
# 只对**队员**生效，不针对 Boss 自己或召唤物。
# ============================================================

scoreboard players set #WEA_C1 tspire_timer 0

# 逐名队员生成 3×3 尖牙（Warmup 20 = 1 秒后咬合）
# 【v0.6.43】排除阵亡/旁观的队友（tspire_dead=1）—— 他们也还在队伍里，
#   否则会在旁观视角的位置凭空出现尖牙。
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~-1 ~ ~-1 {Warmup:20}
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~ ~ ~-1 {Warmup:20}
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~1 ~ ~-1 {Warmup:20}
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~-1 ~ ~ {Warmup:20}
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~ ~ ~ {Warmup:20}
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~1 ~ ~ {Warmup:20}
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~-1 ~ ~1 {Warmup:20}
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~ ~ ~1 {Warmup:20}
execute at @a[team=tspire_party,scores={tspire_dead=0}] run summon minecraft:evoker_fangs ~1 ~ ~1 {Warmup:20}

# 预警：地面粒子圈 + 音效，让玩家有 1 秒时间挪开
execute at @a[team=tspire_party,scores={tspire_dead=0}] run particle minecraft:enchanted_hit ~ ~0.1 ~ 1.2 0.1 1.2 0.02 30 force
execute at @a[team=tspire_party,scores={tspire_dead=0}] run particle minecraft:soul ~ ~0.2 ~ 1 0.1 1 0.01 12 force
title @a[team=tspire_party] actionbar {"text":"⚠ 【尖牙阵】脚下尖牙 1 秒后咬合 —— 快挪开！","color":"light_purple","bold":true}
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.evoker.prepare_attack master @s ~ ~ ~ 1 0.8
execute as @a[team=tspire_party] at @s run playsound minecraft:entity.evoker_fangs.attack master @s ~ ~ ~ 0.7 0.7
