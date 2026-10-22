# ============================================================
# 匠魂尖塔 - V7 验证
# 问题：不用 mob_equipment，改用「summon 生成 + loot replace 塞装备」是否可行？
# ============================================================
# 背景：
#   V5 证明 mob_equipment 对 /summon 生成的怪不生效（它挂在 Forge 的
#   MobSpawnEvent.FinalizeSpawn 上，命令生成不一定触发）。
#   但 V1（tic_materials 直接可用）与 V3（add_tool_data 随机锻造可用）都通过了，
#   所以可以改走：先 summon 空手怪 -> 再用战利品表把随机材料的匠魂工具塞进它手里。
#
# 判定：
#   两只丧尸手上都出现匠魂剑，且 /data get 的 HandItems 里有 tic_materials
#   -> 这条链路可用，塔内出怪就用它（不依赖任何模组）
# ------------------------------------------------------------

kill @e[tag=tspire_v7]

summon minecraft:zombie ~2 ~ ~2 {Tags:["tspire_v7"],CustomName:'"V7-A"',CustomNameVisible:1b,PersistenceRequired:1b,NoAI:1b}
summon minecraft:zombie ~2 ~ ~4 {Tags:["tspire_v7"],CustomName:'"V7-B"',CustomNameVisible:1b,PersistenceRequired:1b,NoAI:1b}

# 关键一行：对刚生成的每只怪，用战利品表替换它的主手
execute as @e[tag=tspire_v7] run loot replace entity @s weapon.mainhand loot tspire:test/forge_sword

# 直接读 NBT，肉眼看手容易和原版铁剑混淆
data get entity @e[tag=tspire_v7,limit=1,sort=nearest] HandItems

tellraw @s [{"text":"[V7] ","color":"gold"},{"text":"已生成 2 只丧尸并尝试塞入匠魂剑。","color":"white"}]
tellraw @s [{"text":"     看上一行的 HandItems：","color":"gray"},{"text":"出现 tic_materials 即通过。","color":"yellow"}]
tellraw @s [{"text":"     清理：","color":"gray"},{"text":"/kill @e[tag=tspire_v7]","color":"gray"}]
