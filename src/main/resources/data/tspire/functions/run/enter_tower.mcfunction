# ============================================================
# 把全队送进塔维度的构筑间
# 用法：/function tspire:run/enter_tower
# ============================================================
# 构筑间位于第 1 层大厅南端，开局的两步构筑都在锚点附近进行。
# y=64 是本层地面（地板方块在 63）。
#
# 前置：地面必须**已经建好**。塔里是虚空时 tp 进来会直接掉下去，
#       所以开局流程拆成两拍，只有 start/enter_draft 才会调到这里。
# ============================================================

execute unless score #TUTOR_MODE tspire_timer matches 1 in tspire:tower run tp @a[team=tspire_party] 0 64 0
execute if score #TUTOR_MODE tspire_timer matches 1 in tspire:tower run tp @a[tag=tspire_tutorial] -120 64 24

# 把重生点设在塔里
# 重要：doImmediateRespawn 开着，玩家阵亡会立刻在重生点复活。
# 不设的话重生点还在主世界，人一死就被弹出塔。
execute unless score #TUTOR_MODE tspire_timer matches 1 in tspire:tower as @a[team=tspire_party] run spawnpoint @s 0 64 0
execute if score #TUTOR_MODE tspire_timer matches 1 in tspire:tower as @a[tag=tspire_tutorial] run spawnpoint @s -120 64 24

# 冒险模式：不能破坏/放置方块，避免把墙拆了绕过路线或把房间挖穿
execute in tspire:tower run gamemode adventure @a[team=tspire_party]

# 塔内锁定入夜（14000，比 12000 的日落更暗）并停住昼夜循环
# 注意：1.20.1 的 /time 会遍历**所有维度**，主世界也会跟着变
time set 14000
execute in tspire:tower run gamerule doDaylightCycle false

# 塔内不开自然刷怪（敌人全部由编队函数精确生成）
execute in tspire:tower run gamerule doMobSpawning false
execute in tspire:tower run gamerule doWeatherCycle false
