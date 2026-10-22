# 第 1 层事件池（12 个，等概率）：贪婪 / 重铸 / 石中剑 / 共鸣 / 抢劫 / 药房 / 黏液 / 生命本源 / 抽奖机 / 疯狂 / 援兵 / 海龟
#   v0.7.6：传统派移到第 3 层；新增「生命本源」（仅 1~2 层）
execute if score #ROLL tspire_timer matches 1 run function tspire:mystery/ev_greed
execute if score #ROLL tspire_timer matches 2 run function tspire:mystery/ev_reforge
execute if score #ROLL tspire_timer matches 3 run function tspire:mystery/ev_sword
execute if score #ROLL tspire_timer matches 4 run function tspire:mystery/ev_resonate
execute if score #ROLL tspire_timer matches 5 run function tspire:mystery/ev_rob
execute if score #ROLL tspire_timer matches 6 run function tspire:mystery/ev_pharmacy
execute if score #ROLL tspire_timer matches 7 run function tspire:mystery/ev_slime
execute if score #ROLL tspire_timer matches 9 run function tspire:mystery/ev_gacha
execute if score #ROLL tspire_timer matches 10 run function tspire:mystery/ev_madness
execute if score #ROLL tspire_timer matches 11 run function tspire:mystery/ev_reinforce
execute if score #ROLL tspire_timer matches 12 run function tspire:mystery/ev_turtle
execute if score #ROLL tspire_timer matches 8 run function tspire:mystery/ev_lifetree
execute if score #ROLL tspire_timer matches 13 run function tspire:mystery/ev_witch
execute if score #ROLL tspire_timer matches 14 run function tspire:mystery/ev_cheese
execute if score #ROLL tspire_timer matches 15 run function tspire:mystery/ev_pigs
execute if score #ROLL tspire_timer matches 16 run function tspire:mystery/ev_treasure
execute if score #ROLL tspire_timer matches 17 run function tspire:mystery/ev_parasite
execute if score #ROLL tspire_timer matches 18 run function tspire:mystery/ev_bridge
