tag @s remove tspire_revive_pending
# 匠魂尖塔 - 重置单名队员的本局状态
# 由 tspire:run/start_run 对每名队员调用
tag @s remove tspire_pig_bless
scoreboard players set @s tspire_pig_run 0
tag @s remove tspire_parasite
tag @s remove tspire_parasite_pending
scoreboard players set @s tspire_para_run 0
tag @s remove tspire_hunger
tag @s remove tspire_treasure
scoreboard players set @s tspire_food_timer 0
scoreboard players set @s tspire_seenout 0
execute if score @s tspire_logout matches 0.. run scoreboard players operation @s tspire_seenout = @s tspire_logout

scoreboard players set @s tspire_layer 0
scoreboard players set @s tspire_battle 0
scoreboard players set @s tspire_ready 0
scoreboard players set @s tspire_dead 0
scoreboard players set @s tspire_gacha 0
scoreboard players set @s tspire_br1 0
scoreboard players set @s tspire_brid1 0
scoreboard players set @s tspire_brid2 0
scoreboard players set @s tspire_brid3 0
scoreboard players set @s tspire_br2 0
scoreboard players set @s tspire_br3 0
# 资源包音乐是玩家偏好，跨局保留，直到主动执行 music/rp_off。
# 【v0.7.35】结算用的分层用时与购买次数
scoreboard players set @s tspire_fltime 0
scoreboard players set @s tspire_t1 0
scoreboard players set @s tspire_t2 0
scoreboard players set @s tspire_t3 0
scoreboard players set @s tspire_bought 0
scoreboard players set @s tspire_gold 0

# 开局构筑的选择标记
scoreboard players set @s tspire_arm0 0
scoreboard players set @s tspire_arm1 0
scoreboard players set @s tspire_arm2 0
scoreboard players set @s tspire_arm3 0
scoreboard players set @s tspire_wcount 0
scoreboard players set @s tspire_service 0
scoreboard players set @s tspire_w0 0
scoreboard players set @s tspire_w1 0
scoreboard players set @s tspire_w2 0
scoreboard players set @s tspire_w3 0
scoreboard players set @s tspire_w4 0
# 结算界面用的两个统计
scoreboard players set @s tspire_time 0
scoreboard players set @s tspire_nodes 0
scoreboard players set @s tspire_offer 0
scoreboard players set @s tspire_ov 0
scoreboard players set @s tspire_src 0
# 构筑方案：每人自己那份（enter_draft 会重抽）
scoreboard players set @s tspire_draft_l 0

# 【v0.6.27 修正】商人状态必须每局清零。
#   原来只清了 shop_f/shop_l 之外的东西 —— 结果开新一局时，如果还是在第 1 层
#   （shop_f 已经等于 #FLOOR），enter_merchant 不会重抽货架，于是**上一局的
#   "这一格已买过"标记被原样带进新局**，玩家点什么都提示"你已经买过了"，
#   看起来就是"商人买不了东西"（日志里连刷 9 条命令确认了这一点）。
scoreboard players set @s tspire_shop_f 0
scoreboard players set @s tspire_shop_l 0
scoreboard players set @s tspire_sale_a -1
scoreboard players set @s tspire_sale_b -1
scoreboard players set @s tspire_shop_node 0
scoreboard players set @s tspire_buy0 0
scoreboard players set @s tspire_buy1 0
scoreboard players set @s tspire_buy2 0
scoreboard players set @s tspire_buy3 0
scoreboard players set @s tspire_buy4 0
scoreboard players set @s tspire_buy5 0
scoreboard players set @s tspire_buy6 0
scoreboard players set @s tspire_buy7 0
scoreboard players set @s tspire_buy8 0
scoreboard players set @s tspire_buy9 0
scoreboard players set @s tspire_buy10 0
scoreboard players set @s tspire_buy11 0
scoreboard players set @s tspire_buy12 0
scoreboard players set @s tspire_buy13 0
scoreboard players set @s tspire_buy14 0
scoreboard players set @s tspire_fuse_used 0
# 【v0.6.44】沼泽猎手【泥沼】的逐人状态
scoreboard players set @s tspire_mud_t 0
scoreboard players set @s tspire_mud_imm 0
scoreboard players set @s tspire_mud_in 0
scoreboard players set @s tspire_heal_node 0
scoreboard players set @s tspire_dm_hp 0
scoreboard players set @s tspire_dm_cd 0
scoreboard players set @s tspire_resonate_used 0
scoreboard players set @s tspire_repairs 0
scoreboard players set @s tspire_repair_cost 0
scoreboard players set @s tspire_heals 0
scoreboard players set @s tspire_heal_cost 0
scoreboard players set @s tspire_mire_in 0
# 本局阵亡次数（deathCount 是触发器，用完就清零，所以另开一个当计数器）
scoreboard players set @s tspire_deaths 0
scoreboard players set @s tspire_death_total 0

gamemode survival @s
effect clear @s

scoreboard players set @s tspire_s0 0
scoreboard players set @s tspire_s1 0
scoreboard players set @s tspire_s2 0
scoreboard players set @s tspire_s3 0
scoreboard players set @s tspire_s4 0
scoreboard players set @s tspire_s5 0
scoreboard players set @s tspire_s6 0
scoreboard players set @s tspire_s7 0
scoreboard players set @s tspire_s8 0
scoreboard players set @s tspire_s9 0
scoreboard players set @s tspire_s10 0
scoreboard players set @s tspire_s11 0
scoreboard players set @s tspire_s12 0
scoreboard players set @s tspire_s13 0
scoreboard players set @s tspire_s14 0
scoreboard players set @s tspire_shop_anc 0
scoreboard players set @s tspire_shop_spec 0
