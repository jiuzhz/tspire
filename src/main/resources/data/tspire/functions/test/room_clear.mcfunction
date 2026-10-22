# ============================================================
# 强制完成当前房间（v0.7.4 新增）—— 卡关时用
# ============================================================
# 用法：/function tspire:test/room_clear
#   1) 清掉塔里的怪 + 结束战斗状态；
#   2) 清掉神秘事件状态（等效于"全队都选完了"）；
#   3) 解开门上的临时封锁，并把全队拉回当前房间中心；
#   4) 调 map/complete_node —— 标记已完成、解锁下一行、刷门。
# 若当前没有 current 节点（人已经在走廊里），退化为"直接解锁下一行"。
# ⚠️ 在 BOSS 房里用它等于跳过这只 Boss（complete_node 会替你推进楼层）。
# ============================================================

execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_boss]
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #BATTLE_TIMER tspire_timer 0
scoreboard players set #MYST_ACTIVE tspire_timer 0
scoreboard players set #MYST_EV tspire_timer 0
scoreboard players set @a[team=tspire_party] tspire_my_choice 0

function tspire:terrain/unlock
execute as @a[team=tspire_party,scores={tspire_dead=0}] at @e[tag=tspire_node_current,limit=1] run tp @s ~ ~ ~2
execute if entity @e[tag=tspire_node_current] run function tspire:map/complete_node
execute unless entity @e[tag=tspire_node_current] run function tspire:map/runtime/unlock_next
function tspire:map/refresh_doors

tellraw @s [{"text":"[修复] ","color":"gold","bold":true},{"text":"当前房间已强制完成 —— 下一行的门已打开。","color":"green"}]
execute as @a[team=tspire_party] at @s run playsound minecraft:block.iron_door.open master @s ~ ~ ~ 1 1
