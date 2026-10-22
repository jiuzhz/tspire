# ============================================================
# BOSS 顶端血条（v0.7.58，玩家要求：像末影龙那样）
# ============================================================
# 可行性说明：原版末影龙那条血条是**写死的特殊血条**，数据包改不了它；
#   但 1.20.1 的 /bossbar 命令可以做出一条**外观完全一样**的血条（顶端居中、名字+血量条），
#   所以"给自定义 BOSS 加顶端血条"是**可行**的，这里就是实现。
#
# 血量来源：boss/tick 每 tick 把实体血量写进 tspire_boss_hp（持有者 = BOSS 实体本身）。
# 最大值：#MAXHP（tspire_timer）。数值换算成 0..1000 的百分比，避免 max 变化时抖动。
# ============================================================

# 有 BOSS 存活：把血条发给队伍、可见、同步数值
bossbar set tspire:boss players @a[team=tspire_party]
bossbar set tspire:boss visible true
bossbar set tspire:boss color red
execute store result score #BAR_HP tspire_timer run data get entity @e[tag=tspire_boss,limit=1] Health 1
bossbar set tspire:boss name [{"selector":"@e[tag=tspire_boss,limit=1]","color":"red"},{"text":"  "},{"score":{"name":"#BAR_HP","objective":"tspire_timer"},"color":"white"},{"text":" / "},{"score":{"name":"#MAXHP","objective":"tspire_timer"},"color":"gray"}]
bossbar set tspire:boss max 1000
scoreboard players set #BAR_V tspire_timer 0
execute store result score #BAR_V tspire_timer run scoreboard players get @e[tag=tspire_boss,limit=1] tspire_boss_hp
scoreboard players set #BAR_1000 tspire_timer 1000
scoreboard players operation #BAR_V tspire_timer *= #BAR_1000 tspire_timer
execute if score #MAXHP tspire_timer matches 1.. run scoreboard players operation #BAR_V tspire_timer /= #MAXHP tspire_timer
execute store result bossbar tspire:boss value run scoreboard players get #BAR_V tspire_timer
