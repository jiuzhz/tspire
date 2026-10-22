# ============================================================
# 神秘事件：收尾（全队都选完后由 mystery/tick 调用）
# ============================================================
# 【抢劫事件（#MYST_EV = 8）特例】必须在**清选择之前**判定：
#   「全员都选寻找」→ 打一场困难池战斗（交给 run/battle_win 去发奖励与 complete_node）；
#   只要有一名存活队员选了"放弃"，就只是各自扣钱，房间照常放行。
scoreboard players set #MYST_ROB_FIGHT tspire_timer 0
execute if score #MYST_EV tspire_timer matches 8 if entity @a[team=tspire_party,scores={tspire_dead=0}] unless entity @a[team=tspire_party,scores={tspire_dead=0,tspire_my_choice=2}] run function tspire:mystery/rob_fight
execute if score #MYST_EV tspire_timer matches 8 if entity @a[team=tspire_party,scores={tspire_dead=0}] unless entity @a[team=tspire_party,scores={tspire_dead=0,tspire_my_choice=2}] run scoreboard players set #MYST_ROB_FIGHT tspire_timer 1

scoreboard players set #MYST_ACTIVE tspire_timer 0
scoreboard players set #MYST_EV tspire_timer 0
scoreboard players set #MYST_REROLL tspire_timer 0
scoreboard players set #MYST_REROLL_N tspire_timer 0
# 【v0.7.4 玩家反馈】结算后**不能再把选择清零** —— 清零等于把聊天栏里那些旧按钮"重新激活"：
#   玩家在房间结束后点旧选项，handler 的 `matches 0` 守卫就会放行，效果被重复结算一遍
#   （再拿一次钱、再吃一次伤害）。现在统一置成 9 = "本轮已结束"，所有 handler 都不会响应。
#   下一次事件由 mystery/roll_event 重新清零。
scoreboard players set @a[team=tspire_party] tspire_my_choice 9

# 冲掉聊天栏：把旧的选项按钮顶出可视区（1.20.1 没有"删除聊天消息"的指令）。
# v0.7.9：统一走 mystery/room_clear_chat（10 条独立空消息 + 一行"已作废"说明），
#   不再在这里塞 14 个 `\\n` —— 那种写法要么让函数加载失败（单个 \n），要么可能显示成字面 `\n`。
function tspire:mystery/room_clear_chat

# 【v0.7.4】先解开房间的临时封锁（barrier）：
#   · 非战斗分支：complete_node → runtime/unlock_next 会 refresh_doors，本节点仍是 current，门会保持开着；
#   · 抢劫变战斗分支：battle_start 会再封一次，打完由 battle_win 的 terrain/unlock 负责。
execute unless score #MYST_ROB_FIGHT tspire_timer matches 1 run function tspire:terrain/unlock

# 变成战斗的那次：不放行、不提示"门开了"（打完由 battle_win 收尾）
execute unless score #MYST_ROB_FIGHT tspire_timer matches 1 run tellraw @a[team=tspire_party] [{"text":"[神秘节点] ","color":"light_purple"},{"text":"所有人都做出了选择 —— 房间的门开了，可以走了。","color":"green"}]
execute unless score #MYST_ROB_FIGHT tspire_timer matches 1 as @a[team=tspire_party] at @s run playsound minecraft:block.iron_door.open master @s ~ ~ ~ 0.8 1
execute unless score #MYST_ROB_FIGHT tspire_timer matches 1 run function tspire:map/complete_node
scoreboard players set #MYST_ROB_FIGHT tspire_timer 0