# ============================================================
# 检查尖塔维度是否已注册
# 用法：/function tspire:test/check_dimension
# ============================================================
# 数据包维度只在【世界加载】时注册，/reload 不会新增维度。
# 如果你刚加入这个数据包，必须先退回标题界面再进世界（或重启游戏），
# 否则 tspire:tower 不存在，enter_tower 里的传送会静默失败。
# ============================================================

execute in tspire:tower run say tower-dimension-ok

tellraw @s [{"text":"[维度自检] ","color":"gold"},{"text":"如果上面没有出现 tower-dimension-ok，说明尖塔维度尚未注册。","color":"white"}]
tellraw @s [{"text":"解决办法：","color":"yellow"},{"text":"退回标题界面再进世界（或重启游戏），然后 /reload。","color":"gray"}]
tellraw @s [{"text":"注意：","color":"red"},{"text":"光执行 /reload 不够 —— 新维度只在世界加载时注册。","color":"gray"}]
