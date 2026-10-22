# 援兵铁傀儡跟随（v0.7.7，由 tick/second 每秒调用）
#   铁傀儡不会自己跟着人走（原版 AI 只会在附近游荡），所以距离太远就把它挪到
#   最近队员身边 —— 但**不要每 tick 都挪**，否则它会一直被打断动作。
#   不攻击玩家：铁傀儡只在"村民受袭 / 玩家声望低"时才打玩家，塔里两者都不成立；
#   另外给了 PlayerCreated:1b，它不会把玩家当成敌人。
execute as @e[tag=tspire_ally] at @s unless entity @a[team=tspire_party,distance=..12] run tp @s @p[team=tspire_party]
