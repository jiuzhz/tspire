# ============================================================
# 多人状态快照（用法：/function tspire:test/mp_check）
# ============================================================
# 把队里**每个人**的关键分数打给执行者看，用来排查"第二个玩家没进队 /
# 没进构筑 / 领不到奖励 / 卡在旧状态"这类只有多人会出现的问题。
#
# 实现要点：要打别人的分数，就得先把自己打个 tag 存住（`as` 之后拿不到原来的 @s），
# 再 `execute as <每个队员> run tellraw @a[tag=...]`。
# ============================================================

tag @s add tspire_mp_probe

# #PARTY_SIZE 平时只在 mobs/cap 里更新（战斗时），这里重算一遍免得看到旧值
scoreboard players set #PARTY_SIZE tspire_timer 0
execute as @a[team=tspire_party] run scoreboard players add #PARTY_SIZE tspire_timer 1

tellraw @s [{"text":"========== 尖塔多人状态 ==========","color":"gold","bold":true}]
tellraw @s [{"text":"队伍人数：","color":"gray"},{"score":{"name":"#PARTY_SIZE","objective":"tspire_timer"},"color":"yellow"},{"text":"　本局进行中：","color":"gray"},{"score":{"name":"#RUN_STARTED","objective":"tspire_timer"},"color":"yellow"},{"text":"　当前层：","color":"gray"},{"score":{"name":"#FLOOR","objective":"tspire_timer"},"color":"yellow"},{"text":"　战斗进行中：","color":"gray"},{"score":{"name":"#BATTLE_ACTIVE","objective":"tspire_timer"},"color":"yellow"}]
tellraw @s [{"text":"PICK_STAGE=","color":"gray"},{"score":{"name":"#PICK_STAGE","objective":"tspire_timer"},"color":"yellow"},{"text":"（每人的构筑方案见下表 draft）","color":"dark_gray"}]
tellraw @s [{"text":"---- 每名队员 ----","color":"aqua"}]
execute as @a[team=tspire_party] run tellraw @a[tag=tspire_mp_probe] [{"selector":"@s","color":"yellow"},{"text":"  phase=","color":"gray"},{"score":{"name":"@s","objective":"tspire_phase"},"color":"white"},{"text":" 层=","color":"gray"},{"score":{"name":"@s","objective":"tspire_layer"},"color":"white"},{"text":" 金币=","color":"gray"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":" 武器数=","color":"gray"},{"score":{"name":"@s","objective":"tspire_wcount"},"color":"white"},{"text":" 阵亡=","color":"gray"},{"score":{"name":"@s","objective":"tspire_dead"},"color":"red"},{"text":" 已领奖励=","color":"gray"},{"score":{"name":"@s","objective":"tspire_offer"},"color":"aqua"},{"text":" 服务节点=","color":"gray"},{"score":{"name":"@s","objective":"tspire_service"},"color":"aqua"}]
# 商人：每人一份自己的货架（shop_f = 抽签的层，shop_l = 1..8 的货架编号）
execute as @a[team=tspire_party] run tellraw @a[tag=tspire_mp_probe] [{"text":"    draft=","color":"gray"},{"score":{"name":"@s","objective":"tspire_draft_l"},"color":"light_purple"},{"text":" 货架：层=","color":"gray"},{"score":{"name":"@s","objective":"tspire_shop_f"},"color":"dark_aqua"},{"text":" 编号=","color":"gray"},{"score":{"name":"@s","objective":"tspire_shop_l"},"color":"dark_aqua"},{"text":" 候选组=","color":"gray"},{"score":{"name":"@s","objective":"tspire_ov"},"color":"dark_aqua"},{"text":" 第1格已买=","color":"gray"},{"score":{"name":"@s","objective":"tspire_buy0"},"color":"dark_aqua"}]

# 不在队里的玩家（排除旁观）
tellraw @s [{"text":"---- 未入队（非旁观）----","color":"dark_gray"}]
execute as @a[team=!tspire_party,gamemode=!spectator] run tellraw @a[tag=tspire_mp_probe] [{"text":"  ","color":"gray"},{"selector":"@s","color":"red"}]
tellraw @s [{"text":"==================================","color":"gold","bold":true}]

tag @s remove tspire_mp_probe
