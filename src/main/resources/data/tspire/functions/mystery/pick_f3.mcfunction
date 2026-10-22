# 第 3 层事件池（11 个，等概率）：重铸 / 赐福 / 伪装者 / 共鸣 / 药房 / 传统派 / 抽奖机 / 黏液收藏家
#   v0.7.2：新增「传统派」。**黏液不出现在第 3 层**（玩家指定仅 1~2 层）。
execute if score #ROLL tspire_timer matches 1 run function tspire:mystery/ev_reforge
execute if score #ROLL tspire_timer matches 2 run function tspire:mystery/ev_bless
execute if score #ROLL tspire_timer matches 3 run function tspire:mystery/ev_mimic
execute if score #ROLL tspire_timer matches 4 run function tspire:mystery/ev_resonate
execute if score #ROLL tspire_timer matches 5 run function tspire:mystery/ev_pharmacy
execute if score #ROLL tspire_timer matches 6 run function tspire:mystery/ev_vanilla
execute if score #ROLL tspire_timer matches 7 run function tspire:mystery/ev_gacha
execute if score #ROLL tspire_timer matches 8 run function tspire:mystery/ev_collector
execute if score #ROLL tspire_timer matches 9 run function tspire:mystery/ev_madness
execute if score #ROLL tspire_timer matches 10 run function tspire:mystery/ev_reinforce
execute if score #ROLL tspire_timer matches 11 run function tspire:mystery/ev_turtle
execute if score #ROLL tspire_timer matches 12 run function tspire:mystery/ev_hunger
execute if score #ROLL tspire_timer matches 13 run function tspire:mystery/ev_pigs
execute if score #ROLL tspire_timer matches 14 run function tspire:mystery/ev_parasite
execute if score #ROLL tspire_timer matches 15 run function tspire:mystery/ev_bridge
