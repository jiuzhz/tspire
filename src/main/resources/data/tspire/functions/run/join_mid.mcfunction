# ============================================================
# 中途加入正在进行的一局（§13.5 多人）
# 用法：/function tspire:run/join_mid
# ============================================================
# 第二 ~ 第 N 名玩家不必等下一局，也不用重开整局。
# 注意：**先记位置再入队** —— 否则 `@a[team=tspire_party,limit=1]`
#       有可能把刚入队的自己选成"队伍位置"，传送就原地打转了。
# ============================================================

execute unless score #RUN_STARTED tspire_timer matches 1 run tellraw @s [{"text":"[匠魂尖塔] ","color":"gold"},{"text":"现在没有进行中的一局。","color":"white"},{"text":"点这里开始一局","color":"yellow","clickEvent":{"action":"run_command","value":"/trigger tspire_click set 5"},"hoverEvent":{"action":"show_text","contents":"进入开局构筑"}}]
execute if score #RUN_STARTED tspire_timer matches 1 if entity @s[team=tspire_party] run tellraw @s {"text":"[匠魂尖塔] 你已在本局队伍中。","color":"yellow"}
execute if score #RUN_STARTED tspire_timer matches 1 unless entity @s[team=tspire_party] in tspire:tower unless entity @a[team=tspire_party,nbt={Dimension:"tspire:tower"}] run tellraw @s {"text":"[匠魂尖塔] 队伍尚未进入尖塔，请稍后再加入。","color":"yellow"}
execute if score #RUN_STARTED tspire_timer matches 1 unless entity @s[team=tspire_party] in tspire:tower if entity @a[team=tspire_party,nbt={Dimension:"tspire:tower"}] run function tspire:run/join_mid_do
