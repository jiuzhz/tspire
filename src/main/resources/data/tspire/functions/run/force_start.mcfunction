# ============================================================
# 强制重开一局（不管当前卡在哪一步）
# ============================================================
# 由 run/start 里那个「强制重开」按钮调用。
# 把构筑阶段的残留状态全部清掉，再走一遍正常的开局流程。
# ============================================================

execute unless entity @s[team=tspire_party] run function tspire:load/join

tellraw @a[team=tspire_party] [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"强制重开……","color":"yellow"}]

# 状态归零
scoreboard players set #PICK_STAGE tspire_timer 0
scoreboard players set #PICK_WAIT tspire_timer 0
scoreboard players set #RUN_STARTED tspire_timer 0
scoreboard players set #BATTLE_ACTIVE tspire_timer 0
scoreboard players set #BOSS_ACTIVE tspire_timer 0
scoreboard players set @a[team=tspire_party] tspire_phase 0
scoreboard players set @a[team=tspire_party] tspire_dead 0

# 清掉塔里的残留
# 先按 marker 位置把 Lock 宝箱挖掉，再杀 marker（offer_clear 内部就是这个顺序）
function tspire:rewards/offer_clear
execute in tspire:tower run kill @e[tag=tspire_node]
execute in tspire:tower run kill @e[tag=tspire_starter]
execute in tspire:tower run kill @e[tag=tspire_shop]
execute in tspire:tower run kill @e[tag=tspire_offer]
execute in tspire:tower run kill @e[tag=tspire_mob]
execute in tspire:tower run kill @e[tag=tspire_boss]
execute in tspire:tower run kill @e[type=minecraft:item]

function tspire:run/start_run
